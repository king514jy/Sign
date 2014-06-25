package ky.controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	public class SlipVerticalGroup extends Sprite
	{
		private var _container:Sprite;
		private var maskSpr:Sprite;
		private var w:Number;
		private var h:Number;
		private var t1:uint;
		private var t2:uint;
		private var y1:Number;
		private var y2:Number;
		private var yOverlap:Number;
		private var yOffset:Number;
		public function SlipVerticalGroup(w:Number,h:Number)
		{
			this.w = w;
			this.h = h;
			_container = new Sprite();
			this.addChild(_container);
			maskSpr = new Sprite();
			maskSpr.mouseEnabled = false;
			maskSpr.mouseChildren = false;
			this.addChild(maskSpr);
			this.mask = maskSpr;
			TweenPlugin.activate([ThrowPropsPlugin]);
			setMask();
		}
		public function get container():Sprite { return _container; }
		public function addMouseEvent():void
		{
			_container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		public function removeMouseEvent():void
		{
			if(_container.hasEventListener(MouseEvent.MOUSE_DOWN))
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		private function mouseDownHandler(event:MouseEvent):void 
		{
			TweenLite.killTweensOf(_container);
			y1 = y2 = _container.y;
			yOffset = this.mouseY - _container.y;
			yOverlap = Math.max(0, _container.height - maskSpr.height);
			t1 = t2 = getTimer();
			_container.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			var y:Number = this.mouseY - yOffset;
			//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
			if (y > maskSpr.y) 
			{
				_container.y = (y + maskSpr.y) * 0.5;
			}
			else
			{
				if (y < maskSpr.y - yOverlap) 
				{
					_container.y = (y + maskSpr.y - yOverlap) * 0.5;
				} 
				else 
				{
					_container.y = y;
				}
				var t:uint = getTimer();
				//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
				if (t - t2 > 50) 
				{
					y2 = y1;
					t2 = t1;
					y1 = _container.y;
					t1 = t;
				}
				event.updateAfterEvent();
			}
		}
		private function mouseUpHandler(event:MouseEvent):void 
		{
			_container.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_container.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var time:Number = (getTimer() - t2) / 1000;
			var yVelocity:Number = (_container.y - y2) / time;
			ThrowPropsPlugin.to(_container, {throwProps:{
				y:{velocity:yVelocity, max:maskSpr.y, min:maskSpr.y - yOverlap, resistance:300}
			}, ease:Strong.easeOut
			}, 10, 0.3, 0.5);
		}
		private function setMask():void
		{
			maskSpr.graphics.beginFill(0, 0);
			maskSpr.graphics.drawRect(0,0,w,h);
			maskSpr.graphics.endFill();
		}
		public function setContainerBack():void
		{
			_container.graphics.clear();
			_container.graphics.beginFill(0, 0);
			_container.graphics.drawRect(0, 0, w, _container.height);
			_container.graphics.endFill();
		}
		public function openMask():void
		{
			this.mask = maskSpr;
		}
		public function closeMask():void
		{
			this.mask = null;
		}
		public function setLayerTop(display:DisplayObject):void
		{
			_container.setChildIndex(display, _container.numChildren - 1);
		}
	}
}

