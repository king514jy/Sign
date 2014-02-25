package controller
{
	import model.CameraProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ModuleMainMe;
	
	public class OpenCameraCmd extends SimpleCommand
	{
		public function OpenCameraCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var mainMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var cameraPro:CameraProxy =  this.facade.retrieveProxy(CameraProxy.NAME) as CameraProxy;
			mainMe.newMain.injectCamera(cameraPro.getCamera());
		}
	}
}