package systemSetUI.events
{
	import flash.events.Event;
	
	public class SystemSetEvent extends Event
	{
		public static const SET_COMPLETE:String = "set_complete";
		public function SystemSetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}