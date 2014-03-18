package model
{
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import view.conmponents.AppRoot;
	
	public class UdpProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "UdpProxy";
		private var datagramSocket:DatagramSocket = new DatagramSocket();
		private var objList:Vector.<Object>;
		private var ip:String;
		private var appRoot:AppRoot;
		public function UdpProxy(data:Object=null)
		{
			super(NAME, data);
			objList = new Vector.<Object>();
			appRoot = AppRoot.getInstance();
		}
		public function start(ip:String=null):void
		{
			if( datagramSocket.bound ) 
			{
				datagramSocket.close();
				datagramSocket = new DatagramSocket();
			}
			datagramSocket.bind(2013);
			datagramSocket.addEventListener( DatagramSocketDataEvent.DATA, dataReceived );
			datagramSocket.receive();
			if(ip)
			{
				this.ip = ip;
				datagramSocket.connect(ip,2013);
			}
		}
		private function dataReceived( e:DatagramSocketDataEvent ):void
		{
			trace("收到信息")
			var info:Object = e.data.readObject();
			trace(info.type);
		}
		public function send(obj:Object):void
		{
			appRoot.addDebugInfo("准备发送--");
			if(datagramSocket.connected)
			{
				sendBegin(obj);
			}
			else
			{
				objList.push(obj);
				datagramSocket.connect(ip,2013);
			}
		}
		private function sendBegin(obj:Object):void
		{
			appRoot.addDebugInfo("发送信息--");
			var msgByte:ByteArray = new ByteArray();
			msgByte.writeObject(obj);
			datagramSocket.send(msgByte);
			handleData();
		}
		private function handleData(e:Event = null):void
		{
			if(objList.length > 0)
				sendBegin(objList.shift());
		}
	}
}