package ky
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class SignShowUICore extends Sprite
	{
		public var path:String;
		public var direction:String;
		public function SignShowUICore()
		{
			
		}
		public function init(path:String,direction:String="bottom",list:Vector.<String>=null):void
		{
			this.path = path;
			this.direction = direction;
		}
		public function injectPic(byt:ByteArray,id:String):void
		{
			
		}
		public function changePicStatus(id:String,x:Number,y:Number,rotation:Number,scale:Number):void
		{
			
		}
		public function separatePic(id:String):void
		{
			
		}
		public function refreshPic(id:String,byt:ByteArray):void
		{
			
		}
		public function customInformation(obj:Object):void
		{
			
		}
	}
}