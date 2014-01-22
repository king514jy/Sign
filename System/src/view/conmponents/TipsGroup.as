package view.conmponents
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class TipsGroup extends Sprite
	{
		private var textFile:TextField;
		public function TipsGroup()
		{
			textFile = new TextField();
			var tff:TextFormat = new TextFormat(null,16,0xffffff);
			textFile.defaultTextFormat = tff;
			textFile.autoSize = TextFieldAutoSize.CENTER;
			textFile.multiline = false;
			textFile.wordWrap = false;
		}
	}
}