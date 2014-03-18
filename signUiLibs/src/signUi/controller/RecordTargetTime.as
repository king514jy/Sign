package signUi.controller
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import signUi.events.RecordTimeEvent;
	
	public class RecordTargetTime extends EventDispatcher
	{
		private var _display:DisplayObject;
		private var oldTime:uint;
		private var time:uint;
		/**
		 *为displayobject添加一个计时器
		 * @param displayobject 目标
		 * @param time 时间(毫秒)
		 * 
		 */
		public function RecordTargetTime(displayobject:DisplayObject,time:uint)
		{
			_display = displayobject;
			this.time = time;
		}
		public function get display():DisplayObject{ return _display; }
		public function start():void
		{
			oldTime = getTimer();
			_display.addEventListener(Event.ENTER_FRAME,run);
		}
		private function run(e:Event):void
		{
			if(getTimer() - oldTime >= time)
			{
				_display.removeEventListener(Event.ENTER_FRAME,run);
				dispatchEvent(new RecordTimeEvent(RecordTimeEvent.TIME_COMPLETE));
			}
		}
	}
}