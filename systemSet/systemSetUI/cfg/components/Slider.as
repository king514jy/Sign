package systemSetUI.cfg.components 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import systemSetUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class Slider extends Sprite 
	{
		private var lineMc:MovieClip;
		private var quadBtn:MovieClip;
		private var _offset:Number;
		private var _min:Number;
		private var _max:Number;
		private var numList:Vector.<Number>;
		private var xList:Vector.<Number>;
		private var xOffset:Number;
		private var count:int = 0;
		private var digital:uint;
		private var _value:Number = 0;
		public function Slider() 
		{
			lineMc = this.getChildByName("line_mc") as MovieClip;
			quadBtn = this.getChildByName("quad_btn") as MovieClip;
			quadBtn.addEventListener(MouseEvent.MOUSE_DOWN, downHandle);
			quadBtn.addEventListener(MouseEvent.MOUSE_UP, upHandle);
		}
		public function get offset():Number { return _offset };
		public function get min():Number { return _min };
		public function get max():Number { return _max };
		public function set value(n:Number):void { _value = n; setQuad(); }
		public function get value():Number { return _value };
		/**
		 * 设置
		 * @param	min 最小值
		 * @param	max 最大值
		 * @param	offset 偏移量
		 * @param	digital 结果保留的小数数位
		 */
		public function setNum(min:Number, max:Number, offset:Number,digital:uint):void
		{
			numList = new Vector.<Number>();
			xList = new Vector.<Number>();
			_offset = offset;
			_min = min;
			_max = max;
			this.digital = digital;
			var le:uint = Math.floor((max - min) / offset);
			xOffset = lineMc.width / le;
			var n:uint=1;
			if (digital != 0)
			{
				for (var i:int = 0; i < digital; i++ )
				{
					n = n * 10;
				}
			}
			for (var j:int = 0; j <= le; j++ )
			{
				numList.push(Math.floor((min + (j * offset)) * n) / n);
				xList.push(lineMc.x +(j * xOffset));
			}
		}
		private function downHandle(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandle);
			quadBtn.gotoAndStop(2);
			quadBtn.startDrag(false, new Rectangle(lineMc.x, quadBtn.y, lineMc.width, 0));
		}
		private function upHandle(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, upHandle);
			quadBtn.stopDrag();
			quadBtn.gotoAndStop(1);
			
			var id:int
			var endNum:Number;
			for each(var xx:Number in xList)
			{
				if (quadBtn.x - xx < xOffset*0.5)
				{
					id = xList.indexOf(xx);
					break;
				}
				if (quadBtn.x - xx > xOffset * 0.5 && quadBtn.x - xx < xOffset)
				{
					id = xList.indexOf(xx)+1;
					break;
				}
			}
			_value = numList[id];
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE_NUMBER, _value));
		}
		private function setQuad():void
		{
			for each(var num:Number in numList)
			{
				if (num == value)
				{
					quadBtn.x = xList[numList.indexOf(num)];
				}
			}
		}
	}

}