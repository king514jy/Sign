package view
{
	import flash.events.Event;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import signUi.events.WeiboEvent;
	import signUi.service.sina.CheckWeibo;
	import signUi.service.sina.WeiboSever;
	
	import view.conmponents.AppRoot;
	
	public class SinaWeiboMe extends Mediator implements IMediator
	{
		public static const NAME:String = "SinaWeiboMe";
		private var checkWeibo:CheckWeibo;
		private var weiboSever:WeiboSever;
		private var appKey:String = "3231115413";
		private var htmlLoader:HTMLLoader;
		private var appRoot:AppRoot;
		public function SinaWeiboMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function start():void
		{
			weiboSever = WeiboSever.getInstance();
			checkWeibo = new CheckWeibo();
			checkWeibo.addEventListener(WeiboEvent.EXPIRED, weiboExpired);
			checkWeibo.addEventListener(WeiboEvent.OK, weiboOK);
			checkWeibo.init();
		}
		private function weiboOK(e:WeiboEvent):void
		{
			trace("授权没有过期")
			var checkWeibo:CheckWeibo = e.target as CheckWeibo;
			weiboSever.access_token = checkWeibo.access_token;
			checkWeibo.removeEventListener(WeiboEvent.EXPIRED, weiboExpired);
			checkWeibo.removeEventListener(WeiboEvent.OK, weiboOK);
			checkWeibo = null;
		}
		private function weiboExpired(e:WeiboEvent):void
		{
			appRoot = AppRoot.getInstance();
			var checkWeibo:CheckWeibo = e.target as CheckWeibo;
			checkWeibo.removeEventListener(WeiboEvent.EXPIRED, weiboExpired);
			checkWeibo.removeEventListener(WeiboEvent.OK, weiboOK);
			checkWeibo = null;
			trace("创建微博授权UI")
			var url:String = "https://api.weibo.com/oauth2/authorize";
			url+="?client_id=" + appKey;
			url += "&response_type=token";
			//url += "&response_type=code";
			url += "&display=flash";
			htmlLoader = new HTMLLoader();
			htmlLoader.load(new URLRequest(url));
			htmlLoader.width = 630;
			htmlLoader.height = 430;
			htmlLoader.x = (appRoot.stageW - 630) * 0.5;
			htmlLoader.y = (appRoot.stageH - 430) * 0.5;
			htmlLoader.addEventListener(Event.LOCATION_CHANGE, onLocationChange);
			appRoot.root.addChildAt(htmlLoader,appRoot.root.numChildren-1);
			
			
		}
		private function onLocationChange(e:Event):void
		{
			var lc:String = htmlLoader.location;
			trace(lc);
			var arr:Array = String(lc.split("#")[1]).split("&");
			for(var i:int = 0 ; i < arr.length; i ++)
			{
				var str:String = arr[i];
				if (str.indexOf("access_token=") >= 0) weiboSever.access_token = str.split("=")[1];
				if (str.indexOf("expires_in=") >= 0) weiboSever.expires_in = str.split("=")[1];
				if (str.indexOf("remind_in=") >= 0) weiboSever.remind_in = str.split("=")[1];
				if (str.indexOf("uid=") >= 0) weiboSever.uid = str.split("=")[1];
			}
			if(weiboSever.access_token != "")
			{
				weiboSever.save();
				htmlLoader.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
				appRoot.root.removeChild(htmlLoader);
			}
		}
		public function sendPic(byt:ByteArray, name:String=""):void
		{
			weiboSever.sendPic(byt,name);
		}
	}
}