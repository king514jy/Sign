package view.conmponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ky.debug.InformationGroup;

	public class AppRoot
	{
		public static var instance:AppRoot;
		public var root:Sprite;
		public var stageW:Number;
		public var stageH:Number;
		private var debugInfo:InformationGroup;
		public function AppRoot()
		{
		}
		public static function getInstance():AppRoot
		{
			if(!instance)
				instance = new AppRoot();
			return instance;
		}
		public function openDebug(w:Number=300,h:Number=300):void
		{
			if(!debugInfo)
			{
				debugInfo = new InformationGroup(w,h);
				root.addChild(debugInfo);
				root.addEventListener(Event.ADDED,addDisplay);
			}
		}
		public function closeDebug():void
		{
			if(debugInfo)
			{
				root.removeChild(debugInfo);
				debugInfo = null;
				root.removeEventListener(Event.ADDED,addDisplay);
			}
		}
		public function addDebugInfo(str:String):void
		{
			if(!debugInfo)
				openDebug();
			debugInfo.addInfo(str);
		}
		private function addDisplay(e:Event):void
		{
			root.setChildIndex(debugInfo,root.numChildren-1);
		}
	}
}