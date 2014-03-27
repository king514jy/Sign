package model
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import signUi.mode.FolderNameMode;
	
	public class ConfigProxy extends Proxy implements IProxy
	{
		public static const NAME:String="ConfigProxy";
		private var xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		private var isSet:Boolean;
		public var projectName:String;
		public var projectPath:String;
		public var devices:String;
		public var direction:String;
		public var terminal:String;
		public var role:String;
		public var coding:String;
		public var ip:String;
		public var password:String;
		public var picList:Vector.<String>;
		public function ConfigProxy(data:Object=null)
		{
			super(NAME,data);
		}
		public function loadConfig(isSet:Boolean=false):void
		{
			this.isSet = isSet;
			var file:File = File.applicationStorageDirectory.resolvePath("assets/");
			var fileSelf:File = File.applicationDirectory.resolvePath("assets/");
			if(!file.exists)
			{
				fileSelf.copyTo(file);
				//初始设置
				this.sendNotification(SystemFacade.OPEN_SYSTEM_SET,null,"inital");
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(new URLRequest(file.url+"/config.xml"));
				urlLoader.addEventListener(Event.COMPLETE,complete);
			}
		}
		private function complete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			projectName = xml.project.@name;
			projectPath = xml.project.@path;
			devices = xml.devices.@num;
			direction = xml.devices.@direction;
			terminal = xml.devices.@terminal;
			role = xml.devices.@role;
			coding = xml.template.@coding;
			ip = xml.server.@ip;
			password = xml.password.@p;
			checkPicList();
			if(isSet)
			{
				var obj:Object = new Object();
				obj.projectName = projectName;
				obj.projectPath = projectPath;
				obj.devices = devices;
				obj.direction = direction;
				obj.terminal = terminal;
				obj.role = role;
				obj.coding = coding;
				obj.ip = ip;
				obj.password = password;
				this.sendNotification(SystemFacade.OPEN_SYSTEM_SET,obj,"new_setting");
			}
			else
			{
				this.sendNotification(SystemFacade.START_MAIN);
			}
		}
		public function saveConfig(obj:Object):void
		{
			var xml:XML = <data></data>
			var projectXML:XML = <project path={obj.projectPath} name={obj.projectName} />
			var devicesXML:XML = <devices num={obj.devices} direction={obj.direction} terminal={obj.terminal} role={obj.role}/>
			var templateXML:XML = <template coding={obj.coding} />
			var serverXML:XML = <server ip={obj.ip} />
			var passwordXML:XML = <password p={obj.password} />
			xml.appendChild(projectXML);
			xml.appendChild(devicesXML);
			xml.appendChild(templateXML);
			xml.appendChild(serverXML);
			xml.appendChild(passwordXML);
			var xmlStr:String = xml.toString();
			var pattern:RegExp =  /\n/g;
			xmlStr = xmlStr.replace(pattern, "\r\n");
			var file:File = File.applicationStorageDirectory.resolvePath("assets/config.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(String(xmlHead + "\r\n" + xmlStr));
			fileStream.close();
			
			this.sendNotification(SystemFacade.LOAD_CONFIG);
		}
		private function checkPicList():void
		{
			var file:File = new File(projectPath+"/"+projectName+"/"+FolderNameMode.SIGN_DISPLAY+"/");
			if(file.exists)
			{
				var ar:Array = file.getDirectoryListing();
				if(ar.length>0)
				{
					picList = new Vector.<String>();
					for(var i:int=0;i<ar.length;i++)
					{
						if(ar[i].url.indexOf(".jpg")!=-1)
						{
							picList.push(ar[i].url);
						}
					}
				}
			}
		}
	}
}