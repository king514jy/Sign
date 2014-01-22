package signUi.events
{
	import flash.events.Event;
	
	public class SignEvent extends Event
	{
		public static const SIGN_COMPLETE:String = "sign_complete";
		public static const OPEN_SIGN_UI:String = "open_sign_ui";
		public static const CLOSE_SIGN_UI:String = "close_sign_ui";
		public static const SEND_TIPS:String = "send_tips";
		/**
		 * 动画播放完毕
		 */
		public static const ANIMATION_COMPLETE:String = "animation_complete";
		/**
		 * 释放图片
		 */
		public static const DISPOSE_PIC:String="dispose_pic";
		
		private var _info:String;
		public function SignEvent(type:String,info:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_info = info;
		}
		public function get info():String{ return _info; }
	}
}