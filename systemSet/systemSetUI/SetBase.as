package systemSetUI
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SetBase extends Sprite
	{
		public var goto:int;
		public var value:String;
		protected var valueList:Vector.<String>;
		protected var btnList:Vector.<MovieClip>;
		protected var nowBtn:MovieClip;
		public function SetBase() 
		{
			valueList = new Vector.<String>();
			btnList = new Vector.<MovieClip>();
		}
		public function addMouseEvent():void
		{
			for each(var mc:MovieClip in btnList)
			{
				mc.addEventListener(MouseEvent.CLICK,clickHandle);
			}
		}
		public function removeMouseEvent():void
		{
			for each(var mc:MovieClip in btnList)
			{
				mc.removeEventListener(MouseEvent.CLICK,clickHandle);
			}
		}
		public function setValue(str:String):void
		{
			var id:int = valueList.indexOf(str);
			if(id!=-1)
			{
				value = str;
				btnList[id].gotoAndStop(2);
				if(nowBtn)
					nowBtn.gotoAndStop(1);
				nowBtn = btnList[id];
			}
		}
		protected function clickHandle(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var id:int = btnList.indexOf(mc);
			if(nowBtn)
				nowBtn.gotoAndStop(1);
			mc.gotoAndStop(2);
			nowBtn = mc;
			value = valueList[id];
		}
	}
	
}
