package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ChangePasswordMe;
	
	public class OpenChangePasswordCmd extends SimpleCommand
	{
		public function OpenChangePasswordCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var changeMe:ChangePasswordMe = this.facade.retrieveMediator(ChangePasswordMe.NAME) as ChangePasswordMe;
			changeMe.openUI(configPro.password);
		}
	}
}