package signEditorUI.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Q·JY
	 */
	public class StatusEvent extends Event 
	{
		public static const OPEN:String = "open";
		public static const CLOSE:String = "close";
		public function StatusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new StatusEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StatusEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}