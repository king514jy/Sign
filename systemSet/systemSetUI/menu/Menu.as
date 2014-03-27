package systemSetUI.menu
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import systemSetUI.SetUIBase;
	import systemSetUI.events.MenuEvent;

	public class Menu extends SetUIBase
	{
		private var systemBtn:MovieClip;
		private var setModuleBtn:MovieClip;
		private var lotteryBtn:MovieClip;
		private var installBtn:MovieClip;
		private var uninstallBtn:MovieClip;
		private var openLotteryBtn:MovieClip;
		private var passwordBtn:MovieClip;
		private var btnList:Vector.<MovieClip>;
		private var valueList:Vector.<String>;
		public function Menu()
		{
			btnList = new Vector.<MovieClip>();
			valueList = new Vector.<String>();
			systemBtn = this.getChildByName("system_btn") as MovieClip;
			lotteryBtn = this.getChildByName("lottery_btn") as MovieClip;
			installBtn = this.getChildByName("install_btn") as MovieClip;
			uninstallBtn = this.getChildByName("uninstall_btn") as MovieClip;
			openLotteryBtn = this.getChildByName("open_lottery_btn") as MovieClip;
			passwordBtn = this.getChildByName("password_btn") as MovieClip;
			setModuleBtn = this.getChildByName("set_module_btn") as MovieClip;
			btnList.push(systemBtn,setModuleBtn,installBtn,uninstallBtn,lotteryBtn,openLotteryBtn,passwordBtn);
			valueList.push(MenuEvent.SET_SYSTEM,MenuEvent.SET_CURRENT_MODULE,MenuEvent.INSTALL_MODULE,
							MenuEvent.UNINSTALL_MODULE,MenuEvent.SET_LOTTERY,MenuEvent.OPEN_LOTTERY,MenuEvent.CHANGE_PASSWORD);
			addMouseEvent();
		}
		private function addMouseEvent():void
		{
			for each(var mc:MovieClip in btnList)
			{
				mc.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				mc.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				mc.addEventListener(MouseEvent.CLICK,mouseClick);
			}
		}
		private function removeMouseEvent():void
		{
			for each(var mc:MovieClip in btnList)
			{
				mc.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				mc.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
				mc.removeEventListener(MouseEvent.CLICK,mouseClick);
			}
		}
		private function mouseDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(2);
		}
		private function mouseUp(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
		}
		private function mouseClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var id:int = btnList.indexOf(mc);
			dispatchEvent(new MenuEvent(valueList[id]));
		}
	}
}