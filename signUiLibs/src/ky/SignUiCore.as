package ky
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Camera;
	
	public class SignUiCore extends Sprite
	{
		public var requestList:Vector.<String>;
		public var eventList:Vector.<String>;
		private var eventBodyList:Vector.<Object>;
		public var path:String;
		public var direction:String;
		public function SignUiCore()
		{
			requestList = new Vector.<String>();
			eventList = new Vector.<String>();
			eventBodyList = new Vector.<Object>();
		}
		public function init(path:String,direction:String="up"):void
		{
			
		}
		public function injectCamera(camera:Camera):void
		{
			
		}
		public function injectCameraPic(bmpDa:BitmapData):void
		{
			
		}
		public function clear():void
		{
			
		}
		public function injectShareQRCode(bitmap:Bitmap,netID:String,id:String):void
		{
			
		}
	}
}