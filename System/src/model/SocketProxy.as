package model
{
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SocketProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SocketProxy";
		private var serverSocket:ServerSocket;
		public function SocketProxy(data:Object=null)
		{
			super(NAME, data);
		}
		public function startSocket():void
		{
			if(serverSocket)
			{
				if( serverSocket.bound ) 
				{
					serverSocket.close();
				}
			}
			serverSocket = new ServerSocket();
			serverSocket.bind(2014);
			serverSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			serverSocket.listen();
		}
		private function onConnect(e:ServerSocketConnectEvent):void
		{
			
		}
		public function closeSocket():void
		{
			serverSocket.close();
			serverSocket = null;
		}
		public function sendPlayList(ip:String):void
		{
			
		}
		public function sendZip(byt:ByteArray):void
		{
			
		}
		private function balePlayList():ByteArray
		{
			var byt:ByteArray = new ByteArray();
			return byt;
		}
	}
}