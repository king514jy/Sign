package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SetCurrentModuleMe;
	
	public class SetCurrentModuleInfoCmd extends SimpleCommand
	{
		public function SetCurrentModuleInfoCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var cuurentMe:SetCurrentModuleMe = this.facade.retrieveMediator(SetCurrentModuleMe.NAME) as SetCurrentModuleMe;
			cuurentMe.info = notification.getBody().info;
		}
	}
}