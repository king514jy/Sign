package view
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import controller.AnalyzeEventCmd;
	import controller.AnalyzeRequestCmd;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import signUi.mode.NetWorkEventMode;
	import signUi.mode.SetRoleMode;
	import signUi.mode.SetTerminalMode;
	import signUi.net.SocketNetWork;
	
	import view.conmponents.AppRoot;
	
	public class ModuleMainMe extends Mediator implements IMediator
	{
		public static const NAME:String = "ModuleMainMe";
		private var root:Sprite;
		private var appRoot:AppRoot;
		private var _newMain:Object
		private var role:String;
		private var terminal:String;
		private var ip:String;
		private var direction:String;
		private var socketNetWork:SocketNetWork;
		public function ModuleMainMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
			appRoot = AppRoot.getInstance();
		}
		public function get newMain():Object{ return _newMain; }
		public function renderMasterFile(url:String,terminal:String,direction:String=null):void
		{
			this.role = role;
			this.terminal = terminal;
			this.ip = ip;
			this.direction = direction;
			var appDo:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			var loaderContext:LoaderContext = new LoaderContext(false,appDo)
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url),loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		private function onComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			var main:Class = loader.contentLoaderInfo.applicationDomain.getDefinition("SignUIMain") as Class;
			_newMain = new main();
			var display:DisplayObject = _newMain as DisplayObject;
			root.addChild(display);
			if(terminal==SetTerminalMode.OPERATE)
			{
				this.facade.registerCommand(SystemFacade.ANALYZE_REQUEST,AnalyzeRequestCmd);
				this.facade.registerCommand(SystemFacade.ANALYZE_EVENT,AnalyzeEventCmd);
				this.sendNotification(SystemFacade.ANALYZE_REQUEST);
				var eventList:Vector.<String> = newMain.eventList;
				for(var i:int = 0;i<eventList.length;i++)
				{
					display.addEventListener(eventList[i],handleEvent,true);
				}
			}
		}
		private function handleEvent(e:Event):void
		{
			this.sendNotification(SystemFacade.ANALYZE_EVENT,e.target,e.type);
		}
		private function savePic(e:Event):void
		{
			var pic:BitmapData = _newMain.pic;
			var photo:BitmapData = _newMain.photo;
			var picID:String = _newMain.picID;
			var picFile:File = File.documentsDirectory.resolvePath("sign/"+picID+".jpg");
			var photoFile:File = File.documentsDirectory.resolvePath("signPrint/"+picID+".jpg");
			var picByt:ByteArray = new ByteArray();
			picByt = pic.encode(new Rectangle(0,0,pic.width,pic.height),new JPEGEncoderOptions(100));
			var picFs:FileStream = new FileStream();
			picFs.open(picFile,FileMode.WRITE);
			picFs.writeBytes(picByt);
			picFs.close();
			if(photo)
			{
				var photoByt:ByteArray = new ByteArray();
				photoByt = photo.encode(new Rectangle(0,0,photo.width,photo.height),new JPEGEncoderOptions(100));
				var photoFs:FileStream = new FileStream();
				photoFs.open(photoFile,FileMode.WRITE);
				photoFs.writeBytes(photoByt);
				photoFs.close();
			}
			var byt:ByteArray = new ByteArray();
			byt = pic.encode(new Rectangle(0,0,pic.width,pic.height),new JPEGEncoderOptions());
			var obj:Object = new Object();
			obj.type = NetWorkEventMode.PICTURE_TRANSPORT;
			obj.picID = picID;
			obj.byt = byt;
			socketNetWork.send(obj);
		}
		private function separate(e:Event):void
		{
			var obj:Object = new Object();
			obj.type = NetWorkEventMode.PICTURE_SEPARATE;
			obj.picID = _newMain.picID;
		}
	}
}