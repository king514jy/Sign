package signEditorUI.conmponents
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ky.controller.DrugOrdinary;
	import ky.display.ScaleBitmap;
	import ky.mode.Orientation;
	
	/**列表
	 * ...
	 * @author Q·Jy
	 * 2013/6/11 17:19
	 */
	public class List extends Sprite 
	{
		private var elementList:Vector.<ListElement>;
		private var drug:DrugOrdinary;
		public var page:Sprite;
		private var _showWidth:Number;
		private var _showHeight:Number;
		private var _back:ScaleBitmap;
		private var space:Number;
		private var _select:ListElement;
		private var _id:int;
		/**
		 * 列表
		 * @param	showWidth 显示区域宽
		 * @param	showHeight 显示区域高
		 * @param	space item之间间距
		 */
		public function List(showWidth:Number,showHeight:Number,space:Number=0)
		{
			elementList = new Vector.<ListElement>();
			_showWidth = showWidth;
			_showHeight = showHeight;
			this.space = space;
			page = new Sprite();
			drug = new DrugOrdinary(page, showWidth, showHeight, Orientation.VERTICAL, 5, 40, 0x7AB326,0x666666);
			this.addChild(drug)
		}
		/**
		 * 列表背景
		 */
		public function set back(bmp:ScaleBitmap):void 
		{ 
			_back = bmp; 
			this.addChildAt(bmp, 0); 
		}
		/**
		 * 列表背景
		 */
		public function get back():ScaleBitmap { return _back; }
		/**
		 * 显示区域宽度
		 */
		public function get showWidth():Number { return _showWidth; }
		/**
		 * 显示区域高度
		 */
		public function get showHeight():Number { return _showHeight; }
		/**
		 * 选中的item ID
		 */
		public function get selectID():int { return getID(_select); }
		/**
		 * 选择的item
		 */
		public function set select(el:ListElement):void { changeSelect(el); }
		/**
		 * 选中的item
		 */
		public function get select():ListElement { return _select; }
		/**
		 * 滑动条与显示区域的偏移量
		 */
		public function set drugOffset(n:Number):void { drug.offset = n; }
		/**
		 * 滑动条与显示区域的偏移量
		 */
		public function get drugOffset():Number { return drug.offset; }
		/**
		 * 列表长度
		 */
		public function get listLength():int { return elementList.length; }
		/**
		 * 设置显示区域
		 * @param	showWidth 显示区域宽度
		 * @param	showHeight 显示区域高度
		 */
		public function setArea(showWidth:Number, showHeight:Number):void
		{
			_showWidth = showWidth;
			_showHeight = showHeight;
			drug.showWidth = showWidth;
			drug.showHeight = showHeight;
		}
		/**
		 * 设置page位置
		 * @param	point page位置
		 */
		public function setPage(point:Point):void
		{
			drug.pageX = point.x;
			drug.pageY = point.y;
		}
		/**
		 * 添加条目
		 * @param	element item
		 */
		public function addItem(element:ListElement):void
		{
			elementList.push(element);
			if (elementList.length == 1) 
			{
				element.y = 0;
			}
			else 
			{
				var next:ListElement = elementList[elementList.length - 2];
				element.y = next.y + next.height + space;
			}
			page.addChild(element);
			drug.decide();
			if (!_select)
			{
				_select = element;
				_select.isSelect = true;
				_select.removeMouseEvent();
			}
			else
			{
				element.addMouseEvent();
				element.addEventListener(Event.SELECT, changeSelect);
			}
		}
		private function selectElement(e:Event):void
		{
			var el:ListElement = e.target as ListElement;
			changeSelect(el);
		}
		private function changeSelect(el:ListElement):void
		{
			_select.isSelect = false;
			_select.addMouseEvent();
			_select = el;
			_id = getID(el);
		}
		/**
		 * 获取item的id
		 * @param	element item 
		 * @return	id:int
		 */
		public function getID(element:ListElement):int
		{
			var id:int = elementList.indexOf(element);
			if (id == -1)
			{
				id = 0;
				_select = null;
			}
			return id;
		}
		public function getItem(id:int):ListElement
		{
			if(id>=0 && id<elementList.length)
				return elementList[id];
			else return null;
		}
		/**
		 * 以id值删除条目
		 * @param	id id
		 */
		public function delectItemByID(id:int):void
		{
			var element:ListElement = elementList[id];
			if (id == selectID)
			{
				if (elementList.length > 1)
				{
					if (id != 0)
					{
						changeSelect(elementList[0]);
					}
					else
					{
						changeSelect(elementList[1]);
					}
					dispatchEvent(new Event(Event.SELECT));
				}
			}
			elementList.splice(id, 1)
			page.removeChild(element);
			removeListener(element);
			drug.decide();
			var le:int = elementList.length;
			for (var i:int = id; i < le; i++ )
			{
				elementList[i].y -= element.height+space;
			}
			element = null;
		}
		/**
		 * 清除所有条目
		 */
		public function clear():void
		{
			var le:uint = elementList.length;
			if (le > 0)
			{
				//elementList.splice(0, elementList.length);
				for (var i:int = le-1; i >=0; i-- )
				{
					removeListener(elementList[i]);
					page.removeChild(elementList[i]);
					drug.decide();
					elementList[i] = null;
					elementList.splice(i, 1);
				}
			}
		}
		private function removeListener(el:ListElement):void
		{
			el.removeMouseEvent();
			if(el.hasEventListener(Event.SELECT))
				el.removeEventListener(Event.SELECT, changeSelect);
		}
	}

}