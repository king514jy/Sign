package signEditorUI
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import signEditorUI.conmponents.FileValuePage;
	import signEditorUI.conmponents.InputValuePage;
	import signEditorUI.conmponents.ModeValuePage;
	import signEditorUI.conmponents.NumberValuePage;
	import signEditorUI.conmponents.ValueModlueBase;
	import signEditorUI.events.MenuEvent;
	
	/**
	 * ...
	 * @author Humberger
	 */
	public class ValuePage extends Sprite 
	{
		public const selfX:uint = 981;
		public const selfY:uint = 44;
		private var backBtn:SimpleButton;
		private var exportBtn:SimpleButton;
		private var pageList:Vector.<ValueModlueBase>;
		private var numberPage:NumberValuePage;
		private var modePage:ModeValuePage;
		private var filePage:FileValuePage;
		private var inputPage:InputValuePage;
		public function ValuePage() 
		{
			pageList = new Vector.<ValueModlueBase>();
			backBtn = this.getChildByName("back_btn") as SimpleButton;
			exportBtn = this.getChildByName("export_btn") as SimpleButton;
			backBtn.addEventListener(MouseEvent.CLICK, back);
			exportBtn.addEventListener(MouseEvent.CLICK, export);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE,remove);
		}
		private function init(e:Event):void
		{
			
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
			inject(xml);
		}
		public function inject(xml:XML):void
		{
			if (xml.numValue.item.length() > 0)
			{
				numberPage = new NumberValuePage();
				this.addChild(numberPage);
				numberPage.injectXml(xml.numValue);
				pageList.push(numberPage);
			}
			if (xml.stringValue.item.length() > 0)
			{
				modePage = new ModeValuePage();
				this.addChild(modePage);
				modePage.injectXml(xml.stringValue);
				pageList.push(modePage);
			}
			if (xml.fileValue.item.length() > 0)
			{
				filePage = new FileValuePage();
				this.addChild(filePage);
				filePage.injectXml(xml.fileValue);
				pageList.push(filePage);
			}
			if (xml.inputValue.item.length() > 0)
			{
				inputPage = new InputValuePage();
				this.addChild(inputPage);
				inputPage.injectXml(xml.inputValue);
				pageList.push(inputPage);
			}
			setPoint();
		}
		private function setPoint():void
		{
			for (var i:int = 0; i < pageList.length; i++)
			{
				pageList[i].x = 25;
				pageList[i].y = 30 + i * 150;
			}
		}
		public function getConfig():XML
		{
			var xml:XML = <data></data>
			for(var i:int=0;i<pageList.length;i++)
			{
				xml.appendChild(pageList[i].getXml());
			}
			return xml;
		}
		private function back(e:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.BACK));
		}
		private function export(e:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.EXPORT));
		}
		private function remove(e:Event):void
		{
			if (numberPage)
			{
				this.removeChild(numberPage);
				numberPage = null;
			}
			if (modePage)
			{
				this.removeChild(modePage);
				modePage = null;
			}
			if (filePage)
			{
				this.removeChild(filePage);
				filePage = null;
			}
			if (inputPage)
			{
				this.removeChild(inputPage);
				inputPage = null;
			}
			pageList.length = 0;
		}
	}

}