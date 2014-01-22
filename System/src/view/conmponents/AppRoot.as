package view.conmponents
{
	import flash.display.Sprite;

	public class AppRoot
	{
		public static var instance:AppRoot;
		public var root:Sprite;
		public var stageW:Number;
		public var stageH:Number;
		public function AppRoot()
		{
		}
		public static function getInstance():AppRoot
		{
			if(!instance)
				instance = new AppRoot();
			return instance;
		}
	}
}