package model
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	
	public class SocketProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SocketProxy";
		private var _ip:String;
		private var socket:Socket;
		private var objList:Vector.<Object>;
		public function SocketProxy(data:Object=null)
		{
			super(NAME, data);
			objList = new Vector.<Object>();
		}
		public function start(ip:String):void
		{
			_ip = ip;
			if(socket)
			{
				try 
				{
					socket.close();
				}
				catch (e:IOError)
				{
					trace (e);//Error: Error #2002: Operation attempted on invalid socket.
				}
				socket = null;
			}
			socket = new Socket();
			socket.connect(_ip,2013);
			socket.addEventListener(Event.CONNECT,handleData);
			socket.addEventListener(Event.CLOSE,closeConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			
		}
		private function closeConnect(e:Event):void
		{
			
		}
		private function handleData(e:Event = null):void
		{
			if(e)
				socket.removeEventListener(Event.CONNECT,handleData);
			if(objList.length > 0)
				sendBegin(objList.shift());
		}
		private function ioError(e:IOErrorEvent):void
		{
			//trace("连接错误")
			
		}
		private function securityError(e:SecurityErrorEvent):void
		{
			
		}
		public function send(obj:Object):void
		{
			if(socket.connected)
			{
				sendBegin(obj);
			}
			else
			{
				objList.push(obj);
				start(_ip);
			}
		}
		private function sendBegin(obj:Object):void
		{
			var objByte:ByteArray = new ByteArray();
			objByte.writeObject(obj); 
			objByte.compress();
			var msgByte:ByteArray = new ByteArray();
			msgByte.writeInt(objByte.length);
			msgByte.writeBytes(objByte, 0, objByte.length); 
			socket.writeBytes(msgByte);
			socket.flush();
			handleData();
		}
		public function close():void
		{
			if(socket)
			{
				try 
				{
					socket.close();
				}
				catch (e:IOError)
				{
					trace (e);//Error: Error #2002: Operation attempted on invalid socket.
				}
			}
		}
	}
}