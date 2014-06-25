package controller
{
	import model.CurrentModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SetCurrentModuleMe;
	
	public class SetCurrentModuleCmd extends SimpleCommand
	{
		public function SetCurrentModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var cm:SetCurrentModuleMe = this.facade.retrieveMediator(SetCurrentModuleMe.NAME) as SetCurrentModuleMe;
			var cmP:CurrentModuleManageProxy = this.facade.retrieveProxy(CurrentModuleManageProxy.NAME) as CurrentModuleManageProxy;
			cm.openUI(cmP.getCurrentConfigAddress());
		}
	}
}