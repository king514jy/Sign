package
{
	import controller.StartCmd;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class EditorFacade extends Facade implements IFacade
	{
		public static const START:String = "start";
		public static const LISTENER_NATIVEWINDOW:String = "listener_nativewindow";
		public static const LOAD_CONFIG:String = "load_config";
		public static const INIT:String = "init";
		public static const OPEN_SCREEN_BLOCK:String = "open_screen_block";
		public static const CLOSE_SCREEN_BLOCK:String = "close_screen_block";
		public static const INSTALL_MODULE:String = "install_module";
		public static const INSTALL_MODULE_COMPLETE:String = "install_module_complete";
		public static const INSTALL_MODULE_INFO:String = "install_module_info";
		public static const UNINSTALL_MODULE:String = "uninstall_module";
		public static const UNINSTALL_MODULE_COMPLETE:String = "uninstall_module_complete";
		public static const SET_MODULE:String = "set_module";
		public static const INJECT_CONFIG_XML:String = "inject_config_xml";
		public static const EXPORT_MODULE:String = "export_module";
		public static const CLEAR_TEMP_DIRECTORY:String = "clear_temp_directory";
		public static var instance:EditorFacade;
		public function EditorFacade()
		{
			super();
		}
		public static function getInstance():EditorFacade
		{
			if(!instance)
				instance = new EditorFacade();
			return instance;
		}
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(START,StartCmd);
		}
		public function startup():void
		{
			sendNotification(START);
		}
	}
}