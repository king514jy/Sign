package controller
{
	import model.ConfigManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ClearTempDirectoryCmd extends SimpleCommand
	{
		public function ClearTempDirectoryCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigManageProxy = this.facade.retrieveProxy(ConfigManageProxy.NAME) as ConfigManageProxy;
			configPro.clearTempDirectory();
		}
	}
}