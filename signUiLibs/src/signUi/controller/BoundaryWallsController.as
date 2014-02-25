package signUi.controller
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import signUi.mode.SetDirectionMode;
	public class BoundaryWallsController extends EventDispatcher
	{
		private var _group:DisplayObjectContainer;
		private var _re:Rectangle;
		private var _thickness:Number;
		private var _wallList:Vector.<Sprite>;
		private var _alpha:Number;
		public function BoundaryWallsController(group:DisplayObjectContainer,re:Rectangle,thickness:Number=200)
		{
			_group = group;
			_re = re;
			_thickness = thickness;
			_wallList = new Vector.<Sprite>();
			init();
		}
		public function get group():DisplayObjectContainer{ return _group; }
		public function get re():Rectangle{ return _re; }
		/**
		 * 顺序为左上右下
		 */
		public function get wallList():Vector.<Sprite>{ return _wallList; }
		public function set wallAlpha(al:Number):void{ _alpha = al;setAlpha(al); }
		public function get wallAlpha():Number{ return _alpha;}
		private function init():void
		{
			var left:Sprite = drawWall(_thickness,_re.height);
			var up:Sprite = drawWall(re.width,_thickness);
			var right:Sprite = drawWall(_thickness,_re.height);
			var bottom:Sprite = drawWall(re.width,_thickness);
			left.x = _re.x - left.width;
			left.y = _re.y;
			up.x = _re.x;
			up.y = _re.y-up.height;
			right.x = _re.right;
			right.y = _re.y;
			bottom.x = _re.x;
			bottom.y = _re.bottom;
			_wallList.push(left,up,right,bottom);
			_group.addChild(left);
			_group.addChild(up);
			_group.addChild(right);
			_group.addChild(bottom);
		}
		private function setAlpha(n:Number):void
		{
			for each(var spr:Sprite in _wallList)
			{
				spr.alpha = n;
			}
		}
		public function hitTestObject(display:DisplayObject,direction:String):Boolean
		{
			var b:Boolean;
			switch(direction)
			{
				case SetDirectionMode.LEFT:
					b = display.hitTestObject(_wallList[2]);
					break;
				case SetDirectionMode.TOP:
					b = display.hitTestObject(_wallList[3]);
					break;
				case SetDirectionMode.RIGHT:
					b = display.hitTestObject(_wallList[0]);
					break;
				case SetDirectionMode.BOTTOM:
					b = display.hitTestObject(_wallList[1]);
					break;
			}
			return b;
		}
		private function drawWall(w:Number,h:Number):Sprite
		{
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0);
			spr.graphics.drawRect(0,0,w,h);
			spr.graphics.endFill();
			return spr;
		}
	}
}