package ky.data.weather
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Q·JY
	 */
	public class WeatherSever extends EventDispatcher 
	{
		private var _city:String;
		private var _status:String;
		private var _direction:String;
		private var _power:String;
		private var _temperature1:String;
		private var _temperature2:String;
		private var _tgd1:String;
		private var _day:int;
		private var _cityCode:String;
		private var eventType:String;
		public function WeatherSever() 
		{
			
		}
		/**
		 * 城市
		 */
		public function get city():String { return _city; }
		/**
		 * 天气状态
		 */
		public function get status():String { return _status; }
		/**
		 * 风向
		 */
		public function get direction():String { return _direction; }
		/**
		 * 风级
		 */
		public function get power():String { return _power; }
		/**
		 * 最高温度
		 */
		public function get temperature1():String { return _temperature1; }
		/**
		 * 最低温度
		 */
		public function get temperature2():String { return _temperature2; }
		/**
		 * 当前温度
		 */
		public function get tgd1():String { return _tgd1; }
		/**
		 * 相当于今天开始第几天的数据,0为当天
		 */
		public function get day():int { return _day };
		/**
		 * 
		 * @param	event 自定义事件名
		 * @param	day 0表示当天，1表示明天。类推.最大值为4
		 * @param	city 地址中city的查询，可以在百度搜索城市名，在地址栏中word后面的数据就是了
		 */
		public function load(event:String="loadOver",day:int=0,city:String="%B3%C9%B6%BC"):void
		{
			eventType = event;
			_day = day;
			_cityCode = city;
			loadBegin();
		}
		private function loadBegin():void
		{
			var url:String = "http://php.weather.sina.com.cn/xml.php?city=" + _cityCode + "&password=DJOYnieT8234jlsK&day=" + String(_day);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,error);
		}
		private function onComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			_city = xml.Weather.city;
			_status =  xml.Weather.status1;
			_direction = xml.Weather.direction1;
			_power = xml.Weather.power1;
			_temperature1 = xml.Weather.temperature1;
			_temperature2 = xml.Weather.temperature2;
			_tgd1 = xml.Weather.tgd1;
			urlLoader.removeEventListener(Event.COMPLETE,onComplete);
			urlLoader = null;
			dispatchEvent(new Event(eventType));
		}
		private function error(e:IOErrorEvent):void
		{
			loadBegin();
		}
	}
}