package controller
{
	import flash.ui.Mouse;
	
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.PasswordManageMe;
	
	public class OpenPasswordUICmd extends SimpleCommand
	{
		public function OpenPasswordUICmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var isSet:Boolean = notification.getBody().isSet;
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var passwordManageMe:PasswordManageMe = this.facade.retrieveMediator(PasswordManageMe.NAME) as PasswordManageMe;
			if(!isSet)
			{
				passwordManageMe.openUI(isSet,configPro.password);
			}
			else
			{
				if(!this.facade.hasCommand(SystemFacade.SET_PASSWORD))
					this.facade.registerCommand(SystemFacade.SET_PASSWORD,SetPasswordCmd);
				passwordManageMe.openUI(isSet);
			}
		}
	}
}