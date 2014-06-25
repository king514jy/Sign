package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ListeningAdministratorMe;
	
	public class OpenListeningCmd extends SimpleCommand
	{
		public function OpenListeningCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			trace("aaasd")
			var laMe:ListeningAdministratorMe = this.facade.retrieveMediator(ListeningAdministratorMe.NAME) as ListeningAdministratorMe;
			laMe.addGesture();
		}
	}
}