package controller
{
	import model.AnalyzeServerDataProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AnalyzeServerDataCmd extends SimpleCommand
	{
		public function AnalyzeServerDataCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var analyzeServerDataPro:AnalyzeServerDataProxy = this.facade.retrieveProxy(AnalyzeServerDataProxy.NAME) as AnalyzeServerDataProxy;
			analyzeServerDataPro.readMsg(notification.getBody());
		}
	}
}