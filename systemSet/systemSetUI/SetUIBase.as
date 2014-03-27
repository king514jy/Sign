package systemSetUI
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class SetUIBase extends Sprite
	{
		protected var group:DisplayObjectContainer;
		public function SetUIBase()
		{
			super();
		}
		public function openUI(group:DisplayObjectContainer):void
		{
			this.group = group;
			group.addChild(this);
		}
		public function closeUI():void
		{
			group.removeChild(this);
		}
	}
}