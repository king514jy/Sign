package systemSetUI
{
	import flash.display.Sprite;
	
	public class OpenTips extends Sprite
	{
		public var circleSpr:Sprite;
		private var tipsSpr:Sprite;
		public function OpenTips() 
		{
			tipsSpr = this.getChildByName("tips_mc") as Sprite;
			circleSpr = this.getChildByName("circle_mc") as Sprite;
		}

	}
	
}
