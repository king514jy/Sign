package model
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import ky.mode.FolderNameMode;
	import ky.utils.XMLTool;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	
	public class ConfigProxy extends Proxy implements IProxy
	{
		public static const NAME:String="ConfigProxy";
		private const USER:String = "moon";
		private var xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		public var projectName:String = "";
		public var projectPath:String = "";
		public var direction:String = "bottom";
		public var terminal:String = "display";
		public var coding:String = "0";
		public var ip:String = "192.168.1.222";
		public var password:String;
		public var picList:Vector.<String>;
		private var separator:String = File.separator;
		public function ConfigProxy(data:Object=null)
		{
			super(NAME,data);
		}
		public function get user():String{ return USER; }
		public function loadConfig():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("assets"+separator);
			var fileSelf:File = File.applicationDirectory.resolvePath("assets"+separator);
			if(!file.exists)
			{
				fileSelf.copyTo(file);
				projectName = "ky";
				projectPath = File.desktopDirectory.nativePath;
				//初始设置
				this.sendNotification(SystemFacade.OPEN_PASSWORD_UI,{isSet:true});
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(new URLRequest(file.url+separator+"config.xml"));
				urlLoader.addEventListener(Event.COMPLETE,complete);
			}
		}
		private function complete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			projectName = xml.project.@name;
			projectPath = xml.project.@path;
			direction = xml.devices.@direction;
			terminal = xml.devices.@terminal;
			coding = xml.template.@coding;
			ip = xml.server.@ip;
			password = xml.password.@p;
			checkPicList();
			this.sendNotification(SystemFacade.INIT_MODULE_MANAGE);
		}
		public function saveConfig():void
		{
			var xml:XML = <data></data>
			var projectXML:XML = <project path={this.projectPath} name={this.projectName} />
			var devicesXML:XML = <devices direction={this.direction} terminal={this.terminal}/>
			var templateXML:XML = <template coding={this.coding} />
			var serverXML:XML = <server ip={this.ip} />
			var passwordXML:XML = <password p={this.password} />
			xml.appendChild(projectXML);
			xml.appendChild(devicesXML);
			xml.appendChild(templateXML);
			xml.appendChild(serverXML);
			xml.appendChild(passwordXML);
			var xmlStr:String = xml.toString();
			var file:File = File.applicationStorageDirectory.resolvePath("assets/config.xml");
			XMLTool.writeXML(file,xmlStr);
			
			this.sendNotification(SystemFacade.LOAD_CONFIG);
		}
		private function checkPicList():void
		{
			var file:File = new File(projectPath+separator+projectName+separator+FolderNameMode.SIGN_DISPLAY+separator);
			if(file.exists)
			{
				var ar:Array = file.getDirectoryListing();
				if(ar.length>0)
				{
					picList = new Vector.<String>();
					var le:uint = Math.min(50,ar.length);
					for(var i:int=0;i<le;i++)
					{
						var n:uint = Math.floor(Math.random() * ar.length);
						if(ar[n].url.indexOf(".jpg")!=-1)
						{
							picList.push(ar[n].url);
							ar.splice(n,1);
						}
					}
				}
			}
		}
	}
}