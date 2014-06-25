package signEditorUI.conmponents
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import signEditorUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class InputValuePage extends ValueModlueBase 
	{
		private var itemList:Vector.<InputValueItem>;
		private var le:uint
		private var inputUI:InputValueUI;
		private var nowItem:InputValueItem;
		public function InputValuePage() 
		{
			itemList = new Vector.<InputValueItem>();
			inputUI = new InputValueUI();
			this.valueUI.other = inputUI;
			inputUI.addEventListener(ChangeDataEvent.CHANGE_OVER, changeOver);
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
			injectXml(xml.inputValue);
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
				var item:InputValueItem = new InputValueItem();
				item.y = i * 60;
				this.valueUI.box.addChild(item);
				item.inject(xml.item[i].@name, xml.item[i]);
				item.addEventListener(ChangeDataEvent.INPUT, input);
				itemList.push(item);
			}
		}
		private function input(e:ChangeDataEvent):void
		{
			var item:InputValueItem = e.target as InputValueItem;
			nowItem = item;
			inputUI.value = item.value;
			this.valueUI.showOther();
		}
		private function changeOver(e:ChangeDataEvent):void
		{
			nowItem.value = inputUI.value;
			this.valueUI.closeOther();
		}
		override public function getXml():XMLList
		{
			for (var i:int = 0; i < le; i++ )
			{
				var n:String = itemList[i].label;
				var v:String = itemList[i].value;
				var xmlList:XMLList = new XMLList("<![CDATA["+v+"]]>");
				var newXML:XML = <item name={n}></item>;
				newXML.appendChild(xmlList);
				xml.replace(i, newXML);
			}
			return xml;
		}
	}

}