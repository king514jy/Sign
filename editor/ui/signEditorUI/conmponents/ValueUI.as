package signEditorUI.conmponents
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Humberger
	 */
	public class ValueUI extends Sprite 
	{
		private var maskMC:MovieClip;
		private var maskOther:MovieClip;
		private var upBtn:SimpleButton;
		private var downBtn:SimpleButton;
		public var titleTxt:TextField;
		public var box:Sprite;
		private var _le:uint;
		private var count:int;
		protected var title:String;
		private var otherBox:Sprite;
		private var _other:Sprite;
		public function ValueUI() 
		{
			upBtn = this.getChildByName("up_btn") as SimpleButton;
			downBtn = this.getChildByName("down_btn") as SimpleButton;
			titleTxt = this.getChildByName("title_txt") as TextField;
			init();
		}
		public function init():void
		{
			maskMC = new PageMask();
			maskMC.y = 22;
			this.addChild(maskMC);
			maskMC.mouseEnabled = false;
			maskMC.mouseChildren = false;
			
			maskMC.alpha = 0;
			box = new Sprite();
			box.y = 22;
			this.addChild(box);
			box.mask = maskMC;
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			if (le)
				setBtn();
		}
		public function set le(u:uint):void { _le = u; setBtn(); }
		public function get le():uint { return _le };
		public function set other(spr:Sprite):void 
		{ 
			_other = spr;
			if (!otherBox)
			{
				otherBox = new Sprite();
				otherBox.addChild(spr);
				otherBox.x = 250;
				otherBox.y = 22;
				this.addChild(otherBox);
				maskOther = new MaskMc();
				maskOther.y = 22;
				maskOther.mouseEnabled = false;
				maskOther.mouseChildren = false;
				this.addChild(maskOther);
				otherBox.mask = maskOther;
			}
			else
			{
				otherBox.removeChildren();
				otherBox.addChild(spr);
			}
		}
		public function get other():Sprite { return _other; }
		private function setBtn():void
		{
			if (le > 2)
			{
				addMouseEvent();
			}
			else
			{
				downBtn.visible = false;
				upBtn.visible = false;
				removeMouseEvent();
			}
		}
		public function openMask():void
		{
			box.mask = maskMC;
		}
		public function closeMask():void
		{
			box.mask = null;
		}
		public function setLayer(spr:Sprite, layer:int):void
		{
			box.setChildIndex(spr, layer);
		}
		public function setLayerTop(spr:Sprite):void
		{
			box.setChildIndex(spr, box.numChildren - 1);
		}
		public function pick(spr:Sprite):void
		{
			var p:Number = spr.y - Math.abs(box.y);
			if (!spr.hitTestObject(maskMC))
				spr.visible = false;
			else
				spr.visible = true;
		}
		public function showOther():void
		{
			TweenLite.to(box, 1, { x:"-30", ease:Quint.easeInOut } );
			TweenLite.to(otherBox, 1, { x:0, ease:Quint.easeInOut } );
		}
		public function closeOther():void
		{
			TweenLite.to(box, 1, { x:"30", ease:Quint.easeInOut } );
			TweenLite.to(otherBox, 1, { x:250, ease:Quint.easeInOut } );
		}
		private function addMouseEvent():void
		{
			downBtn.addEventListener(MouseEvent.CLICK, downMove);
			upBtn.addEventListener(MouseEvent.CLICK, upMove);
		}
		private function removeMouseEvent():void
		{
			if (downBtn.hasEventListener(MouseEvent.CLICK))
			{
				downBtn.removeEventListener(MouseEvent.CLICK, downMove);
				upBtn.removeEventListener(MouseEvent.CLICK, upMove);
			}
		}
		private function downMove(e:MouseEvent):void
		{
			if (count < le-2)
			{
				removeMouseEvent();
				count++;
				TweenLite.to(box, 0.5, { y:"-60", onComplete:addMouseEvent } );
			}
		}
		private function upMove(e:MouseEvent):void
		{
			if (count > 0)
			{
				removeMouseEvent();
				count--;
				TweenLite.to(box, 0.5, { y:"60", onComplete:addMouseEvent } );
			}
		}
		private function removed(e:Event):void
		{
			box.removeChildren();
			removeMouseEvent();
		}
	}

}