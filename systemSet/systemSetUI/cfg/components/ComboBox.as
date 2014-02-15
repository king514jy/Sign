package systemSetUI.cfg.components 
{
	import com.kingclass.utils.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import systemSetUI.events.ChangeDataEvent;
	
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
		public function ComboBox(w:uint=303,h:uint=36) 
		{
			this.w = w;
			this.h = h;
			re = new Rectangle(5, 5, 278, 28);
			bmp = new ScaleBitmap(new ComboBoxFrame());
			bmp.scale9Grid = re;
			bmp.width = w;
			bmp.height = h;
			this.addChild(bmp);
			textField = new TextField();
			var tf:TextFormat = new TextFormat("_sans", 20, 0x2b2b2b);
			textField.defaultTextFormat = tf;
			textField.x = re.x;
			textField.y = re.y;
			textField.width = re.width;
			textField.height = h;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.selectable = false;
			this.addChild(textField);
			_dataList = new Vector.<Object>();
			this.addEventListener(MouseEvent.CLICK, clickHnadle);
		}
		public function set dataList(list:Vector.<Object>):void { _dataList = list; setData(); }
		public function get dataList():Vector.<Object> { return _dataList };
		public function get value():Object { return _dataList[nowID].value };
		public function get label():String{ return _dataList[nowID].label };
		public function set enabled(b:Boolean):void { _enabled = b; setEnable(); }
		public function get enabled():Boolean { return _enabled; }
		public function get comboBoxOptions():ComboBoxOptions { return options; }
		private function setData():void
		{
			textField.text = _dataList[0].label;
			nowID = 0;
			var hh:Number;
			if (_dataList.length < 7)
				hh = (_dataList.length-1) * 36 + 16;//加的20为上下两端多出的部分
			else
				hh = 268;
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
			options.addEventListener(ChangeDataEvent.CHANGE_OVER, changeValueOver);
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE_BEGIN));
		}
		private function changeValue(e:ChangeDataEvent):void
		{
			nowID = options.id;
			textField.text = _dataList[nowID].label;
		}
		private function changeValueOver(e:ChangeDataEvent):void
		{
			if (this.contains(options))
				this.removeChild(options);
		}
	}

}