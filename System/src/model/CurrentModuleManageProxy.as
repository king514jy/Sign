package model
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import ky.mode.SetTerminalMode;
	import ky.utils.XMLTool;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CurrentModuleManageProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CurrentModuleManageProxy";
		private var folder:String;
		private var coding:String;
		private var terminal:String;
		private var defaultAdd:String;
		private var address:String;
		public var hasConfig:Boolean;
		private var xml:XML;
		private var separator:String = File.separator;
		public function CurrentModuleManageProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
		}
		public function init(folder:String,coding:String,terminal:String):void
		{
			this.folder = folder;
			this.coding = coding;
			this.terminal = terminal;
			var urlLoader:URLLoader = new URLLoader();
			var file:File = File.applicationStorageDirectory.resolvePath(folder+coding+separator+"template_config.xml");
			urlLoader.load(new URLRequest(file.url));
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			xml = XML(urlLoader.data);
			if(terminal == SetTerminalMode.OPERATE)
			{
				hasConfig = String(xml.template.@operateConfig) == "true";
				defaultAdd = xml.defaultConfig.@operate;
				address = xml.operateConfigPath;
			}
			else
			{
				hasConfig = String(xml.template.@displayConfig) == "true";
				defaultAdd = xml.defaultConfig.@display;
				address = xml.displayConfigPath;
			}	
			this.sendNotification(SystemFacade.ANALYZE_RUN_MODULE);
		}
		public function getCurrentConfigAddress():String
		{
			var addStr:String;
			if(address!="")
				addStr = address;
			else
				addStr = "";
			return addStr;
		}
		public function getRunConfigAddress():String
		{
			var addStr:String;
			if(address.length>0)
				addStr = address;
			else
				addStr = File.applicationStorageDirectory.resolvePath(folder+coding+separator+defaultAdd).nativePath;
			return addStr;
		}
		public function saveConfig(path:String):void
		{
			var xmlList:XMLList = new XMLList("<![CDATA["+path+"]]>");
			var newXML:XML
			if(terminal == SetTerminalMode.OPERATE)
			{
				newXML =  <operateConfigPath></operateConfigPath>
				newXML.appendChild(xmlList);
				xml.replace(2,newXML);
			}
			else
			{
				newXML = <displayConfigPath><![CDATA[]]></displayConfigPath>
				newXML.appendChild(xmlList);
				xml.replace(3);
			}
			XMLTool.writeXML(File.applicationStorageDirectory.resolvePath(folder+coding+separator+"template_config.xml"),xml.toString());
			this.sendNotification(SystemFacade.CURRENT_MODULE_INFO,{info:"保存完毕，软件重启后生效"});
		}
	}
}