package controller
{	
	import model.ConfigProxy;
	import model.PicHandleProxy;
	import model.SocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import signUi.mode.ModuleEventMode;
	
	import view.ModuleMainMe;
	
	public class AnalyzeEventCmd extends SimpleCommand
	{
		public function AnalyzeEventCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var mainMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var picHandlePro:PicHandleProxy = this.facade.retrieveProxy(PicHandleProxy.NAME) as PicHandleProxy;
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var socketPro:SocketProxy = this.facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			var type:String = notification.getType();
			var informationObj:Object = notification.getBody().informationObj;
			switch(type)
			{
				case ModuleEventMode.SAVE_PIC:
					picHandlePro.savePic(informationObj,configPro.projectPath+"/"+configPro.projectName);
					break;
				case ModuleEventMode.SEND_PIC:
					socketPro.send(informationObj);
					break;
				case ModuleEventMode.SEND_PIC_STATUS:
					socketPro.send(informationObj);
					break;
				case ModuleEventMode.PHOTOGRAPH:
					if(this.facade.hasCommand(SystemFacade.PHOTOGRAPH))
						this.sendNotification(SystemFacade.PHOTOGRAPH);
					break;
				case ModuleEventMode.REFRESH_PIC:
					socketPro.send(informationObj);
					break;
			}
		}
	}
}