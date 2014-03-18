package signUi.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import signUi.events.AnimationEvent;
	
	public class PicSwitchGroup extends Sprite
	{
		private var _list:Array;
		private var oldTime:uint;
		private var _interval:uint;
		private var _startIndex:int;
		private var _endIndex:int;
		private var _loop:Boolean;
		private var count:int;
		public function PicSwitchGroup(ar:Array)
		{
			_list = ar;
		}
		public function play(startIndex:int=0,endIndex:int=-1,interval:uint=1000,loop:Boolean = false):void
		{
			oldTime = getTimer();
			_startIndex = startIndex;
			if(endIndex==-1)
				_endIndex = _list.length-1;
			else
				_endIndex = endIndex;
			_interval = interval;
			_loop = loop;
			count = startIndex;
			this.removeChildren();
			this.addChild(_list[startIndex]);
			this.addEventListener(Event.ENTER_FRAME,playRun);
		}
		public function stop():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME,playRun);
		}
		private function playRun(e:Event):void
		{
			if(getTimer() - oldTime >= _interval)
			{
				oldTime = getTimer();
				this.removeChild(_list[count]);
				judge();
				this.addChild(_list[count]);
			}
		}
		private function judge():void
		{
			if(_startIndex < _endIndex)
			{
				if(count<_endIndex)
					count++;
				else
					setLoop();
			}
			else
			{
				if(count>_endIndex)
					count--;
				else
					setLoop();
			}
		}
		private function setLoop():void
		{
			if(_loop)
			{
				count=_startIndex;
			}
			else
			{
				count = _endIndex;
				this.removeEventListener(Event.ENTER_FRAME,playRun);
				dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
			}
		}
	}
}