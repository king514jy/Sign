package systemSetUI.events
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		/**
		 * 系统设置
		 */
		public static const SET_SYSTEM:String = "set_system";
		/**
		 * 设置当前模板
		 */
		public static const SET_CURRENT_MODULE = "set_current_module";
		/**
		 * 安装模块
		 */
		public static const INSTALL_MODULE:String = "install_module";
		/**
		 * 卸载模块
		 */
		public static const UNINSTALL_MODULE:String = "uninstall_module";
		/**
		 * 修改密码
		 */
		public static const CHANGE_PASSWORD:String = "change_password";
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}