package model.vo
{
	import flash.net.Socket;

	public class ClientGroup
	{
		public var socket:Socket;
		public var msgLen:int;
		public var isReadHead:Boolean;
		public function ClientGroup()
		{
		}
	}
}