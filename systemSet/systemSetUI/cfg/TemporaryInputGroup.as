package systemSetUI.cfg
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class TemporaryInputGroup extends Sprite
	{
		private var valueTxt:TextField;
		public function TemporaryInputGroup()
		{
			valueTxt = this.getChildByName("value_txt") as TextField;
		}
		public function get value():String{ return valueTxt.text; }
		public function get textField():TextField{ return valueTxt; }
		public function add(str:String):void
		{
			valueTxt.appendText(str);
		}
		public function clear():void
		{
			valueTxt.text = "";
		}
		public function del():void
		{
			valueTxt.text = valueTxt.text.substring(0, valueTxt.text.length - 1);
		}
	}
}