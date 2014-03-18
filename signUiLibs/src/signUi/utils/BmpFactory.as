package signUi.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author King
	 */
	public class BmpFactory 
	{
		/**
		 * 裁剪式缩小图片,按比例
		 * @param	_dis DisplayObject
		 * @param	_scale 缩放比例
		 * @return bitmap
		 */
		public static function ZoomScale(_dis:DisplayObject, _scale:Number):Bitmap
		{
			var _w:Number = _dis.width;
			var _h:Number = _dis.height;
			_dis.scaleX = _dis.scaleY = _scale;
			var bitmapData:BitmapData = new BitmapData(_w * _scale, _h * _scale);
			var ma:Matrix = new Matrix();
			ma.scale(_scale, _scale);
			bitmapData.draw(_dis,ma);
			var newBitmap:Bitmap = new Bitmap(bitmapData);
			return newBitmap;
		}
		/**
		 * 裁剪式缩小图片,按尺寸
		 * @param	_dis DisplayObject
		 * @param	_w 目标宽度
		 * @param	_h 目标高度
		 * @return bitmap
		 */
		public static function ZoomSize(_dis:DisplayObject, _w:Number, _h:Number):Bitmap
		{
			_dis.width = _w;
			_dis.height = _h;
			var bitmapData:BitmapData = new BitmapData(_w, _h);
			bitmapData.draw(_dis);
			var newBitmap:Bitmap = new Bitmap(bitmapData);
			return newBitmap;
		}
		/**
		 * 根据宽缩放
		 * @param	bmp 原图
		 * @param	width 目标宽
		 * @return	Bitmap
		 */
		public static function basisWidth(bmp:Bitmap, width:Number):Bitmap
		{
			var oldW:Number = bmp.width;
			var scaX:Number = width / oldW;
			var matrix:Matrix = new Matrix();
			matrix.scale(scaX, scaX);
			var bmpDa:BitmapData = new BitmapData(width, bmp.height * scaX);
			bmpDa.draw(bmp, matrix);
			var thumb:Bitmap = new Bitmap(bmpDa);
			return thumb;
		}
		/**
		 * 根据高缩放
		 * @param	bmp 原图
		 * @param	height 目标高
		 * @return	Bitmap
		 */
		public static function basisHeight(bmp:Bitmap, height:Number):Bitmap
		{
			var oldH:Number = bmp.height;
			var scaY:Number = height / oldH;
			var matrix:Matrix = new Matrix();
			matrix.scale(scaY, scaY);
			var bmpDa:BitmapData = new BitmapData(bmp.width * scaY, height);
			bmpDa.draw(bmp, matrix);
			var thumb:Bitmap = new Bitmap(bmpDa);
			return thumb;
		}
	}

}