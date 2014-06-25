package signEditorUI.conmponents
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import signEditorUI.events.MenuEvent;

	/**
	 * ...
	 * @author Q·JY
	 */
	public class ListElement extends Sprite 
	{
		private var deleteBtn:SimpleButton;
		private var nameTxt:TextField;
		private var goinBtn:SimpleButton;
		private var bgBtn:MovieClip;
		private var _isSelect:Boolean;
		public function ListElement() 
		{
			deleteBtn = this.getChildByName("delete_btn") as SimpleButton;
			nameTxt = this.getChildByName("name_txt") as TextField;
			goinBtn = this.getChildByName("goin_btn") as SimpleButton;
			bgBtn = this.getChildByName("item_bg_mc") as MovieClip;
			bgBtn.alpha = 0;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		public function set goinVisible(b:Boolean):void { goinBtn.visible = b; }
		public function get goinVisible():Boolean { return goinBtn.visible };
		public function set txt(str:String):void { nameTxt.text = str; }
		public function get txt():String { return nameTxt.text };
		public function set isSelect(b:Boolean):void
		{
			_isSelect = b;
			if(b)
				rollOver();
			else
				rollOut();
		}
		public function get isSelect():Boolean { return _isSelect };
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteThis);
			goinBtn.addEventListener(MouseEvent.CLICK, goin);
			addMouseEvent();
		}
		public function addMouseEvent():void
		{
			//bgBtn.addEventListener(MouseEvent.CLICK, clickHandle);
			//bgBtn.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			//bgBtn.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		public function removeMouseEvent():void
		{
			//bgBtn.removeEventListener(MouseEvent.CLICK, clickHandle);
			//bgBtn.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			//bgBtn.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		private function rollOver(e:MouseEvent=null):void
		{
			//nameTxt.textColor = 0xffffff;
			//bgBtn.alpha = 1;
		}
		private function rollOut(e:MouseEvent=null):void
		{
			//nameTxt.textColor = 0x2B2B2B;
			//bgBtn.alpha = 0;
		}
		private function clickHandle(e:MouseEvent):void
		{
			removeMouseEvent();
			dispatchEvent(new Event(Event.SELECT));
		}
		private function deleteThis(e:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.DELETE));
		}
		private function goin(e:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.GOIN));
		}
	}

}