package signEditorUI
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import signEditorUI.events.MenuEvent;
	
	public class TipsGroup extends Sprite
	{
		public const selfX:uint = 981;
		public const selfY:uint = 44;
		private var tipsTxt:TextField;
		private var okBtn:SimpleButton;
		private var cancelBtn:SimpleButton;
		public function TipsGroup()
		{
			tipsTxt = this.getChildByName("tips_txt") as TextField;
			okBtn = this.getChildByName("ok_btn") as SimpleButton;
			cancelBtn = this.getChildByName("cancel_btn") as SimpleButton;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		public function set tips(str:String):void{ tipsTxt.text = str; }
		public function get tips():String{ return tipsTxt.text; }
		private function addToStage(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			okBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			cancelBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function removeFromStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			okBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
			cancelBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			if(btn == okBtn)
				dispatchEvent(new MenuEvent(MenuEvent.OK));
			else
				dispatchEvent(new MenuEvent(MenuEvent.CANCEL));
		}
	}
}