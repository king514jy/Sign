package model.vo
{
	import flash.net.Socket;
	
	public class SocketExtend extends Socket
	{
		public var msgLen:int;
		public var isReadHead:Boolean;
		public function SocketExtend(host:String=null, port:int=0)
		{
			super(host, port);
		}
	}
}