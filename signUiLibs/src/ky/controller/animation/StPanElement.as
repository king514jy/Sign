package ky.controller.animation
{
	import ky.starlingdisplay.PicGroup;
	
	public class StPanElement extends PicGroup
	{
		private var _orientation:String;
		private var _speed:Number;
		public function StPanElement(id:String=null, isCenter:Boolean=true, scale:Number=1, mipMaps:Boolean=false)
		{
			super(id, isCenter, scale, mipMaps);
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