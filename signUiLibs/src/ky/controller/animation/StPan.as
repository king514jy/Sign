package ky.controller.animation
{
	import flash.geom.Rectangle;
	
	import ky.mode.AnimationDirectionMode;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StPan extends Sprite
	{
		private var sprList:Vector.<StPanElement> = new Vector.<StPanElement>();
		private var _minWidth:Number;
		private var runSprList:Vector.<StPanElement> = new Vector.<StPanElement>();
		private var _speed:Number;
		private var _rectangle:Rectangle;
		private var _showSum:uint;
		private var minElement:int = 0;//最小宽度索引值
		private var space:Number;
		private var sum:uint;
		/**
		 * 左右平移动画,sprite在显示区域内，位置随机
		 * @param	minWidth 显示图片的最小宽度
		 * @param	rectangle 显示的区域
		 * @param	showSum 显示区域内保持的图片数量
		 * @param	speed 宽高最小一张图的速度
		 */
		public function StPan(minWidth:Number,rectangle:Rectangle,showSum:uint,queueSum:uint, speed:Number = 1)
		{
			_minWidth = minWidth;
			this._rectangle = rectangle;
			this._showSum = showSum;
			this._speed = speed;
			this.space = rectangle.width / showSum;
			this.sum = showSum+queueSum;
		}
		//----设置速度----
		private function setSpeed(panElement:StPanElement):void
		{
			panElement.speed = _speed * (_minWidth / panElement.width);
		}
		//----获取范围内随机
		private function getNumber(num:Number):int
		{
			return Math.floor(Math.random() * num);
		}
		private function setOrientation(panElement:StPanElement):void
		{
			if (Math.random() < 0.5)
			{
				panElement.orientation = AnimationDirectionMode.LEFT;
				panElement.speed = -panElement.speed;
			}
			else
			{
				panElement.orientation = AnimationDirectionMode.RIGHT;
			}
		}
		//----图片运行-
		private function run(e:Event):void
		{
			for (var k:int=0;k<runSprList.length;k++)
			{
				runSprList[k].x += runSprList[k].speed;
				if (runSprList[k].orientation == AnimationDirectionMode.LEFT)
				{
					if (runSprList[k].x < _rectangle.x-runSprList[k].width)
					{
						runSprList[k].speed = -runSprList[k].speed;
						this.removeChild(runSprList[k]);
						runSprList.splice(k, 1);
						if (runSprList.length < _showSum)
						{
							addElement();
						}
					}
				}
				else
				{
					if (runSprList[k].x > _rectangle.right)
					{
						this.removeChild(runSprList[k]);
						runSprList.splice(k, 1);
						if (runSprList.length < _showSum)
						{
							addElement();
						}
					}
				}
			}
		}
		//---删除后添加元素补充---
		private function addElement():void
		{
			var n:int = Math.floor(Math.random() * sprList.length);
			if (examineElement(sprList[n]))
			{
				addElement();
			}
			else
			{
				setXY(sprList[n]);
				this.addChild(sprList[n]);
				runSprList.push(sprList[n]);
			}
		}
		//----检查新元素是否是在运行中的元素---
		private function examineElement(element:StPanElement):Boolean
		{
			var b:Boolean = false;
			for each(var k:StPanElement in runSprList)
			{
				if (element == k)
				{
					b = true;
					break;
				}
			}
			return b;
		}
		//-----添加后设置初始位置
		private function setXY(element:StPanElement):void
		{
			if (Math.random() < 0.5)
			{
				element.orientation = AnimationDirectionMode.LEFT;
				element.x = _rectangle.right;
				element.speed = -element.speed;
			}
			else
			{
				element.orientation = AnimationDirectionMode.RIGHT;
				element.x = _rectangle.x - element.width;
			}
			element.y = _rectangle.y + getNumber(_rectangle.height);
		}
		public function addPanElement(el:StPanElement,xx:Number,yy:Number,scale:Number=1,rotation:Number=0):void
		{
			el.x = xx;
			el.y = yy;
			el.scaleX = el.scaleY = scale;
			el.rotation = rotation;
			this.addChild(el);
			setSpeed(el);
			setOrientation(el);
			if(sprList.length >= sum)
			{
				var index:int = chooseIdleElement();
				sprList[index].pic.texture.dispose();
				sprList[index].pic.dispose();
				sprList[index].dispose()
				sprList.splice(index, 1);
			}
			sprList.push(el);
			runSprList.push(el);
		}
		//----选择没有在显示区域运动的图片
		private function chooseIdleElement():int
		{
			var id:int;
			for (var k:int=0;k<sprList.length;k++)
			{
				if(runSprList.indexOf(sprList[k])==-1)
				{
					id = k;
					break;
				}
			}
			return id;
		}
		public function play():void
		{
			this.addEventListener(Event.ENTER_FRAME,run);
		}
		public function stop():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, run);
		}
		public function clear():void
		{
			
		}
	}
}