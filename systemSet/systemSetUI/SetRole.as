package systemSetUI
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import signUi.mode.SetRoleMode;
	import flash.events.MouseEvent;
	public class SetRole extends SetBase
	{

		public function SetRole() 
		{
			super();
			valueList.push(SetRoleMode.SERVER,SetRoleMode.CLIENT);
			btnList.push(this.getChildByName("server_mc") as MovieClip,this.getChildByName("client_mc") as MovieClip);
		}
		override protected function clickHandle(e:MouseEvent):void
		{
			super.clickHandle(e);
			var mc:MovieClip = e.currentTarget as MovieClip;
			if(mc == btnList[1])
				goto = 4;
			else
				goto = 5;
			dispatchEvent(new Event("goto"));
		}
	}
	
}
