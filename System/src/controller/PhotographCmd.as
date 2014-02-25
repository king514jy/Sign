package controller
{
	import model.CameraProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ModuleMainMe;
	
	public class PhotographCmd extends SimpleCommand
	{
		public function PhotographCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var maniMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var cameraPro:CameraProxy =  this.facade.retrieveProxy(CameraProxy.NAME) as CameraProxy;
			maniMe.newMain.injectCameraPic(cameraPro.photographByDraw());
		}
	}
}