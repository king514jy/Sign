package controller
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SystemSetMe;
	import view.conmponents.AppRoot;

	public class StartCmd extends SimpleCommand
	{
		public function StartCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var appRoot:AppRoot = AppRoot.getInstance();
			this.facade.registerProxy(new ConfigProxy());
			
			this.facade.registerMediator(new SystemSetMe(appRoot.root));
			
			this.facade.registerCommand(SystemFacade.LOAD_CONFIG,LoadConfigCmd);
			this.facade.registerCommand(SystemFacade.OPEN_SYSTEM_SET,OpenSystemSetCmd);
			this.facade.registerCommand(SystemFacade.SAVE_SYSTEM_SET,SaveSystemSetCmd);
			
			var obj:Object = new Object();
			obj.isSet = false;
			this.sendNotification(SystemFacade.LOAD_CONFIG,obj);
		}
	}
}