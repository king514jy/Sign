package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartSocketCmd extends SimpleCommand
	{
		public function StartSocketCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			
		}
	}
}