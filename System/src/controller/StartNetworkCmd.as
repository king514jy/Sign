package controller
{
	import model.UdpProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartNetworkCmd extends SimpleCommand
	{
		public function StartNetworkCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var udpPro:UdpProxy = this.facade.retrieveProxy(UdpProxy.NAME) as UdpProxy;
			udpPro.start();
		}
	}
}