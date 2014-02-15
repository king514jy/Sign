package systemSetUI.cfg 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import systemSetUI.cfg.components.ComboBox;
	import systemSetUI.cfg.components.ComboBoxOptions;
	import systemSetUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class ModeValueItem extends Sprite 
	{
		private var nameTxt:TextField;
		private var comboBox:ComboBox;
		public function ModeValueItem() 
		{
			nameTxt = this.getChildByName("name_txt") as TextField;
			comboBox = this.getChildByName("combo_mc") as ComboBox;
		}
		public function get value():String { return String(comboBox.value); }
		public function get label():String{ return comboBox.label; }
		public function inject(name:String,dataList:Vector.<Object>):void
		{
			nameTxt.text = name;
			comboBox.dataList = dataList;
		}
	}

}