package systemSetUI.menu
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import systemSetUI.core.ISetUI;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.SetUIEvent;
	
	public class SetCurrentModule extends Sprite implements ISetUI
	{
		private var regainBtn:SimpleButton;
		private var selectBtn:SimpleButton;
		private var saveBtn:SimpleButton;
		private var pathTxt:TextField;
		private var infoTxt:TextField;
		private var _complete:Boolean;
		public function SetCurrentModule()
		{
			regainBtn = this.getChildByName("regain_btn") as SimpleButton;
			selectBtn = this.getChildByName("select_btn") as SimpleButton;
			saveBtn = this.getChildByName("save_btn") as SimpleButton;
			pathTxt = this.getChildByName("path_txt") as TextField;
			infoTxt = this.getChildByName("info_txt") as TextField;
			
			regainBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			selectBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			saveBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		public function set path(str:String):void{ pathTxt.text = str; }
		public function get path():String{ return pathTxt.text; }
		public function set progress(n:Number):void{}
		public function set complete(b:Boolean):void{ _complete = b;}
		public function get complete():Boolean{ return _complete; }
		public function set info(str:String):void{ infoTxt.text = str; }
		public function get info():String{ return infoTxt.text; }
		private function clickHandle(e:MouseEvent):void
		{
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			switch(btn)
			{
				case regainBtn:
					dispatchEvent(new SetUIEvent(SetUIEvent.CURRENT_REGAIN));
					break;
				case selectBtn:
					dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FILE,0,"*.mtc"));
					break;
				case saveBtn:
					dispatchEvent(new SetUIEvent(SetUIEvent.CURRENT_SAVE));
					break;
			}
		}
		
	}
}