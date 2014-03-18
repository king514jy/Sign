package controller
{
	import model.ServerSocketProxy;
	import model.SocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.conmponents.AppRoot;
	
	public class OpenSocketDebugCmd extends SimpleCommand
	{
		public function OpenSocketDebugCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var openDebug:Boolean = notification.getBody().opDebug;
			var appRoot:AppRoot = AppRoot.getInstance();
			if(openDebug)
				appRoot.openDebug();
			else
				appRoot.closeDebug();
			if(this.facade.hasProxy(SocketProxy.NAME))
			{
				var socketPro:SocketProxy = this.facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				socketPro.openDebug = openDebug;
			}
			if(this.facade.hasProxy(ServerSocketProxy.NAME))
			{
				var serverSocketPro:ServerSocketProxy = this.facade.retrieveProxy(ServerSocketProxy.NAME) as ServerSocketProxy;
				serverSocketPro.openDebug = openDebug;
			}	
		}
	}
}