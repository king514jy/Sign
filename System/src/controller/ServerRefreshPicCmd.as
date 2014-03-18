package controller
{
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ModuleMainMe;
	
	public class ServerRefreshPicCmd extends SimpleCommand
	{
		public function ServerRefreshPicCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var moduleMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var info:Object = notification.getBody();
			moduleMe.newMain.refreshPic(info.id,info.byt);
		}
	}
}