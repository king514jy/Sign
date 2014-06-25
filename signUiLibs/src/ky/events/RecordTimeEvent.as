package ky.events
{
	import flash.events.Event;
	
	public class RecordTimeEvent extends Event
	{
		public static const TIME_COMPLETE:String = "time_complete";
		public function RecordTimeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}