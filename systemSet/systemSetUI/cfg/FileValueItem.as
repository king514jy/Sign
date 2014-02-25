package systemSetUI.cfg 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.text.TextField;
	
	import systemSetUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class FileValueItem extends Sprite 
	{
		private var nameTxt:TextField;
		private var pathTxt:TextField;
		private var addBtn:MovieClip;
		private var _value:String;
		private var _extension:String;
		private var _tips:String;
		private var _showName:String;
		public function FileValueItem() 
		{
			nameTxt = this.getChildByName("name_txt") as TextField;
			pathTxt = this.getChildByName("path_txt") as TextField;
			addBtn = this.getChildByName("add_mc") as MovieClip;
			addBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addBtn.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addBtn.addEventListener(MouseEvent.CLICK, clickHandle);
		}
		public function set value(str:String):void { _value = str; pathTxt.text = str; }
		public function get value():String { return _value; }
		public function get tips():String { return _tips; }
		public function get extension():String { return _extension; }
		public function get label():String{ return nameTxt.text; }
		public function get showName():String{ return _showName; }
		private function mouseDown(e:MouseEvent):void
		{
			addBtn.gotoAndStop(2);
		}
		private function mouseUp(e:MouseEvent):void
		{
			addBtn.gotoAndStop(1);
		}
		public function inject(name:String,tips:String,extension:String,value:String):void
		{
			nameTxt.text = name;
			pathTxt.text = value;
			_showName = name;
			_value = value;
			_tips = tips;
			_extension = extension;
			addBtn.addEventListener(MouseEvent.CLICK, clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FILE));
		}
	}

}