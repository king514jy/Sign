package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SystemSetMe;
	
	public class OpenSystemSetCmd extends SimpleCommand
	{
		public function OpenSystemSetCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var type:String = notification.getType();
			var setMe:SystemSetMe = this.facade.retrieveMediator(SystemSetMe.NAME) as SystemSetMe;
			if(type == "inital")
				setMe.openUI(true);
			else
				setMe.openUI(false,notification.getBody());
		}
	}
}