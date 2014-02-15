package systemSetUI.cfg.components 
{
	import flash.display.Sprite;
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
			bgSpr.visible = false;
			selectedSpr.visible = _selected;
			this.addEventListener(MouseEvent.CLICK, clickHandle);
		}
		public function set selected(b:Boolean):void
		{
			_selected = b;
			selectedSpr.visible = b;
			bgSpr.visible = b;
			if (b)
				textFiled.textColor = 0xffffff;
			else
				textFiled.textColor = 0x2b2b2b;
		}
		public function get selected():Boolean { return _selected };
		public function set text(str:String):void { textFiled.text = str; }
		public function get text():String { return textFiled.text; }
		private function clickHandle(e:MouseEvent):void
		{
			bgSpr.visible = true;
			textFiled.textColor = 0xffffff;
			_selected = true;
			selectedSpr.visible = true;
			bgSpr.visible = true;
		}
	}

}