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
		 * 解析服务器接收到的数据
		 */
		public static const ANALYZE_SERVER_DATA:String = "analyze_server_data";
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
		 * 服务器：接收图片并注入到UI
		 */
		public static const SERVER_INJECT_PIC:String = "server_inject_pic";
		/**
		 * 服务器：改天图片显示状态
		 */
		public static const SERVER_CHANGE_PIC_STATUS:String = "server_change_pic_status";
		/**
		 * 服务器：图片脱离控制，进去显示端模式
		 */
		public static const SERVER_PIC_SEPARATE:String = "server_pic_separate";
		/**
		 * 服务器：刷新图片
		 */
		public static const SERVER_REFRESH_PIC:String = "server_refresh_pic";
		/**
		 * 服务器：接收到模板自定义信息
		 */
		public static const SERVER_CUSTOM_INFORMATION:String = "server_custom_information";
		/**
		 * 关闭app;
		 */
		public static const CLOSE_APP:String = "close_app";
		public static const OPEN_DEBUG_SOCKET:String = "open_debug_socket";
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