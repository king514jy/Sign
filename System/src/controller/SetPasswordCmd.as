package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.PasswordManageMe;
	
	public class SetPasswordCmd extends SimpleCommand
	{
		public function SetPasswordCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var passwordMe:PasswordManageMe = this.facade.retrieveMediator(PasswordManageMe.NAME) as PasswordManageMe;
			configPro.password = passwordMe.password;
			configPro.saveConfig();
		}
	}
}