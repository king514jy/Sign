package controller
{	
	import model.ConfigProxy;
	import model.PicHandleProxy;
	import model.SocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import signUi.mode.ModuleEventMode;
	
	import view.ModuleMainMe;
	import view.SinaWeiboMe;
	
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
			if(this.facade.hasMediator(SinaWeiboMe.NAME))
				var sinaMe:SinaWeiboMe = this.facade.retrieveMediator(SinaWeiboMe.NAME) as SinaWeiboMe;
			var type:String = notification.getType();
			var info:Object = notification.getBody();
			switch(type)
			{
				case ModuleEventMode.SAVE_PIC:
					picHandlePro.savePic(info,configPro.projectPath+"/"+configPro.projectName);
					break;
				case ModuleEventMode.SAVE_PRINT_PIC:
					picHandlePro.savePic(info,configPro.projectPath+"/"+configPro.projectName);
					break;
				case ModuleEventMode.SEND_PIC:
					socketPro.send(info);
					break;
				case ModuleEventMode.SEND_PIC_STATUS:
					socketPro.send(info);
					break;
				case ModuleEventMode.SEND_PIC_SEPARATE:
					mainMe.newMain.clear();
					socketPro.send(info);
					break;
				case ModuleEventMode.PHOTOGRAPH:
					if(this.facade.hasCommand(SystemFacade.PHOTOGRAPH))
						this.sendNotification(SystemFacade.PHOTOGRAPH);
					break;
				case ModuleEventMode.REFRESH_PIC:
					socketPro.send(info);
					break;
				case ModuleEventMode.SEND_CUSTOM_INFORMATION:
					socketPro.send(info);
					break;
				case ModuleEventMode.SEND_WEIBO:
					sinaMe.sendPic(info.byt,info.infomation);
					break;
			}
		}
	}
}