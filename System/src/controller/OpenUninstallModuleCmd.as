package controller
{
	import flash.filesystem.File;
	
	import model.ModuleManageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.UninstallModuleMe;
	
	public class OpenUninstallModuleCmd extends SimpleCommand
	{
		public function OpenUninstallModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var mmPro:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			var uninstallUIMe:UninstallModuleMe = this.facade.retrieveMediator(UninstallModuleMe.NAME) as UninstallModuleMe;
			var path:String = File.applicationStorageDirectory.resolvePath(mmPro.folderAddress).url+"/";
			uninstallUIMe.openUI(path,mmPro.templateList);
		}
	}
}