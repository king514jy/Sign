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
		public static const NAME:String="ConfigProxy";
		private const USER:String = "moon";
		private var xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		
		private var xmlFile:File;
		private var xml:XML;
		public var folderAddress:String;
		public var templateList:Vector.<String>;
		public var nameList:Vector.<String>;
		private var coding:String;
		private var name:String;
		private var fileStr:String;
		public function ModuleManageProxy(data:Object=null)
		{
			super(NAME,data);
			templateList = new Vector.<String>();
			nameList = new Vector.<String>();
		}
		public function get user():String{ return USER; }
		public function loadConfig():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("assets/");
			var fileSelf:File = File.applicationDirectory.resolvePath("assets/");
			if(!file.exists)
			{
				fileSelf.copyTo(file);
			}
			loadXML(file.url+"/template_list_config.xml");
		}
		private function loadXML(url:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE,complete);
		}
		private function complete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			xml = XML(urlLoader.data);
			var le:uint = xml.template.length();
			folderAddress = xml.address.@folder;
			for(var i:int=0;i<le;i++)
			{
				templateList.push(xml.template[i].@coding);
				nameList.push(xml.template[i].@name);
			}
			this.sendNotification(EditorFacade.INIT);
			this.sendNotification(EditorFacade.LISTENER_NATIVEWINDOW);
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
				this.sendNotification(EditorFacade.OPEN_SCREEN_BLOCK,{info:"正在安装模块..."});
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
					this.sendNotification(EditorFacade.INSTALL_MODULE_COMPLETE);
					this.sendNotification(EditorFacade.CLOSE_SCREEN_BLOCK);
				}
			}
			else
			{
				this.sendNotification(EditorFacade.INSTALL_MODULE_INFO,{info:"将要安装的模块与系统不匹配"});
			}
		}
		private function installBegin(e:TimerEvent):void
		{
			var timer:Timer = e.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,installBegin);
			timer = null;
			var endStr:String = PassHandler.decryption(fileStr);
			var endByt:ByteArray = Base64.decodeToByteArray(endStr);
			var fzip:FZip = new FZip();
			fzip.addEventListener(Event.COMPLETE,fzipComplete);
			fzip.loadBytes(endByt);
		}
		private function fzipComplete(e:Event):void
		{
			var fzip:FZip = e.target as FZip;
			var folderPath:String = File.applicationStorageDirectory.resolvePath(folderAddress+coding+"/").nativePath;
			decompressZIP(fzip,folderPath);
			this.sendNotification(EditorFacade.INSTALL_MODULE_COMPLETE);
			this.sendNotification(EditorFacade.CLOSE_SCREEN_BLOCK);
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
			var index:int = templateList.indexOf(template);
			if(index!=-1)
			{
				this.sendNotification(EditorFacade.OPEN_SCREEN_BLOCK,{info:"正在卸载模板"});
				var file:File = File.applicationStorageDirectory.resolvePath(folderAddress+template+"/");
				file.deleteDirectory(true);
				delete xml.template[index];
				XMLTool.writeXML(xmlFile,xml.toString());
				templateList.splice(index,1);
				this.sendNotification(EditorFacade.UNINSTALL_MODULE_COMPLETE);
				this.sendNotification(EditorFacade.CLOSE_SCREEN_BLOCK);
			}
		}
		private function saveXml():void
		{
			xml.appendChild(<template coding={coding} name={name} />);
			XMLTool.writeXML(xmlFile,xml.toString());
		}
		private function decompressZIP(fzip:FZip,folderPath:String):void
		{
			var le:uint = fzip.getFileCount();
			for(var i:int=0;i<le;i++)
			{
				var ff:FZipFile = fzip.getFileAt(i);
				var file:File = new File(folderPath+ff.filename);
				var fs:FileStream = new FileStream();
				fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,progress);
				fs.addEventListener(Event.CLOSE,closeFs);
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(ff.content);
				fs.close();
			}
		}
	}
}