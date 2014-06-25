package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.ui.Mouse;
	
	import view.conmponents.AppRoot;
	[SWF(width="1366",height="768",backgroundColor="#000000",frameRate="30")]
	public class System extends Sprite
	{
		private var appRoot:AppRoot;
		public function System()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			//Mouse.hide();
			appRoot = AppRoot.getInstance();
			appRoot.root = this;
			appRoot.stageW = stage.stageWidth;
			appRoot.stageH = stage.stageHeight;
			//appRoot.openDebug();
			SystemFacade.getInstance().startup();
		}
	}
}