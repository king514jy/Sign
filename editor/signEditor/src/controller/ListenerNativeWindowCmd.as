package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.AppRootMe;
	
	public class ListenerNativeWindowCmd extends SimpleCommand
	{
		public function ListenerNativeWindowCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var app:AppRootMe = this.facade.retrieveMediator(AppRootMe.NAME) as AppRootMe;
			app.addListener();
		}
	}
}