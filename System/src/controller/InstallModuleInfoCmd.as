package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.InstallModuleMe;
	
	public class InstallModuleInfoCmd extends SimpleCommand
	{
		public function InstallModuleInfoCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var info:String = notification.getBody().info;
			var installMe:InstallModuleMe = this.facade.retrieveMediator(InstallModuleMe.NAME) as InstallModuleMe;
			installMe.info = info;
		}
	}
}