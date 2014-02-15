package systemSetUI.cfg 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Humberger
	 */
	public class ValueModlueBase extends Sprite 
	{
		protected var xml:XMLList;
		private var titleTxt:TextField;
		public var valueUI:ValueUI;
		public function ValueModlueBase() 
		{
			createTxt();
			createValueUI();
		}
		public function set title(str:String):void { titleTxt.text = str; }
		public function get title():String { return titleTxt.text; }
		private function createTxt():void
		{
			titleTxt = new TextField();
			titleTxt.autoSize = TextFieldAutoSize.LEFT;
			titleTxt.multiline = false;
			titleTxt.wordWrap = false;
			var tff:TextFormat = new TextFormat("_sans", 20, 0x2e2e2e);
			titleTxt.defaultTextFormat = tff;
			this.addChild(titleTxt);
		}
		private function createValueUI():void
		{
			valueUI = new ValueUI();
			valueUI.y = 32;
			this.addChild(valueUI);
		}
		public function injectXml(xml:XMLList ):void 
		{
			
		}
		public function getXml():XMLList
		{
			
			return xml;
		}
	}

}