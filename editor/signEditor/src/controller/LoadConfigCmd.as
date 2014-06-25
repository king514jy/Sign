package controller
{
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadConfigCmd extends SimpleCommand
	{
		public function LoadConfigCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var proxy:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			proxy.loadConfig();
		}
	}
}