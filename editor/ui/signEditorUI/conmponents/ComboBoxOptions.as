package signEditorUI.conmponents
{
	import flash.display.Sprite;
	import ky.display.ScaleBitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import signEditorUI.events.ChangeDataEvent;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author Humberger
	 */
	public class ComboBoxOptions extends Sprite 
	{
		private var bmp:ScaleBitmap;
		private var _id:int;
		private var oldTime:int;
		private var box:Sprite;
		private var itemList:Vector.<ComboBoxItem>;
		private var nowItem:ComboBoxItem;
		private var cBtnDown:ComboBoxBtn;
		private var cBtnUp:ComboBoxBtn;
		private var w:uint;
		private var h:uint;
		private var maskSpr:Sprite;
		public function ComboBoxOptions(w:uint=165,h:uint=200) 
		{
			this.w = w;
			this.h = h;
			var re:Rectangle = new Rectangle(10, 10, 228, 69);
			bmp = new ScaleBitmap(new Plank());
			bmp.scale9Grid = re;
			bmp.width = w;
			bmp.height = h;
			this.addChild(bmp);
			box = new Sprite();
			box.y = 10;
			this.addChild(box);
			maskSpr = new Sprite();
			maskSpr.graphics.beginFill(0, 0.5);
			maskSpr.graphics.drawRect(0,0, 165,180);
			maskSpr.graphics.endFill();
			maskSpr.y = 10;
			this.addChild(maskSpr);
			box.mask = maskSpr;
			itemList = new Vector.<ComboBoxItem>();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function get id():int { return itemList.indexOf(nowItem)+1; };
		public function init(e:Event=null):void
		{
			oldTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, run);
			
		}
		private function run(e:Event):void
		{
			if (getTimer() - oldTime >= 200)
			{
				this.removeEventListener(Event.ENTER_FRAME, run);
				stage.addEventListener(MouseEvent.CLICK, clickStage);
			}
		}
		private function clickStage(e:MouseEvent):void
		{
			for each(var item:ComboBoxItem in itemList)
			{
				if (item.selected && item != nowItem)
				{
					nowItem.selected = false;
					nowItem = item;
				}
			}
			stage.removeEventListener(MouseEvent.CLICK, clickStage);
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.CHANGE));
		}
		public function addItem(str:String):void
		{
			var item:ComboBoxItem = new ComboBoxItem();
			box.addChild(item);
			item.y = itemList.length * 20;
			item.text = str;
			itemList.push(item);
			if (!nowItem)
			{
				nowItem = item;
				nowItem.selected = true;
			}
			judge();
		}
		private function judge():void
		{
			if (box.height > maskSpr.height)
			{
				if (!cBtnDown)
				{
					cBtnDown = new ComboBoxBtn(w);
					cBtnDown.y = bmp.height - cBtnDown.height * 0.5;
					cBtnDown.x = bmp.width * 0.5;
					this.addChild(cBtnDown);
					cBtnDown.addEventListener(MouseEvent.ROLL_OVER, rollOver);
					cBtnDown.addEventListener(MouseEvent.ROLL_OUT, rollOut);
					cBtnDown.addEventListener(MouseEvent.CLICK, clickHandle);
					cBtnUp = new ComboBoxBtn(w);
					cBtnUp.y = cBtnUp.height * 0.5;
					cBtnUp.x = bmp.width * 0.5;
					cBtnUp.addEventListener(MouseEvent.ROLL_OVER, rollOver);
					cBtnUp.addEventListener(MouseEvent.ROLL_OUT, rollOut);
					cBtnUp.addEventListener(MouseEvent.CLICK, clickHandle);
					cBtnUp.rotation = 180;
				}
			}
		}
		private function rollOver(e:MouseEvent):void
		{
			var btn:ComboBoxBtn = e.currentTarget as ComboBoxBtn;
			btn.selected = true;
			stage.removeEventListener(MouseEvent.CLICK, clickStage);
		}
		private function rollOut(e:MouseEvent):void
		{
			var btn:ComboBoxBtn = e.currentTarget as ComboBoxBtn;
			btn.selected = false;
			stage.addEventListener(MouseEvent.CLICK, clickStage);
		}
		private function clickHandle(e:MouseEvent):void
		{
			var btn:ComboBoxBtn = e.currentTarget as ComboBoxBtn;
			if (btn == cBtnDown)
				moveUp();
			else
				moveDown();
				
		}
		private function moveUp():void
		{
			var yy:Number;
			var dis:Number = (box.y + box.height) - (maskSpr.x + maskSpr.height);
			if (dis > 0)
			{
				if (dis >= nowItem.height)
					yy = box.y - nowItem.height;
				else
					yy = maskSpr.x + maskSpr.height-box.height;
				TweenLite.to(box, 0.5, { y:yy } );
			}
			if (!this.contains(cBtnUp))
				this.addChild(cBtnUp);
		}
		private function moveDown():void
		{
			var yy:Number
			if (box.y < maskSpr.y)
			{
				if (box.y <= maskSpr.y - nowItem.height)
					yy = box.y + nowItem.height;
				else
				{
					yy = maskSpr.y;
					this.removeChild(cBtnUp)
				}
				TweenLite.to(box, 0.5, { y:yy } );
			}
		}
	}

}