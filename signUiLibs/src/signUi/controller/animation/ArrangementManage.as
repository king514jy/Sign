package signUi.controller.animation
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import signUi.core.IAnimation;
	import signUi.events.RenderEvent;
	
	public class ArrangementManage extends Sprite implements IAnimation
	{
		private var arrangementList:Vector.<Arrangement>;
		private var nowAr:Arrangement;
		private var _isCutover:Boolean;
		private var _holding:uint;
		private var oldTime:uint;
		private var count:int;
		private var maxLe:uint;
		public var displayList:Vector.<DisplayObject>;
		private var _isReady:Boolean;
		public function ArrangementManage(isCutover:Boolean=false,holding:uint=5)
		{
			_isCutover = isCutover;
			_holding = holding * 60 * 1000;
			arrangementList = new Vector.<Arrangement>();
			displayList = new Vector.<DisplayObject>();
		}
		public function set isCutover(b:Boolean):void{ _isCutover = b; }
		public function get isCutover():Boolean{ return _isCutover; }
		public function get holding():uint{ return _holding/1000/60; }
		public function get isReady():Boolean{ return _isReady; }
		public function addConfig(url:String):void
		{
			var a:Arrangement = new Arrangement(url);
			if(!nowAr)
			{
				nowAr = a;
				nowAr.addEventListener(RenderEvent.RENDER_COMPLETE,ready);
			}
			arrangementList.push(a);
		}
		private function ready(e:RenderEvent):void
		{
			nowAr.removeEventListener(RenderEvent.RENDER_COMPLETE,ready);
			_isReady = true;
			dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
		}
		public function addElement(display:DisplayObject):void
		{
			this.addChild(display);
			var p:Point = new Point(display.x,display.y);
			var newP:Point = this.globalToLocal(p);
			display.x = newP.x;
			display.y = newP.y;
			var vo:ArrangementVo = this.getStatus();
			/*if(vo.shadow)
			{
				TweenMax.to(display, 0.1, {dropShadowFilter:{color:0x000000, alpha:0.4, blurX:vo.blurX, blurY:vo.blurY, 
					strength:vo.strength, angle:vo.angle, distance:vo.distance}});
			}
			TweenLite.to(display,1,{x:vo.x,y:vo.y,scaleX:vo.scale,scaleY:vo.scale,rotation:vo.rotation,ease:Quint.easeInOut});*/
			TweenMax.to(display, 1, {x:vo.x,y:vo.y,scaleX:vo.scale,scaleY:vo.scale,rotation:vo.rotation,ease:Quint.easeInOut,
										dropShadowFilter:{color:0x000000, alpha:0.4, blurX:vo.blurX, blurY:vo.blurY, strength:vo.strength, 
										angle:vo.angle, distance:vo.distance}});
			if(displayList.length<nowAr.length)
			{
				displayList.push(display);
			}
			else
			{
				var index:int = nowAr.voList.indexOf(vo)
				removeElement(index);
				displayList.splice(index,1,display);
			}
		}
		private function removeElement(index:int):void
		{
			TweenLite.to(displayList[index],1,{scaleX:0,scaleY:0,ease:Quint.easeInOut,onComplete:complete,onCompleteParams:[displayList[index]]});
		}
		private function complete(display:DisplayObject):void
		{
			if(this.contains(display))
			{
				this.removeChild(display);
				display = null;
			}
		}
		public function play():void
		{
			if(arrangementList.length > 1 && _isCutover)
			{
				oldTime = getTimer();
				this.addEventListener(Event.ENTER_FRAME,run);
			}
		}
		public function stop():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME,run);
		}
		public function clear():void
		{
		}
		public function getDisplay(index:int):DisplayObject
		{
			return displayList[index];
		}
		public function getStatus():ArrangementVo
		{
			var vo:ArrangementVo;
			if(displayList.length>=nowAr.length)
				vo = nowAr.voList[Math.floor(Math.random() * nowAr.length)];
			else
				vo = nowAr.voList[displayList.length];
			return vo;
		}
		private function run(e:Event):void
		{
			if(getTimer() - oldTime >= _holding)
			{
				oldTime = getTimer();
				if(count < arrangementList.length-1)
					count++;
				else
					count = 0;
				stop();
				change();
			}
		}
		private function change():void
		{
			nowAr = arrangementList[count];
			var le:int = Math.min(displayList.length,nowAr.length);
			for(var i:int=0;i<le;i++)
			{
				/*if(nowAr.voList[i].shadow)
				{
					TweenMax.to(displayList[i], 1, {x:nowAr.voList[i].x,y:nowAr.voList[i].y,scaleX:nowAr.voList[i].scale,
						scaleY:nowAr.voList[i].scale,rotation:nowAr.voList[i].rotation,
						dropShadowFilter:{color:0x000000, alpha:0.4, blurX:nowAr.voList[i].blurX, blurY:nowAr.voList[i].blurY, 
						strength:nowAr.voList[i].strength, angle:nowAr.voList[i].angle, distance:nowAr.voList[i].distance},
						ease:Quint.easeInOut,delay:0.1*i,onComplete:play});
				}
				else
				{*/
					TweenLite.to(displayList[i],1,{x:nowAr.voList[i].x,y:nowAr.voList[i].y,scaleX:nowAr.voList[i].scale,
						scaleY:nowAr.voList[i].scale,rotation:nowAr.voList[i].rotation,delay:0.2*i,ease:Quint.easeInOut,onComplete:play});
				//}
			}
			if(nowAr.length==le)
			{
				for(var j:int = le;j<displayList.length;j++)
				{
					removeElement(j);
				}
			}
		}
	}
}