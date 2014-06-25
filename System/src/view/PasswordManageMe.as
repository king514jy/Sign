package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.InputPassword;
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.InputPasswordEvent;
	
	public class PasswordManageMe extends Mediator implements IMediator
	{
		public static const NAME:String = "PasswordManageMe";
		private var inputPassword:InputPassword;
		private var root:Sprite
		public var password:String;
		private var closeSpr:Sprite;
		public function PasswordManageMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
		}
		public function openUI(isSet:Boolean,password:String=null):void
		{
			this.password = password;
			inputPassword = new InputPassword(isSet);
			inputPassword.x = (root.stage.stageWidth - 1024) * 0.5;
			inputPassword.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(inputPassword,root.numChildren-1);
			else
				root.addChild(inputPassword);
			inputPassword.addEventListener(InputPasswordEvent.VERIFY,verify);
			inputPassword.addEventListener(InputPasswordEvent.ENTER,setPassword);
			if(!isSet)
				addCloseSpr();
		}
		private function verify(e:InputPasswordEvent):void
		{
			if(password != e.password)
				inputPassword.passwordError();
			else
				enterSet();
		}
		private function setPassword(e:InputPasswordEvent):void
		{
			password = e.password;
			this.sendNotification(SystemFacade.SET_PASSWORD);
			clearInputPassword();
			this.sendNotification(SystemFacade.OPEN_SYSTEM_SET);
			clickClose();
		}
		private function enterSet():void
		{
			this.sendNotification(SystemFacade.OPEN_SYSTEM_MENU);
			clickClose();
		}
		private function clearInputPassword():void
		{
			if(inputPassword && root.contains(inputPassword))
			{
				root.removeChild(inputPassword);
				if(inputPassword.hasEventListener(InputPasswordEvent.VERIFY))
					inputPassword.removeEventListener(InputPasswordEvent.VERIFY,verify);
				if(inputPassword.hasEventListener(InputPasswordEvent.ENTER))
					inputPassword.removeEventListener(InputPasswordEvent.ENTER,setPassword);
				inputPassword = null;
			}
		}
		private function addCloseSpr():void
		{
			closeSpr = new Sprite();
			closeSpr.x = 1080;
			closeSpr.y = 70;
			closeSpr.addChild(new Bitmap(new CloseData()));
			root.addChild(closeSpr);
			closeSpr.addEventListener(MouseEvent.CLICK,clickClose);
		}
		private function clickClose(e:MouseEvent=null):void
		{
			clearInputPassword();
			if(closeSpr && root.contains(closeSpr))
			{
				root.removeChild(closeSpr);
				closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
				closeSpr = null;
			}
			if(e)
			{
				Mouse.hide();
				this.sendNotification(SystemFacade.OPEN_ADMIN_LISTENER);
			}
		}
	}
}