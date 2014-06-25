package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.EditorUIMe;
	
	public class InjectConfigXMLCmd extends SimpleCommand
	{
		public function InjectConfigXMLCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			this.sendNotification(EditorFacade.CLOSE_SCREEN_BLOCK);
			var em:EditorUIMe = this.facade.retrieveMediator(EditorUIMe.NAME) as EditorUIMe;
			var xml:XML = notification.getBody().data;
			em.setConfig(xml);
		}
	}
}