package model
{
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import model.vo.ClientGroup;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import signUi.mode.NetWorkEventMode;
	
	public class ServerSocketProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ServerSocketProxy";
		private var serverSocket:ServerSocket;
		private var clientList:Vector.<ClientGroup>;
		private var jcount:int;
		private var tcount:int
		public function ServerSocketProxy(data:Object=null)
		{
			super(NAME, data);
		}
		public function startSocket():void
		{
			if(!clientList)
				clientList = new Vector.<ClientGroup>();
			if(serverSocket)
			{
				if( serverSocket.bound ) 
				{
					serverSocket.close();
				}
			}
			serverSocket = new ServerSocket();
			serverSocket.bind(2013);
			serverSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			serverSocket.listen();
		}
		private function onConnect(e:ServerSocketConnectEvent):void
		{
			var client:Socket = e.socket;
			var group:ClientGroup = new ClientGroup();
			group.socket = client;
			clientList.push(group);
			client.addEventListener(ProgressEvent.SOCKET_DATA,onClientSocketData)
			trace("有人进来")
		}
		private function onClientSocketData( e:ProgressEvent ):void
		{
			var socket:Socket = e.target as Socket;
			var id:int;
			for each(var cp:ClientGroup in clientList)
			{
				if(cp.socket == socket)
					readData(cp);
				break;
			}
		}
		private function readData(cp:ClientGroup):void
		{     
			//如果还没读过头部则读一次。
			if (!cp.isReadHead && cp.socket.bytesAvailable>4)
			{
				var lenByte:ByteArray = new ByteArray();
				cp.socket.readBytes(lenByte, 0, 4);
				cp.msgLen = lenByte.readInt();
				//trace("新的消息长度:" + this.msgLen);
				cp.isReadHead = true;
			}
			//如果读了头部，并且当前可读长度大于等于消息长度，则开始读取
			if (cp.isReadHead && cp.socket.bytesAvailable >= cp.msgLen)
			{
				var objByte:ByteArray = new ByteArray();
				cp.socket.readBytes(objByte, 0, cp.msgLen); 
				cp.isReadHead = false;
				objByte.uncompress();
				var obj:Object = objByte.readObject(); 
				readMsg(obj);   //读完了，可以去解释了
			} 
			//如果是读过头，则如果当前消息大于消息长度则再次调用读取，否则则判断是否可读头部
			if(cp.socket.bytesAvailable > 0 && !cp.isReadHead  )  
				readData(cp);
			
		}  
		private function readMsg(obj:Object):void
		{
			if(obj.type==NetWorkEventMode.PICTURE_TRANSPORT)
			{
				trace("接收图片"+jcount);
				jcount++
				var picFile:File = File.documentsDirectory.resolvePath("sign/"+obj.id+".jpg");
				var picByt:ByteArray = obj.byt;
				var picFs:FileStream = new FileStream();
				picFs.open(picFile,FileMode.WRITE);
				picFs.writeBytes(picByt);
				picFs.close();
			}
			if(obj.type==NetWorkEventMode.PICTURE_SEPARATE)
			{
				trace("脱离控制"+tcount);
				tcount++;
			}
		}
		public function closeSocket():void
		{
			serverSocket.close();
			serverSocket = null;
		}
		
	}
}