package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import systemSetUI.SetProject;
	import systemSetUI.SetUIPage;
	import systemSetUI.assets.CloseData;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.SystemSetEvent;
	
	
	public class SystemSetMe extends Mediator implements IMediator
	{
		public static const NAME:String = "SystemSetMe";
		private var xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		private var setPage:SetUIPage;
		private var root:Sprite;
		private var closeSpr:Sprite;
		private var thisGroup:Sprite;
		private var setProject:SetProject;
		public function SystemSetMe(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
			root = viewComponent as Sprite;
		}
		public function openUI(obj:Object):void
		{
			thisGroup = new Sprite();
			thisGroup.x = (root.stage.stageWidth - 1024) * 0.5;
			thisGroup.y = (root.stage.stageHeight - 768) * 0.5;
			if(root.numChildren>1)
				root.addChildAt(thisGroup,root.numChildren-1);
			else
				root.addChild(thisGroup);
			var templateURL:String = File.applicationStorageDirectory.resolvePath("assets/template_list_config.xml").url;
			setPage = new SetUIPage(templateURL);
			setPage.storageDirectory = File.applicationStorageDirectory.url;
			setPage.addEventListener(SystemSetEvent.SET_COMPLETE,setComplete);
			setPage.addEventListener(ChangeDataEvent.SELECT_FOLDER,selectFolder,true);
			setPage.projectName = obj.projectName;
			setPage.projectPath = obj.projectPath;
			setPage.direction = obj.direction;
			setPage.terminal = obj.terminal;
			setPage.ip = obj.ip;
			setPage.template = obj.coding;
			thisGroup.addChild(setPage);
			addCloseSpr();
		}
		private function setComplete(e:SystemSetEvent=null):void
		{
			var obj:Object = new Object();
			obj.projectName = setPage.projectName;
			obj.projectPath = setPage.projectPath;
			obj.direction = setPage.direction;
			obj.terminal = setPage.terminal;
			obj.ip = setPage.ip;
			obj.coding = setPage.template;
			this.sendNotification(SystemFacade.SAVE_SYSTEM_SET,obj);
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
		private function clickClose(e:MouseEvent):void
		{
			clearSetPage();
			thisGroup.removeChild(closeSpr);
			closeSpr.removeEventListener(MouseEvent.CLICK,clickClose);
			closeSpr = null;
			root.removeChild(thisGroup);
			thisGroup = null;
			this.sendNotification(SystemFacade.OPEN_SYSTEM_MENU);
		}
		private function clearSetPage():void
		{
			if(setPage && thisGroup.contains(setPage))
			{
				thisGroup.removeChild(setPage);
				setPage.removeEventListener(SystemSetEvent.SET_COMPLETE,setComplete);
				setPage.removeEventListener(ChangeDataEvent.SELECT_FOLDER,selectFolder,true);
				setPage = null;
			}
		}
		private function selectFolder(e:ChangeDataEvent):void
		{
			setProject = e.target as SetProject;
			var file:File = File.desktopDirectory;
			file.browseForDirectory("选择图片保存目录");
			file.addEventListener(Event.SELECT,setFolder);
		}
		private function setFolder(e:Event):void
		{
			var file:File = e.target as File;
			setProject.projectPath = file.nativePath;
		}
	}
}