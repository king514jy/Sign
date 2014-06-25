package view
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.LongPressGesture;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.OpenTips;
	
	import view.conmponents.CoolDownEffect;
	
	public class ListeningAdministratorMe extends Mediator implements IMediator
	{
		public static const NAME:String = "ListeningAdministratorMe";
		private var root:Sprite;
		private var stage:Stage;
		private var longGesture:LongPressGesture;
		private var cdEffrect:CoolDownEffect;
		private var openTips:OpenTips;
		private var thisGroup:Sprite;
		public function ListeningAdministratorMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
			stage = root.stage;
			addGesture();
		}
		public function addGesture():void
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
		private function openMenu():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopCD);
			root.removeChild(openTips);
			openTips = null;
			cdEffrect = null;
			this.sendNotification(SystemFacade.OPEN_PASSWORD_UI,{isSet:false});
			Mouse.show();
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
	}
}