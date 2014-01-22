package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveSystemSetCmd extends SimpleCommand
	{
		public function SaveSystemSetCmd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configPro.saveConfig(notification.getBody());
		}
	}
}