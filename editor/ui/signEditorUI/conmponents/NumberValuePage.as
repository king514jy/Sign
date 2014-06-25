package signEditorUI.conmponents
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
		private var vUI:ValueUI;
		private var le:uint
		public function NumberValuePage() 
		{
			itemList = new Vector.<NumberValueItem>();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			//test();
		}
		private function test():void 
		{
			var xml:XML = <data>
							<numValue>
								<item name="我是参数" value="5" min="0" max="10" offset="1" digital="0" />
								<item name="我是参数" value="5" min="0" max="10" offset="1" digital="0" />
								</numValue>
							<stringValue>
								<item name="我是参数" value="asd0" mode="默认标签">
									<candidate value="asd1" mode="候选标签1" />
									<candidate value="asd2" mode="候选标签2" />
									<candidate value="asd3" mode="候选标签3" />
									<candidate value="asd4" mode="候选标签4" />
									<candidate value="asd5" mode="候选标签5" />
									</item>
								<item name="我是参数" value="asd0" mode="默认标签">
									<candidate value="asd1" mode="候选标签1" />
									<candidate value="asd2" mode="候选标签2" />
									<candidate value="asd3" mode="候选标签3" />
									<candidate value="asd4" mode="候选标签4" />
									<candidate value="asd5" mode="候选标签5" />
									</item>
								</stringValue>
							<fileValue>
								<item name="我是文件" tips="选择图片" extension="*.jpg;*.png"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
								<item name="我是文件" tips="选择视频" extension="*.mp4"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
								</fileValue>
							<inputValue>
								<item name="输入文本0"><![CDATA[我是输入的文本内容！]]></item>
								<item name="输入文本1"><![CDATA[我是输入的文本内容！]]></item>
								<item name="输入文本2"><![CDATA[我是输入的文本内容！]]></item>
								<item name="输入文本3"><![CDATA[我是输入的文本内容！]]></item>
								</inputValue>
							</data>
			injectXml(xml.numValue);
			//trace(getNumberXml());
		}
		override public function injectXml(xml:XMLList):void 
		{
			le = xml.item.length();
			this.valueUI.le = le;
			this.xml = xml;
			this.title = xml.@title;
			for (var i:int = 0; i < le; i++ )
			{
				var item:NumberValueItem = new NumberValueItem();
				item.y = i * 60;
				this.valueUI.box.addChild(item);
				item.inject(xml.item[i].@name, Number(xml.item[i].@value), Number(xml.item[i].@min),
									Number(xml.item[i].@max), Number(xml.item[i].@offset), uint(xml.item[i].@digital));
				item.value = Number(xml.item[i].@value);
				itemList.push(item);
			}
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