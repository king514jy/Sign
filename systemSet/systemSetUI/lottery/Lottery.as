package systemSetUI.lottery
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import systemSetUI.NumberKeyboard;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.NumberKeyboardEvent;
	
	public class Lottery extends Sprite
	{
		private var numberTxt:TextField;
		private var selectBtn:MovieClip;
		private var pathTxt:TextField;
		private var handBtn:MovieClip;
		private var nowTxt:TextField;
		
		private var setCheat:SetCheat;
		public function Lottery()
		{
			var maskSpr:Sprite = new Sprite();
			maskSpr.graphics.beginFill(0,0.5);
			maskSpr.graphics.drawRect(0,0,862,467);
			maskSpr.graphics.endFill();
			this.addChild(maskSpr);
			this.mask = maskSpr;
			
			numberTxt = this.getChildByName("number_path_txt") as TextField;
			selectBtn = this.getChildByName("select_btn") as MovieClip;
			pathTxt = this.getChildByName("pic_path_txt") as TextField;
			handBtn = this.getChildByName("hand_btn") as MovieClip;
			setCheat = this.getChildByName("cheat_mc") as SetCheat;
			numberTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			pathTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			
			selectBtn.addEventListener(MouseEvent.CLICK,clickBtn);
			handBtn.addEventListener(MouseEvent.CLICK,clickBtn);
			handBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			handBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			
			setCheat.addEventListener("back",back);
		}
		public function get requesterTxt():TextField{ return nowTxt;}
		public function get numberPath():String{ return numberTxt.text;}
		public function get picPath():String{ return pathTxt.text;}
		private function clickTxt(e:MouseEvent):void
		{
			var txt:TextField = e.currentTarget as TextField;
			nowTxt = txt;
			if(txt == numberTxt)
				dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FILE));
			else
				dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FOLDER));
		}
		
		private function clickBtn(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if(mc == selectBtn)
			{
				if(mc.currentFrame==1)
				{
					mc.gotoAndStop(2);
					pathTxt.removeEventListener(MouseEvent.CLICK,clickTxt);
					nowTxt = pathTxt;
					dispatchEvent(new ChangeDataEvent(ChangeDataEvent.REQUEST_PROJECT_FOLDER));
				}
				else
				{
					mc.gotoAndStop(1);
					pathTxt.addEventListener(MouseEvent.CLICK,clickTxt);
					pathTxt.text = "";
				}
			}
			else
			{
				TweenLite.to(setCheat,1,{x:"-862",ease:Quint.easeInOut});
			}
		}
		private function back(e:Event):void
		{
			TweenLite.to(setCheat,1,{x:"862",ease:Quint.easeInOut});
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
	}
}