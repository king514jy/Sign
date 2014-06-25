package controller
{
	import model.ConfigManageProxy;
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import signEditorUI.events.MenuEvent;
	
	public class SetModuleCmd extends SimpleCommand
	{
		public function SetModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigManageProxy = this.facade.retrieveProxy(ConfigManageProxy.NAME) as ConfigManageProxy;
			var moduleM:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			var type:String = notification.getType();
			var id:int = notification.getBody().id;
			var temp:String = moduleM.templateList[id];
			if(type == MenuEvent.SET_DISPLAY)
				configPro.decompressModuleConfig("display",temp);
			if(type == MenuEvent.SET_OPERATE)
				configPro.decompressModuleConfig("operate",temp);
		}
	}
}