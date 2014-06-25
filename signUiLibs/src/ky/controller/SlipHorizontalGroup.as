package ky.controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class SlipHorizontalGroup extends Sprite
	{
		private var _container:Sprite;
		private var maskSpr:Sprite;
		private var bounds:Rectangle;
		private var t1:uint;
		private var t2:uint;
		private var x1:Number;
		private var x2:Number;
		private var xOverlap:Number;
		private var xOffset:Number;
		private var _showWidth:Number;
		private var _showHeight:Number;
		public function SlipHorizontalGroup(showWidth:Number,showHeight:Number)
		{
			this._showWidth = showWidth;
			this._showHeight = showHeight;
			_container = new Sprite();
			this.addChild(_container);
			maskSpr = new Sprite();
			maskSpr.mouseChildren = false;
			maskSpr.mouseEnabled = false;
			this.addChild(maskSpr);
			this.mask = maskSpr;
			bounds = new Rectangle(0, 0, showWidth, showHeight);
			setMask();
			TweenPlugin.activate([ThrowPropsPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public function get container():Sprite { return _container; }
		private function init(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,removed);
			_container.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		public function setMask():void
		{
			maskSpr.graphics.beginFill(0, 0);
			maskSpr.graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
			maskSpr.graphics.endFill();
		}
		public function addItem(display:DisplayObject):void
		{
			_container.addChild(display);
		}
		private function mouseDownHandler(event:MouseEvent):void
		{
			TweenLite.killTweensOf(_container);
			x1 = x2 = _container.x;
			xOffset = this.mouseX - _container.x;
			xOverlap = Math.max(0, _container.width - bounds.width);
			t1 = t2 = getTimer();
			_container.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var x:Number = this.mouseX - xOffset;
			//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
			if (x > bounds.left) {
				_container.x = (x + bounds.left) * 0.5;
			} else if (x < bounds.left - xOverlap) {
				_container.x = (x + bounds.left - xOverlap) * 0.5;
			} else {
				_container.x = x;
			}
			var t:uint = getTimer();
			//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
			if (t - t2 > 50) 
			{
				x2 = x1;
				t2 = t1;
				x1 = _container.x;
				t1 = t;
			}
			event.updateAfterEvent();
		}
		private function mouseUpHandler(event:MouseEvent):void
		{
			_container.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_container.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var time:Number = (getTimer() - t2) / 1000;
			var xVelocity:Number = (_container.x - x2) / time;
			ThrowPropsPlugin.to(_container, {throwProps:{
				x:{velocity:xVelocity, max:bounds.left, min:bounds.left - xOverlap, resistance:300}
			}, ease:Strong.easeOut
			}, 10, 0.3, 1);
		}
		public function clear():void
		{
			if(_container.numChildren>0)
				_container.removeChildren();
			_container.x = 0;
		}
		private function removed(e:Event):void
		{
			_container.stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removed);
		}
	}
}