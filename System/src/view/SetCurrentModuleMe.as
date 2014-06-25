package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.SetUIEvent;
	import systemSetUI.menu.SetCurrentModule;
	
	public class SetCurrentModuleMe extends Mediator implements IMediator
	{
		public static const NAME:String = "SetCurrentModuleMe";
		private var root:Sprite;
		private var thisGroup:Sprite;
		private var setCurrentModule:SetCurrentModule;
		private var closeSpr:Sprite;
		public function SetCurrentModuleMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
		}
		public function get path():String{ return setCurrentModule.path; }
		public function set info(str:String):void{ setCurrentModule.info = str; }
		public function get info():String{ return setCurrentModule.info; }
		public function openUI(path:String):void
		{
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			setCurrentModule = new SetCurrentModule();
			setCurrentModule.path = path;
			thisGroup.addChild(setCurrentModule);
			setCurrentModule.addEventListener(SetUIEvent.CURRENT_REGAIN,regain);
			setCurrentModule.addEventListener(SetUIEvent.CURRENT_SAVE,saveCurrent);
			setCurrentModule.addEventListener(ChangeDataEvent.SELECT_FILE,selectFile);
			addCloseSpr();
		}
		
		private function regain(e:SetUIEvent):void
		{
			setCurrentModule.path = "";
		}
		private function saveCurrent(e:SetUIEvent):void
		{
			this.sendNotification(SystemFacade.SAVE_CURRENT_MODULE);
		}
		private function selectFile(e:ChangeDataEvent):void
		{
			var file:File = File.desktopDirectory;
			file.browseForOpen("选择配置文件包",[new FileFilter("mtc","*.zip")]);
			file.addEventListener(Event.SELECT,setPath);
		}
		private function setPath(e:Event):void
		{
			var file:File = e.target as File;
			setCurrentModule.path = file.nativePath;
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
			thisGroup.removeChild(setCurrentModule);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
			root.removeChild(thisGroup);
			thisGroup = null;
			this.sendNotification(SystemFacade.OPEN_SYSTEM_MENU);
		}
	}
}