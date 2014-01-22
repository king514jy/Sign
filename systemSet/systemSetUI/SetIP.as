package systemSetUI
{
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import systemSetUI.events.NumberKeyboardEvent;
	public class SetIP extends SetBase
	{
		private var txt:TextField;
		private var enterBtn:SimpleButton;
		private var numKeyboard:NumberKeyboard;
		private var oldTime:int;
		public function SetIP()
		{
			txt = this.getChildByName("ip_txt") as TextField;
			txt.restrict = "0-9."
			enterBtn = this.getChildByName("enter_btn") as SimpleButton;
			numKeyboard = new NumberKeyboard();
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,remove);
			enterBtn.addEventListener(MouseEvent.CLICK,enter);
			txt.addEventListener(MouseEvent.CLICK,addIme);
		}
		private function addIme(e:MouseEvent):void
		{
			txt.removeEventListener(MouseEvent.CLICK,addIme);
			this.addChild(numKeyboard);
			numKeyboard.addEventListener(NumberKeyboardEvent.CLICK_NUM,clickNumber);
			numKeyboard.addEventListener(NumberKeyboardEvent.CLOSE,closeNum);
			numKeyboard.x = -160;
			numKeyboard.y = 56;
			numKeyboard.alpha = 0;
			TweenLite.to(numKeyboard,1,{y:"-100",alpha:1,ease:Quint.easeInOut});
			TweenLite.to(title_mc,1,{y:"-100",ease:Quint.easeInOut});
			TweenLite.to(address_mc,1,{y:"-100",ease:Quint.easeInOut});
			TweenLite.to(txt,1,{y:"-100",ease:Quint.easeInOut});
			
		}
		private function clickNumber(e:NumberKeyboardEvent):void
		{
			if(numKeyboard.info != "de")
			{
				txt.appendText(numKeyboard.info);
			}
			else
			{
				var str:String = txt.text;
				if(str.length>1)
				{
					txt.text = str.substring(0,str.length-1);
				}
				else
				{
					txt.text = "";
				}
			}
		}
		private function closeNum(e:NumberKeyboardEvent):void
		{
			TweenLite.to(numKeyboard,1,{y:"100",alpha:0,ease:Quint.easeInOut,onComplete:removeNumKeyboard});
			TweenLite.to(title_mc,1,{y:"100",ease:Quint.easeInOut});
			TweenLite.to(address_mc,1,{y:"100",ease:Quint.easeInOut});
			TweenLite.to(txt,1,{y:"100",ease:Quint.easeInOut});
		}
		private function removeNumKeyboard():void
		{
			txt.addEventListener(MouseEvent.CLICK,addIme);
			this.removeChild(numKeyboard);
			numKeyboard.removeEventListener(NumberKeyboardEvent.CLICK_NUM,clickNumber);
			numKeyboard.removeEventListener(NumberKeyboardEvent.CLOSE,closeNum);
		}
		private function enter(e:MouseEvent):void
		{
			goto = 5;
			value = txt.text;
			dispatchEvent(new Event("goto"));
		}
		private function remove(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,remove);
			enterBtn.removeEventListener(MouseEvent.CLICK,enter);
			if(txt.hasEventListener(MouseEvent.CLICK))
				txt.removeEventListener(MouseEvent.CLICK,addIme);
		}
		override public function setValue(str:String):void
		{
			txt.text = str;
		}
	}
	
}
