package controller
{
	import model.CameraProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import signUi.mode.ModuleRequestMode;
	
	import view.ModuleMainMe;
	
	public class AnalyzeRequestCmd extends SimpleCommand
	{
		public function AnalyzeRequestCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var maniMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var requestList:Vector.<String> = maniMe.newMain.requestList;
			if(requestList.indexOf(ModuleRequestMode.REQUEST_CAMERA)!=-1)
			{
				this.facade.registerCommand(SystemFacade.OPEN_CAMERA,OpenCameraCmd);
				this.facade.registerCommand(SystemFacade.PHOTOGRAPH,PhotographCmd);
				this.facade.registerProxy(new CameraProxy());
				this.sendNotification(SystemFacade.OPEN_CAMERA);
			}
		}
	}
}