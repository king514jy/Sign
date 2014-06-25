package ky.events
{
	import flash.events.Event;
	
	public class WeiboEvent extends Event 
	{
		public static const LAND_SUCCESS:String = "land_success";
		/**
		 * 过期
		 */
		public static const EXPIRED:String = "expired";
		public static const OK:String = "ok";
		public static const SEND_SUCCESS:String = "send_success";
		public function WeiboEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new WeiboEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WeiboEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}