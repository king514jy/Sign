package systemSetUI
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import ky.mode.SetTerminalMode;
	import flash.events.MouseEvent;
	
	public class SetTerminal extends SetBase
	{
		public function SetTerminal() 
		{
			super();
			valueList.push(SetTerminalMode.OPERATE,SetTerminalMode.DISPLAY);
			btnList.push(this.getChildByName("operate_mc") as MovieClip,this.getChildByName("display_mc") as MovieClip);
		}
		override protected function clickHandle(e:MouseEvent):void
		{
			super.clickHandle(e);
			if(value == SetTerminalMode.DISPLAY)
				goto = 4;
			else
				goto = 3;
			dispatchEvent(new Event("goto"));
		}

	}
	
}
