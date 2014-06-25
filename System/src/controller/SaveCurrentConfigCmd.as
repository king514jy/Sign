package controller
{
	import model.CurrentModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SetCurrentModuleMe;
	
	public class SaveCurrentConfigCmd extends SimpleCommand
	{
		public function SaveCurrentConfigCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var currentMMP:CurrentModuleManageProxy = this.facade.retrieveProxy(CurrentModuleManageProxy.NAME) as CurrentModuleManageProxy;
			var currentMe:SetCurrentModuleMe = this.facade.retrieveMediator(SetCurrentModuleMe.NAME) as SetCurrentModuleMe;
			currentMMP.saveConfig(currentMe.path);
		}
	}
}