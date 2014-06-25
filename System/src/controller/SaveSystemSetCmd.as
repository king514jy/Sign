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
			var obj:Object = notification.getBody();
			configPro.projectName = obj.projectName;
			configPro.projectPath = obj.projectPath;
			configPro.direction = obj.direction;
			configPro.terminal = obj.terminal;
			configPro.ip = obj.ip;
			configPro.coding = obj.coding;
			configPro.saveConfig();
		}
	}
}