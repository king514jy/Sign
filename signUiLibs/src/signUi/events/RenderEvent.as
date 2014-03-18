package signUi.events
{
	import flash.events.Event;
	
	public class RenderEvent extends Event
	{
		public static const RENDER_PROGRESS:String = "render_progress";
		public static const RENDER_COMPLETE:String = "render_complete";
		private var _progress:Number;
		public function RenderEvent(type:String,progress:Number=0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_progress = progress;
		}
		public function get progress():Number{ return _progress;}
	}
}