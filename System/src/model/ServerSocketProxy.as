package model
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import model.vo.ClientGroup;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import view.conmponents.AppRoot;
	
	
	public class ServerSocketProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ServerSocketProxy";
		private var serverSocket:ServerSocket;
		private var clientList:Vector.<ClientGroup>;
		private var appRoot:AppRoot;
		private var oldTime:uint;
		private var isBegin:Boolean;
		public var openDebug:Boolean;
		public function ServerSocketProxy(data:Object=null)
		{
			super(NAME, data);
			appRoot = AppRoot.getInstance();
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
				serverSocket = null;
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
			client.addEventListener(ProgressEvent.SOCKET_DATA,onClientSocketData);
			client.addEventListener(Event.CLOSE,closeClient);
			if(openDebug)
				appRoot.addDebugInfo(client.remoteAddress+"进入服务器");
		}
		private function closeClient(e:Event):void
		{
			var client:Socket = e.target as Socket;
			if(openDebug)
				appRoot.addDebugInfo("退出服务器");
			for(var i:int=0;i<clientList.length;i++)
			{
				if(clientList[i].socket == client)
				{
					clientList.splice(i,1);
					break;
				}
			}
			client.removeEventListener(Event.CLOSE,closeClient);
			client.removeEventListener(ProgressEvent.SOCKET_DATA,onClientSocketData);
			client = null;
			
		}
		private function onClientSocketData( e:ProgressEvent ):void
		{
			if(openDebug)
			{
				if(!isBegin)
				{
					appRoot.addDebugInfo("开始接收信息");
					isBegin = true;
					oldTime = getTimer();
				}
			}
			var socket:Socket = e.target as Socket;
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
				 //读完了，可以去解释了
				if(openDebug)
				{
					appRoot.addDebugInfo("接收完毕--"+"耗时:"+String((getTimer()-oldTime)/1000)+"秒");
					isBegin = false;
				}
				this.sendNotification(SystemFacade.ANALYZE_SERVER_DATA,obj);
			} 
			//如果是读过头，则如果当前消息大于消息长度则再次调用读取，否则则判断是否可读头部
			if(cp.socket.bytesAvailable > 0 && !cp.isReadHead  )  
				readData(cp);
			
		}  
		public function closeSocket():void
		{
			for each(var cp:ClientGroup in clientList)
			{
				try
				{
					cp.socket.close();
				}
				catch (e:IOError)
				{
					trace (e);//Error: Error #2002: Operation attempted on invalid socket.
				}
			}
			if(serverSocket)
			{
				if( serverSocket.bound ) 
				{
					serverSocket.close();
				}
				serverSocket = null;
			}
		}
		
	}
}