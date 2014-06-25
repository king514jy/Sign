package view
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ScreenBlockMe extends Mediator implements IMediator
	{
		public static const NAME:String = "ScreenBlockMe";
		private var root:Sprite;
		public var container:Sprite;
		public var infoTxt:TextField;
		public function ScreenBlockMe(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			root = viewComponent as Sprite;
			
			infoTxt = new TextField();
			infoTxt.wordWrap = false;
			infoTxt.autoSize = TextFieldAutoSize.CENTER;
			infoTxt.multiline = false;
			var tff:TextFormat = new TextFormat(null,16,0xffffff);
			infoTxt.defaultTextFormat = tff;
		}
		public function set info(str:String):void{ infoTxt.text = str; }
		public function get info():String{ return infoTxt.text; }
		public function render():void
		{
			container = new Sprite();
			container.graphics.beginFill(0,0.8);
			container.graphics.drawRect(0,0,root.stage.stageWidth,root.stage.stageHeight);
			container.graphics.endFill();
			if(root.numChildren>1)
				root.addChildAt(container,root.numChildren-1);
			else
				root.addChild(container);
			infoTxt.x = container.width * 0.5;
			infoTxt.y = container.height * 0.5;
			container.addChild(infoTxt);
		}
		public function close():void
		{
			root.removeChild(container);
			container.removeChildren();
			container = null;
		}
	}
}