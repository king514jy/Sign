package model
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import signUi.mode.NetWorkEventMode;
	
	import view.conmponents.AppRoot;
	
	public class AnalyzeServerDataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "AnalyzeServerDataProxy";
		private var _path:String;
		private var appRoot:AppRoot;
		public function AnalyzeServerDataProxy(data:Object=null)
		{
			super(NAME, data);
			appRoot = AppRoot.getInstance();
		}
		public function set path(str:String):void{ _path = str; }
		public function get path():String{ return _path; }
		public function readMsg(obj:Object):void
		{
			var type:int = int(obj.type);
			//appRoot.addDebugInfo("事件＝"+type);
			if(obj)
			{
				switch(type)
				{
					case NetWorkEventMode.PICTURE_TRANSPORT:
						//appRoot.addDebugInfo("接收图片"+obj.id);
						var picFile:File = new File(_path+"signDisplay/"+obj.id+".jpg");
						var picByt:ByteArray = obj.byt;
						var picFs:FileStream = new FileStream();
						picFs.open(picFile,FileMode.WRITE);
						picFs.writeBytes(picByt);
						picByt.position = 0;
						picFs.close();
						this.sendNotification(SystemFacade.SERVER_INJECT_PIC,obj);
						break;
					case NetWorkEventMode.PICTURE_SEPARATE:
						//appRoot.addDebugInfo("脱离控制"+obj.id);
						this.sendNotification(SystemFacade.SERVER_PIC_SEPARATE,obj);
						break;
					case NetWorkEventMode.PICTURE_CHANGE_STATUS:
						//appRoot.addDebugInfo("改变图片状态+"+obj.id);
						this.sendNotification(SystemFacade.SERVER_CHANGE_PIC_STATUS,obj);
						break;
					case NetWorkEventMode.PICTURE_REFRESH:
						//appRoot.addDebugInfo("刷新图片"+obj.id);
						var picFile2:File = new File(_path+"signDisplay/"+obj.id+".jpg");
						var picByt2:ByteArray = obj.byt;
						var picFs2:FileStream = new FileStream();
						picFs2.open(picFile2,FileMode.WRITE);
						picFs2.writeBytes(picByt2);
						picByt2.position = 0;
						picFs2.close();
						this.sendNotification(SystemFacade.SERVER_REFRESH_PIC,obj);
						break;
					case NetWorkEventMode.MODULE_CUSTOM_INFORMATION:
						//appRoot.addDebugInfo("模块自由信息");
						this.sendNotification(SystemFacade.SERVER_CUSTOM_INFORMATION,obj);
						break;
				}
			}
		}
	}
}