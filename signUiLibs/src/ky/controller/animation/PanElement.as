package ky.controller.animation
{	
	import ky.display.PicGroup;
	
	public class PanElement extends PicGroup
	{
		private var _orientation:String;
		private var _speed:Number;
		public function PanElement(id:String=null,isCenter:Boolean=true,scale:Number=1,smoothing:Boolean=false)
		{
			super(id,isCenter,scale,smoothing);
		}
		/**
		 * 速度值
		 */
		public function set speed(sp:Number):void { _speed = sp; };
		/**
		 * 速度值
		 */
		public function get speed():Number { return _speed; };
		/**
		 * 方向值
		 */
		public function set orientation(str:String):void { _orientation = str; };
		/**
		 * 方向值
		 */
		public function get orientation():String { return _orientation; };
	}
}