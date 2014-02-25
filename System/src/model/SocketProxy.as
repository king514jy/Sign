package model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import signUi.net.SocketNetWork;
	
	public class SocketProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SocketProxy";
		private var _ip:String;
		private var socketNetWork:SocketNetWork;
		public function SocketProxy(data:Object=null)
		{
			super(NAME, data);
			_ip = data as String;
			socketNetWork = new SocketNetWork(_ip);
		}
		public function send(obj:Object):void
		{
			socketNetWork.send(obj);
		}
		public function close():void
		{
			socketNetWork.close();
		}
	}
}