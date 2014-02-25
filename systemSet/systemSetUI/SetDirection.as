package systemSetUI
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import signUi.mode.SetDirectionMode;
	import flash.events.MouseEvent;

	public class SetDirection extends SetBase
	{
		public function SetDirection()
		{
			super();
			valueList.push(SetDirectionMode.LEFT,SetDirectionMode.RIGHT,SetDirectionMode.TOP,SetDirectionMode.BOTTOM,SetDirectionMode.EMBED);
			btnList.push(this.getChildByName("left_mc") as MovieClip,this.getChildByName("right_mc") as MovieClip,
						this.getChildByName("top_mc") as MovieClip,this.getChildByName("bottom_mc") as MovieClip,
						this.getChildByName("embed_mc") as MovieClip);
		}
		override protected function clickHandle(e:MouseEvent):void
		{
			super.clickHandle(e);
			goto = 3;
			dispatchEvent(new Event("goto"));
		}
	}
	
}
