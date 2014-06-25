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
	 * @author Q·JY
	 */
	public class InputValueItem extends Sprite 
	{
		private var nameTxt:TextField;
		private var contentTxt:TextField;
		private var editorBtn:SimpleButton;
		private var _value:String;
		public function InputValueItem() 
		{
			nameTxt = this.getChildByName("name_txt") as TextField;
			contentTxt = this.getChildByName("content_txt") as TextField;
			editorBtn = this.getChildByName("editor_btn") as SimpleButton;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function set value(str:String):void 
		{ 
			_value = str;
			if (contentTxt)
				contentTxt.text = str;
		}
		public function get value():String { return _value; }
		public function get label():String{ return nameTxt.text;}
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if(_value)
				contentTxt.text = _value;
		}
		public function inject(name:String,value:String):void
		{
			nameTxt.text = name;
			contentTxt.text = value;
			_value = value;
			editorBtn.addEventListener(MouseEvent.CLICK, clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.INPUT));
		}
	}

}