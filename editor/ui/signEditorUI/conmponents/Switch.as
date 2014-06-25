package signEditorUI.conmponents
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import signEditorUI.events.StatusEvent;
	/**
	 * ...
	 * @author Q·JY
	 */
	public class Switch extends Sprite 
	{
		private static const OPEN:String = "open";
		private static const CLOSE:String = "close";
		private var openMC:MovieClip;
		private var closeMC:MovieClip;
		private var aniMC:MovieClip;
		private var slider:MovieClip;
		private var status:String;
		public function Switch() 
		{
			openMC = this.getChildByName("bg_mc") as MovieClip;
			closeMC = this.getChildByName("close_mc") as MovieClip;
			aniMC = this.getChildByName("close_ani_mc") as MovieClip;
			slider = this.getChildByName("slider_mc") as MovieClip;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			openMC.alpha = 0;
			status = CLOSE;
			this.addEventListener(MouseEvent.CLICK, clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.CLICK, clickHandle);
			if (status == CLOSE)
			{
				open();
				status = OPEN;
				dispatchEvent(new StatusEvent(StatusEvent.OPEN));
			}
			else
			{
				close();
				status = CLOSE;
				dispatchEvent(new StatusEvent(StatusEvent.CLOSE));
			}
		}
		private function open():void
		{
			TweenLite.to(slider, 0.5, { x:11 } );
			TweenLite.to(aniMC, 0.5, { scaleX:0, scaleY:0 } );
			TweenLite.to(closeMC, 0.5, { alpha:0 } );
			TweenLite.to(openMC, 0.5, { alpha:1 ,onComplete:aniOnComplete} );
		}
		private function close():void
		{
			TweenLite.to(slider, 0.5, { x:0 } );
			TweenLite.to(aniMC, 0.5, { scaleX:1, scaleY:1 } );
			TweenLite.to(closeMC, 0.5, { alpha:1 } );
			TweenLite.to(openMC, 0.5, { alpha:0,onComplete:aniOnComplete } );
		}
		private function aniOnComplete():void
		{
			this.addEventListener(MouseEvent.CLICK, clickHandle);
		}
	}

}