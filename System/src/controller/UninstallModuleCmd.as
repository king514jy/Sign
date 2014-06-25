package controller
{
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class UninstallModuleCmd extends SimpleCommand
	{
		public function UninstallModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var type:String = notification.getType();
			var mmPro:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			mmPro.uninstallModule(type);
		}
	}
}