package systemSetUI.cfg
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import systemSetUI.events.ChangeDataEvent;

	public class InputValueItem extends Sprite
	{
		private var nameTxt:TextField;
		private var contentTxt:TextField;
		private var editorBtn:MovieClip;
		private var _value:String;
		public function InputValueItem()
		{
			nameTxt = this.getChildByName("name_txt") as TextField;
			contentTxt = this.getChildByName("content_txt") as TextField;
			editorBtn = this.getChildByName("editor_mc") as MovieClip;
			editorBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			editorBtn.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			editorBtn.addEventListener(MouseEvent.CLICK, clickHandle);
		}
		public function set value(str:String):void 
		{ 
			_value = str;
			contentTxt.text = str;
		}
		public function get value():String { return _value; }
		public function get label():String{ return nameTxt.text;}
		private function mouseDown(e:MouseEvent):void
		{
			editorBtn.gotoAndStop(2);
		}
		private function mouseUp(e:MouseEvent):void
		{
			editorBtn.gotoAndStop(1);
		}
		public function inject(name:String,value:String):void
		{
			nameTxt.text = name;
			contentTxt.text = value;
			_value = value;
		}
		private function clickHandle(e:MouseEvent):void
		{
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.INPUT));
		}
	}
}