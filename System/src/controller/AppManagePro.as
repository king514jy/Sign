package controller
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import view.conmponents.AppRoot;
	
	public class AppManagePro extends Proxy implements IProxy
	{
		public static const NAME:String = "AppManagePro";
		private var appRoot:AppRoot;
		public function AppManagePro(data:Object=null)
		{
			super(NAME, data);
			appRoot = AppRoot.getInstance();
			appRoot.root.stage.nativeWindow.addEventListener(Event.CLOSE,closeApp);
		}
		private function closeApp(e:Event):void
		{
			this.sendNotification(SystemFacade.CLOSE_APP);
		}
	}
}