package
{
	import controller.StartCmd;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class SystemFacade extends Facade implements IFacade
	{
		public static const START:String = "start";
		/**
		 * 加载配置文件
		 */
		public static const LOAD_CONFIG:String = "load_config";
		/**
		 * 打开系统设置界面
		 */
		public static const OPEN_SYSTEM_SET:String = "open_system_set";
		/**
		 * 保存设置
		 */
		public static const SAVE_SYSTEM_SET:String = "save_system_set";
		public static var instance:SystemFacade;
		public function SystemFacade()
		{
			super();
		}
		public static function getInstance():SystemFacade
		{
			if(!instance)
				instance = new SystemFacade();
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