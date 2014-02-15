package systemSetUI
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import systemSetUI.events.NumberKeyboardEvent;
	import systemSetUI.events.InputPasswordEvent;

	public class InputPassword extends Sprite
	{
		private var titleTxt:TextField;
		private var passwordTxt:TextField;
		private var passwordAgainTxt:TextField;
		private var bgA:MovieClip;
		private var bgB:MovieClip;
		private var enterBtn:SimpleButton;
		private var _isInit:Boolean;
		private var numKeyboard:NumberKeyboard;
		private var nowTxt:TextField;
		public function InputPassword(isInit:Boolean=false)
		{
			_isInit = isInit;
			titleTxt = this.getChildByName("title_txt") as TextField;
			passwordTxt = this.getChildByName("password_txt") as TextField;
			passwordTxt.displayAsPassword = true;
			passwordAgainTxt = this.getChildByName("password_again_txt") as TextField;
			passwordAgainTxt.displayAsPassword = true;
			bgA = this.getChildByName("bgA_mc") as MovieClip;
			bgB = this.getChildByName("bgB_mc") as MovieClip;
			enterBtn = this.getChildByName("enter_btn") as SimpleButton;
			numKeyboard = new NumberKeyboard();
			numKeyboard.x = -143;
			numKeyboard.addEventListener(NumberKeyboardEvent.CLICK_NUM,clickNum);
			numKeyboard.addEventListener(NumberKeyboardEvent.CLOSE,closeNum);
			setSelf();
			this.addEventListener(Event.ADDED_TO_STAGE,addToSatge);
		}
		public function set isInit(b:Boolean):void
		{ 
			_isInit = b;
			setSelf();
		}
		public function get isInit():Boolean{ return _isInit; }
		private function addToSatge(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,remove);
			if(_isInit)
				passwordAgainTxt.addEventListener(MouseEvent.CLICK,clickHandle);
			passwordTxt.addEventListener(MouseEvent.CLICK,clickHandle);
			enterBtn.addEventListener(MouseEvent.CLICK,enterClick);
		}
		private function setSelf():void
		{
			if(_isInit)
			{
				titleTxt.text = "请设置密码";
				titleTxt.y = -172;
				bgA.y = -122;
				passwordTxt.y = -118;
				passwordTxt.text = "";
				bgB.visible = true;
				passwordAgainTxt.visible = true;
				passwordAgainTxt.text = "";
				again_mc.visible = true;
			}
			else
			{
				titleTxt.text = "请输入密码";
				titleTxt.y = -80;
				bgA.y = -30;
				passwordTxt.y = -26;
				passwordTxt.text = "";
				bgB.visible = false;
				passwordAgainTxt.visible = false;
				passwordAgainTxt.text = "";
				again_mc.visible = false;
			}
		}
		private function clickHandle(e:MouseEvent):void
		{
			var txt:TextField = e.currentTarget as TextField;
			nowTxt = txt;
			numKeyboard.y = txt.y + 60;
			this.addChild(numKeyboard);
		}
		private function clickNum(e:NumberKeyboardEvent):void
		{
			if(numKeyboard.info != "de")
			{
				nowTxt.appendText(numKeyboard.info);
			}
			else
			{
				var str:String = nowTxt.text;
				if(str.length>1)
				{
					nowTxt.text = str.substring(0,str.length-1);
				}
				else
				{
					nowTxt.text = "";
				}
			}
		}
		private function enterClick(e:MouseEvent):void
		{
			if(_isInit)
			{
				if(passwordTxt.text == passwordAgainTxt.text)
				{
					dispatchEvent(new InputPasswordEvent(InputPasswordEvent.ENTER,passwordTxt.text));
				}
				else
				{
					titleTxt.text = "两次输入不一致请从新输入";
					passwordTxt.text = "";
					passwordAgainTxt.text = "";
				}
			}
			else
			{
				dispatchEvent(new InputPasswordEvent(InputPasswordEvent.VERIFY,passwordTxt.text));
			}
			
		}
		public function passwordError():void
		{
			titleTxt.text = "密码错误请从新输入";
			passwordTxt.text = "";
			passwordAgainTxt.text = "";
		}
		private function closeNum(e:NumberKeyboardEvent):void
		{
			this.removeChild(numKeyboard);
		}
		private function remove(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,remove);
			if(passwordAgainTxt.hasEventListener(MouseEvent.CLICK))
				passwordAgainTxt.removeEventListener(MouseEvent.CLICK,clickHandle);
			passwordTxt.removeEventListener(MouseEvent.CLICK,clickHandle);
			enterBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
		}
	}
	
}
