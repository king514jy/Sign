package signUi.service.sina 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import signUi.events.WeiboEvent

	public class CheckWeibo extends EventDispatcher 
	{
		private const oneDay:Number = 24 * 3600 * 1000;
		private var _access_token:String;
		private var _information:String;
		public function CheckWeibo() 
		{
			
		}
		public function get access_token():String { return _access_token; }
		public function init():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("assets/global.xml");
			if (file.exists)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(new URLRequest(file.url));
				urlLoader.addEventListener(Event.COMPLETE, onComplete);
			}
			else
			{
				dispatchEvent(new WeiboEvent(WeiboEvent.EXPIRED));
			}
		}
		private function onComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			var date:Date = new Date();
			var expires:String = xml.weibo.@expires;
			var expiresDate:Date = new Date();
			expiresDate.setFullYear(Number(expires.substr(0, 4)), Number(expires.substr(4, 2)), Number(expires.slice(6)));
			if (date>=expiresDate)
			{
				dispatchEvent(new WeiboEvent(WeiboEvent.EXPIRED));
			}
			else
			{
				_access_token = xml.weibo.@token;
				dispatchEvent(new WeiboEvent(WeiboEvent.OK));
			}
			urlLoader.removeEventListener(Event.COMPLETE, onComplete);
			urlLoader = null;
		}
	}

}