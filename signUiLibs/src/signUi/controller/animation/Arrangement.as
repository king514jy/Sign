package signUi.controller.animation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import signUi.events.RenderEvent;
	import signUi.utils.Base64;
	import signUi.utils.PassHandler;
	
	public class Arrangement extends EventDispatcher
	{
		private var _voList:Vector.<ArrangementVo>;
		private var _le:uint;
		private var _url:String;
		public function Arrangement(url:String)
		{
			_url = url;
			_voList = new Vector.<ArrangementVo>();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
		}
		public function get length():uint{ return _voList.length; }
		public function get voList():Vector.<ArrangementVo>{ return _voList; }
		public function get url():String{ return _url; }
		private function onComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var byt:ByteArray = urlLoader.data as ByteArray;
			byt.uncompress();
			var fileData:String = Base64.decode(PassHandler.decryption(byt.readUTFBytes(byt.bytesAvailable)));
			var xml:XML = XML(fileData);
			var le:uint = xml.planeItem.length();
			for(var i:int=0;i<le;i++)
			{
				var picVo:ArrangementVo = new ArrangementVo();
				picVo.level = Number(xml.planeItem[i].@level);
				picVo.x = Number(xml.planeItem[i].@x);
				picVo.y = Number(xml.planeItem[i].@y);
				picVo.scale = Number(xml.planeItem[i].@scale);
				picVo.rotation = Number(xml.planeItem[i].@rotation);
				picVo.shadow = xml.planeItem[i].@shadow=="true";
				picVo.blurX = Number(xml.planeItem[i].@blurX);
				picVo.blurY = Number(xml.planeItem[i].@blurY);
				picVo.strength = Number(xml.planeItem[i].@strength);
				picVo.angle = Number(xml.planeItem[i].@angle);
				picVo.distance = Number(xml.planeItem[i].@distance);
				_voList.push(picVo);
			}
			dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
		}
	}
}