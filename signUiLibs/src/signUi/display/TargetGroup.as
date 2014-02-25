package signUi.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class TargetGroup extends Sprite
	{
		private var _display:DisplayObject;
		private var _isCenter:Boolean;
		public function TargetGroup(display:DisplayObject,isCenter:Boolean=true)
		{
			_display = display;
			this.addChild(_display);
			_isCenter = isCenter;
			setPoint();
		}
		public function get display():DisplayObject{ return _display; }
		public function set isCenter(b:Boolean):void
		{
			_isCenter = b;
			setPoint();
		}
		public function get isCenter():Boolean{ return _isCenter; }
		private function setPoint():void
		{
			if(_isCenter)
			{
				_display.x = -_display.width * 0.5;
				_display.y = -display.height * 0.5;
			}
			else
			{
				_display.x = 0;
				_display.y = 0;
			}
		}
		public function dispose():void
		{
			this.removeChild(_display);
			_display = null;
		}
	}
}