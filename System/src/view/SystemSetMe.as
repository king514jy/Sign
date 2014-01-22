package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.LongPressGesture;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.InputPassword;
	import systemSetUI.OpenTips;
	import systemSetUI.SetUIPage;
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.InputPasswordEvent;
	import systemSetUI.events.SystemSetEvent;
	
	import view.conmponents.CoolDownEffect;
	
	public class SystemSetMe extends Mediator implements IMediator
	{
		public static const NAME:String = "SystemSetMe";
		private var setPage:SetUIPage;
		private var inputPassword:InputPassword;
		private var password:String;
		private var root:Sprite;
		private var stage:Stage;
		private var longGesture:LongPressGesture;
		private var cdEffrect:CoolDownEffect;
		private var openTips:OpenTips;
		private var closeSpr:Sprite;
		private var thisGroup:Sprite;
		public function SystemSetMe(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
			root = viewComponent as Sprite;
			stage = root.stage;
			addGesture();
		}
		private function addGesture():void
		{
			longGesture = new LongPressGesture(stage);
			longGesture.minPressDuration = 3000;
			longGesture.addEventListener(GestureEvent.GESTURE_BEGAN,onGesture);
		}
		private function removeGesture():void
		{
			if(longGesture)
			{
				longGesture.removeEventListener(GestureEvent.GESTURE_BEGAN,onGesture);
				longGesture.dispose();
				longGesture = null;
			}
		}
		private function onGesture(e:GestureEvent):void
		{
			openTips = new OpenTips();
			openTips.x = longGesture.location.x;
			openTips.y = longGesture.location.y;
			if(root.numChildren>1)
				root.addChildAt(openTips,root.numChildren-1);
			else
				root.addChild(openTips);
			removeGesture();
			cdEffrect = new CoolDownEffect();
			cdEffrect.play(openTips.circleSpr,4000,0,loadConfig);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopCD);
		}
		private function loadConfig():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopCD);
			root.removeChild(openTips);
			openTips = null;
			cdEffrect = null;
			var obj:Object = new Object();
			obj.isSet = true;
			this.sendNotification(SystemFacade.LOAD_CONFIG,obj);
		}
		private function stopCD(e:MouseEvent):void
		{
			if(cdEffrect)
			{
				cdEffrect.stop(false);
				cdEffrect = null;
			}
			if(openTips && root.contains(openTips))
			{
				root.removeChild(openTips);
				openTips = null;
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopCD);
			addGesture();
		}
		public function openUI(isInitial:Boolean,obj:Object=null):void
		{
			removeGesture();
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			inputPassword = new InputPassword(isInitial);
			inputPassword.x = 1024 * 0.5;
			inputPassword.y = 768 * 0.5;
			thisGroup.addChild(inputPassword);
			var signleURL:String = File.applicationDirectory.resolvePath("assets/template_signle_config.xml").url;
			var multiURL:String = File.applicationDirectory.resolvePath("assets/template_multi_config.xml").url;
			setPage = new SetUIPage(signleURL,multiURL);
			setPage.addEventListener(SystemSetEvent.SET_COMPLETE,setComplete);
			if(!isInitial)
			{
				setPage.devices = obj.devices;
				setPage.direction = obj.direction;
				setPage.terminal = obj.terminal;
				setPage.role = obj.role;
				setPage.ip = obj.ip;
				setPage.template = obj.coding;
				password = obj.password;
				inputPassword.addEventListener(InputPasswordEvent.VERIFY,verify);
				addCloseSpr();
			}
			else
			{
				inputPassword.addEventListener(InputPasswordEvent.ENTER,setPassword);
			}
		}
		private function setPassword(e:InputPasswordEvent):void
		{
			password = e.password;
			addCloseSpr();
			enterSet();
		}
		private function verify(e:InputPasswordEvent):void
		{
			if(password != e.password)
				inputPassword.passwordError();
			else
				enterSet();
		}
		private function enterSet():void
		{
			clearInputPassword();
			thisGroup.addChildAt(setPage,0);
		}
		private function setComplete(e:SystemSetEvent):void
		{
			setPage.parent.removeChild(setPage);
			var obj:Object = new Object();
			obj.devices = setPage.devices;
			obj.direction = setPage.direction;
			obj.terminal = setPage.terminal;
			obj.role = setPage.role;
			obj.ip = setPage.ip;
			obj.coding = setPage.template;
			obj.password = password;
			this.sendNotification(SystemFacade.SAVE_SYSTEM_SET,obj);
			addGesture();
			clearSetPage();
			root.removeChild(thisGroup);
			thisGroup = null;
		}
		private function addCloseSpr():void
		{
			closeSpr = new Sprite();
			closeSpr.x = 944;
			closeSpr.y = 5;
			closeSpr.addChild(new Bitmap(new CloseData()));
			thisGroup.addChild(closeSpr);
			closeSpr.addEventListener(MouseEvent.CLICK,clickClose);
		}
		private function clearCloseSpr():void
		{
			thisGroup.removeChild(closeSpr);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
		}
		private function clickClose(e:MouseEvent):void
		{
			clearInputPassword();
			addGesture();
			clearSetPage();
			root.removeChild(thisGroup);
			thisGroup = null;
		}
		private function clearInputPassword():void
		{
			if(inputPassword && thisGroup.contains(inputPassword))
			{
				thisGroup.removeChild(inputPassword);
				if(inputPassword.hasEventListener(InputPasswordEvent.VERIFY))
					inputPassword.removeEventListener(InputPasswordEvent.VERIFY,verify);
				if(inputPassword.hasEventListener(InputPasswordEvent.ENTER))
					inputPassword.removeEventListener(InputPasswordEvent.ENTER,setPassword);
				inputPassword = null;
			}
		}
		private function clearSetPage():void
		{
			if(setPage && thisGroup.contains(setPage))
			{
				thisGroup.removeChild(setPage);
				setPage.removeEventListener(SystemSetEvent.SET_COMPLETE,setComplete);
				setPage = null;
			}
		}
	}
}