package signUi
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Camera;
	
	public class SignUiCore extends Sprite
	{
		public var requestList:Vector.<String>;
		public var eventList:Vector.<String>;
		public function SignUiCore()
		{
			requestList = new Vector.<String>();
			eventList = new Vector.<String>();
		}
		public function init(stageW:Number,stageH:Number,direction:String="up",ip:String=null):void
		{
			
		}
		public function injectCamera(camera:Camera):void
		{
			
		}
		public function injectCameraPic(bmpDa:BitmapData):void
		{
			
		}
		public function openUI():void
		{
			
		}
		public function closeUI():void
		{
			
		}
	}
}