package systemSetUI.cfg
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import systemSetUI.events.ChangeDataEvent;
	
	public class SetModlueConfig extends Sprite
	{
		private var pageList:Vector.<ValueModlueBase>;
		private var numberPage:NumberValuePage;
		private var modePage:ModeValuePage;
		private var filePage:FileValuePage;
		private var inputPage:InputValuePage;
		private var pageXList:Vector.<Number>;
		private var pageYList:Vector.<Number>;
		private var saveBtn:SimpleButton;
		private var _address:String;
		public function SetModlueConfig()
		{
			pageList = new Vector.<ValueModlueBase>();
			pageXList = new Vector.<Number>();
			pageXList.push(33,529,33,529);
			pageYList = new Vector.<Number>();
			pageYList.push(100,100,388,388);
			saveBtn = this.getChildByName("save_btn") as SimpleButton;
			saveBtn.addEventListener(MouseEvent.CLICK,saveConfig);
		}
		public function set configAddress(address:String):void
		{
			_address = address;
			loadConfig();
		}
		public function get configAddress():String{ return _address; }
		private function loadConfig():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(_address));
			urlLoader.addEventListener(Event.COMPLETE,loadComplete);
		}
		private function loadComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			inject(xml);
		}
		private function inject(xml:XML):void
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
				pageList[i].x = pageXList[i];
				pageList[i].y = pageYList[i];
			}
		}
		private function saveConfig(e:MouseEvent):void
		{
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SAVE_CONFIG));
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
	}
}