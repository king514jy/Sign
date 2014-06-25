package signEditorUI.conmponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Humberger
	 */
	public class IpBox extends Sprite 
	{
		private var t1Txt:TextField;
		private var t2Txt:TextField;
		private var t3Txt:TextField;
		private var t4Txt:TextField;
		private var txtList:Vector.<TextField>;
		public function IpBox() 
		{
			t1Txt = this.getChildByName("t1_txt") as TextField;
			t1Txt.restrict = "0-9";
			t1Txt.maxChars = 3;
			t2Txt = this.getChildByName("t2_txt") as TextField;
			t2Txt.restrict = "0-9";
			t2Txt.maxChars = 3;
			t3Txt = this.getChildByName("t3_txt") as TextField;
			t3Txt.restrict = "0-9";
			t3Txt.maxChars = 3;
			t4Txt = this.getChildByName("t4_txt") as TextField;
			t4Txt.restrict = "0-9";
			t4Txt.maxChars = 3;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			txtList = new Vector.<TextField>();
			txtList.push(t1Txt);
			txtList.push(t2Txt);
			txtList.push(t3Txt);
			txtList.push(t4Txt);
		}
		public function set ip(str:String):void { setIp(str); }
		public function get ip():String { return getIp(); };
		private function setIp(str:String):void
		{
			var array:Array = str.split(".");
			for (var i:int = 0; i < array.length; i++)
			{
				txtList[i].text = array[i];
			}
		}
		private function getIp():String
		{
			var str:String = "";
			for (var i:int = 0; i < txtList.length; i++ )
			{
				if(i!= txtList.length-1)
					str += txtList[i].text + ".";
				else
					str += txtList[i].text;
			}
			return str;
		}
	}

}