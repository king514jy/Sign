package ky.net
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class SocketNetWork extends EventDispatcher
	{
		private var socket:Socket;
		private var _ip:String;
		private var _port:int;
		private var objList:Vector.<Object>;
		public function SocketNetWork()
		{
			objList = new Vector.<Object>();
		}
		public function get ip():String{ return _ip; }
		public function get port():int{ return _port; }
		public function connect(ip:String,port:int=2013):void
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
			socket.connect(_ip,_port);
			socket.addEventListener(Event.CONNECT,handleData);
			socket.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
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
			trace("连接错误")
		}
		private function securityError(e:SecurityErrorEvent):void
		{
			trace("安全错误")
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
				connect(_ip);
				
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