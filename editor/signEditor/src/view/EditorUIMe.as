package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import signEditorUI.Main;
	import signEditorUI.ModuleList;
	import signEditorUI.SelectUI;
	import signEditorUI.TipsGroup;
	import signEditorUI.ValuePage;
	import signEditorUI.conmponents.FileValueItem;
	import signEditorUI.events.ChangeDataEvent;
	import signEditorUI.events.MenuEvent;
	
	public class EditorUIMe extends Mediator implements IMediator
	{
		public static const NAME:String = "EditorUIMe";
		
		private var main:Main;
		private var moduleList:ModuleList;
		private var selectUI:SelectUI;
		private var valuePage:ValuePage;
		private var tipsGroup:TipsGroup;
		private var root:Sprite;
		
		private var keepIndex:int;
		private var fileItem:FileValueItem;
		public function EditorUIMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
			main = new Main();
			root.addChild(main);
			tipsGroup = new TipsGroup();
			tipsGroup.addEventListener(MenuEvent.OK,tipsOK);
			tipsGroup.addEventListener(MenuEvent.OK,tipsCancel);
		}
		public function init(list:Vector.<String>):void
		{
			if(!moduleList)
			{
				moduleList = new ModuleList();
				moduleList.x = moduleList.selfX;
				moduleList.y = moduleList.selfY;
				main.addChild(moduleList);
				moduleList.addEventListener(MenuEvent.ADD,addModule);
				moduleList.addEventListener(MenuEvent.DELETE_MODULE,deleteModule);
				moduleList.addEventListener(MenuEvent.ENTER_EDITOR,enterEditor);
			}
			moduleList.inject(list);
		}
		private function addModule(e:MenuEvent):void
		{
			var file:File = File.desktopDirectory;
			file.browseForOpen("选择模板文件",[new FileFilter("mt","*.mt")]);
			file.addEventListener(Event.SELECT,selectFile);
		}
		private function selectFile(e:Event):void
		{
			var file:File = e.target as File;
			this.sendNotification(EditorFacade.INSTALL_MODULE,{path:file.nativePath});
		}
		private function deleteModule(e:MenuEvent):void
		{
			keepIndex = e.index;
			main.addChildAt(tipsGroup,main.numChildren-1);
			
		}
		private function enterEditor(e:MenuEvent):void
		{
			if(!selectUI)
			{
				selectUI = new SelectUI();
				selectUI.x = selectUI.selfX;
				selectUI.y = selectUI.selfY;
				main.addChild(selectUI);
				selectUI.addEventListener(MenuEvent.SET_DISPLAY,setModule);
				selectUI.addEventListener(MenuEvent.SET_OPERATE,setModule);
				selectUI.addEventListener(MenuEvent.BACK,back);
			}
			keepIndex = e.index;
			moduleList.visible = false;
			selectUI.visible = true;
		}
		private function setModule(e:MenuEvent):void
		{
			this.sendNotification(EditorFacade.OPEN_SCREEN_BLOCK,{info:"解析模块"});
			this.sendNotification(EditorFacade.SET_MODULE,{id:keepIndex},e.type);
		}
		public function setConfig(xml:XML):void
		{
			selectUI.visible = false;
			if(!valuePage)
			{
				valuePage = new ValuePage();
				valuePage.x = valuePage.selfX;
				valuePage.y = valuePage.selfY;
				main.addChild(valuePage);
				valuePage.addEventListener(MenuEvent.BACK,back);
				valuePage.addEventListener(MenuEvent.EXPORT,export);
				valuePage.addEventListener(ChangeDataEvent.SELECT_FILE,selectConfigFile,true);
			}
			if(!main.contains(valuePage))
				main.addChild(valuePage);
			valuePage.inject(xml);
		}
		private function tipsOK(e:MenuEvent):void
		{
			this.sendNotification(EditorFacade.UNINSTALL_MODULE,{id:keepIndex});
			main.removeChild(tipsGroup);
			moduleList.deleteListItem(keepIndex);
		}
		private function tipsCancel(e:MenuEvent):void
		{
			main.removeChild(tipsGroup);
		}
		private function back(e:MenuEvent):void
		{
			if(main.contains(valuePage))
			{
				main.removeChild(valuePage);
				this.sendNotification(EditorFacade.CLEAR_TEMP_DIRECTORY);
			}
			selectUI.visible = false;
			moduleList.visible = true;
		}
		private function export(e:MenuEvent):void
		{
			var file:File = File.desktopDirectory;
			file.browseForDirectory("选择配置包保存目录");
			file.addEventListener(Event.SELECT,selectFolderExport);
		}
		private function selectFolderExport(e:Event):void
		{
			var file:File = e.target as File;
			this.sendNotification(EditorFacade.OPEN_SCREEN_BLOCK,{info:"正在导出配置包"});
			this.sendNotification(EditorFacade.EXPORT_MODULE,{path:file.nativePath+"/",xml:valuePage.getConfig()});
		}
		private function selectConfigFile(e:ChangeDataEvent):void
		{
			fileItem = e.target as FileValueItem;
			var file:File = File.desktopDirectory;
			file.browseForOpen("选择文件",[new FileFilter("文件",fileItem.extension)]);
			file.addEventListener(Event.SELECT,setPath);
		}
		private function setPath(e:Event):void
		{
			var file:File = e.target as File;
			fileItem.value = file.nativePath;
		}
	}
}