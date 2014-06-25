package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class UninstallModuleCompleteCmd extends SimpleCommand
	{
		public function UninstallModuleCompleteCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			
		}
	}
}