package signUi.controller 
{
	 import flash.utils.getTimer;
	/**
	 * 利用flash运行时，记录某个时间段时间
	 * ...
	 * @author King
	 */
	public class RecordTime 
	{
		private var startTime:int;//记录起始时间
		private var endTime:int;//记录停止屎时间
		private var _time:Number;//运行的时间，单位:秒
		private var isPause:Boolean = false;//是否暂停状态
		public function RecordTime() 
		{
			
		}
		public function get time():Number
		{
			return _time;
		}
		public function starRecord():void
		{
			startTime = getTimer();
		}
		public function pauseRecord():void
		{
			
		}
		public function stopRecord():void
		{
			endTime = getTimer();
			_time = (endTime - startTime) / 1000;
		}

	}

}