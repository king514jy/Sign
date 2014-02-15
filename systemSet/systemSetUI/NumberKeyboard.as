package systemSetUI
{
	import com.kingclass.events.MenuClickEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import systemSetUI.events.NumberKeyboardEvent;
	
	public class NumberKeyboard extends Sprite
	{
		private var btnList:Vector.<MovieClip>;
		private var numberList:Vector.<String>;
		private var _info:String;
		private var oldTime:int;
		public function NumberKeyboard()
		{
			numberList = new Vector.<String>();
			numberList.push("1","2","3","4","5","6","7","8","9",".","0","de");
			btnList = new Vector.<MovieClip>();
			var b0:MovieClip = this.getChildByName("b0_mc") as MovieClip;
			var b1:MovieClip = this.getChildByName("b1_mc") as MovieClip;
			var b2:MovieClip = this.getChildByName("b2_mc") as MovieClip;
			var b3:MovieClip = this.getChildByName("b3_mc") as MovieClip;
			var b4:MovieClip = this.getChildByName("b4_mc") as MovieClip;
			var b5:MovieClip = this.getChildByName("b5_mc") as MovieClip;
			var b6:MovieClip = this.getChildByName("b6_mc") as MovieClip;
			var b7:MovieClip = this.getChildByName("b7_mc") as MovieClip;
			var b8:MovieClip = this.getChildByName("b8_mc") as MovieClip;
			var b9:MovieClip = this.getChildByName("b9_mc") as MovieClip;
			var b10:MovieClip = this.getChildByName("b10_mc") as MovieClip;
			var b11:MovieClip = this.getChildByName("b11_mc") as MovieClip;
			btnList.push(b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11);
			for each(var mc:MovieClip in btnList)
			{
				mc.addEventListener(MouseEvent.CLICK,clickHandle);
				mc.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				mc.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			}
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public function get info():String{ return _info; }
		private function init(e:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME,record);
			oldTime = getTimer();
		}
		private function record(e:Event):void
		{
			if(getTimer()-oldTime>500)
			{
				this.removeEventListener(Event.ENTER_FRAME,record);
				stage.addEventListener(MouseEvent.CLICK,clickStage);
			}
		}
		private function mouseDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(2);
		}
		private function mouseUp(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
		}
		private function clickHandle(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var id:int = btnList.indexOf(mc);
			_info = numberList[id];
			dispatchEvent(new NumberKeyboardEvent(NumberKeyboardEvent.CLICK_NUM,_info));
		}
		private function clickStage(e:MouseEvent):void
		{
			if(!this.hitTestPoint(stage.mouseX,stage.mouseY))
			{
				stage.removeEventListener(MouseEvent.CLICK,clickStage);
				dispatchEvent(new NumberKeyboardEvent(NumberKeyboardEvent.CLOSE));
			}
		}
	}
}