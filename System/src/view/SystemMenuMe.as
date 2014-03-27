package view
{
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
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.InputPasswordEvent;
	import systemSetUI.events.SystemSetEvent;
	
	import view.conmponents.CoolDownEffect;
	
	public class SystemMenuMe extends Mediator implements IMediator
	{
		public var NAME:String = "SystemMenuMe";
		
		private var inputPassword:InputPassword;
		private var password:String;
		private var root:Sprite;
		private var stage:Stage;
		private var longGesture:LongPressGesture;
		private var cdEffrect:CoolDownEffect;
		private var openTips:OpenTips;
		private var closeSpr:Sprite;
		private var thisGroup:Sprite;
		public function SystemMenuMe(viewComponent:Object=null)
		{
			super(viewComponent);
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
			cdEffrect.play(openTips.circleSpr,4000,0,openMenu);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopCD);
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
			
			if(!isInitial)
			{
				password = obj.password;
				inputPassword.addEventListener(InputPasswordEvent.VERIFY,verify);
				addCloseSpr();
			}
			else
			{
				inputPassword.addEventListener(InputPasswordEvent.ENTER,setPassword);
			}
		}
	}
}