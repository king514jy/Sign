package systemSetUI.menu
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import systemSetUI.NumberKeyboard;
	import systemSetUI.events.NumberKeyboardEvent;
	import systemSetUI.events.SetUIEvent;
	
	public class ChangePassword extends Sprite
	{
		private var oldPasswordTxt:TextField;
		private var okBtn:SimpleButton;
		private var tipsTxt:TextField;
		private var newPasswordTxt:TextField;
		private var identifyNewPasswordTxt:TextField;
		private var saveBtn:SimpleButton;
		private var uiAMc:MovieClip;
		private var uiBMc:MovieClip;
		public var password:String;
		private var nowTxt:TextField;
		private var numberKeyboard:NumberKeyboard;
		public function ChangePassword(password:String=null)
		{
			this.password = password;
			oldPasswordTxt = this.getChildByName("old_password_txt") as TextField;
			okBtn = this.getChildByName("ok_btn") as SimpleButton;
			tipsTxt = this.getChildByName("tips_txt") as TextField;
			newPasswordTxt = this.getChildByName("new_password_txt") as TextField;
			identifyNewPasswordTxt = this.getChildByName("identify_new_password_txt") as TextField;
			saveBtn = this.getChildByName("save_btn") as SimpleButton;
			uiAMc = this.getChildByName("uiA_mc") as MovieClip;
			uiBMc = this.getChildByName("uiB_mc") as MovieClip;
			oldPasswordTxt.displayAsPassword = true;
			newPasswordTxt.displayAsPassword = true;
			identifyNewPasswordTxt.displayAsPassword = true;
			numberKeyboard = new NumberKeyboard();
			numberKeyboard.x = 240;
			numberKeyboard.y = 360;
			numberKeyboard.addEventListener(NumberKeyboardEvent.CLOSE,closeKeyboard);
			numberKeyboard.addEventListener(NumberKeyboardEvent.CLICK_NUM,clickKeyboard);
			changeUI("A");
			
			okBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			saveBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			
			oldPasswordTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			newPasswordTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			identifyNewPasswordTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			
			tipsTxt.text = "";
		}
		public function set tips(str:String):void{ tipsTxt.text = str; }
		public function get tips():String{ return tipsTxt.text}
		private function changeUI(status:String):void
		{
			var b:Boolean;
			if(status == "A")
				b=false;
			else
				b=true;
			uiBMc.visible = b;
			newPasswordTxt.visible = b;
			identifyNewPasswordTxt.visible = b;
			saveBtn.visible = b;
			
			oldPasswordTxt.visible = !b;
			okBtn.visible = !b;
			uiAMc.visible = !b;
		}
		private function clickHandle(e:MouseEvent):void
		{
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			if(btn == okBtn)
			{
				if(oldPasswordTxt.text==this.password)
				{
					changeUI("B");
					tipsTxt.text = "";
				}
				else
				{
					oldPasswordTxt.text = "";
					tipsTxt.text = "密码错误，请从新输入！";
				}
			}
			else
			{
				if(newPasswordTxt.text == identifyNewPasswordTxt.text)
				{
					tipsTxt.text = "";
					this.password = newPasswordTxt.text;
					dispatchEvent(new SetUIEvent(SetUIEvent.CHANGE_PASSWORD));
				}
				else
				{
					newPasswordTxt.text = "";
					identifyNewPasswordTxt.text = "";
					tipsTxt.text = "两次输入的密码不一致，请从新输入！";
				}
			}
		}
		private function clickTxt(e:MouseEvent):void
		{
			var text:TextField = e.currentTarget as TextField;
			nowTxt = text;
			this.addChild(numberKeyboard);
		}
		private function closeKeyboard(e:NumberKeyboardEvent):void
		{
			this.removeChild(numberKeyboard);
		}
		private function clickKeyboard(e:NumberKeyboardEvent):void
		{
			if(numberKeyboard.info != "de")
			{
				nowTxt.appendText(numberKeyboard.info);
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
	}
}