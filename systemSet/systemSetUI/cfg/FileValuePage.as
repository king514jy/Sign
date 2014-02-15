package systemSetUI.cfg 
{
	/**
	 * ...
	 * @author Humberger
	 */
	public class FileValuePage extends ValueModlueBase 
	{
		private var itemList:Vector.<FileValueItem>;
		private var le:uint
		public function FileValuePage() 
		{
			itemList = new Vector.<FileValueItem>();
			//test();
		}
		private function test():void 
		{
			var xml:XML = <fileValue title="文件选择类参数测试：">
					<item name="我是文件0" tips="选择图片" extension="*.jpg;*.png"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
					<item name="我是文件1" tips="选择视频" extension="*.mp4"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
					<item name="我是文件2" tips="选择视频" extension="*.mp4"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
					<item name="我是文件3" tips="选择视频" extension="*.mp4"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
					<item name="我是文件4" tips="选择视频" extension="*.mp4"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
					<item name="我是文件5" tips="选择视频" extension="*.mp4"><![CDATA[C:\Users\jy\Desktop\LOGO10.jpg]]></item>
				  </fileValue>
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
				var item:FileValueItem = new FileValueItem();
				item.y = i * 81;
				h = item.y;
				valueUI.container.addChild(item);
				item.inject(xml.item[i].@name, xml.item[i].@tips, xml.item[i].@extension, xml.item[i]);
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
				var item:FileValueItem = new FileValueItem();
				item.y = i * 81;
				h = item.y;
				valueUI.container.addChild(item);
				item.inject(xml.item[i].@name, xml.item[i].@tips, xml.item[i].@extension, xml.item[i]);
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
				var n:String = itemList[i].name;
				var t:String = itemList[i].tips;
				var e:String = itemList[i].extension;
				var v:String = itemList[i].value;
				var xmlList:XMLList = new XMLList("<![CDATA["+v+"]]>");
				var newXML:XML = <item name={n} tips={t} extension={e}></item>;
				newXML.appendChild(xmlList);
				xml.replace(i, newXML);
			}
			return xml;
		}
	}

}