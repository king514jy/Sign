package signUi.display 
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author Q·Jy
	 */
	public class VideoWindow extends Sprite 
	{
		private var duration:Number;
		private var ns:NetStream
		private var _video:Video;
		private var _loop:Boolean;
		private var _url:String;
		public function VideoWindow(w:Number,h:Number,url:String=null,loop:Boolean=true) 
		{
			_loop = loop;
			_url = url;
			var _client:Object=new Object();
			_client.onMetaData = onMetaData;
			_video = new Video(w, h);
			_video.smoothing = true;
			addChild(_video);
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.client = _client;
			if(url)
				ns.play(url);
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			_video.attachNetStream(ns);
		}
		public function get video():Video{ return _video; }
		public function set loop(b:Boolean):void{ _loop = b; }
		public function get loop():Boolean{ return _loop; }
		public function set url(str:String):void{ _url = url;ns.play(url); }
		public function get url():String{ return _url; }
		private function onMetaData(data:Object):void
		{
			duration = data.duration;
		}
		private function netStatus(e:NetStatusEvent):void
		{
			if (e.info.code == "NetStream.Play.Stop")
			{
				if(_loop)
					ns.play(_url);
			}
		}
	}

}