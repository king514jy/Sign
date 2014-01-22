package view.events
{
	import flash.events.Event;
	
	public class GetDataEvent extends Event
	{
		public static const GET_WEATHER:String = "get_weather";
		public function GetDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}