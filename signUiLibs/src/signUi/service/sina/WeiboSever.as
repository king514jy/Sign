package signUi.service.sina 
{
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import signUi.events.WeiboEvent;
	/**
	 * ...
	 * @author Q·JY
	 */
	public class WeiboSever extends EventDispatcher 
	{
		public static var instance:WeiboSever;
		private const oneDay:Number = 24 * 3600 * 1000;
		private var microBlog:MicroBlog;
		private var _access_token:String = "";
		private var _expires_in:String = "";
		private var	_remind_in:String = "";
		private var _uid:String = "";
		private var xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		private var xml:XML;
		private var fileStream:FileStream;
		private var file:File;
		public function WeiboSever() 
		{
			if (instance != null) throw Error("单例");
			microBlog = new MicroBlog();
			microBlog.consumerKey = "3231115413";
			microBlog.consumerSecret = "24690fc82663e0e3ee62cc7e2ca4549c";
			microBlog.proxyURI = "http://kongyue.sinaapp.com/proxy.php";
		}
		public function set access_token(str:String):void { _access_token = str;trace("token:"+_access_token) }
		public function get access_token():String { return _access_token; }
		public function set expires_in(str:String):void { _expires_in = str; }
		public function get expires_in():String { return _expires_in; }
		public function set remind_in(str:String):void { _remind_in = str; }
		public function get remind_in():String { return _remind_in; }
		public function set uid(str:String):void { _uid = str; }
		public function get uid():String { return _uid; }
		public static function getInstance():WeiboSever
		{
			if (instance == null) instance = new WeiboSever();
			return instance;
		}
		/**
		 * 发送图片
		 * @param byt
		 * @param name
		 * 
		 */
		public function sendPic(byt:ByteArray, infomation:String=""):void
		{
			trace("发送")
			var obj:Object = new Object();
			obj.access_token = _access_token;
			obj.status = infomation;
			obj.pic = byt;
			microBlog.callWeiboAPI("2/statuses/upload", obj, "POST", "resultSendMessage", "onFriendsshipsError");
			microBlog.addEventListener("resultSendMessage", resultSendMessage); 
		}
		private function resultSendMessage(e:MicroBlogEvent):void
		{
			microBlog.removeEventListener("resultSendMessage", resultSendMessage);    
			trace(e.result); 
			dispatchEvent(new WeiboEvent(WeiboEvent.SEND_SUCCESS));
		}
		private function onFriendsshipsError(e:MicroBlogErrorEvent):void
		{     
			microBlog.removeEventListener("resultSendMessage", resultSendMessage);    
			//获得错误信息   
			trace(e.message); 
		}
		public function save():void
		{
			if (_access_token)
			{
				var date:Date = new Date();
				date.setTime(date.valueOf() + oneDay);
				var year:String = String(date.getFullYear());
				var month:String
				if (date.getMonth() < 10) month = "0" + String(date.getMonth());
				else month = String(date.getMonth());
				var day:String;
				if (date.getDate() < 10) day = "0" + String(date.getDate());
				else day = String(date.getDate());
				xml = <data>
					<weibo token="0" expires="0" />
				</data>
				xml.weibo.@token = _access_token;
				xml.weibo.@expires = year + month + day;
				saveXml();
			}
		}
		private function saveXml():void
		{
			var xmlStr:String = xml.toString();
			var pattern:RegExp =  /\n/g;
			xmlStr = xmlStr.replace(pattern, "\r\n");
			file = File.applicationStorageDirectory.resolvePath("assets/global.xml");
			fileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(String(xmlHead + "\r\n" + xmlStr));
			fileStream.close();
			fileStream = null;
		}
	}

}