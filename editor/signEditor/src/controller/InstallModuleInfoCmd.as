package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class InstallModuleInfoCmd extends SimpleCommand
	{
		public function InstallModuleInfoCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var info:String = notification.getBody().info;
		}
	}
}