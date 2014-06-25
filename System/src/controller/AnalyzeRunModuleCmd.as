package controller
{
	import flash.filesystem.File;
	
	import model.ConfigProxy;
	import model.CurrentModuleManageProxy;
	import model.ModuleManageProxy;
	import model.RuntimeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AnalyzeRunModuleCmd extends SimpleCommand
	{
		public function AnalyzeRunModuleCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var analyzePro:RuntimeProxy = this.facade.retrieveProxy(RuntimeProxy.NAME) as RuntimeProxy;
			var mmPro:ModuleManageProxy = this.facade.retrieveProxy(ModuleManageProxy.NAME) as ModuleManageProxy;
			var configPro:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var currentPro:CurrentModuleManageProxy = this.facade.retrieveProxy(CurrentModuleManageProxy.NAME) as CurrentModuleManageProxy;
			
			analyzePro.analyzeModule(mmPro.folderAddress + configPro.coding+File.separator,configPro.terminal,currentPro.hasConfig,currentPro.getRunConfigAddress());
		}
	}
}