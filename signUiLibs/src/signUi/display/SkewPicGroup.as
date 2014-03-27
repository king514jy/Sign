package signUi.display
{
	import signUi.mode.DisplayAlignMode;
	import signUi.utils.Skew;

	public class SkewPicGroup extends PicGroup
	{
		private var skew:Skew;
		private var _x0:Number = 0;
		private var _x1:Number = 0;
		private var _x2:Number = 0;
		private var _x3:Number = 0;
		private var _y0:Number = 0;
		private var _y1:Number = 0;
		private var _y2:Number = 0;
		private var _y3:Number = 0;
		private var _align:String;
		public function SkewPicGroup(id:String=null, align:String="center_center", scale:Number=1, smoothing:Boolean=false)
		{
			super(id, align, scale, smoothing);
			_align = align;
		}
		public function set x0(n:Number):void{_x0 = n;setTransform();}
		public function set x1(n:Number):void{_x1 = n;setTransform();}
		public function set x2(n:Number):void{_x2 = n;setTransform();}
		public function set x3(n:Number):void{_x3 = n;setTransform();}
		public function set y0(n:Number):void{_y0 = n;setTransform();}
		public function set y1(n:Number):void{_y1 = n;setTransform();}
		public function set y2(n:Number):void{_y2 = n;setTransform();}
		public function set y3(n:Number):void{_y3 = n;setTransform();}
		
		public function get x0():Number{return _x0;}
		public function get x1():Number{return _x1;}
		public function get x2():Number{return _x2;}
		public function get x3():Number{return _x3;}
		public function get y0():Number{return _y0;}
		public function get y1():Number{return _y1;}
		public function get y2():Number{return _y2;}
		public function get y3():Number{return _y3;}
		public function openSkew():void
		{
			this.removeChildren();
			switch(_align)
			{
				case DisplayAlignMode.LEFT_TOP:
					break;
				case DisplayAlignMode.LEFT_CENTER:
					break;
				case DisplayAlignMode.LEFT_BOTTOM:
					break;
				case DisplayAlignMode.CENTER_TOP:
					_x0 = -pic.bitmapData.width * 0.5;
					_x1 = pic.bitmapData.width * 0.5;
					_x2 = pic.bitmapData.width * 0.5;
					_x3 = -pic.bitmapData.width * 0.5;
					_y0 = 0;
					_y1 = 0;
					_y2 = pic.bitmapData.height;
					_y3 = pic.bitmapData.height;
					break;
				case DisplayAlignMode.CENTER_CENTER:
					break;
				case DisplayAlignMode.CENTER_BOTTOM:
					break;
				case DisplayAlignMode.RIGHT_TOP:
					break;
				case DisplayAlignMode.RIGHT_CENTER:
					break;
				case DisplayAlignMode.RIGHT_BOTTOM:
					break;
			}
			
			skew = new Skew(this,pic.bitmapData,4,4);
			setTransform();
		}
		public function closeSkew():void
		{
			this.removeChildren();
			skew = null;
			this.addChild(pic);
			this.align = _align;
		}
		private function setTransform():void
		{
			skew.setTransform(_x0,_y0,_x1,_y1,_x2,_y2,_x3,_y3);	
		}
	}
}