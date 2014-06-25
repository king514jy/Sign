package ky.controller
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class AnalogClock extends Sprite
	{
		public static const HALT:String = "halt";
		public static const CONSISTENT:String = "consistent";
		
		private var hourSpr:DisplayObject;
		private var minuteSpr:DisplayObject;
		private var secondSpr:DisplayObject;
		private var mode:String;
		
		private var second:Number;
		private var minute:Number;
		private var hour:Number;
		private var date:Date;
		private var graduate:uint = 6;
		private var graduate2:uint = 30;
		
		private var oldTime:int;
		private var offset:int;
		public function AnalogClock(hourSpr:DisplayObject,minuteSpr:DisplayObject=null,secondSpr:DisplayObject=null,mode:String="halt",add:Boolean=false)
		{
			this.hourSpr = hourSpr;
			this.minuteSpr = minuteSpr;
			this.secondSpr = secondSpr;
			this.mode = mode;
			if(mode == HALT)
				offset = 1000;
			else
				offset = 167;
			if(add)
			{
				this.addChild(hourSpr);
				if(minuteSpr)
					this.addChild(minuteSpr);
				if(secondSpr)
					this.addChild(secondSpr);
			}
			init();
		}
		private function init():void
		{
			date = new Date();
			second = date.getSeconds();
			minute = date.getMinutes();
			hour = date.getHours();
			hourSpr.rotation = graduate2 * hour + minute * 0.5;
			if(secondSpr)
				secondSpr.rotation = graduate * second;
			if(minuteSpr)
				minuteSpr.rotation = graduate * minute + second * 0.1;
			oldTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME,run);
		}
		private function run(e:Event):void
		{
			var n:Number = getTimer();
			if(getTimer() - oldTime >= offset)
			{
				setTime();
				oldTime =n;
			}
		}
		private function setTime():void
		{
			date.setTime(date.valueOf() + offset);
			second = date.getSeconds();
			minute = date.getMinutes();
			hour = date.getHours();
			secondSpr.rotation = graduate * second;
			minuteSpr.rotation = graduate * minute + second * 0.1;
			hourSpr.rotation = graduate2 * hour + minute * 0.5;
		}
		public function dispose():void
		{
			this.removeEventListener(Event.ENTER_FRAME,run);
			date = null;
			secondSpr = null;
			minuteSpr = null;
			hourSpr = null;
		}
	}
}