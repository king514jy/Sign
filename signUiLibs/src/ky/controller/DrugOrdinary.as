package ky.controller
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import ky.mode.Orientation
	import flash.geom.Rectangle;
	/**
	 * @param 普通拖动，可设置滑块宽高颜色，杆颜色
	 * 
	 * ...
	 * @author King
	 */
	public class DrugOrdinary extends Sprite
	{
		private var quad:Sprite;
		private var line:Sprite;
		private var lineColor:uint;
		private var pagemask:Sprite;
		private var page:Sprite;
		
		private var page_h:Number;
		private var mask_h:Number;
		private var lenght_h:Number;
		private var drug_h:Number;
		private var mask_y:Number;
		private var page_y :Number;
		private var oldWord_y:Number = 0;//记录初始化时word坐标
		
		private var speed:int = 1;//移动速度
		private var d_speed:Number;//鼠标在上下按钮时滑块的速度
		private var w_speed:Number=9;//拖动速度
		private var d_min:Number;//滑块在可动区域的最上边的Y值
		private var d_max:Number;//滑块在可动区域的最下边的Y值
		private var myvalue:Number;//文字的可动范围与滑块的可动范围的比值
		private var d_x:Number;//滑块的x坐标
		private var down:int = 0;//文字拖动判断
		private var txtMove:Number;
		private var m_y:Number;
		private var everydistance:Number;
		private var mode:String;
		private var lineAlwaysShow:Boolean;
		
		private var _offset:Number = 20;//滑块与显示区域偏移量
		private var _showWidth:Number;
		private var _showHeight:Number;
		/**
		 * 
		 * @param	_page 传入页面
		 * @param	_showWidth 遮罩宽度
		 * @param	_showHeight 遮罩高度
		 * @param	_mode 拖动方向
		 * @param	_quadw 滑块宽
		 * @param	_quadh 滑块高
		 * @param	_quadColor 滑块颜色
		 * @param	_lineColor 线条颜色
		 * @param	_lineAlwaysShow 线条是否一直显示
		 */
		public function DrugOrdinary(_page:Sprite,_showWidth:Number,_showHeight:Number,_mode:String =Orientation.VERTICAL,_quadw:uint=5,_quadh:uint=20,_quadColor:Number=0x000000,_lineColor:Number=0x000000,_lineAlwaysShow:Boolean=true) 
		{
			page = _page;
			this.addChild(page);
			this._showWidth = _showWidth;
			this._showHeight = _showHeight;
			pagemask = drawRect(_showWidth, _showHeight, 0x000000);
			this.addChild(pagemask);
			page.mask = pagemask;
			
			lineAlwaysShow = _lineAlwaysShow;
			mode = _mode;
			lineColor = _lineColor;
			if (_mode == Orientation.VERTICAL)
			{
				line = drawRect(1, _showHeight, _lineColor);
				line.x = _showWidth + _offset;
				this.addChild(line);
				
				quad = drawRect(_quadw, _quadh, _quadColor);
				quad.x = line.x - _quadw / 2;
				this.addChild(quad);
				d_x = quad.x;
			}
			if (mode == Orientation.HORIZONTAL)
			{
				line = drawRect(_showWidth, 1, _lineColor);
				line.y = _showHeight + _offset;
				this.addChild(line);
				
				quad = drawRect(_quadw, _quadh, _quadColor);
				quad.y = line.y -_quadh / 2;
				this.addChild(quad);
			}
			if (!_lineAlwaysShow)
			{
				line.alpha = 0;
			}
			lenght_h = _showHeight;
			drug_h = _quadh;
			mask_y = pagemask.y;
			page_y = page.y;
			oldWord_y = page.y;
			
			decide();
		}
		/**
		 * 设置遮罩宽度
		 */
		public function set showWidth(u:Number):void 
		{ 
			_showWidth = u;
			pagemask.width = u; 
			decide();
			line.x = u + _offset;
			quad.x = line.x - quad.width * 0.5;
			d_x = quad.x;
		};
		/**
		 * 设置遮罩高度
		 */
		public function set showHeight(u:Number):void { _showHeight = u; pagemask.height = u; decide(); };
		public function set offset(n:Number):void
		{ 
			_offset = n;
			line.x = _showWidth + _offset;
			quad.x = line.x + (line.width - quad.width) * 0.5;
			d_x = quad.x;
		}
		public function get offset():Number { return _offset; }
		public function set pageX(n:Number):void { page.x = n; pagemask.x = n; }
		public function set pageY(n:Number):void { page.y = n; oldWord_y = n; pagemask.y = n; mask_y = n; }
		public function setLineSize(w:Number, h:Number):void
		{
			line.graphics.clear();
			line.graphics.beginFill(lineColor);
			line.graphics.drawRect(0, 0, w, h);
			line.graphics.endFill();
		}
		private function drawRect(_w:uint, _h:uint, _c:Number):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(_c);
			s.graphics.drawRect(0, 0, _w, _h);
			s.graphics.endFill();
			return s;
		}
		/**
		 * 判断，内容是否高于遮罩
		 */
		public function decide():void
		{
			page_h = page.height;
			mask_h = pagemask.height;
			if (page.y != oldWord_y)
			{
				TweenLite.to(page, 1, { y:oldWord_y } );
			}
			if (quad.y != line.y)
			{
				TweenLite.to(quad, 1, { y:line.y } );
			}
			var word_vis:Number = page_h - mask_h;
			if(word_vis<0)
			{
				quad.visible = false;
				line.visible = false;
			}
			else
			{
				quad.visible = true;
				line.visible = true;
				enactment();
			}
		}
		public function changePage(_page:Sprite):void
		{
			quad.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse_d);
			quad.removeEventListener(MouseEvent.MOUSE_UP,onMouse_u);
			TweenLite.to(page, 1, { alpha:1, ease:Quint.easeInOut, onCompleteParams:[_page], onComplete:change } );
		}
		private function change(_p:Sprite):void
		{
			this.removeChild(page);
			page = null;
			page = _p;
			this.addChild(page);
			decide();
		}
		//--------------拖动-------------------------
		private function enactment():void//设定
		{
			quad.buttonMode=true;
			d_min = Math.round(line.y);//
			d_max = Math.round(lenght_h-drug_h);
			myvalue = (page_h-mask_h)/(d_max-d_min);//距离比值
			d_speed = (d_max-d_min)/((page_h-mask_h)/speed);
			quad.addEventListener(MouseEvent.MOUSE_DOWN,onMouse_d);
			quad.addEventListener(MouseEvent.MOUSE_UP, onMouse_u);
			
			if (mode == Orientation.VERTICAL)
			{
				var distance:uint = Math.floor(page_h / mask_h);
			}
			if (mode == Orientation.HORIZONTAL)
			{
				
			}
			everydistance = mask_h / (distance * 5);
			page.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		private function onMouse_d(e:MouseEvent):void
		{
			if (!lineAlwaysShow)
			{
				TweenLite.to(line, 1, { alpha:1 } );
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse_u)
			quad.startDrag(false,new Rectangle(d_x+1,d_min,0,d_max));//左坐标，右坐标，宽，高
			this.addEventListener(Event.ENTER_FRAME,run);
		}
		private function onMouse_u(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouse_u);
			quad.stopDrag();
			if (!lineAlwaysShow)
			{
				TweenLite.to(line, 1, { alpha:0 } );
			}
			this.removeEventListener(Event.ENTER_FRAME,run);
		}
		private function run(e:Event):void
		{
			txtMove = (quad.y-d_min)*myvalue;
			m_y = page_y-txtMove;
			TweenLite.to(page, 1, {y:m_y});
		}
		private function mouseWheel(e:MouseEvent):void
		{
			var yy:Number
			if (e.delta < 0)
			{
				if (quad.y < d_max - everydistance)
				{
					yy = quad.y + everydistance;
					txtMove = (yy-d_min)*myvalue;
					m_y = page_y-txtMove;
					TweenLite.to(quad, 1, { y:yy } );
					TweenLite.to(page, 1, { y:m_y } );
				}
				else
				{
					yy = d_max;
					txtMove = (yy-d_min)*myvalue;
					m_y = page_y-txtMove;
					TweenLite.to(quad, 1, { y:yy } );
					TweenLite.to(page, 1, { y:m_y } );
				}
			}
			else
			{
				if (quad.y > d_min + everydistance)
				{
					yy = quad.y - everydistance;
					txtMove = (yy-d_min)*myvalue;
					m_y = page_y-txtMove;
					TweenLite.to(quad, 1, { y:yy } );
					TweenLite.to(page, 1, { y:m_y } );
				}
				else
				{
					yy = d_min;
					txtMove = (yy-d_min)*myvalue;
					m_y = page_y-txtMove;
					TweenLite.to(quad, 1, { y:yy } );
					TweenLite.to(page, 1, { y:m_y } );
				}
			}
		}
	}

}