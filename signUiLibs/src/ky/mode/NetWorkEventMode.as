package ky.mode
{
	public class NetWorkEventMode
	{
		//图片传输类事件（PICTURE）//object
		/**
		 * 传输图片
		 */
		public static const PICTURE_TRANSPORT:int = 0;
		/**
		 * 刷新图片
		 */
		public static const PICTURE_REFRESH:int = 1;
		/**
		 * 显示端图片脱离控制
		 */
		public static const PICTURE_SEPARATE:int = 2;
		/**
		 * 改变图片状态（用于内嵌）
		 */
		public static const PICTURE_CHANGE_STATUS:int = 3;
		/**
		 * 删除图片
		 */
		public static const PICTURE_DELETE:int = 4;
		
		//互动元素类事件（OPERATE）
		/**
		 * 操作互动元素
		 */
		public static const OPERATE_INTERACTIVE_ELEMENT:int = 5;
		
		//模块自由信息(MODULE)
		/**
		 * 模块自由信息
		 */
		public static const MODULE_CUSTOM_INFORMATION:int = 6;
		public function NetWorkEventMode()
		{
		}
	}
}