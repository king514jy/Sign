package signEditorUI.conmponents
{
	import ky.display.ScaleBitmap;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Humberger
	 */
	public class ComboBoxBtn extends Sprite 
	{
		private var bmp:ScaleBitmap;
		private var arrowA:Bitmap;
		private var arrowB:Bitmap;
		private var _selected:Boolean;
		public function ComboBoxBtn(w:uint = 165,h:uint=10 ) 
		{
			var re:Rectangle = new Rectangle(10, 0, 228, 10);
			bmp = new ScaleBitmap(new PlankBtn());
			bmp.scale9Grid = re;
			bmp.width = w;
			bmp.height = h;
			bmp.x = -bmp.width * 0.5;
			bmp.y = -bmp.height * 0.5;
			this.addChild(bmp);
			bmp.alpha = 0;
			arrowA = new Bitmap(new PlankArrowA());
			arrowA.x = -arrowA.width * 0.5;
			arrowA.y = -arrowA.height * 0.5;
			this.addChild(arrowA);
			arrowB = new Bitmap(new PlankArrowB());
			arrowB.x = -arrowB.width * 0.5;
			arrowB.y = -arrowB.height * 0.5;
		}
		public function set selected(b:Boolean):void { _selected = b; change(); }
		public function get selected():Boolean { return _selected; }
		private function change():void
		{
			if (_selected)
			{
				bmp.alpha = 1;
				this.removeChild(arrowA);
				this.addChild(arrowB);
			}
			else
			{
				bmp.alpha = 0;
				this.removeChild(arrowB);
				this.addChild(arrowA);
			}
		}
	}

}