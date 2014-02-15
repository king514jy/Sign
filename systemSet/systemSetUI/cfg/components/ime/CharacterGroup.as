package systemSetUI.cfg.components.ime
{
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import systemSetUI.events.ImeEvent;
	
	public class CharacterGroup extends Sprite
	{
		private var txt:TextField;
		private var _showHeight:Number;
		private var _minWidth:Number;
		public function CharacterGroup(minWidth:Number=60,showHeight:Number=60,size:uint=30,xOffset:Number=0)
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_showHeight = showHeight;
			_minWidth = minWidth;
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.wordWrap = false;
			txt.multiline = false;
			txt.selectable = false;
			var tff:TextFormat = new TextFormat("_sans",size,0);
			txt.defaultTextFormat = tff;
			this.addChild(txt);
			this.addEventListener(TouchEvent.TOUCH_ROLL_OVER,rollOver);
			this.addEventListener(TouchEvent.TOUCH_ROLL_OUT,rollOut);
			this.addEventListener(TouchEvent.TOUCH_TAP,tap);
		}
		public function set character(str:String):void
		{
			txt.text = str;
			handleBack();
		}
		public function get character():String{ return txt.text; }
		private function handleBack(activate:Boolean=false):void
		{
			this.graphics.clear();
			var co:uint;
			var w:Number;
			if(txt.text.length>1)
				w = txt.width;
			else
				w = _minWidth;
			if(activate)
				co = 0x999999;
			else
				co = 0xffffff;
			this.graphics.beginFill(co);
			this.graphics.drawRect(0,0,w,_showHeight);
			this.graphics.endFill();
			txt.x = (w-txt.width) * 0.5;
			txt.y = (_showHeight - txt.height) * 0.5;
		}
		private function rollOver(e:TouchEvent):void
		{
			handleBack(true);
		}
		private function rollOut(e:TouchEvent):void
		{
			handleBack();
		}
		private function tap(e:TouchEvent):void
		{
			dispatchEvent(new ImeEvent(ImeEvent.TAP,txt.text));
		}
	}
}