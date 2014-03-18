package signUi.debug
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class InformationGroup extends Sprite
	{
		private var textWidth:uint;
		private var textHeight:uint;
		private var _text:TextField;
		public function InformationGroup(_w:uint,_h:uint)
		{
			textWidth = _w;
			textHeight = _h;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function get textField():TextField { return _text; };
		private function init(e:Event=null):void
		{
			_text = new TextField();
			_text.width = textWidth;
			_text.height = textHeight;
			//_text.autoSize = TextFieldAutoSize.LEFT;
			_text.multiline = true;
			_text.background = true;
			_text.backgroundColor = 0xFFFFFF;
			_text.border = true;
			_text.borderColor = 0xCCCCCC;
			_text.textColor = 0x000000;
			_text.wordWrap = true;
			this.addChild(_text);
		}
		public function addInfo(str:String):void
		{
			_text.appendText(str);
		}
		public function clear():void
		{
			_text.text = "";
		}
	}
}