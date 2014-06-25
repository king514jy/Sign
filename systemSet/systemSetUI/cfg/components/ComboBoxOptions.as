package systemSetUI.cfg.components 
{
	import flash.display.Sprite;
	import flash.display.Sprite;
	import ky.utils.ScaleBitmap
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import systemSetUI.events.ChangeDataEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ThrowPropsPlugin;
	/**
	 * ...
	 * @author Humberger
	 */
	public class ComboBoxOptions extends Sprite 
	{
		private var bmp:ScaleBitmap;
		private var _id:int;
		private var oldTime:int;
		private var _container:Sprite;
		private var itemList:Vector.<ComboBoxItem>;
		private var nowItem:ComboBoxItem;
		private var w:uint;
		private var h:uint;
		private var maskSpr:Sprite;
		
		private var t1:uint;
		private var t2:uint;
		private var y1:Number;
		private var y2:Number;
		private var yOverlap:Number;
		private var yOffset:Number;
		public function ComboBoxOptions(w:uint=303,h:uint=268)
		{
			this.w = w;
			this.h = h;
			var re:Rectangle = new Rectangle(8, 8, 287, 252);
			bmp = new ScaleBitmap(new Plank());
			bmp.scale9Grid = re;
			bmp.width = w;
			bmp.height = h;
			this.addChild(bmp);
			_container = new Sprite();
			_container.y = 8;
			this.addChild(_container);
			maskSpr = new Sprite();
			maskSpr.graphics.beginFill(0, 0.5);
			maskSpr.graphics.drawRect(0,0,w,h-16);
			maskSpr.graphics.endFill();
			maskSpr.y = 8;
			this.addChild(maskSpr);
			_container.mask = maskSpr;
			itemList = new Vector.<ComboBoxItem>();
			var shadowFilter:DropShadowFilter = new DropShadowFilter(4, 45, 0, 0.6);
			bmp.filters = [shadowFilter];
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function get container():Sprite { return _container; }
		public function get id():int { return itemList.indexOf(nowItem)+1; };
		public function get showArea():Rectangle
		{
			var re:Rectangle = new Rectangle(bmp.x, bmp.y, bmp.width, bmp.height);
			return re;
		}
		public function init(e:Event=null):void
		{
			oldTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, run);
			
		}
		private function run(e:Event):void
		{
			if (getTimer() - oldTime >= 200)
			{
				this.removeEventListener(Event.ENTER_FRAME, run);
				stage.addEventListener(MouseEvent.CLICK, clickStage);
			}
		}
		private function clickStage(e:MouseEvent):void
		{
			var p:Point = new Point(this.mouseX, this.mouseY);
			var newP:Point = this.localToGlobal(p);
			if (this.hitTestPoint(newP.x, newP.y))
			{
				for each(var item:ComboBoxItem in itemList)
				{
					if (item.selected && item != nowItem)
					{
						nowItem.selected = false;
						nowItem = item;
					}
				}
				dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE));
			}
			else
			{
				stage.removeEventListener(MouseEvent.CLICK, clickStage);
				dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE_OVER));
			}
		}
		public function addItem(str:String):void
		{
			var item:ComboBoxItem = new ComboBoxItem();
			_container.addChild(item);
			item.y = itemList.length * 36;
			item.text = str;
			itemList.push(item);
			if (!nowItem)
			{
				nowItem = item;
				nowItem.selected = true;
			}
			if (_container.height > maskSpr.height)
				addMouseEvent();
		}
		private function addMouseEvent():void
		{
			_container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		private function removeMouseEvent():void
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
	}

}