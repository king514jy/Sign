package signUi.controller
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TransformGesture;
	
	import signUi.events.StatusEvent;
	
	public class GestureSportController extends EventDispatcher
	{
		private var _display:DisplayObject;
		private var isContinue:Boolean = true;//是否延续一段距离
		private var distance:int = 30;//滑行距离
		private var isLeft:Boolean = false;
		private var isUp:Boolean = false;
		private var isMove:Boolean = false;
		private var count:int;//记录下首次方向用的计数参数
		private var prevX:Number;//拖动过程中记录上一个坐标
		private var PrevY:Number;
		private var recordTime:RecordTime;//计时器
		private var runTime:Number = 0;
		private var newX:int;
		private var newY:int;
		private var timerLine:TimelineLite
		
		private var isDrug:Boolean = false;
		
		private var oldX:Number;
		private var oldY:Number;
		private var oldRotation:Number;
		private var oldScale:Number;
		
		private var rotationCh:Number;
		private var transformGesture:TransformGesture;
		public function GestureSportController(display:DisplayObject)
		{
			_display = display;
		}
		public function get display():DisplayObject{ return _display; }
		public function start():void
		{
			transformGesture = new TransformGesture(_display);
			transformGesture.addEventListener(GestureEvent.GESTURE_BEGAN, beginGesture);
			transformGesture.addEventListener(GestureEvent.GESTURE_CHANGED, onGesture);
			transformGesture.addEventListener(GestureEvent.GESTURE_CANCELLED, endGesture);
			transformGesture.addEventListener(GestureEvent.GESTURE_ENDED, endGesture);
			if (isContinue)
			{
				recordTime = new RecordTime();
				timerLine = new TimelineLite( { onUpdate:timerLineUpdate,onComplete:timerLineComplete } );
			}
		}
		private function beginGesture(e:GestureEvent):void
		{
			if (isContinue)
			{
				timerLine.stop();
				timerLine.clear();
				oldX = _display.x;
				oldY = _display.y;
				oldRotation = _display.rotation;
				oldScale = _display.scaleX;
			}
		}
		private function onGesture(e:GestureEvent):void
		{
			var gesture:TransformGesture = e.target as TransformGesture;
			var matrix:Matrix = _display.transform.matrix;
			
			matrix.translate(gesture.offsetX, gesture.offsetY);
			_display.transform.matrix = matrix;
			if (gesture.scale != 1 || gesture.rotation != 0)
			{
				var transformPoint:Point = matrix.transformPoint(_display.globalToLocal(gesture.location));
				matrix.translate(-transformPoint.x, -transformPoint.y);
				matrix.rotate(gesture.rotation);
				matrix.scale(gesture.scale, gesture.scale);
				matrix.translate(transformPoint.x, transformPoint.y);
				
				_display.transform.matrix = matrix;
			}
			limitScale(_display, 0.3, 1.4);
			dispatchEvent(new StatusEvent(StatusEvent.CHANGED));
			if (gesture.touchesCount == 1)
			{
				if (!isMove)
				{
					recordTime.starRecord();
					isMove = true;
				}
				sprMove();
			}
		}
		private function limitScale(_display:DisplayObject,min:Number,max:Number):void
		{
			if (_display.scaleX < min)
				_display.scaleX = _display.scaleY = min;
			if (_display.scaleX > max)
				_display.scaleX = _display.scaleY = max;
		}
		private function endGesture(e:GestureEvent):void
		{
			if (isContinue)
			{
				if (isMove)
				{
					if (count != 0)
					{
						recordTime.stopRecord();
						runTime = recordTime.time;
						if (runTime>0.2)
							continueMove();
						else
							dispatchEvent(new StatusEvent(StatusEvent.GESTURE_MOVE_END));
					}
					else
					{
						dispatchEvent(new StatusEvent(StatusEvent.GESTURE_MOVE_END));
					}
					count = 0;
				}
			}
			else
			{
				if(isMove)
					dispatchEvent(new StatusEvent(StatusEvent.GESTURE_MOVE_END));
				else
					dispatchEvent(new StatusEvent(StatusEvent.GESTURE_CHANGE_END));
			}
			isMove = false;
		}
		private function sprMove():void
		{
			/*
			*主要记录初始坐标，当拖动过程中有方向改变时，更新初始坐标为转折点的坐标 
			*/
			if (count <= 2)
			{
				if (count == 1)
				{
					if (_display.x - oldX > 0)
						isLeft = false;
					else
						isLeft = true;
					if (_display.y - oldY > 0)
						isUp = false;
					else
						isUp = true;
					prevX = _display.x;
					PrevY = _display.y;
				}
				if (count < 2)
					count++;
				if (count == 2)
				{
					if (isLeft)
					{
						if (_display.x - prevX > 0)
						{
							oldX = _display.x;
							isLeft = false;
						}
					}
					else
					{
						if (_display.x - prevX < 0)
						{
							oldX = _display.x;
							isLeft = true;
						}
					}
					if (isUp)
					{
						if (_display.y - PrevY > 0)
						{
							oldY = _display.y;
							isUp = false;
						}
					}
					else
					{
						if (_display.y - PrevY < 0)
						{
							oldY = _display.y;
							isUp = true;
						}
					}
					prevX = _display.x;
					PrevY = _display.y; 
				}
			}
		}
		private function continueMove():void
		{
			var xx:Number = _display.x;
			var yy:Number = _display.y;
			var dx:Number = xx - oldX;
			var dy:Number = yy - oldY;
			var ds:Number = Math.sqrt(dx * dx + dy * dy);//起始坐标到末坐标距离
			var v0:Number = ds / runTime;//初始速度
			if (v0 != 0)
			{
				var a:Number = -100;//加速度
				var t:Number = 1;//滑行时间
				var glide:Number = Math.abs((v0 * t + 0.5 * a * (t * t)) / 10);//滑行的距离
				var sin:Number = dy / ds;//正弦值
				var cos:Number = dx / ds;//余弦值
				newX = Math.floor(xx + (cos * glide));
				newY = Math.floor(yy + (sin * glide));
				/*trace("起始点坐标(" + oldX + "," + oldY + "),末坐标(" + xx + "," + yy + "),V0=" 
					+ v0 + ",滑行距离=" + glide + ",最终坐标(" + newX + "," + newY + ")");*/
				timerLine.append(new TweenLite(_display, t, { x:newX, y:newY } ));
				timerLine.restart();
			}
		}
		private function timerLineUpdate():void
		{
			
		}
		private function timerLineComplete():void
		{
			dispatchEvent(new StatusEvent(StatusEvent.SPORT_END));
		}
		public function removeGesture():void
		{
			if (transformGesture)
			{
				transformGesture.dispose();
				transformGesture = null;
			}
		}
	}
}