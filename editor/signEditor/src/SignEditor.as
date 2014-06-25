package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import view.conmponents.AppRoot;
	
	[SWF(width="1280",height="700",backgroundColor="#000000",frameRate="30")]
	public class SignEditor extends Sprite
	{
		private var appRoot:AppRoot;
		public function SignEditor()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			appRoot = AppRoot.getInstance();
			appRoot.root = this;
			appRoot.stageW = stage.stageWidth;
			appRoot.stageH = stage.stageHeight;
			//appRoot.openDebug();
			EditorFacade.getInstance().startup();
		}
	}
}