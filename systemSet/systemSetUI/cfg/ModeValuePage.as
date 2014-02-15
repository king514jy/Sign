package systemSetUI.cfg 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import systemSetUI.cfg.components.ComboBox;
	import systemSetUI.cfg.components.ComboBoxOptions;
	import systemSetUI.events.ChangeDataEvent;
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
			//test();
		}
		private function test():void 
		{
			var xml:XML = <stringValue title="方式选择类测试:">
					<item name="我是参数0" value="asd0" mode="默认标签">
						<candidate value="asd1" mode="候选标签1" />
						<candidate value="asd2" mode="候选标签2" />
						<candidate value="asd3" mode="候选标签3" />
						<candidate value="asd4" mode="候选标签4" />
						<candidate value="asd5" mode="候选标签5" />
						<candidate value="asd5" mode="候选标签6" />
						<candidate value="asd5" mode="候选标签7" />
						<candidate value="asd5" mode="候选标签8" />
						<candidate value="asd5" mode="候选标签9" />
						<candidate value="asd5" mode="候选标签10" />
						<candidate value="asd5" mode="候选标签11" />
					</item>
					<item name="我是参数1" value="asd0" mode="默认标签">
						<candidate value="asd1" mode="候选标签1" />
						<candidate value="asd2" mode="候选标签2" />
					</item>
					<item name="我是参数2" value="asd0" mode="默认标签">
						<candidate value="asd1" mode="候选标签1" />
					</item>
					<item name="我是参数3" value="asd0" mode="默认标签">
						<candidate value="asd1" mode="候选标签1" />
						<candidate value="asd2" mode="候选标签2" />
						<candidate value="asd3" mode="候选标签3" />
						<candidate value="asd4" mode="候选标签4" />
						<candidate value="asd5" mode="候选标签5" />
					</item>
					<item name="我是参数4" value="asd0" mode="默认标签">
						<candidate value="asd1" mode="候选标签1" />
						<candidate value="asd2" mode="候选标签2" />
						<candidate value="asd3" mode="候选标签3" />
						<candidate value="asd4" mode="候选标签4" />
						<candidate value="asd5" mode="候选标签5" />
					</item>
				</stringValue>
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
				var item:ModeValueItem = new ModeValueItem();
				item.y = i * 81;
				h = item.y;
				this.valueUI.container.addChild(item);
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
				item.addEventListener(ChangeDataEvent.CHANGE_BEGIN,changeBegin,true);
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
				var item:ModeValueItem = new ModeValueItem();
				item.y = i * 81;
				h = item.y;
				this.valueUI.container.addChild(item);
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
				item.addEventListener(ChangeDataEvent.CHANGE_BEGIN,changeBegin,true);
			}
			valueUI.setContainerBack(h + 80);
			if (le > 3)
				valueUI.addMouseEvent();
			else
				valueUI.removeMouseEvent();
		}
		private function changeBegin(e:ChangeDataEvent):void
		{
			var comBox:ComboBox = e.target as ComboBox;
			var options:ComboBoxOptions = comBox.comboBoxOptions;
			options.x = (434-options.showArea.width) * 0.5;
			options.y = 119 - (options.showArea.height * 0.5);
			this.addChild(comBox.comboBoxOptions);
			options.addEventListener(ChangeDataEvent.CHANGE_OVER, changeOver);
			this.valueUI.removeMouseEvent();
		}
		private function changeOver(e:ChangeDataEvent):void
		{
			this.removeChild(e.target as ComboBoxOptions);
			this.valueUI.addMouseEvent();
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