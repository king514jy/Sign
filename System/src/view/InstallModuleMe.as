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
	import systemSetUI.menu.template.InstallItem;
	import systemSetUI.menu.template.InstallModuleUI;
	
	public class InstallModuleMe extends Mediator implements IMediator
	{
		public static const NAME:String = "InstallModuleMe";
		private var installUI:InstallModuleUI;
		private var nowItem:InstallItem;
		private var root:Sprite;
		private var thisGroup:Sprite;
		private var closeSpr:Sprite;
		public function InstallModuleMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
		}
		public function get path():String{ return installUI.path; }
		public function set info(str:String):void{ installUI.info = str;}
		public function set complete(b:Boolean):void{ installUI.complete = b;}
		public function openUI():void
		{
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			installUI = new InstallModuleUI();
			thisGroup.addChild(installUI);
			installUI.addEventListener(SetUIEvent.INSTALL_BEGIN,installBegin);
			installUI.addEventListener(ChangeDataEvent.SELECT_FILE,selectFile);
			addCloseSpr();
		}
		private function installBegin(e:SetUIEvent):void
		{
			this.sendNotification(SystemFacade.INSTALL_MODULE,{path:installUI.path});
		}
		private function selectFile(e:ChangeDataEvent):void
		{
			var file:File = File.desktopDirectory;
			file.browseForOpen("选择模块文件",[new FileFilter("mt",e.strValue)]);
			file.addEventListener(Event.SELECT,setPath);
		}
		private function setPath(e:Event):void
		{
			var file:File = e.target as File;
			installUI.path = file.nativePath;
			installUI.allowInstall = true;
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
			thisGroup.removeChild(installUI);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
			root.removeChild(thisGroup);
			thisGroup = null;
			this.sendNotification(SystemFacade.OPEN_SYSTEM_MENU);
		}
	}
}