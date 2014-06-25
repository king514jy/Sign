package ky.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import ky.events.AnimationEvent;
	import ky.utils.BmpIncision;
	
	public class WaitNumberAnimation extends Sprite
	{
		private var _interval:uint;
		private var _startNumber:int;
		private var _endNumber:int;
		private var nowNumber:int;
		private var oldTime:uint;
		private var bmpAr:Array;
		private var picSwitch:PicSwitchGroup;
		public function WaitNumberAnimation(numberPNG:Bitmap,cutW:Number,startNumber:int=3,endNumber:int=0,interval:uint=1000)
		{
			_interval = interval;
			_startNumber = startNumber;
			_endNumber = endNumber;
			bmpAr = new Array();
			var dataList:Vector.<BitmapData> = BmpIncision.pixel(numberPNG,cutW,numberPNG.height,null,true);
			for(var i:int = 0;i<dataList.length;i++)
			{
				bmpAr.push(new Bitmap(dataList[i]));
			}
			picSwitch = new PicSwitchGroup(bmpAr);
			this.addChild(picSwitch);
		}
		public function play():void
		{
			picSwitch.play(_startNumber,_endNumber,_interval);
			picSwitch.addEventListener(AnimationEvent.COMPLETE,onComplete);
		}
		private function onComplete(e:AnimationEvent):void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
			
		}
	}
}