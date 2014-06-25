package view
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.conmponents.AppRoot;
	
	public class AppRootMe extends Mediator implements IMediator
	{
		public static const NAME:String = "AppRootMe";
		private var appRoot:AppRoot;
		public function AppRootMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			appRoot = AppRoot.getInstance();
		}
		public function addListener():void
		{
			appRoot.root.stage.nativeWindow.addEventListener(Event.CLOSE,closeApp);
		}
		private function closeApp(e:Event):void
		{
			this.sendNotification(EditorFacade.CLEAR_TEMP_DIRECTORY);
		}
	}
}