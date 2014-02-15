package controller
{
	import model.ServerSocketProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartServerSocketCmd extends SimpleCommand
	{
		public function StartServerSocketCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var serverPro:ServerSocketProxy = this.facade.retrieveProxy(ServerSocketProxy.NAME) as ServerSocketProxy;
			serverPro.startSocket();
		}
	}
}