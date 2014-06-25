package signEditorUI.conmponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Humberger
	 */
	public class ComboBoxItem extends Sprite 
	{
		private var selectedSpr:Sprite;
		private var textFiled:TextField;
		private var bgSpr:Sprite;
		private var _text:String;
		private var _selected:Boolean = false;
		public function ComboBoxItem() 
		{
			selectedSpr = this.getChildByName("selected_mc") as Sprite;
			textFiled = this.getChildByName("item_txt") as TextField;
			bgSpr = this.getChildByName("bg_mc") as Sprite;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function set selected(b:Boolean):void
		{
			_selected = b;
			if (selectedSpr)
				selectedSpr.visible = b;
		}
		public function get selected():Boolean { return _selected };
		public function set text(str:String):void { _text = str; }
		public function get text():String { return _text; }
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bgSpr.visible = false;
			selectedSpr.visible = _selected;
			if (_text)
				textFiled.text = _text;
			this.addEventListener(MouseEvent.CLICK, clickHandle);
			this.addEventListener(MouseEvent.ROLL_OVER, overHandle);
			this.addEventListener(MouseEvent.ROLL_OUT, outHandle);
		}
		private function overHandle(e:MouseEvent):void
		{
			bgSpr.visible = true;
			textFiled.textColor = 0xffffff;
		}
		private function outHandle(e:MouseEvent):void
		{
			bgSpr.visible = false;
			textFiled.textColor = 0x2b2b2b;
		}
		private function clickHandle(e:MouseEvent):void
		{
			_selected = true;
			selectedSpr.visible = true;
		}
	}

}