package signEditorUI.conmponents
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
			createValueUI();
		}
		public function set title(str:String):void { valueUI.titleTxt.text = str; }
		public function get title():String { return valueUI.titleTxt.text; }
		private function createValueUI():void
		{
			valueUI = new ValueUI();
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