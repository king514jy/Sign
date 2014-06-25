package model
{
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import ky.mode.SetTerminalMode;
	import ky.utils.Base64;
	import ky.utils.PassHandler;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RuntimeProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "RuntimeProxy";
		public var tempDirectory:String;
		public var swfName:String;
		private var separator:String = File.separator;
		private var configFile:File;
		private var config:Boolean;
		public function RuntimeProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function analyzeModule(templatePath:String,terminal:String,config:Boolean,configPath:String=null):void
		{
			tempDirectory = File.createTempDirectory().nativePath+separator;
			trace(tempDirectory)
			var templateFile:File;
			this.config = config;
			if(config)
			{
				configFile = new File(configPath);
			}
			if(terminal == SetTerminalMode.OPERATE)
			{
				templateFile = File.applicationStorageDirectory.resolvePath(templatePath+"sign.mt");
			}
			else
			{
				templateFile = File.applicationStorageDirectory.resolvePath(templatePath+"signShow.mt");
			}
			var fs:FileStream = new FileStream();
			fs.open(templateFile,FileMode.READ);
			var endByt:ByteArray = new ByteArray();
			fs.readBytes(endByt);
			fs.close();
			endByt.position = 0;
			var str:String = endByt.readUTFBytes(endByt.bytesAvailable);
			var zipByt:ByteArray = Base64.decodeToByteArray(PassHandler.decryption(str));
			var fzip:FZip = new FZip();
			fzip.addEventListener(Event.COMPLETE,fzipComplete);
			fzip.loadBytes(zipByt);
		}
		private function fzipComplete(e:Event):void
		{
			var fzip:FZip = e.target as FZip;
			swfName = fzip.getFileAt(0).filename;
			decompressZIP(fzip,tempDirectory);
			if(config)
			{
				var fs:FileStream = new FileStream();
				fs.open(configFile,FileMode.READ);
				var byt:ByteArray = new ByteArray();
				fs.readBytes(byt);
				fs.close();
				var configFzip:FZip = new FZip();
				configFzip.addEventListener(Event.COMPLETE,configFzipComplete);
				configFzip.loadBytes(byt);
			}
			else
			{
				this.sendNotification(SystemFacade.START_MAIN);
			}
		}
		private function configFzipComplete(e:Event):void
		{
			var fzip:FZip = e.target as FZip;
			decompressZIP(fzip,tempDirectory);
			this.sendNotification(SystemFacade.START_MAIN);
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
		private function clear():void
		{
			configFile = null;
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
	}
}