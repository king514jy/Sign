package signUi.controller.animation
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import signUi.core.IAnimation;
	import signUi.mode.AnimationDirectionMode;

	public class Pan extends Sprite implements IAnimation
	{
		private var sprList:Vector.<PanElement> = new Vector.<PanElement>();
		private var _minWidth:Number;
		private var runSprList:Vector.<PanElement> = new Vector.<PanElement>();
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
		public function Pan(minWidth:Number,rectangle:Rectangle,showSum:uint,queueSum:uint, speed:Number = 1) 
		{
			_minWidth = minWidth;
			this._rectangle = rectangle;
			this._showSum = showSum;
			this._speed = speed;
			this.space = rectangle.width / showSum;
			this.sum = showSum+queueSum;
		}
		//----设置速度----
		private function setSpeed(panElement:PanElement):void
		{
			panElement.speed = _speed * (_minWidth / panElement.width);
		}
		//----获取范围内随机
		private function getNumber(num:Number):int
		{
			return Math.floor(Math.random() * num);
		}
		private function setOrientation(panElement:PanElement):void
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
							add();
						}
					}
				}
				else
				{
					if (runSprList[k].x > _rectangle.right+runSprList[k].width)
					{
						this.removeChild(runSprList[k]);
						runSprList.splice(k, 1);
						if (runSprList.length < _showSum)
						{
							add();
						}
					}
				}
			}
		}
		//---删除后添加元素补充---
		private function add():void
		{
			var n:int = Math.floor(Math.random() * sprList.length);
			if (examineElement(sprList[n]))
			{
				add();
			}
			else
			{
				setXY(sprList[n]);
				this.addChild(sprList[n]);
				runSprList.push(sprList[n]);
			}
		}
		//----检查新元素是否是在运行中的元素---
		private function examineElement(element:PanElement):Boolean
		{
			var b:Boolean = false;
			for each(var k:PanElement in runSprList)
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
		private function setXY(element:PanElement):void
		{
			if (Math.random() < 0.5)
			{
				element.orientation = AnimationDirectionMode.LEFT;
				element.x = _rectangle.right+element.width;
				element.speed = -element.speed;
			}
			else
			{
				element.orientation = AnimationDirectionMode.RIGHT;
				element.x = _rectangle.x - element.width;
			}
			element.y = _rectangle.y + getNumber(_rectangle.height);
		}
		public function addElement(el:DisplayObject):void
		{
			var pe:PanElement = el as PanElement;
			this.addChild(pe);
			setSpeed(pe);
			setOrientation(pe);
			if(sprList.length >= sum)
				sprList.splice(chooseIdleElement(), 1);
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
			this.addEventListener(Event.ENTER_FRAME, run);
		}
		public function stop():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, run);
		}
		public function clear():void
		{
			
		}
		public function getDisplay(index:int):DisplayObject
		{
			return sprList[index];
		}
	}

}