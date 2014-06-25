package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ScreenBlockMe;
	
	public class CloseScreenBlockCmd extends SimpleCommand
	{
		public function CloseScreenBlockCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var screenBM:ScreenBlockMe = this.facade.retrieveMediator(ScreenBlockMe.NAME) as ScreenBlockMe;
			screenBM.close();
		}
	}
}