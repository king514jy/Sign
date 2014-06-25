package controller
{
	import model.ConfigProxy;
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InstallModuleCmd extends SimpleCommand
	{
		public function InstallModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var moduleMP:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var path:String = notification.getBody().path;
			moduleMP.installModule(path,configPro.user);
		}
	}
}