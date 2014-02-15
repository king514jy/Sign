package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import signUi.mode.SetRoleMode;
	
	public class StartMainCmd extends SimpleCommand
	{
		public function StartMainCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			if(configPro.role == SetRoleMode.SERVER)
				this.sendNotification(SystemFacade.START_SERVERSOCKET);
		}
	}
}