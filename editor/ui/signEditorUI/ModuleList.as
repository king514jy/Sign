package signEditorUI
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import signEditorUI.conmponents.List;
	import signEditorUI.conmponents.ListElement;
	import signEditorUI.events.MenuEvent;
	
	public class ModuleList extends Sprite
	{
		public const selfX:uint = 981;
		public const selfY:uint = 44;
		private var addBtn:SimpleButton;
		private var deleteBtn:SimpleButton;
		private var completeBtn:SimpleButton;
		private var list:List;
		public function ModuleList()
		{
			addBtn = this.getChildByName("add_btn") as SimpleButton;
			deleteBtn = this.getChildByName("delete_btn") as SimpleButton;
			completeBtn = this.getChildByName("complete_btn") as SimpleButton;
			completeBtn.visible = false;
			list = new List(248,568);
			list.x = 18;
			list.y = 49;
			this.addChild(list);
			addBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			completeBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		public function inject(strList:Vector.<String>):void
		{
			var le:uint = strList.length;
			for(var i:int = 0;i<le;i++)
			{
				addItem(strList[i]);
			}
		}
		private function clickHandle(e:MouseEvent):void
		{
			var button:SimpleButton = e.currentTarget as SimpleButton;
			switch(button)
			{
				case addBtn:
					dispatchEvent(new MenuEvent(MenuEvent.ADD));
					break;
				case deleteBtn:
					deleteUI();
					break;
				case completeBtn:
					completeDelete();
					break;
			}
		}
		private function deleteUI():void
		{
			completeBtn.visible = true;
			deleteBtn.visible = false;
			TweenLite.to(list.page,1,{x:30,ease:Quint.easeInOut});
		}
		private function completeDelete():void
		{
			completeBtn.visible = false;
			deleteBtn.visible = true;
			TweenLite.to(list.page,1,{x:0,ease:Quint.easeInOut});
		}
		private function deleteItem(e:MenuEvent):void
		{
			var el:ListElement = e.target as ListElement;
			dispatchEvent(new MenuEvent(MenuEvent.DELETE_MODULE,list.getID(el)));
		}
		public function deleteListItem(index:int):void
		{
			list.delectItemByID(index);
		}
		public function addItem(str:String):void
		{
			var listElement:ListElement = new ListElement();
			listElement.txt = str;
			list.addItem(listElement);
			listElement.addEventListener(MenuEvent.DELETE,deleteItem);
			listElement.addEventListener(MenuEvent.GOIN,enterEditor);
		}
		private function enterEditor(e:MenuEvent):void
		{
			var el:ListElement = e.target as ListElement;
			dispatchEvent(new MenuEvent(MenuEvent.ENTER_EDITOR,list.getID(el)));
		}
	}
}