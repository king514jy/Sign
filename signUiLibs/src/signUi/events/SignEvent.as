package signUi.events
{
	import flash.events.Event;
	
	public class SignEvent extends Event
	{
		public static const SIGN_COMPLETE:String = "sign_complete";
		public static const SIGN_REWRITE:String = "sign_rewrite";
		private var _info:String;
		public function SignEvent(type:String,info:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_info = info;
		}
		public function get info():String{ return _info; }
	}
}