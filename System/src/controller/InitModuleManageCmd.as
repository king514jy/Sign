package controller
{
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitModuleManageCmd extends SimpleCommand
	{
		public function InitModuleManageCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var mmp:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			mmp.init();
		}
	}
}