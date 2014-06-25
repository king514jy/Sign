package ky.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/*
	 * 	rank(source,4,3)  把source按4行3列切成12张bitmapData

		pixel(source,400,300)  把source切成若干张宽400高300的图片，原图不满的地方会补白

		transparent(source)   取source左上角像素颜色,与此颜色的差异小于阈值的像素全部透明 
	 */
	public class BmpIncision 
	{
		public static function rank(source:DisplayObject, col:int, row:int, valid = null, trans:Boolean = true):Vector.<BitmapData>
		{
			var w:Number = source.width/col;
			var h:Number = source.height/row;
			valid = valid == null ? col*row : valid;
			var target:Vector.<BitmapData> = incise(source,w,h,col,row,valid,trans);
			return target;
		}
		public static function pixel(source:DisplayObject, w:Number, h:Number, valid = null, trans:Boolean = false):Vector.<BitmapData>
		{
			var col:int = Math.ceil(source.width/w);
			var row:int = Math.ceil(source.height/h);
			valid = valid === null ? col*row : valid;
			var target:Vector.<BitmapData> = incise(source,w,h,col,row,valid,trans);
			return target;			
		}
		public static function transparent(source, arg1 = null, arg2 = null):BitmapData
		{
			var threshold:uint;
			var s:BitmapData = source is Bitmap ? source.bitmapData : source;
			if (arg1 == null)
			{
				threshold = s.getPixel(0,0);
			}
			else
			{
				if (arg2 == null)
				{
					threshold = arg1;
				}
				else
				{
					threshold = s.getPixel(arg1,arg2);
				}
			}
			var rect:Rectangle = new Rectangle(0,0,s.width,s.height);
			var origin:Point = new Point(0,0);
			var result:BitmapData = new BitmapData(s.width,s.height,true);
			result.copyPixels(s,rect,origin);
			result.threshold(s,rect,origin,"==",threshold,0,0xF0F0F0,true);
			return result;
		}
		private static function incise(source:DisplayObject, w:Number, h:Number, col:int, row:int, valid:int, trans:Boolean):Vector.<BitmapData> 
		{
			var target:Vector.<BitmapData> = new Vector.<BitmapData>();
			var matrix:Matrix = new Matrix();
			var rect:Rectangle = new Rectangle(0 , 0, w, h);
			out:
			for (var j:int = 0; j < row; j++)
			{
				for (var i:int = 0; i < col; i++) 
				{
					if (valid <= 0)break out;					
					var bmp:BitmapData = new BitmapData(w,h,trans,0);
					matrix.tx = -i*w;
					matrix.ty = -j*h;
					bmp.draw(source,matrix,null,null,rect,true);
					target.push(bmp);
					valid--;
				}
			}
			return target;
		}
	}
}