package signUi.events
{
	import flash.events.Event;
	
	public class StatusEvent extends Event
	{
		public static const BEGIN:String = "begin";
		public static const ON_GOING:String = "on_going";
		public static const END:String = "end";
		public static const SPORT_END:String = "sport_end";
		public static const CHANGED:String = "changed";
		public static const GESTURE_MOVE_END:String = "gesture_end";
		public static const GESTURE_CHANGE_END:String = "gesture_change_end";
		public function StatusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}