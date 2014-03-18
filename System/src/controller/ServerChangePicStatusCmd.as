package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ModuleMainMe;
	
	public class ServerChangePicStatusCmd extends SimpleCommand
	{
		public function ServerChangePicStatusCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var moduleMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var info:Object = notification.getBody();
			moduleMe.newMain.changePicStatus(info.id,info.x,info.y,info.rotation,info.scale);
		}
	}
}