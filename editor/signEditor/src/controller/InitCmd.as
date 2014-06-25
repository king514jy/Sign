package controller
{
	import model.ConfigManageProxy;
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.EditorUIMe;
	
	public class InitCmd extends SimpleCommand
	{
		public function InitCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var em:EditorUIMe = this.facade.retrieveMediator(EditorUIMe.NAME) as EditorUIMe;
			var mm:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			var configPro:ConfigManageProxy = this.facade.retrieveProxy(ConfigManageProxy.NAME) as ConfigManageProxy;
			configPro.init(mm.folderAddress);
			em.init(mm.nameList);
		}
	}
}