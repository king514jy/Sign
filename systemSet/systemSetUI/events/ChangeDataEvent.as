package systemSetUI.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Q·JY
	 */
	public class ChangeDataEvent extends Event 
	{
		public static const CHANGE:String = "change";
		public static const CHANGE_NUMBER:String = "change_number";
		public static const CHANGE_STRING:String = "change_string";
		public static const SELECT_FILE:String = "select_file";
		public static const SELECT_FOLDER:String = "select_folder";
		public static const INPUT:String = "input";
		public static const CHANGE_BEGIN:String = "change_begin";
		public static const CHANGE_OVER:String = "change_over";
		public static const SAVE_CONFIG:String = "save_config";
		private var _numValue:Number;
		private var _strValue:String;
		public function ChangeDataEvent(type:String, numValue:Number = 0,strValue:String=null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_numValue = numValue;
			_strValue = strValue;
		} 
		public function get numValue():Number { return _numValue; }
		public function get strValue():String { return _strValue };
		public override function clone():Event 
		{ 
			return new ChangeDataEvent(type,numValue,strValue, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ChangeDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}