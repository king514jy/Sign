package systemSetUI.menu.template
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ky.controller.SlipVerticalGroup;
	
	import starling.core.starling_internal;
	
	import systemSetUI.core.ISetUI;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.SetUIEvent;
	
	public class InstallModuleUI extends Sprite implements ISetUI
	{
		private var installItemList:Vector.<InstallItem>;
		private var addBtn:SimpleButton;
		private var nowItem:InstallItem;
		private var itemGroup:SlipVerticalGroup;
		public function InstallModuleUI()
		{
			installItemList = new Vector.<InstallItem>();
			addBtn = this.getChildByName("add_btn") as SimpleButton;
			addBtn.addEventListener(MouseEvent.CLICK,addModule);
			itemGroup = new SlipVerticalGroup(730,410);
			itemGroup.x = 150;
			itemGroup.y = 240;
			this.addChild(itemGroup);
			itemGroup.addMouseEvent();
		}
		public function set path(str:String):void{ nowItem.pathTxt.text = str};
		public function get path():String{ return nowItem.pathTxt.text };
		public function set progress(n:Number):void{ nowItem.progressMc.gotoAndStop(n); }
		public function set info(str:String):void{ nowItem.pathTxt.text = str; }
		public function set complete(b:Boolean):void
		{
			if(b)
				nowItem.installComplete();
		}
		public function get complete():Boolean{ return nowItem.complete; }
		public function set allowInstall(b:Boolean){ nowItem.allowInstall = b; }
		public function get allowInstall():Boolean{ return nowItem.allowInstall; }
		private function addModule(e:MouseEvent):void
		{
			var installItem:InstallItem = new InstallItem();
			installItem.y = installItemList.length * 60;
			itemGroup.container.addChild(installItem);
			itemGroup.setContainerBack();
			installItemList.push(installItem);
			nowItem = installItem;
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FILE,0,"*.mt"));
			installItem.addEventListener("selectModule",handleItemEvent);
			installItem.addEventListener("installModule",handleItemEvent);
			installItem.addEventListener("deleteModule",handleItemEvent);
		}
		private function handleItemEvent(e:Event):void
		{
			var item:InstallItem = e.target as InstallItem;
			nowItem = item;
			switch(e.type)
			{
				case "selectModule":
					dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FILE,0,"*.mt"));
					break;
				case "installModule":
					dispatchEvent(new SetUIEvent(SetUIEvent.INSTALL_BEGIN));
					break;
				case "deleteModule":
					deleteItem(installItemList.indexOf(item));
					break;
			}
		}
		private function deleteItem(index:int):void
		{
			var item:InstallItem = installItemList[index];
			itemGroup.container.removeChild(item);
			item.removeEventListener("selectModule",handleItemEvent);
			item.removeEventListener("installModule",handleItemEvent);
			item.removeEventListener("deleteModule",handleItemEvent);
			item = null;
			for(var i:int=0;i<installItemList.length;i++)
			{
				if(i>index)
				{
					installItemList[i].y -= 60;
				}
			}
			installItemList.splice(index,1);
		}
	}
}