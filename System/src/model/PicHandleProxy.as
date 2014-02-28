package model
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class PicHandleProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PicHandleProxy";
		public function PicHandleProxy(data:Object=null)
		{
			super(NAME, data);
		}
		public function savePic(obj:Object,path:String):void
		{
			var picFile:File = new File(path+"/"+obj.folderName+"/"+obj.id+".jpg");
			var picByt:ByteArray = obj.byt;
			var picFs:FileStream = new FileStream();
			picFs.open(picFile,FileMode.WRITE);
			picFs.writeBytes(picByt);
			picFs.close();
		}
	}
}