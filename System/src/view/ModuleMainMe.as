package view
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetDataEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import controller.AnalyzeEventCmd;
	import controller.AnalyzeRequestCmd;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import signUi.mode.SetTerminalMode;
	import signUi.net.SocketNetWork;
	
	import view.conmponents.AppRoot;
	
	public class ModuleMainMe extends Mediator implements IMediator
	{
		public static const NAME:String = "ModuleMainMe";
		private var root:Sprite;
		private var appRoot:AppRoot;
		private var _newMain:Object
		private var display:DisplayObject;
		private var role:String;
		private var terminal:String;
		private var direction:String;
		private var path:String;
		private var picList:Vector.<String>;
		private var socketNetWork:SocketNetWork;
		
		public function ModuleMainMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
			appRoot = AppRoot.getInstance();
		}
		public function get newMain():Object{ return _newMain; }
		public function renderMasterFile(path:String,url:String,terminal:String,direction:String=null,picList:Vector.<String>=null):void
		{
			this.terminal = terminal;
			this.direction = direction;
			this.path = path;
			this.picList = picList;
			if(_newMain)
			{
				root.removeChild(display);
				display = null;
				if(newMain.hasOwnProperty("eventList"))
				{
					var eventList:Vector.<String> = newMain.eventList;
					for(var i:int = 0;i<eventList.length;i++)
					{
						_newMain.removeEventListener(eventList[i],handleEvent);
						_newMain.removeEventListener(eventList[i],handleEvent,true);
					}
				}
				_newMain = null;
			}
			var swfBytes:ByteArray = new ByteArray();
			var file:File = new File(url);
			
			var loadStream:FileStream = new FileStream();
			loadStream.open( file, FileMode.READ );
			loadStream.readBytes(swfBytes);
			loadStream.close();
			
			var loader:Loader = new Loader();
			var appDo:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			var loaderContext:LoaderContext = new LoaderContext(false,appDo);
			loaderContext.allowLoadBytesCodeExecution = true;
			loader.loadBytes( swfBytes, loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			
		}
		private function onComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			var main:Class;
			if(terminal==SetTerminalMode.OPERATE)
				main = loader.contentLoaderInfo.applicationDomain.getDefinition("SignUIMain") as Class;
			else
				main = loader.contentLoaderInfo.applicationDomain.getDefinition("SignShowUIMain") as Class;
			_newMain = new main();
			display = _newMain as DisplayObject;
			root.addChild(display);
			
			if(terminal==SetTerminalMode.OPERATE)
				_newMain.init(path,direction);
			else
				_newMain.init(path,direction,picList);
			
			if(terminal==SetTerminalMode.OPERATE)
			{
				this.facade.registerCommand(SystemFacade.ANALYZE_REQUEST,AnalyzeRequestCmd);
				this.facade.registerCommand(SystemFacade.ANALYZE_EVENT,AnalyzeEventCmd);
				this.sendNotification(SystemFacade.ANALYZE_REQUEST);
				var eventList:Vector.<String> = newMain.eventList;
				for(var i:int = 0;i<eventList.length;i++)
				{
					_newMain.addEventListener(eventList[i],handleEvent);
					_newMain.addEventListener(eventList[i],handleEvent,true);
				}
			}
		}
		private function handleEvent(e:NetDataEvent):void
		{
			//trace("收到事件+"+e.type+"发送者"+e.target);
			this.sendNotification(SystemFacade.ANALYZE_EVENT,e.info,e.type);
		}
	}
}