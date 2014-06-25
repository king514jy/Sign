package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SystemMenuMe;
	
	public class OpenSystemMenuCmd extends SimpleCommand
	{
		public function OpenSystemMenuCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var systemMe:SystemMenuMe = this.facade.retrieveMediator(SystemMenuMe.NAME) as SystemMenuMe;
			systemMe.openUI();
		}
	}
}