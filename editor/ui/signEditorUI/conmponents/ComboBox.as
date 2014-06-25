package signEditorUI.conmponents
{
	import ky.display.ScaleBitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import signEditorUI.events.ChangeDataEvent;
	/**
	 * ...
	 * @author Humberger
	 */
	public class ComboBox extends Sprite 
	{
		private var bmp:ScaleBitmap;
		private var textField:TextField;
		private var _txt:String;
		private var _dataList:Vector.<Object>;
		private var nowID:int;
		private var options:ComboBoxOptions;
		private var w:uint;
		private var h:uint;
		private var re:Rectangle
		private var _enabled:Boolean = true;
		public function ComboBox(w:uint=165,h:uint=21) 
		{
			this.w = w;
			this.h = h;
			re = new Rectangle(5, 4, 148, 11);
			bmp = new ScaleBitmap(new ComboBoxFrame());
			bmp.scale9Grid = re;
			bmp.width = w;
			bmp.height = h;
			this.addChild(bmp);
			textField = new TextField();
			var tf:TextFormat = new TextFormat("_sans", 12, 0x2b2b2b);
			textField.defaultTextFormat = tf;
			textField.x = re.x;
			textField.y = re.y-2;
			textField.width = re.width;
			textField.height = h;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.selectable = false;
			this.addChild(textField);
			_dataList = new Vector.<Object>();
			this.addEventListener(MouseEvent.CLICK, clickHnadle);
			//test();
		}
		public function set dataList(list:Vector.<Object>):void { _dataList = list; setData(); }
		public function get dataList():Vector.<Object> { return _dataList };
		public function get value():Object { return _dataList[nowID].value };
		public function get label():String{ return _dataList[nowID].label };
		public function set enabled(b:Boolean):void { _enabled = b; setEnable(); }
		public function get enabled():Boolean { return _enabled; }
		private function test():void
		{
			for (var i:int = 0; i < 14; i++ )
			{
				_dataList.push( { label:"我日" + i, value:i } );
			}
			setData();
		}
		private function setData():void
		{
			textField.text = _dataList[0].label;
			nowID = 0;
			var hh:Number;
			if (_dataList.length < 9)
				hh = (_dataList.length-1) * 20 + 20;//加的20为上下两端多出的部分
			else
				hh = 200;
			if (options)
				options = null;
			options = new ComboBoxOptions(w, hh);
			options.y = -hh * 0.5;
			for each(var obj:Object in _dataList)
			{
				if(obj!=_dataList[0])
					options.addItem(obj.label);
			}
		}
		private function setEnable():void
		{
			if (_enabled)
			{
				this.addEventListener(MouseEvent.CLICK, clickHnadle);
				this.alpha = 1;
			}
			else
			{
				this.removeEventListener(MouseEvent.CLICK, clickHnadle);
				this.alpha = 0.3;
			}
		}
		private function clickHnadle(e:MouseEvent):void
		{
			if(options)
				this.addChild(options);
			options.addEventListener(ChangeDataEvent.CHANGE, changeValue);
		}
		private function changeValue(e:ChangeDataEvent):void
		{
			if (this.contains(options))
				this.removeChild(options);
			nowID = options.id;
			textField.text = _dataList[nowID].label;
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE_OVER));
		}
	}

}