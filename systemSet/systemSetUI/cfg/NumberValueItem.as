package systemSetUI.cfg 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import systemSetUI.cfg.components.Slider;
	import systemSetUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class NumberValueItem extends Sprite 
	{
		private var nameTxt:TextField;
		private var numTxt:TextField;
		private var slider:Slider;
		public function NumberValueItem() 
		{
			nameTxt = this.getChildByName("name_txt") as TextField;
			numTxt = this.getChildByName("num_txt") as TextField;
			slider = this.getChildByName("slider_mc") as Slider;
		}
		public function set value(n:Number):void { slider.value = n };
		public function get value():Number { return slider.value; }
		public function inject(name:String,value:Number,min:Number,max:Number,offset:Number,digital:uint):void
		{
			nameTxt.text = name;
			numTxt.text = String(value);
			slider.setNum(min, max, offset, digital);
			slider.addEventListener(ChangeDataEvent.CHANGE_NUMBER, changeValue);
		}
		private function changeValue(e:ChangeDataEvent):void
		{
			numTxt.text = String(e.numValue);
		}
	}

}