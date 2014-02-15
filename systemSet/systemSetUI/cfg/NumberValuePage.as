package systemSetUI.cfg 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author Humberger
	 */
	public class NumberValuePage extends ValueModlueBase 
	{
		private var itemList:Vector.<NumberValueItem>;
		private var le:uint
		public function NumberValuePage() 
		{
			super();
			itemList = new Vector.<NumberValueItem>();
			//test();
		}
		private function test():void 
		{
			var xml:XML = <numValue title="数字类参数测试:">
					<item name="我是参数0" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数1" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数2" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数3" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数4" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数5" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数6" value="4" min="0" max="10" offset="1" digital="0" />
					<item name="我是参数7" value="4" min="0" max="10" offset="1" digital="0" />
				</numValue>
			injectTest(xml);
			//trace(getNumberXml());
		}
		private function injectTest(xml:XML):void 
		{
			le = xml.item.length();
			this.title = xml.@title;
			var h:Number = 0;
			for (var i:int = 0; i < le; i++ )
			{
				var item:NumberValueItem = new NumberValueItem();
				item.y = i * 81;
				h = item.y;
				valueUI.container.addChild(item);
				item.inject(xml.item[i].@name, Number(xml.item[i].@value), Number(xml.item[i].@min),
									Number(xml.item[i].@max), Number(xml.item[i].@offset), uint(xml.item[i].@digital));
				item.value = Number(xml.item[i].@value);
				itemList.push(item);
			}
			valueUI.setContainerBack(h + 80);
			if (le > 3)
				valueUI.addMouseEvent();
			else
				valueUI.removeMouseEvent();
		}
		override public function injectXml(xml:XMLList):void 
		{
			le = xml.item.length();
			this.xml = xml;
			this.title = xml.@title;
			var h:Number = 0;
			for (var i:int = 0; i < le; i++ )
			{
				var item:NumberValueItem = new NumberValueItem();
				item.y = i * 81;
				h = item.y;
				valueUI.container.addChild(item);
				item.inject(xml.item[i].@name, Number(xml.item[i].@value), Number(xml.item[i].@min),
									Number(xml.item[i].@max), Number(xml.item[i].@offset), uint(xml.item[i].@digital));
				item.value = Number(xml.item[i].@value);
				itemList.push(item);
			}
			valueUI.setContainerBack(h + 80);
			if (le > 3)
				valueUI.addMouseEvent();
			else
				valueUI.removeMouseEvent();
		}
		override public function getXml():XMLList
		{
			for (var i:int = 0; i < le; i++ )
			{
				xml.item[i].@value = String(itemList[i].value);
			}
			return xml;
		}
	}

}