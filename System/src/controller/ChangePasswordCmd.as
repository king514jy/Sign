package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ChangePasswordCmd extends SimpleCommand
	{
		public function ChangePasswordCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configPro.password = notification.getType();
			configPro.saveConfig();
			this.sendNotification(SystemFacade.CHANGE_PASSWORD_COMPLETE);
		}
	}
}