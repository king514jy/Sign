package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.SetUIEvent;
	import systemSetUI.menu.template.UninstallModuleUI;
	
	public class UninstallModuleMe extends Mediator implements IMediator
	{
		public static const NAME:String = "UninstallModuleMe";
		private var root:Sprite;
		private var thisGroup:Sprite;
		private var closeSpr:Sprite;
		private var uninstallUI:UninstallModuleUI;
		public function UninstallModuleMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
		}
		public function set deleteComplete(b:Boolean):void
		{
			uninstallUI.deleteComplete = b;
		}
		public function openUI(path:String,templateList:Vector.<String>):void
		{
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			uninstallUI = new UninstallModuleUI();
			uninstallUI.init(path,templateList);
			thisGroup.addChild(uninstallUI);
			uninstallUI.addEventListener(SetUIEvent.UNINSTALL_BEGIN,uninstallBegin);
			addCloseSpr();
		}
		private function uninstallBegin(e:SetUIEvent):void
		{
			this.sendNotification(SystemFacade.UNINSTALL_MODULE,null,uninstallUI.deleteTemplate);
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
			thisGroup.removeChild(uninstallUI);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
			root.removeChild(thisGroup);
			thisGroup = null;
			this.sendNotification(SystemFacade.OPEN_SYSTEM_MENU);
		}
	}
}