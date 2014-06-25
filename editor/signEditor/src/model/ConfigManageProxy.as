package model
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigManageProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ConfigManageProxy";
		private static const xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		private var templateFolder:String;
		public var configFileFolder:String;
		private var packageName:String;
		public function ConfigManageProxy(data:Object=null)
		{
			super(NAME, data);
		}
		public function init(templateFolder:String):void
		{
			this.templateFolder = templateFolder;
		}
		public function decompressModuleConfig(type:String,template:String):void
		{
			var file:File;
			if(type == "display")
				packageName = "/signShowConfig.zip";
			else
				packageName = "/signConfig.zip";
			file = File.applicationStorageDirectory.resolvePath(templateFolder+template+packageName);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var byt:ByteArray = new ByteArray();
			fs.readBytes(byt);
			fs.close();
			byt.position = 0;
			var fzip:FZip = new FZip();
			fzip.addEventListener(Event.COMPLETE,decompressComplete);
			fzip.loadBytes(byt);
		}
		private function decompressComplete(e:Event):void
		{
			var fzip:FZip = e.target as FZip;
			configFileFolder = File.createTempDirectory().nativePath+"/";
			decompressZIP(fzip,configFileFolder);
			var file:File = new File(configFileFolder+"config.xml");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			var xml:XML = XML(str);
			this.sendNotification(EditorFacade.INJECT_CONFIG_XML,{data:xml});
		}
		public function exportZIP(folder:String,xml:XML):void
		{
			var fzip:FZip = new FZip();
			var fileList:Vector.<String> = new Vector.<String>();
			var le:uint = xml.fileValue.item.length();
			for(var i:int =0;i<le;i++)
			{
				var str:String = xml.fileValue.item[i];
				if(str.indexOf(File.separator)!=-1)
				{
					var ar:Array = str.split(File.separator);
					var fileName:String = ar[ar.length-1];
					fzip.addFile(fileName,readFile(str));
					var name:String = xml.fileValue.item[i].@name;
					var tips:String = xml.fileValue.item[i].@tips;
					var extension:String = xml.fileValue.item[i].@extension;
					var xmlList:XMLList = new XMLList("<![CDATA["+fileName+"]]>");
					var newXML:XML = <item name={name} tips={tips} extension={extension}></item>
					newXML.appendChild(xmlList);
					xml.fileValue.replace(i,newXML);
				}
				else
				{
					if(str.length>0)
						fzip.addFile(str,readFile(configFileFolder+str));
				}
			}
			var xmlStr:String = String(xmlHead + "\r\n" + xml.toString());
			fzip.addFileFromString("config.xml",xmlStr);
			var byt:ByteArray = new ByteArray();
			//byt.writeUTF("asd");后期做对应模块使用，写入模块编码(coding);
			fzip.serialize(byt);
			var file:File = new File(folder+packageName);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(byt);
			fs.close();
			this.sendNotification(EditorFacade.CLOSE_SCREEN_BLOCK);
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
		private function readFile(path:String):ByteArray
		{
			var file:File = new File(path);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var byt:ByteArray = new ByteArray();
			fs.readBytes(byt);
			fs.close();
			return byt;
		}
		public function clearTempDirectory():void
		{
			if(configFileFolder)
			{
				var file:File = new File(configFileFolder);
				try
				{
					file.deleteDirectory(true);
				}
				catch(e:IOError)
				{
					trace(e.message);
				}
			}
		}
	}
}