package controller
{
	import model.ConfigManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ExportCmd extends SimpleCommand
	{
		public function ExportCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var configPro:ConfigManageProxy = this.facade.retrieveProxy(ConfigManageProxy.NAME) as ConfigManageProxy;
			var obj:Object = notification.getBody();
			configPro.exportZIP(obj.path,obj.xml);
		}
	}
}