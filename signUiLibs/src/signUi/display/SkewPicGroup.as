package signUi.display
{
	import signUi.utils.Skew;

	public class SkewPicGroup extends PicGroup
	{
		private var skew:Skew;
		private var _x0:Number;
		private var _x1:Number;
		private var _x2:Number;
		private var _x3:Number;
		private var _y0:Number;
		private var _y1:Number;
		private var _y2:Number;
		private var _y3:Number;
		private var _align:String;
		public function SkewPicGroup(id:String=null, align:String="center_center", scale:Number=1, smoothing:Boolean=false)
		{
			super(id, align, scale, smoothing);
			_align = align;
		}
		public function set x0(n:Number):void{_x0 = n;trace(n);setTransform();}
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
			skew = new Skew(this,pic.bitmapData,4,4);
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