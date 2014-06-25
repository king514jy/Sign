package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.MenuEvent;
	import systemSetUI.menu.Menu;
	
	
	
	public class SystemMenuMe extends Mediator implements IMediator
	{
		public static const NAME:String = "SystemMenuMe";
		
		private var root:Sprite;
		private var closeSpr:Sprite;
		private var thisGroup:Sprite;
		private var menu:Menu;
		public function SystemMenuMe(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
			root = viewComponent as Sprite;
		}
		public function openUI():void
		{
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			menu = new Menu();
			thisGroup.addChild(menu);
			menu.addEventListener(MenuEvent.SET_SYSTEM,setSystem);
			menu.addEventListener(MenuEvent.SET_CURRENT_MODULE,setCurrentModule);
			menu.addEventListener(MenuEvent.INSTALL_MODULE,installModule);
			menu.addEventListener(MenuEvent.UNINSTALL_MODULE,uninstallModule);
			menu.addEventListener(MenuEvent.CHANGE_PASSWORD,changePassword);
			addCloseSpr();
		}
		private function setSystem(e:MenuEvent):void
		{
			clickClose();
			this.sendNotification(SystemFacade.OPEN_SYSTEM_SET);
		}
		private function setCurrentModule(e:MenuEvent):void
		{
			clickClose();
			this.sendNotification(SystemFacade.SET_CURRENT_MODULE);
		}
		private function installModule(e:MenuEvent):void
		{
			clickClose();
			this.sendNotification(SystemFacade.OPEN_INSTALL_MODULE);
		}
		private function uninstallModule(e:MenuEvent):void
		{
			clickClose();
			this.sendNotification(SystemFacade.OPEN_UNINSTALL_MODULE);
		}
		private function changePassword(e:MenuEvent):void
		{
			clickClose();
			this.sendNotification(SystemFacade.OPEN_CHANGE_PASSWORD);
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
			thisGroup.removeChild(menu);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
			root.removeChild(thisGroup);
			thisGroup = null;
			if(e)
			{
				Mouse.hide();
				this.sendNotification(SystemFacade.OPEN_ADMIN_LISTENER);
			}
		}
	}
}