package controller
{
	import model.ConfigProxy;
	import model.CurrentModuleManageProxy;
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitCurrentModuleCmd extends SimpleCommand
	{
		public function InitCurrentModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var cm:CurrentModuleManageProxy = this.facade.retrieveProxy(CurrentModuleManageProxy.NAME) as CurrentModuleManageProxy;
			var mmp:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			cm.init(mmp.folderAddress,configPro.coding,configPro.terminal);
		}
	}
}