package model
{
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import ky.utils.Base64;
	import ky.utils.PassHandler;
	import ky.utils.XMLTool;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ModuleManageProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ModuleManageProxy";
		private var xmlFile:File;
		private var xml:XML;
		public var folderAddress:String;
		public var templateList:Vector.<String>;
		public var nameList:Vector.<String>;
		private var fzip:FZip;
		private var coding:String;
		private var name:String;
		private var fileStr:String;
		private var separator:String = File.separator;
		public function ModuleManageProxy(data:Object=null)
		{
			super(NAME, data);
			templateList = new Vector.<String>();
			nameList = new Vector.<String>();
		}
		public function init():void
		{
			xmlFile = File.applicationStorageDirectory.resolvePath("assets/template_list_config.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
			urlLoader.load(new URLRequest(xmlFile.url));
			
		}
		private function onComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			xml = XML(urlLoader.data);
			var le:uint = xml.template.length();
			folderAddress = xml.address.@folder;
			for(var i:int=0;i<le;i++)
			{
				templateList.push(xml.template[i].@coding);
			}
			this.sendNotification(SystemFacade.INIT_CURRENT_MODULE);
		}
		//-------------------------------------------------------------------------------------
		/**
		 *安装模块 
		 * @param path 模块路径
		 * @param administrator 管理员账号 
		 * 
		 */
		public function installModule(path:String,administrator:String):void
		{
			var file:File = new File(path);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var byt:ByteArray = new ByteArray();
			fs.readBytes(byt);
			fs.close();
			var user:String = byt.readUTF();
			if(user==administrator)
			{
				this.sendNotification(SystemFacade.OPEN_SCREEN_BLOCK,{info:"正在安装模块..."});
				coding = byt.readUTF();
				if(checkVersion(coding))
				{
					templateList.push(coding);
					name = byt.readUTF();
					nameList.push(name);
					fileStr = byt.readUTFBytes(byt.bytesAvailable);
					var timer:Timer = new Timer(100,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE,installBegin);
					timer.start();
				}
				else
				{
					this.sendNotification(SystemFacade.INSTALL_MODULE_COMPLETE);
					this.sendNotification(SystemFacade.CLOSE_SCREEN_BLOCK);
				}
			}
			else
			{
				this.sendNotification(SystemFacade.INSTALL_MODULE_INFO,{info:"将要安装的模块与系统不匹配"});
			}
		}
		private function installBegin(e:TimerEvent):void
		{
			var timer:Timer = e.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,installBegin);
			timer = null;
			var endStr:String = PassHandler.decryption(fileStr);
			var endByt:ByteArray = Base64.decodeToByteArray(endStr);
			fzip = new FZip();
			fzip.addEventListener(Event.COMPLETE,fzipComplete);
			fzip.loadBytes(endByt);
		}
		private function fzipComplete(e:Event):void
		{
			var le:uint = fzip.getFileCount();
			for(var i:int=0;i<le;i++)
			{
				var ff:FZipFile = fzip.getFileAt(i);
				var file:File = File.applicationStorageDirectory.resolvePath(folderAddress+coding+separator+ff.filename);
				var fs:FileStream = new FileStream();
				fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,progress);
				fs.addEventListener(Event.CLOSE,closeFs);
				fs.openAsync(file,FileMode.WRITE);
				fs.writeBytes(ff.content);
				fs.close();
			}
			this.sendNotification(SystemFacade.INSTALL_MODULE_COMPLETE);
			this.sendNotification(SystemFacade.CLOSE_SCREEN_BLOCK);
			saveXml();
		}
		private function progress(e:OutputProgressEvent):void
		{
			var pro:int = Math.floor((e.bytesTotal-e.bytesPending)/e.bytesTotal * 100);
		}
		private function closeFs(e:Event):void
		{
			var fs:FileStream = e.target as FileStream;
			fs.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS,progress);
			fs.removeEventListener(Event.CLOSE,closeFs);
			fs = null;
		}
		/**
		 * 可安装返回true,不可安装返回false
		 */
		private function checkVersion(coding:String):Boolean
		{
			return templateList.indexOf(coding) == -1;
		}
		//-------------------------------------------------------------------------------------
		public function uninstallModule(template:String):void
		{
			trace(template);
			var index:int = templateList.indexOf(template);
			if(index!=-1)
			{
				var file:File = File.applicationStorageDirectory.resolvePath(folderAddress+template+separator);
				file.deleteDirectory(true);
				delete xml.template[index];
				XMLTool.writeXML(xmlFile,xml.toString());
				templateList.splice(index,1);
				this.sendNotification(SystemFacade.UNINSTALL_MODULE_COMPLETE);
			}
		}
		private function saveXml():void
		{
			xml.appendChild(<template coding={coding} name={name} />);
			XMLTool.writeXML(xmlFile,xml.toString());
		}
	}
}