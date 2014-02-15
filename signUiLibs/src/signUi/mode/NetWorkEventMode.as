package signUi.mode
{
	public class NetWorkEventMode
	{
		//图片传输类事件（PICTURE）
		/**
		 * 传输图片
		 */
		public static const PICTURE_TRANSPORT:int = 0;
		/**
		 * 改变图片状态（用于内嵌）
		 */
		public static const PICTURE_CHANGE_STATUS:int = 1;
		
		//互动元素类事件（OPERATE）
		/**
		 * 操作互动元素
		 */
		public static const OPERATE_INTERACTIVE_ELEMENT:int = 2;
		
		//抽奖类事件（LOTTERY）
		/**
		 * 打开抽奖界面
		 */
		public static const LOTTERY_OPEN:int = 3;
		/**
		 * 关闭抽奖界面
		 */
		public static const LOTTERY_CLOSE:int = 4;
		/**
		 * 重置抽奖数据
		 */
		public static const LOTTERY_RESET:int = 5;
		/**
		 * 用数字抽取
		 */
		public static const LOTTERY_NUMBER:int = 6;
		/**
		 * 用图片抽取
		 */
		public static const LOTTERY_PICTURE:int = 7;
		public function NetWorkEventMode()
		{
		}
	}
}