package systemSetUI.events
{
	import flash.events.Event;
	
	public class InputPasswordEvent extends Event
	{
		/**
		* 进入
		**/
		public static const ENTER:String = "enter";
		/**
		* 验证
		**/
		public static const VERIFY:String = "verify"
		private var _password:String;
		public function InputPasswordEvent(type:String,password:String,bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_password = password;
		}
		public function get password():String{ return _password; }
	}
	
}
