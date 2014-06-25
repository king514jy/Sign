package ky.controller.animation
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ky.core.IAnimation;
	import ky.display.PicGroup;
	import ky.mode.AnimationDirectionMode;
	
	public class Ring extends Sprite implements IAnimation
	{
		private var circleA:int;//圆心
		private var circleB:int;
		private var r:int;
		private var _sprWidth:Number;
		private var _sprHeight:Number;
		private var stageW:Number;
		private var rightPoint:Point;
		private var rigthAngle:Number=1000;
		private var leftPoint:Point;
		private var leftAngle:Number;
		private var effectiveAngle:Number = 0;//有效角度,在舞台内
		private var pointList:Vector.<Point> 
		private var space:Number;
		private var _showList:Vector.<DisplayObject>;
		private var closeList:Vector.<DisplayObject>;//不显示的图片列表
		private var showPicAngle:Vector.<Number>;//每个显示的图片在圆中角度列表
		private var _speed:Number;
		private var _direction:String = AnimationDirectionMode.LEFT;
		private var _holdSum:int;
		private var isAdd:Boolean;
		private var temporaryDisplay:DisplayObject;
		/**
		 * 图片在设定的圆环上旋转，圆心(0,0)
		 * @param	positionX 圆环的X值
		 * @param	positionY 圆环的Y值
		 * @param	r 圆环半径
		 * @param	space 图片间距(角度)
		 * @param	picW 图片宽
		 * @param	picH 图片高
		 * @param	stageW 舞台宽
		 */
		public function Ring(positionX:int, positionY:int, r:int,space:int,picW:Number,picH:Number,stageW:Number,holdSum:uint=20,speed:Number=0.1)
		{
			circleA = 0;
			circleB = 0;
			this.r = r;
			_sprWidth = picW;
			_sprHeight = picH;
			this.x = positionX;
			this.y = positionY;
			this.space = space;
			this.stageW = stageW;
			_holdSum = holdSum;
			_speed = speed;
			selectPoint();
		}
		public function set direction(str:String):void{ _direction = str; }
		public function get direction():String{ return _direction; }
		public function set holdSum(u:uint):void{ _holdSum = u; }
		public function get holdSum():uint{ return _holdSum; }
		public function get displayObjectWidth():Number{ return _sprWidth; }
		public function get displayObjectHeight():Number{ return _sprHeight; }
		public function set speed(n:Number):void{ _speed = n; }
		public function get speed():Number{ return _speed; }
		/**
		 * 选择显示区域
		 */
		private function selectPoint():void
		{
			pointList = new Vector.<Point>();
			_showList = new Vector.<DisplayObject>();
			closeList = new Vector.<DisplayObject>();
			showPicAngle = new Vector.<Number>();
			for (var i:int = 0; i < 360; i++) 
			{
				var hudu:Number = (2 * Math.PI / 360) * i;
				var X:Number = circleA + Math.sin(hudu) * r;
				var Y:Number = circleB - Math.cos(hudu) * r;
				//圆环上每一度的坐标点
				var point:Point = new Point(X, Y);
				var globalPoint:Point = this.localToGlobal(point);
				//选取在舞台的有效点
				if (globalPoint.x >= -_sprWidth && globalPoint.x<=stageW+_sprWidth && globalPoint.y >= -_sprHeight)
				{
					if (rigthAngle == 1000)
					{
						//右边缘，在圆环上的度数
						rigthAngle = i;
					}
					pointList.push(new Point(Math.floor(point.x),Math.floor(point.y)));
					effectiveAngle++;
				}
			}
			if(pointList.length<1)
			{
				throw new Error("屏幕内无有效排列点")
			}
			else
			{
				//左边缘，在圆环上的度数
				leftAngle = rigthAngle + effectiveAngle;
				rightPoint = pointList[0];
				leftPoint = pointList[pointList.length - 1];
			}
		}
		public function lookOrbit():void
		{
			var ponitLe:uint = pointList.length;
			for(var j:int=0;j<ponitLe;j++)
			{
				this.graphics.beginFill(0xff00ff);
				this.graphics.drawCircle(pointList[j].x, pointList[j].y, 10);
				this.graphics.endFill();
			}
			
		}
		public function addElement(display:DisplayObject):void
		{
			var thisP:Point = this.globalToLocal(new Point(display.x,display.y));
			display.x = thisP.x;
			display.y = thisP.y;
			this.addChild(display);
			_showList.push(display);
			showPicAngle.push(rigthAngle+selectPointIndex(thisP));
		}
		private function selectPointIndex(p:Point):uint
		{
			var n:Number;
			var id:int;
			for(var i:int=0;i<pointList.length;i++)
			{
				var m:Number = Math.abs(pointList[i].x - p.x);
				if(i==0)
				{
					n = m;
				}
				else
				{
					if(m<=n)
					{
						n = m;
						id = i;
					}
				}
			}
			return id;
		}
		public function play():void
		{
			this.addEventListener(Event.ENTER_FRAME, run);
		}
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME,run);
		}
		private function run(event:Event) : void
		{
			if(_showList.length==0)
				addNextPic();
			for each(var pic:DisplayObject in _showList)
			{
				var id:int = _showList.indexOf(pic);
				var angle:Number = showPicAngle[id];
				var newAngle:Number;
				if(!judge())
					addNextPic();
				if (_direction == AnimationDirectionMode.LEFT)
				{
					newAngle = changeAngle(angle, pic, _speed);
					if (newAngle <= leftAngle)
						updatePic(pic, newAngle);
					else
						deletePic(pic);
				}
				else
				{
					newAngle = changeAngle(angle, pic, -_speed);
					if (newAngle >= rigthAngle)
						updatePic(pic, newAngle);
					else
						deletePic(pic);
				}
			}
		}
		/**
		 * 改变角度
		 * @param	angle
		 * @param	pic
		 * @param	speed
		 * @return
		 */
		private function changeAngle(angle:Number,pic:DisplayObject,speed:Number):Number
		{
			if (pic.x > 0)
			{
				angle = 180 - Math.asin((pic.x - circleA) / r) * (180 / Math.PI) + speed;
			}
			else
			{
				angle = 180 + Math.asin((circleA-pic.x) / r) * (180 / Math.PI) + speed;
			}
			return angle;
		}
		/**
		 * 更新图片位置
		 * @param	pic
		 * @param	angle
		 */
		private function updatePic(pic:DisplayObject,angle:Number):void
		{
			var hudu:Number = (2 * Math.PI / 360) * angle;
			var X:Number = circleA + Math.sin(hudu) * r;
			var Y:Number = circleB - Math.cos(hudu) * r;
			pic.x = X;
			pic.y = Y;
			pic.rotation = -Math.atan2(pic.x , pic.y) * (180 / Math.PI);
		}
		/**
		 * 剔除
		 * @param	pic
		 */
		private function deletePic(pic:DisplayObject):void
		{
			var deleteID:int = _showList.indexOf(pic);
			_showList.splice(_showList.indexOf(pic), 1);
			showPicAngle.splice(deleteID, 1);
			this.removeChild(pic);
			closeList.push(pic);
			isAdd = true;
			if (_holdSum > 0)
			{
				if (closeList.length + _showList.length > _holdSum)
					deleteForever(closeList.pop());
			}
		}
		private function judge():Boolean
		{
			var b:Boolean = false;
			for each(var pic:DisplayObject in _showList)
			{
				if(computingDegree(pic)<space)
				{
					b=true;
					break;
				}
			}
			return b;
		}
		private function computingDegree(display:DisplayObject):Number
		{
			var d:Number;
			var pA:Point = new Point(display.x, display.y);
			if (_direction == AnimationDirectionMode.LEFT)
				d = Point.distance(pA, rightPoint);
			else
				d = Point.distance(pA, leftPoint);
			var du:Number = Math.asin(d * 0.5 / r) * (180 / Math.PI);
			return 2*du;
		}
		/**
		 * 添加新图
		 */
		private function addNextPic():void
		{
			if (closeList.length > 0)
			{
				var pic:DisplayObject = closeList[0];
				closeList.shift();
				if (_direction == AnimationDirectionMode.LEFT)
				{
					pic.x = rightPoint.x;
					pic.y = rightPoint.y;
					showPicAngle.push(rigthAngle);
				}
				else
				{
					pic.x = leftPoint.x;
					pic.y = leftPoint.y;
					showPicAngle.push(leftAngle);
				}
				pic.rotation = -Math.atan2(pic.x , pic.y);
				this.addChild(pic);
				_showList.push(pic);
			}
		}
		private function deleteForever(display:DisplayObject):void
		{
			var img:PicGroup = display as PicGroup;
			img.dispose();
		}
		public function getRandomGlobalPoint():Point
		{
			var index:int = Math.floor(Math.random()*pointList.length);
			return this.localToGlobal(pointList[index]);
		}
		public function getRotation(p:Point):Number
		{
			return -Math.atan2(p.x , p.y) * (180 / Math.PI);
		}
		public function clear():void
		{
		}
	}
}