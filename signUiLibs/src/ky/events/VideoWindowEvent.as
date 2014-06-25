package ky.events
{
	import flash.events.Event;
	
	public class VideoWindowEvent extends Event
	{
		public static const START:String = "start";
		public function VideoWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}