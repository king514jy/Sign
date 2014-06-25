package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.SetUIEvent;
	import systemSetUI.menu.ChangePassword;
	
	public class ChangePasswordMe extends Mediator implements IMediator
	{
		public static const NAME:String = "ChangePasswordMe";
		private var root:Sprite;
		private var thisGroup:Sprite;
		private var closeSpr:Sprite;
		private var changeUI:ChangePassword;
		public function ChangePasswordMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
		}
		public function set tips(str:String):void{ changeUI.tips = str; }
		public function get tips():String{ return changeUI.tips; }
		public function openUI(password:String):void
		{
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			changeUI = new ChangePassword(password);
			thisGroup.addChild(changeUI);
			changeUI.addEventListener(SetUIEvent.CHANGE_PASSWORD,changeBegin);
			addCloseSpr();
		}
		private function changeBegin(e:SetUIEvent):void
		{
			this.sendNotification(SystemFacade.CHANGE_PASSWORD,null,changeUI.password);
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
		private function clickClose(e:MouseEvent=null):void
		{
			thisGroup.removeChild(closeSpr);
			thisGroup.removeChild(changeUI);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
			root.removeChild(thisGroup);
			thisGroup = null;
			this.sendNotification(SystemFacade.OPEN_SYSTEM_MENU);
		}
	}
}