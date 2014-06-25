package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SystemSetMe;
	
	public class OpenSystemSetCmd extends SimpleCommand
	{
		public function OpenSystemSetCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var type:String = notification.getType();
			var setMe:SystemSetMe = this.facade.retrieveMediator(SystemSetMe.NAME) as SystemSetMe;
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var obj:Object = new Object();
			obj.projectName = configPro.projectName;
			obj.projectPath = configPro.projectPath;
			obj.direction = configPro.direction;
			obj.terminal = configPro.terminal;
			obj.ip = configPro.ip;
			obj.coding = configPro.coding;
			setMe.openUI(obj);
		}
	}
}