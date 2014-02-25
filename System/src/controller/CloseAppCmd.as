package controller
{
	import model.ServerSocketProxy;
	import model.SocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CloseAppCmd extends SimpleCommand
	{
		public function CloseAppCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			if(this.facade.hasProxy(ServerSocketProxy.NAME))
			{
				var ssPro:ServerSocketProxy = this.facade.retrieveProxy(ServerSocketProxy.NAME) as ServerSocketProxy;
				ssPro.closeSocket();
			}
			if(this.facade.hasProxy(SocketProxy.NAME))
			{
				var sPro:SocketProxy = this.facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				sPro.close();
			}
		}
	}
}