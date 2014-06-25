package controller
{
	import flash.filesystem.File;

	import ky.mode.SetTerminalMode;
	
	import model.AnalyzeServerDataProxy;
	import model.ConfigProxy;
	import model.RuntimeProxy;
	import model.ServerSocketProxy;
	import model.SocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	import view.ModuleMainMe;
	
	public class StartMainCmd extends SimpleCommand
	{
		public function StartMainCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var runPro:RuntimeProxy = this.facade.retrieveProxy(RuntimeProxy.NAME) as RuntimeProxy;
			var moduleMainMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var swfURL:String = new File(runPro.tempDirectory+runPro.swfName).url;
			var pathURL:String = new File(runPro.tempDirectory).url+"/";
			if(configPro.terminal == SetTerminalMode.DISPLAY)
			{
				if(!this.facade.hasProxy(ServerSocketProxy.NAME))
					this.facade.registerProxy(new ServerSocketProxy());
				var serverSocket:ServerSocketProxy = this.facade.retrieveProxy(ServerSocketProxy.NAME) as ServerSocketProxy;
				serverSocket.startSocket();
				if(!this.facade.hasProxy(AnalyzeServerDataProxy.NAME))
					this.facade.registerProxy(new AnalyzeServerDataProxy());
				var analyzeServerData:AnalyzeServerDataProxy = this.facade.retrieveProxy(AnalyzeServerDataProxy.NAME) as AnalyzeServerDataProxy;
				analyzeServerData.path = configPro.projectPath+"/"+configPro.projectName+"/";
				
				if(!this.facade.hasCommand(SystemFacade.ANALYZE_SERVER_DATA))
					this.facade.registerCommand(SystemFacade.ANALYZE_SERVER_DATA,AnalyzeServerDataCmd);
				
				if(!this.facade.hasCommand(SystemFacade.SERVER_INJECT_PIC))
					this.facade.registerCommand(SystemFacade.SERVER_INJECT_PIC,ServerInjectPicCmd);
				
				if(!this.facade.hasCommand(SystemFacade.SERVER_CHANGE_PIC_STATUS))
					this.facade.registerCommand(SystemFacade.SERVER_CHANGE_PIC_STATUS,ServerChangePicStatusCmd);
				
				if(!this.facade.hasCommand(SystemFacade.SERVER_REFRESH_PIC))
					this.facade.registerCommand(SystemFacade.SERVER_REFRESH_PIC,ServerRefreshPicCmd);
				
				if(!this.facade.hasCommand(SystemFacade.SERVER_PIC_SEPARATE))
					this.facade.registerCommand(SystemFacade.SERVER_PIC_SEPARATE,ServerPicSeparateCmd);
				
				if(!this.facade.hasCommand(SystemFacade.SERVER_CUSTOM_INFORMATION))
					this.facade.registerCommand(SystemFacade.SERVER_CUSTOM_INFORMATION,ServerCustomInformationCmd);
			}
			else
			{
				var ip:String = configPro.ip;
				if(!this.facade.hasProxy(SocketProxy.NAME))
					this.facade.registerProxy(new SocketProxy());
				var socketPro:SocketProxy = this.facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				socketPro.start(ip);
			}
			moduleMainMe.renderMasterFile(pathURL,swfURL,configPro.terminal,configPro.direction,configPro.picList);
		}
	}
}