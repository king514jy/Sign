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
		 * 初始化模块管理器
		 */
		public static const INIT_MODULE_MANAGE:String = "init_module_manage";
		/**
		 * 初始化当前模块配置文件包
		 */
		public static const INIT_CURRENT_MODULE:String = "init_current_module";
		/**
		 * 解压模块swf
		 */
		public static const ANALYZE_RUN_MODULE:String = "analyze_run_module";
		/**
		 * 开启管理员界面手势监听
		 */
		public static const OPEN_ADMIN_LISTENER:String = "open_admin_listener";
		/**
		 * 打开屏幕遮挡界面({info:String})
		 */
		public static const OPEN_SCREEN_BLOCK:String = "open_screen_block";
		/**
		 * 关闭屏幕遮挡界面
		 */
		public static const CLOSE_SCREEN_BLOCK:String = "close_screen_block";
		/**
		 * 打开密码界面
		 */
		public static const OPEN_PASSWORD_UI:String = "open_password_ui";
		/**
		 * 设置管理员密码
		 */
		public static const SET_PASSWORD:String = "set_password";
		/**
		 * 打开系统菜单
		 */
		public static const OPEN_SYSTEM_MENU:String = "open_system_menu";
		/**
		 * 打开系统设置界面
		 */
		public static const OPEN_SYSTEM_SET:String = "open_system_set";
		/**
		 * 设置当前模块
		 */
		public static const SET_CURRENT_MODULE:String = "set_current_module";
		/**
		 * 保存当前配置文件包
		 */
		public static const SAVE_CURRENT_MODULE:String = "save_current_module";
		/**
		 * 当前配置设置信息
		 */
		public static const CURRENT_MODULE_INFO:String = "current_module_info";
		/**
		 * 打开安装模块UI
		 */
		public static const OPEN_INSTALL_MODULE:String = "open_install_module";
		/**
		 * 开始安装模块
		 */
		public static const INSTALL_MODULE:String = "install_module";
		/**
		 * 模块安装信息
		 */
		public static const INSTALL_MODULE_INFO:String = "install_module_info";
		/**
		 * 安装完成
		 */
		public static const INSTALL_MODULE_COMPLETE:String = "install_module_complete";
		/**
		 * 打开卸载模块界面
		 */
		public static const OPEN_UNINSTALL_MODULE:String = "open_uninstall_module";
		/**
		 * 卸载模块
		 */
		public static const UNINSTALL_MODULE:String = "uninstall_module";
		/**
		 * 卸载模块完成
		 */
		public static const UNINSTALL_MODULE_COMPLETE:String = "uninstall_module_complete";
		/**
		 * 打开密码修改界面
		 */
		public static const OPEN_CHANGE_PASSWORD:String = "open_change_password";
		/**
		 * 修改密码
		 */
		public static const CHANGE_PASSWORD:String = "change_password";
		/**
		 * 修改密码完成
		 */
		public static const CHANGE_PASSWORD_COMPLETE:String = "change_password_complete";
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
		 * 服务器：改变图片显示状态
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