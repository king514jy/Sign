package systemSetUI.lottery
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import systemSetUI.events.ChangeDataEvent;
	
	public class SetCheat extends Sprite
	{
		private var backBtn:Sprite;
		private var numberBtn:MovieClip;
		private var picBtn:MovieClip;
		
		private var numberMc:MovieClip;
		private var picMc:MovieClip;
		
		private var numberPathTxt:TextField;
		private var aBtn:MovieClip;
		private var bBtn:MovieClip;
		private var picPathTxt:TextField;
		public var nowTxt:TextField;
		public function SetCheat()
		{
			backBtn = this.getChildByName("back_btn") as MovieClip;
			numberBtn = this.getChildByName("number_btn") as MovieClip;
			picBtn = this.getChildByName("pic_btn") as MovieClip;
			
			numberMc = this.getChildByName("number_mc") as MovieClip;
			picMc = this.getChildByName("pic_mc") as MovieClip;
			
			numberPathTxt = numberMc.getChildByName("number_txt") as TextField;
			aBtn = picMc.getChildByName("a_btn") as MovieClip;
			bBtn = picMc.getChildByName("b_btn") as MovieClip;
			picPathTxt = picMc.getChildByName("path_txt") as TextField;
			init();
		}
		private function init():void
		{
			numberBtn.gotoAndStop(2);
			picMc.visible = false;
			backBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			numberBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			picBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			aBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			bBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			
			numberPathTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			picPathTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			bBtn.gotoAndStop(2);
		}
		private function clickHandle(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch(mc)
			{
				case backBtn:
					dispatchEvent(new Event("back"));
					break;
				case numberBtn:
					numberBtn.gotoAndStop(2);
					picBtn.gotoAndStop(1);
					picMc.visible = false;
					numberMc.visible = true;
					break;
				case picBtn:
					numberBtn.gotoAndStop(1);
					picBtn.gotoAndStop(2);
					picMc.visible = true;
					numberMc.visible = false;
					break;
				case aBtn:
					aBtn.gotoAndStop(2);
					bBtn.gotoAndStop(1);
					dispatchEvent(new ChangeDataEvent(ChangeDataEvent.REQUEST_LOTTERY_PIC_LIST));
					if(picPathTxt.hasEventListener(MouseEvent.CLICK))
						picPathTxt.removeEventListener(MouseEvent.CLICK,clickTxt);
					break;
				case bBtn:
					aBtn.gotoAndStop(1);
					bBtn.gotoAndStop(2);
					picPathTxt.addEventListener(MouseEvent.CLICK,clickTxt);
					break;
			}
		}
		private function clickTxt(e:MouseEvent):void
		{
			var txt:TextField = e.currentTarget as TextField;
			nowTxt = txt;
			if(txt==numberPathTxt)
				dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FILE));
			else
				dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FOLDER));
		}
	}
}