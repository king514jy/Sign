package signUi.tools
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import signUi.core.ActionBase;
	
	public class SignBoard extends ActionBase
	{
		private var brush:Sprite;
		private var brushClass:Class;
		private var brushW:Number;
		private var brushH:Number;
		private var bm:Bitmap;
		private var bmd:BitmapData;
		private var paper:Sprite;
		private var oldX:Number;
		private var oldY:Number;
		private var oldScale:Number;
		private var brushBox:Sprite;
		
		private var defaultScale:Number = .8;//默认笔触的大小
		private var cx:Number = .05;//粗细变化参数
		private var brushMin:Number = .3;//最细笔触限制
		private var brushAlpha:Number = .3;//笔刷浓度
		private var brushBlur:Number = 1;//笔刷模糊
		private var midu:Number = 1;//笔刷密度
		
		private var bf:BlurFilter;
		private var dsf:DropShadowFilter;
		private var filterAr:Array;
		private var paperWidth:Number;
		private var paperHeight:Number;
		private var undoStack:Vector.<BitmapData>;
		private var numUndoLevels:int = 10;
		private var nowColor:int;
		private var colorList:Vector.<uint>;
		public function SignBoard(brushClass:Class,paperWidth:Number,paperHeight:Number)
		{
			this.brushClass = brushClass;
			brush = new brushClass();
			brushW = brush.width;
			brushH = brush.height;
			this.paperWidth = paperWidth;
			this.paperHeight = paperHeight;
			colorList = new Vector.<uint>();
			colorList.push(0xD71E26, 0xE74926, 0xCFA10E, 0x86D524, 0x07CD7E, 0x0FBBCF, 0x9314D5, 0xE80E6D, 0xE2E2E2);
			bf = new BlurFilter(brushBlur, brushBlur);
			//dsf = new DropShadowFilter(0, 0, 0xff0000, 1, 8, 8);
			filterAr = new Array(bf);
			brush.alpha = brushAlpha;
			brush.scaleX = brush.scaleY = defaultScale;
			brush.filters = filterAr;
			paper = new Sprite();
			addChild(paper);
			paper.addChild(brush);
			brushBox = new Sprite();
			paper.addChild(brushBox);
			brush.visible = false;
			bmd = new BitmapData(paperWidth, paperHeight,true,0xffffff);
			bm = new Bitmap(bmd);
			bm.smoothing = true;
			addChild(bm);
			undoStack = new Vector.<BitmapData>();
		}
		public function get content():BitmapData{ return bmd; }
		override public function startAction():void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		override public function stopAction():void
		{
			if (hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		override public function setAction():void
		{
			removeChild(bm);
			bmd.dispose();
			bmd = null;
			bm = null;
			bmd = new BitmapData(paperWidth, paperHeight, true, 0xffffff);
			undoStack.length = 0;
			bm = new Bitmap(bmd);
			bm.smoothing = true;
			addChild(bm);
		}
		override public function replyAction():void 
		{
			undo();
		}
		private function mouseUp(e:MouseEvent):void
		{
			brush.visible = false;
			brush.scaleX = brush.scaleY = 1;
			stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE, addBrush);
			var undoBuffer:BitmapData = new BitmapData(paperWidth, paperHeight, true, 0xffffff);
			undoBuffer.copyPixels(bmd,undoBuffer.rect,new Point(0,0));
			undoStack.push(undoBuffer);
			if (undoStack.length > numUndoLevels + 1)
			{
				undoStack.splice(0,1);
			}
		}
		private function mouseDown(e:MouseEvent):void
		{
			oldX = brush.x = mouseX;
			oldY = brush.y = mouseY;
			oldScale = 1;
			brush.startDrag(true);
			brush.visible = true;
			
			addEventListener(MouseEvent.MOUSE_MOVE, addBrush);
		}
		
		private function addBrush(e:Event):void
		{
			//计算距离
			var disX:Number=mouseX-oldX;
			var disY:Number=mouseY-oldY;
			var dis:Number = Math.sqrt(disX * disX + disY * disY);
			//改变笔触的大小,越快越小
			if (dis > 0) 
			{
				var scale:Number = defaultScale - dis * cx;
				if (scale > 1) 
				{
					scale = 1;
				}
				else if (scale < brushMin) 
				{
					scale = brushMin;
				}
				scale = (oldScale + scale) / 2;
				brush.scaleY = brush.scaleX = scale;
			}
			//填充
			var count:int = Math.floor(dis / midu);
			var scaleBili:Number = (oldScale-scale) / count;
			for (var i:int = 0; i < count - 1; i++)
			{
				/*var bmpData:BitmapData = new BitmapData(brushW,brushH,true,0);
				var matrix:Matrix = new Matrix();
				matrix.scale(scale+(1-scale),scale+(1-scale));
				bmpData.draw(brush,matrix);
				var bmp:Bitmap = new Bitmap(bmpData);
				bmp.filters = filterAr;
				bmp.alpha = brushAlpha;
				bmp.scaleX = bmp.scaleY = oldScale-i * scaleBili;
				brushBox.addChild(bmp);
				bmp.x = (disX / count) * (i + 1) + oldX;
				bmp.y = (disY / count) * (i + 1) + oldY;*/
				var br:Sprite = new brushClass();
				br.filters = filterAr;
				br.alpha = brushAlpha;
				br.scaleX = br.scaleY = oldScale-i * scaleBili;
				brushBox.addChild(br);
				br.x = (disX / count) * (i + 1) + oldX;
				br.y = (disY / count) * (i + 1) + oldY;
			}
			oldScale = scale;
			oldX = mouseX;
			oldY = mouseY;
			bmd.draw(paper);
			//删除填充
			while (brushBox.numChildren > 0)
			{
				brushBox.removeChildAt(0);
			}
		}
		private function undo():void 
		{
			if (undoStack.length > 1)
			{
				bmd.copyPixels(undoStack[undoStack.length - 2],bmd.rect,new Point(0,0));
				undoStack.splice(undoStack.length - 1, 1);
			}
			else
			{
				removeChild(bm);
				bmd.dispose();
				bmd = null;
				bmd = new BitmapData(paperWidth, paperHeight, true, 0xffffff);
				undoStack.length = 0;
				bm = new Bitmap(bmd);
				bm.smoothing = true;
				addChild(bm);
			}
		}
	}
}