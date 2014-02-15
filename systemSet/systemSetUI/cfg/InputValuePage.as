package systemSetUI.cfg
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import systemSetUI.cfg.components.ime.ImeUI;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.ImeEvent;
	
	public class InputValuePage extends ValueModlueBase
	{
		private var itemList:Vector.<InputValueItem>;
		private var le:uint
		private var imeUI:ImeUI;
		private var temporaryGroup:TemporaryInputGroup;
		private var container:DisplayObjectContainer;
		private var nowItem:InputValueItem;
		private var inputBack:Sprite;
		public function InputValuePage()
		{
			itemList = new Vector.<InputValueItem>();
			inputBack = new Sprite();
			inputBack.graphics.beginFill(0,0.6);
			inputBack.graphics.drawRect(0,0,1024,768);
			inputBack.graphics.endFill();
			//test();
		}
		private function test():void 
		{
			var xml:XML = <inputValue title="文本类参数测试:">
					<item name="输入标语："><![CDATA[我日]]></item>
					<item name="输入文本1"><![CDATA[我晕]]></item>
					<item name="输入文本2"><![CDATA[卧槽]]></item>
					<item name="输入文本3"><![CDATA[SHIT]]></item>
				</inputValue>
			injectTest(xml);
		}
		private function injectTest(xml:XML):void
		{
			le = xml.item.length();
			this.title = xml.@title;
			var h:Number = 0;
			for (var i:int = 0; i < le; i++ )
			{
				var item:InputValueItem = new InputValueItem();
				item.y = i * 81;
				h = item.y;
				valueUI.container.addChild(item);
				item.inject(xml.item[i].@name, xml.item[i]);
				item.addEventListener(ChangeDataEvent.INPUT, input);
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
				var item:InputValueItem = new InputValueItem();
				item.y = i * 81;
				h = item.y;
				valueUI.container.addChild(item);
				item.inject(xml.item[i].@name, xml.item[i]);
				item.addEventListener(ChangeDataEvent.INPUT, input);
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
				var n:String = itemList[i].label;
				var v:String = itemList[i].value;
				var xmlList:XMLList = new XMLList("<![CDATA["+v+"]]>");
				var newXML:XML = <item name={n}></item>;
				newXML.appendChild(xmlList);
				xml.replace(i, newXML);
			}
			return xml;
		}
		private function input(e:ChangeDataEvent):void
		{
			nowItem = e.target as InputValueItem;
			container = this.parent;
			container.addChild(inputBack);
			imeUI = new ImeUI();
			imeUI.y = 198;
			container.addChild(imeUI);
			temporaryGroup = new TemporaryInputGroup();
			temporaryGroup.x = 164;
			temporaryGroup.y = 8;
			container.addChild(temporaryGroup);
			temporaryGroup.add(nowItem.value);
			imeUI.addEventListener(ImeEvent.INPUT,imeEvent);
			imeUI.addEventListener(ImeEvent.DELETE,imeEvent);
			imeUI.addEventListener(ImeEvent.COMPLETE,imeEvent);
			TweenLite.from(inputBack,1,{alpha:0});
			TweenLite.from(temporaryGroup,1,{alpha:0});
			TweenLite.from(imeUI,1,{alpha:0});
		}
		private function imeEvent(e:ImeEvent):void
		{
			switch(e.type)
			{
				case ImeEvent.INPUT:
					temporaryGroup.add(e.value);
					break;
				case ImeEvent.DELETE:
					temporaryGroup.del();
					break;
				case ImeEvent.COMPLETE:
					container.removeChild(imeUI);
					container.removeChild(temporaryGroup);
					container.removeChild(inputBack);
					imeUI.removeEventListener(ImeEvent.INPUT,imeEvent);
					imeUI.removeEventListener(ImeEvent.DELETE,imeEvent);
					imeUI.removeEventListener(ImeEvent.COMPLETE,imeEvent);
					nowItem.value = temporaryGroup.value;
					imeUI = null;
					temporaryGroup = null;
					break;
			}
		}
	}
}