package signEditorUI
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import signEditorUI.events.MenuEvent;
	
	public class SelectUI extends Sprite
	{
		public const selfX:uint = 981;
		public const selfY:uint = 44;
		
		private var backBtn:SimpleButton;
		private var setOperateBtn:SimpleButton;
		private var setDisplayBtn:SimpleButton;
		public function SelectUI()
		{
			backBtn = this.getChildByName("back_btn") as SimpleButton;
			setOperateBtn = this.getChildByName("setOperate_btn") as SimpleButton;
			setDisplayBtn = this.getChildByName("setDisplay_btn") as SimpleButton;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(e:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			backBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			setDisplayBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			setOperateBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function removeFromStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			backBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
			setDisplayBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
			setOperateBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			switch(btn)
			{
				case backBtn:
					dispatchEvent(new MenuEvent(MenuEvent.BACK));
					break;
				case setOperateBtn:
					dispatchEvent(new MenuEvent(MenuEvent.SET_OPERATE));
					break;
				case setDisplayBtn:
					dispatchEvent(new MenuEvent(MenuEvent.SET_DISPLAY));
					break;
			}
		}
	}
}