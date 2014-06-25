package systemSetUI.menu.template
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class InstallItem extends Sprite
	{
		public var progressMc:MovieClip;
		public var pathTxt:TextField;
		private var installMc:MovieClip;
		private var deleteMc:MovieClip;
		public var complete:Boolean;
		public function InstallItem()
		{
			progressMc = this.getChildByName("progress_mc") as MovieClip;
			pathTxt = this.getChildByName("path_txt") as TextField;
			installMc = this.getChildByName("install_mc") as MovieClip;
			deleteMc = this.getChildByName("delete_mc") as MovieClip;
			
			pathTxt.addEventListener(MouseEvent.CLICK,clickTxt);
			installMc.addEventListener(MouseEvent.CLICK,clickInstall);
			deleteMc.addEventListener(MouseEvent.CLICK,clickDelete);
		}
		public function set allowInstall(b:Boolean):void
		{
			if(b)
			{
				installMc.addEventListener(MouseEvent.CLICK,clickInstall);
			}
			else
			{
				if(installMc.hasEventListener(MouseEvent.CLICK))
					installMc.removeEventListener(MouseEvent.CLICK,clickInstall);
			}
		}
		public function get allowInstall():Boolean
		{
			return installMc.hasEventListener(MouseEvent.CLICK);
		}
		private function clickTxt(e:MouseEvent):void
		{
			if(installMc.currentFrame==1)
				dispatchEvent(new Event("selectModule"));
		}
		private function clickInstall(e:MouseEvent):void
		{
			if(installMc.currentFrame==1)
			{
				dispatchEvent(new Event("installModule"));
				installMc.removeEventListener(MouseEvent.CLICK,clickInstall);
			}
		}
		private function clickDelete(e:MouseEvent):void
		{
			dispatchEvent(new Event("deleteModule"));
		}
		public function installComplete():void
		{
			complete = true;
			this.installMc.gotoAndStop(2);
			this.pathTxt.textColor = 0xffffff;
			progressMc.gotoAndStop(100);
			deleteMc.visible = false;
			pathTxt.text = "安装完成";
		}
	}
}