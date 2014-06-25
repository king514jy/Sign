package signEditorUI.conmponents
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import signEditorUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class InputValueUI extends Sprite
	{
		private var backBtn:SimpleButton;
		private var inputText:TextField;
		private var _value:String;
		public function InputValueUI() 
		{
			backBtn = this.getChildByName("back_btn") as SimpleButton;
			inputText = this.getChildByName("input_txt") as TextField;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function set value(str:String):void
		{
			_value = str;
			if (inputText)
				inputText.text = str;
		}
		public function get value():String { return _value; }
		private function init(e:Event):void
		{
			
			if (_value)
				inputText.text = _value;
			backBtn.addEventListener(MouseEvent.CLICK, clickHandle);
			inputText.addEventListener(Event.CHANGE, changeValue);
		}
		private function clickHandle(e:MouseEvent):void
		{
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE_OVER));
		}
		private function changeValue(e:Event):void
		{
			_value = inputText.text;
		}
	}

}