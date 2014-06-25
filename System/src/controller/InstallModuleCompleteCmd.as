package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.InstallModuleMe;
	
	public class InstallModuleCompleteCmd extends SimpleCommand
	{
		public function InstallModuleCompleteCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var installMe:InstallModuleMe = this.facade.retrieveMediator(InstallModuleMe.NAME) as InstallModuleMe;
			installMe.complete = true;
		}
	}
}