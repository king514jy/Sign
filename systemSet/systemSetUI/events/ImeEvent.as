package systemSetUI.events
{
	import flash.events.Event;
	
	public class ImeEvent extends Event
	{
		public static const INPUT:String = "input";
		public static const COMPLETE:String = "complete";
		public static const DELETE:String = "delete";
		public static const TAP:String="tap";
		private var _value:String;
		public function ImeEvent(type:String,value:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_value = value;
		}
		public function get value():String{ return _value; }
	}
}