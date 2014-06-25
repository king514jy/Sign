package ky.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ky.events.RenderEvent;
	import ky.mode.DisplayAlignMode;
	import ky.utils.BmpFactory;
	
	public class PicGroup extends Sprite
	{
		private var _byt:ByteArray;
		private var _id:String;
		private var _align:String;
		private var _pic:Bitmap;
		private var _url:String;
		private var _scale:Number;
		private var _smoothing:Boolean;
		public function PicGroup(id:String=null,align:String="center_center",scale:Number=1,smoothing:Boolean=false)
		{
			_id = id;
			_align = align;
			_scale = scale;
			_smoothing = smoothing;
			_pic = new Bitmap();
			this.addChild(_pic);
		}
		public function set id(str:String):void{ _id = str; }
		public function get id():String{ return _id; }
		public function set align(str:String):void{ _align = str;setPoint(); }
		public function get align():String{ return _align; }
		public function get pic():Bitmap{ return _pic; }
		public function get complete():Boolean{ return _pic.bitmapData!=null; }
		public function get byt():ByteArray{ return _byt; }
		public function get url():String{ return _url; }
		public function set scale(n:Number):void{ _scale = n; }
		public function get scale():Number{ return _scale; }
		public function set smoothing(b:Boolean):void{ _smoothing = b; _pic.smoothing = b; }
		public function get smoothing():Boolean{ return _pic.smoothing; }
		public function loadByt(byt:ByteArray):void
		{
			_byt = byt;
			var loader:Loader = new Loader();
			loader.loadBytes(byt);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
		}
		public function loadURL(url:String):void
		{
			_url = url;
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loading);
		}
		private function loading(e:ProgressEvent):void
		{
			var pro:Number = Math.floor(e.bytesLoaded/e.bytesTotal*100);
			dispatchEvent(new RenderEvent(RenderEvent.RENDER_PROGRESS,pro));
		}
		public function draw(display:DisplayObject,mt:Matrix=null,transparent:Boolean=false):void
		{
			if(_pic.bitmapData)
			{
				_pic.bitmapData.dispose();
				_pic.bitmapData = null;
			}
			if(transparent)
				_pic.bitmapData = new BitmapData(display.width * scale,display.height * scale,transparent,0);
			else
				_pic.bitmapData = new BitmapData(display.width * scale,display.height * scale,transparent);
			_pic.bitmapData.draw(display,mt);
			_pic.smoothing = _smoothing;
			setPoint();
		}
		private function onComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			if(_pic.bitmapData)
				_pic.bitmapData.dispose();
			var bmp:Bitmap = loader.content as Bitmap;
			if(scale==1)
				_pic.bitmapData = bmp.bitmapData;
			else
				_pic.bitmapData = BmpFactory.ZoomScale(bmp,_scale).bitmapData;
			_pic.smoothing = _smoothing;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,loading);
			loader = null;
			setPoint();
			dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
		}
		private function setPoint():void
		{
			switch(_align)
			{
				case DisplayAlignMode.LEFT_TOP:
					_pic.x = 0;
					_pic.y = 0;
					break;
				case DisplayAlignMode.LEFT_CENTER:
					_pic.x = 0;
					_pic.y = -_pic.height * 0.5;
					break;
				case DisplayAlignMode.LEFT_BOTTOM:
					_pic.x = 0;
					_pic.y = -_pic.height;
					break;
				case DisplayAlignMode.CENTER_TOP:
					_pic.x = -_pic.width * 0.5;
					_pic.y = 0;
					break;
				case DisplayAlignMode.CENTER_CENTER:
					_pic.x = -_pic.width * 0.5;
					_pic.y = -_pic.height * 0.5;
					break;
				case DisplayAlignMode.CENTER_BOTTOM:
					_pic.x = -_pic.width * 0.5;
					_pic.y = -_pic.height;
					break;
				case DisplayAlignMode.RIGHT_TOP:
					_pic.x = -_pic.width;
					_pic.y = 0;
					break;
				case DisplayAlignMode.RIGHT_CENTER:
					_pic.x = -_pic.width;
					_pic.y = -_pic.height * 0.5;
					break;
				case DisplayAlignMode.RIGHT_BOTTOM:
					_pic.x = -_pic.width;
					_pic.y = -_pic.height;
					break;
			}
		}
		public function dispose():void
		{
			if(_pic.bitmapData)
				_pic.bitmapData.dispose();
			_pic.bitmapData = null;
		}
	}
}