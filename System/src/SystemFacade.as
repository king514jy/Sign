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
		/**
		 * 启动主程序
		 */
		public static const START_MAIN:String = "start_main";
		/**
		 * 启动服务器
		 */
		public static const START_SERVERSOCKET:String = "start_serversocket";
		/**
		 * 启动socket
		 */
		public static const START_SOCKET:String = "start_socket";
		/**
		 * 解析模块请求
		 */
		public static const ANALYZE_REQUEST:String = "analyze_request";
		/**
		 * 解析模块事件
		 */
		public static const ANALYZE_EVENT:String = "analyze_event";
		/**
		 * 打开摄像头
		 */
		public static const OPEN_CAMERA:String = "open_camera";
		/**
		 * 拍照
		 */
		public static const PHOTOGRAPH:String = "photograph";
		/**
		 * 保存图片
		 */
		public static const SAVE_PIC:String = "save_pic";
		/**
		 * 发送图片
		 */
		public static const SEND_PIC:String = "send_pic";
		/**
		 * 关闭app;
		 */
		public static const CLOSE_APP:String = "close_app";
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