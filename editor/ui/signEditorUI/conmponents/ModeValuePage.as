package signEditorUI.conmponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import signEditorUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class ModeValuePage extends ValueModlueBase 
	{
		private var itemList:Vector.<ModeValueItem>
		private var le:uint;
		public function ModeValuePage() 
		{
			itemList = new Vector.<ModeValueItem>();
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
								<item name="我是参数" value="asd1" mode="候选标签1">
									<candidate value="asd1" mode="候选标签1" />
									<candidate value="asd2" mode="候选标签2" />
									<candidate value="asd3" mode="候选标签3" />
									<candidate value="asd4" mode="候选标签4" />
									<candidate value="asd5" mode="候选标签5" />
									</item>
								<item name="我是参数" value="asd1" mode="候选标签1">
									<candidate value="asd1" mode="候选标签1" />
									<candidate value="asd2" mode="候选标签2" />
									<candidate value="asd3" mode="候选标签3" />
									<candidate value="asd4" mode="候选标签4" />
									<candidate value="asd5" mode="候选标签5" />
									<candidate value="asd5" mode="候选标签5" />
									</item>
									<item name="我是参数" value="asd1" mode="候选标签1">
									<candidate value="asd1" mode="候选标签1" />
									<candidate value="asd2" mode="候选标签2" />
									<candidate value="asd3" mode="候选标签3" />
									<candidate value="asd4" mode="候选标签4" />
									<candidate value="asd5" mode="候选标签5" />
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
			injectXml(xml.stringValue);
		}
		override public function injectXml(xml:XMLList):void 
		{
			le = xml.item.length();
			this.valueUI.le = le;
			this.xml = xml;
			this.title = xml.@title;
			for (var i:int = 0; i < le; i++ )
			{
				var item:ModeValueItem = new ModeValueItem();
				item.y = i * 60;
				this.valueUI.box.addChild(item);
				var objList:Vector.<Object> = new Vector.<Object>();
				objList.push( { label:xml.item[i].@mode, value:xml.item[i].@value } );
				for (var j:int = 0; j < xml.item[i].candidate.length(); j++ )
				{
					var obj:Object = new Object();
					obj.label = xml.item[i].candidate[j].@mode;
					obj.value = xml.item[i].candidate[j].@value;
					objList.push(obj);
				}
				item.inject(xml.item[i].@name, objList);
				itemList.push(item);
				item.addEventListener(MouseEvent.CLICK, clickItem);
				item.addEventListener(ChangeDataEvent.CHANGE, changeOver, true);
				item.addEventListener(ChangeDataEvent.CHANGE, changeOver);
			}
		}
		private function clickItem(e:MouseEvent):void
		{
			var spr:Sprite = e.currentTarget as Sprite;
			this.valueUI.closeMask();
			this.valueUI.setLayerTop(spr);
			for (var i:int = 0; i < itemList.length; i++)
			{
				this.valueUI.pick(itemList[i]);
			}
			this.parent.setChildIndex(this,this.parent.numChildren-1);
		}
		private function changeOver(e:ChangeDataEvent):void
		{
			this.valueUI.openMask();
			for (var i:int = 0; i < itemList.length; i++)
			{
				itemList[i].visible = true;
			}
		}
		override public function getXml():XMLList
		{
			for (var i:int = 0; i < le; i++ )
			{
				xml.item[i].@value = String(itemList[i].value);
				xml.item[i].@mode = itemList[i].label;
			}
			return xml;
		}
	}

}