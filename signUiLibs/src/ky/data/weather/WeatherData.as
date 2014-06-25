package ky.data.weather
{
	import flash.events.EventDispatcher;
	
	public class WeatherData extends EventDispatcher
	{
		/**
		 * 城市
		 */
		public var city:String;
		/**
		 * 天气状态
		 */
		public var status:String;
		/**
		 * 风向
		 */
		public var direction:String ;
		/**
		 * 风级
		 */
		public var power:String;
		/**
		 * 最高温度
		 */
		public var temperature1:String;
		/**
		 * 最低温度
		 */
		public var temperature2:String
		/**
		 * 当前温度
		 */
		public var tgd1:String;
		/**
		 * 相当于今天开始第几天的数据,0为当天
		 */
		public var day:int;
		public function WeatherData()
		{
			
		}
	}
}