package signUi.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import signUi.events.AnimationEvent;
	
	public class WaitNumberAnimation extends Sprite
	{
		private var _size:uint = 20;
		private var _fontName:String;
		private var _interval:uint;
		private var _startNumber:int;
		private var _endNumber:int;
		private var nowNumber:int;
		private var txt:TextField;
		private var oldTime:uint;
		public function WaitNumberAnimation(startNumber:int=3,endNumber:int=0,interval:uint=1000,fontName:String="_sans",
											size:uint=20,color:uint=0)
		{
			_interval = interval;
			_startNumber = startNumber;
			_endNumber = endNumber;
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.multiline = false;
			txt.wordWrap = false;
			//txt.border = true;
			var tff:TextFormat = new TextFormat(fontName,size,color);
			txt.defaultTextFormat = tff;
			this.addChild(txt);
			setPoint();
			
		}
		public function start():void
		{
			nowNumber = _startNumber;
			txt.text = String(nowNumber);
			setPoint();
			oldTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME,run);
		}
		public function stop():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME,run);
		}
		private function run(e:Event):void
		{
			if(getTimer() - oldTime >= _interval)
			{
				if(_startNumber > _endNumber)
					nowNumber--;
				else
				nowNumber++;
				oldTime = getTimer();		
				if(nowNumber == _endNumber)
				{
					this.removeEventListener(Event.ENTER_FRAME,run);
					dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));		
				}
				txt.text = String(nowNumber);
				setPoint();
			}
		}
		private function setPoint():void
		{
			txt.x = -txt.width * 0.5;
			txt.y = -txt.height * 0.5;
		}
	}
}