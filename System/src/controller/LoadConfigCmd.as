package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadConfigCmd extends SimpleCommand
	{
		public function LoadConfigCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configProxy:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configProxy.loadConfig();
		}
	}
}