package ky.data
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import ky.events.RenderEvent;
	
	public class BitmapHoldList extends EventDispatcher
	{
		private var _urlList:Vector.<String>;
		private var le:uint;
		private var count:uint = 0;
		public var _complete:Boolean;
		private var bmpList:Vector.<Bitmap>;
		public function BitmapHoldList(urlList:Vector.<String>)
		{
			_urlList = urlList;
			le = urlList.length;
			bmpList = new Vector.<Bitmap>();
			load();
		}
		public function set urlList(list:Vector.<String>):void
		{
			_urlList.length = 0;
			_urlList = list;
			count = 0;
			bmpList.length = 0;
			_complete = false;
			load();
		}
		public function get urlList():Vector.<String> { return _urlList; }
		public function get complete():Boolean { return _complete; }
		private function load():void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(_urlList[count]));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
		}
		private function loadComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			var bmp:Bitmap = loader.content as Bitmap;
			bmpList.push(bmp);
			count++;
			if(count<le)
			{
				load();
			}
			else
			{
				_complete = true;
				dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
			}
		}
		public function getBitmapData(index:int):BitmapData
		{
			try
			{
				return bmpList[index].bitmapData.clone();
			}
			catch(e:Error)
			{
				throw new Error("所需要的图还没加载完成");
			}
		}
		public function dispose():void
		{
			for each(var bmp:Bitmap in bmpList)
			{
				bmp.bitmapData.dispose();
			}
			bmpList.length = 0;
		}
	}
}