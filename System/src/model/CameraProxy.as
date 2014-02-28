package model
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CameraProxy extends Proxy implements IProxy
	{
		public static const NAME:String="CameraProxy";
		private var camera:Camera;
		public function CameraProxy(data:Object=null)
		{
			super(NAME, data);
		}
		public function getCamera():Camera
		{
			if(!camera)
			{
				camera = Camera.getCamera();
				camera.setMode(1440,1080,30);
				camera.setQuality(0,100);
			}
			return camera;
		}
		public function photographByDraw():BitmapData
		{
			var bmpData:BitmapData = new BitmapData(camera.width,camera.height,false);
			camera.drawToBitmapData(bmpData);
			return bmpData;
		}
		public function photographByCopyByt():BitmapData
		{
			var bmpData:BitmapData = new BitmapData(camera.width,camera.height,false);
			var rect:Rectangle = new Rectangle(0,0,camera.width,camera.height);
			var byt:ByteArray = new ByteArray();
			camera.copyToByteArray(rect,byt);
			byt.position = 0;
			bmpData.lock();
			bmpData.setPixels(rect,byt);
			bmpData.unlock();
			return bmpData;
		}
	}
}