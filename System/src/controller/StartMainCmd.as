package controller
{
	import flash.filesystem.File;
	
	import model.ConfigProxy;
	import model.ServerSocketProxy;
	import model.SocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import signUi.mode.SetDevicesMode;
	import signUi.mode.SetRoleMode;
	import signUi.mode.SetTerminalMode;
	
	import view.ModuleMainMe;
	import view.conmponents.AppRoot;
	
	public class StartMainCmd extends SimpleCommand
	{
		public function StartMainCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var moduleMainMe:ModuleMainMe = this.facade.retrieveMediator(ModuleMainMe.NAME) as ModuleMainMe;
			var devicesFolder:String;
			var swfURL:String;
			var swfPath:String;
			var ip:String;
			var direction:String;
			var appRoot:AppRoot = AppRoot.getInstance();
			if(configPro.devices == SetDevicesMode.SIGNLE)
			{
				devicesFolder = "signle/";
				direction = null;
			}
			else
			{
				devicesFolder = "multi/";
				direction = configPro.direction;
			}
			if(configPro.terminal == SetTerminalMode.DISPLAY)
			{
				swfURL = "/signShowUI/signShowUIMain.swf";
				swfPath = "/signShowUI/";
			}
			else
			{
				swfURL = "/signUI/signUIMain.swf";
				swfPath = "/signUI/";
			}
			var url:String = File.applicationStorageDirectory.resolvePath("assets/template/"+devicesFolder+configPro.coding+swfURL).url;
			var pathURL:String = File.applicationStorageDirectory.resolvePath("assets/template/"+devicesFolder+configPro.coding+swfPath).url;
			if(configPro.role == SetRoleMode.SERVER)
			{
				ip = null;
				var serverSocket:ServerSocketProxy = new ServerSocketProxy();
				this.facade.registerProxy(serverSocket);
				serverSocket.startSocket();
			}
			else
			{
				ip = configPro.ip;
				if(!this.facade.hasProxy(SocketProxy.NAME))
					this.facade.registerProxy(new SocketProxy());
				var socketPro:SocketProxy = this.facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				socketPro.start(ip);
			}
			moduleMainMe.renderMasterFile(pathURL,url,configPro.terminal,configPro.direction);
		}
	}
}