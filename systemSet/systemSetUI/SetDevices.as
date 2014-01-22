package systemSetUI
{
	import flash.display.Sprite;
	import signUi.mode.SetDevicesMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SetDevices extends SetBase
	{
		public function SetDevices() 
		{
			super();
			valueList.push(SetDevicesMode.SIGNLE,SetDevicesMode.MULTI);
			btnList.push(this.getChildByName("dan_mc") as MovieClip,this.getChildByName("duo_mc") as MovieClip);
		}
		override protected function clickHandle(e:MouseEvent):void
		{
			super.clickHandle(e);
			var mc:MovieClip = e.currentTarget as MovieClip;
			var id:int = btnList.indexOf(mc);
			if(id == 0)
				goto = 3;
			else
				goto = 1;
			dispatchEvent(new Event("goto"));
		}
	}
	
}
