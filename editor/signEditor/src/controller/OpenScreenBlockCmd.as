package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ScreenBlockMe;
	
	public class OpenScreenBlockCmd extends SimpleCommand
	{
		public function OpenScreenBlockCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var screenBM:ScreenBlockMe = this.facade.retrieveMediator(ScreenBlockMe.NAME) as ScreenBlockMe;
			screenBM.render();
			screenBM.info = notification.getBody().info;
		}
	}
}