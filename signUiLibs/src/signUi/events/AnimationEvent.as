package signUi.events
{
	import flash.events.Event;
	
	public class AnimationEvent extends Event
	{
		public static const COMPLETE:String="complete";
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}