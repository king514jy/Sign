package signUi.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SignHandle extends EventDispatcher
	{
		public static function cutCanvas(bmpDa:BitmapData):BitmapData
		{
			var newDa:BitmapData;
			var leftP:Point = searchLeftPoint(bmpDa);
			var rightP:Point = searchRightPoint(bmpDa);
			var topP:Point = searchTopPoint(bmpDa);
			var bottomP:Point = searchBottomPoint(bmpDa);
			var rect:Rectangle = determineRectangle(leftP,topP,rightP,bottomP);
			if(rect.width!=0)
			{
				newDa = new BitmapData(rect.width,rect.height,true,0);
			//newDa = new BitmapData(rect.width,rect.height,false,0x339999);
				newDa.copyPixels(bmpDa,rect,new Point(0,0));
			}
			return newDa;
		}
		private static function searchLeftPoint(bmpDa:BitmapData):Point
		{
			var point:Point = new Point();
			var w:Number = bmpDa.width;
			var h:Number = bmpDa.height;
			outLoop:for (var i:int = 0; i<w; i++)
			{
				for (var j:int = 0; j <h; j++)
				{
					if (bmpDa.getPixel32(i, j) != 0)
					{
						point.x = i;
						point.y = j;
						break outLoop;
					}
				}
			}
			return point;
		}
		private static function searchTopPoint(bmpDa:BitmapData):Point
		{
			var point:Point = new Point();
			var w:Number = bmpDa.width;
			var h:Number = bmpDa.height;
			outLoop:for (var i:int = 0; i<h; i++)
			{
				for (var j:int = 0; j <w; j++)
				{
					if (bmpDa.getPixel32(j, i) != 0)
					{
						point.x = j;
						point.y = i;
						break outLoop;
					}
				}
			}
			return point;
		}
		private static function searchRightPoint(bmpDa:BitmapData):Point
		{
			var point:Point = new Point();
			var w:Number = bmpDa.width;
			var h:Number = bmpDa.height;
			outLoop:for (var i:int = w; i>0; i--)
			{
				for (var j:int = 0; j <h; j++)
				{
					if (bmpDa.getPixel32(i, j) != 0)
					{
						point.x = i;
						point.y = j;
						break outLoop;
					}
				}
			}
			return point;
		}
		private static function searchBottomPoint(bmpDa:BitmapData):Point
		{
			var point:Point = new Point();
			var w:Number = bmpDa.width;
			var h:Number = bmpDa.height;
			outLoop:for (var i:int = h; i>0; i--)
			{
				for (var j:int = 0; j <w; j++)
				{
					if (bmpDa.getPixel32(j, i) != 0)
					{
						point.x = j;
						point.y = i;
						break outLoop;
					}
				}
			}
			return point;
		}
		private static function determineRectangle(leftPoint:Point,topPoint:Point,rightPoint:Point,bottomPoint:Point):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			rect.left = leftPoint.x;
			rect.top = topPoint.y;
			rect.right = rightPoint.x;
			rect.bottom = bottomPoint.y;
			return rect;
		}
		public static function handleSign(source:Bitmap,perfectWidth:Number,perfectHeight:Number,priorityHeight:Boolean=true):void
		{
			var h:Number = source.height;
			var w:Number = source.width;
			var s:Number = 0;
			if(priorityHeight)
			{
				s = perfectHeight/h;
				source.height = perfectHeight;
				source.width = w * s;
				if(source.width > perfectWidth)
				{
					source.width = perfectWidth;
					s = perfectWidth/w;
					source.height = h * s;
				}
			}
			else
			{
				source.width = perfectWidth;
				s = perfectWidth/w;
				source.height = h * s;
				if(source.height>perfectHeight)
				{
					s = perfectHeight/h;
					source.height = perfectHeight;
					source.width = w * s;
				}
			}
		}
			
	}
}