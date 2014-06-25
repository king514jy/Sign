package systemSetUI.events
{
	import flash.events.Event;
	
	public class SetUIEvent extends Event
	{
		/**
		 * 当前模块：保存配置文件包
		 */
		public static const CURRENT_SAVE:String = "current_save";
		/**
		 * 当前模块:恢复默认
		 */
		public static const CURRENT_REGAIN:String = "current_regain";
		/**
		 * 安装模块：安装模块
		 */
		public static const INSTALL_BEGIN:String = "install_begin";
		/**
		 * 卸载模块:卸载模块
		 */
		public static const UNINSTALL_BEGIN:String = "uninstall_begin";
		/**
		 * 修改密码（保存）
		 */
		public static const CHANGE_PASSWORD:String = "change_password";
		public function SetUIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}