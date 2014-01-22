package systemSetUI.events
{
	import flash.events.Event;
	
	public class NumberKeyboardEvent extends Event
	{
		public static const CLICK_NUM:String = "click_num";
		public static const CLOSE:String = "close";
		private var _info:String;
		public function NumberKeyboardEvent(type:String,info:String="",bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_info = info;
		}
		public function get info():String{ return _info; }
	}
	
}
