package signEditorUI.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Q·JY
	 */
	public class MenuEvent extends Event 
	{
		public static const ADD:String = "add";
		public static const DELETE:String = "delete";
		public static const GOIN:String = "goin";
		public static const COMPLETE:String = "complete";
		public static const OK:String = "ok";
		public static const CANCEL:String = "cancel";
		public static const BACK:String = "back";
		
		public static const DELETE_MODULE:String = "delete_module";
		public static const ENTER_EDITOR:String = "enter_editor";
		
		public static const SET_OPERATE:String = "set_operate";
		public static const SET_DISPLAY:String = "set_display";
		
		public static const EXPORT:String = "export";
		private var _index:int;
		public function MenuEvent(type:String,index:int=0, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_index = index;
		} 
		public function get index():int { return _index };
		public override function clone():Event 
		{ 
			return new MenuEvent(type,index, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}