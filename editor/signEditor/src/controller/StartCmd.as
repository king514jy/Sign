package controller
{
	import model.ConfigManageProxy;
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.AppRootMe;
	import view.EditorUIMe;
	import view.ScreenBlockMe;
	import view.conmponents.AppRoot;
	
	public class StartCmd extends SimpleCommand
	{
		public function StartCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var appRoot:AppRoot = AppRoot.getInstance();
			
			this.facade.registerProxy( new ModuleManageProxy());
			this.facade.registerProxy(new ConfigManageProxy());
			
			this.facade.registerCommand(EditorFacade.LOAD_CONFIG,LoadConfigCmd);
			this.facade.registerCommand(EditorFacade.LISTENER_NATIVEWINDOW,ListenerNativeWindowCmd);
			this.facade.registerCommand(EditorFacade.INIT,InitCmd);
			this.facade.registerCommand(EditorFacade.INSTALL_MODULE,InstallModuleCmd);
			this.facade.registerCommand(EditorFacade.INSTALL_MODULE_COMPLETE,InstallModuleCompleteCmd);
			this.facade.registerCommand(EditorFacade.INSTALL_MODULE_INFO,InstallModuleInfoCmd);
			this.facade.registerCommand(EditorFacade.UNINSTALL_MODULE,UninstallModuleCmd);
			this.facade.registerCommand(EditorFacade.UNINSTALL_MODULE_COMPLETE,UninstallModuleCompleteCmd);
			this.facade.registerCommand(EditorFacade.OPEN_SCREEN_BLOCK,OpenScreenBlockCmd);
			this.facade.registerCommand(EditorFacade.CLOSE_SCREEN_BLOCK,CloseScreenBlockCmd);
			this.facade.registerCommand(EditorFacade.SET_MODULE,SetModuleCmd);
			this.facade.registerCommand(EditorFacade.INJECT_CONFIG_XML,InjectConfigXMLCmd);
			this.facade.registerCommand(EditorFacade.EXPORT_MODULE,ExportCmd);
			this.facade.registerCommand(EditorFacade.CLEAR_TEMP_DIRECTORY,ClearTempDirectoryCmd);
			
			this.facade.registerMediator(new AppRootMe());
			this.facade.registerMediator(new ScreenBlockMe(appRoot.root));
			this.facade.registerMediator(new EditorUIMe(appRoot.root));
			
			this.sendNotification(EditorFacade.LOAD_CONFIG);
		}
	}
}