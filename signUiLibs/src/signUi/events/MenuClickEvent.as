package signUi.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author King
	 */
	public class MenuClickEvent extends Event 
	{
		/**
		 * 点击
		 */
		public static const IS_CLICK:String = "isclick";
		
		private var _clickID:int; 
		/**
		 * 
		 * @param	type 时间类型
		 * @param	clickID 点击的按钮ID
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function MenuClickEvent(type:String, clickID:int,bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_clickID = clickID;
		}
		public function get clickID():int { return _clickID };
	}

}