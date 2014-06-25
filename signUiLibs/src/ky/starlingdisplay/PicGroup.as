package ky.starlingdisplay
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ky.utils.BmpFactory;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class PicGroup extends Sprite
	{
		private var _image:Image;
		private var _mipMaps:Boolean;
		private var _byt:ByteArray;
		private var _id:String;
		private var _isCenter:Boolean;
		private var _url:String;
		private var _scale:Number;
		private var _smoothing:String;
		public function PicGroup(id:String=null,isCenter:Boolean=true,scale:Number=1,mipMaps:Boolean=false)
		{
			super();
			_id = id;
			_isCenter = isCenter;
			_scale = scale;
			_mipMaps = mipMaps;
		}
		public function get pic():Image{ return _image; }
		public function set id(str:String):void{ _id = str; }
		public function get id():String{ return _id; }
		public function set isCenter(b:Boolean):void{ _isCenter = b;setPoint(); }
		public function get isCenter():Boolean{ return _isCenter; }
		public function get byt():ByteArray{ return _byt; }
		public function get url():String{ return _url; }
		public function set scale(n:Number):void{ _scale = n; }
		public function get scale():Number{ return _scale; }
		public function set smoothing(str:String):void
		{
			_smoothing = str;
			if(_image)
				_image.smoothing = str;
		}
		public function get smoothing():String{ return _image.smoothing;}
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
		}
		private function onComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			if(_image)
			{
				this.removeChild(_image,true);
				_image = null;
			}
			var bmp:Bitmap = loader.content as Bitmap;
			var newBmp:Bitmap;
			if(scale==1)
				newBmp = bmp;
			else
				newBmp = BmpFactory.ZoomScale(bmp,_scale);
			_image = Image.fromBitmap(newBmp,_mipMaps);
			this.addChild(_image);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			loader = null;
			setPoint();
		}
		public function draw(display:DisplayObject,scale:Number=1,transparent:Boolean=false):void
		{
			if(_image)
			{
				this.removeChild(_image,true);
				_image = null;
			}
			var newData:BitmapData;
			if(transparent)
				newData = new BitmapData(display.width * scale,display.height * scale,transparent,0);
			else
				newData = new BitmapData(display.width * scale,display.height * scale,transparent);
			var mat:Matrix = new Matrix();
			mat.scale(scale,scale);
			newData.draw(display,mat);
			_image = Image.fromBitmap(new Bitmap(newData),_mipMaps);
			this.addChild(_image);
			setPoint();
		}
		private function setPoint():void
		{
			if(_isCenter)
			{
				_image.x = -_image.width * 0.5;
				_image.y = -_image.height * 0.5;
			}
			else
			{
				_image.x = 0;
				_image.y = 0;
			}
		}
	}
}