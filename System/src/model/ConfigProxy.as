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
	
	public class ConfigProxy extends Proxy implements IProxy
	{
		public static const NAME:String="ConfigProxy";
		private var xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		private var isSet:Boolean;
		public function ConfigProxy(data:Object=null)
		{
			super(NAME,data);
		}
		public function loadConfig(isSet:Boolean):void
		{
			this.isSet = isSet;
			var file:File = File.applicationStorageDirectory.resolvePath("config.xml");
			if(!file.exists)
			{
				//初始设置
				this.sendNotification(SystemFacade.OPEN_SYSTEM_SET,null,"inital");
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(new URLRequest(file.url));
				urlLoader.addEventListener(Event.COMPLETE,complete);
			}
		}
		private function complete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			var obj:Object = new Object();
			obj.devices = xml.devices.@num;
			obj.direction = xml.devices.@direction;
			obj.terminal = xml.devices.@terminal;
			obj.role = xml.devices.@role;
			obj.coding = xml.template.@coding;
			obj.ip = xml.server.@ip;
			obj.password = xml.password.@p;
			if(isSet)
				this.sendNotification(SystemFacade.OPEN_SYSTEM_SET,obj,"new_setting");
		}
		public function saveConfig(obj:Object):void
		{
			var xml:XML = <data></data>
			var devicesXML:XML = <devices num={obj.devices} direction={obj.direction} terminal={obj.terminal} role={obj.role}/>
			var templateXML:XML = <template coding={obj.coding} />
			var serverXML:XML = <server ip={obj.ip} />
			var passwordXML:XML = <password p={obj.password} />
			xml.appendChild(devicesXML);
			xml.appendChild(templateXML);
			xml.appendChild(serverXML);
			xml.appendChild(passwordXML);
			var xmlStr:String = xml.toString();
			var pattern:RegExp =  /\n/g;
			xmlStr = xmlStr.replace(pattern, "\r\n");
			var file:File = File.applicationStorageDirectory.resolvePath("config.xml");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(String(xmlHead + "\r\n" + xmlStr));
			fileStream.close();
		}
	}
}