package systemSetUI
{
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import systemSetUI.cfg.components.ime.ImeUI;
	import systemSetUI.events.ChangeDataEvent;
	import systemSetUI.events.ImeEvent;
	import systemSetUI.cfg.TemporaryInputGroup;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.events.Event;

	public class SetProject extends SetBase
	{
		private var projectNameTxt:TextField;
		private var projectPathTxt:TextField;
		private var enterBtn:SimpleButton;
		private var inputBack:Sprite;
		private var imeUI:ImeUI;
		private var temporaryGroup:TemporaryInputGroup;
		private var container:DisplayObjectContainer;
		private var nowTxt:TextField;
		
		public function SetProject() 
		{
			projectNameTxt = this.getChildByName("project_name_txt") as TextField;
			projectPathTxt = this.getChildByName("project_path_txt") as TextField;
			enterBtn = this.getChildByName("enter_btn") as SimpleButton;
			projectNameTxt.addEventListener(MouseEvent.CLICK,inputInformation);
			projectPathTxt.addEventListener(MouseEvent.CLICK,selectFolder);
			enterBtn.addEventListener(MouseEvent.CLICK,enter);
			inputBack = new Sprite();
			inputBack.graphics.beginFill(0,0.6);
			inputBack.graphics.drawRect(0,0,1024,768);
			inputBack.graphics.endFill();
		}
		public function set projectPath(str:String):void{ projectPathTxt.text = str; }
		public function get projectPath():String{ return projectPathTxt.text; }
		public function set projectName(str:String):void{ projectNameTxt.text = str;}
		public function get projectName():String{ return projectNameTxt.text; }
		private function inputInformation(e:MouseEvent):void
		{
			container = this.parent;
			container.addChild(inputBack);
			imeUI = new ImeUI();
			imeUI.y = 198;
			imeUI.x = 0;
			container.addChild(imeUI);
			temporaryGroup = new TemporaryInputGroup();
			temporaryGroup.x = 164;
			temporaryGroup.y = 8;
			container.addChild(temporaryGroup);
			temporaryGroup.add(projectNameTxt.text);
			imeUI.addEventListener(ImeEvent.INPUT,imeEvent);
			imeUI.addEventListener(ImeEvent.DELETE,imeEvent);
			imeUI.addEventListener(ImeEvent.COMPLETE,imeEvent);
			TweenLite.from(inputBack,1,{alpha:0});
			TweenLite.from(temporaryGroup,1,{alpha:0});
			TweenLite.from(imeUI,1,{alpha:0});
		}
		private function imeEvent(e:ImeEvent):void
		{
			switch(e.type)
			{
				case ImeEvent.INPUT:
					temporaryGroup.add(e.value);
					break;
				case ImeEvent.DELETE:
					temporaryGroup.del();
					break;
				case ImeEvent.COMPLETE:
					container.removeChild(imeUI);
					container.removeChild(temporaryGroup);
					container.removeChild(inputBack);
					imeUI.removeEventListener(ImeEvent.INPUT,imeEvent);
					imeUI.removeEventListener(ImeEvent.DELETE,imeEvent);
					imeUI.removeEventListener(ImeEvent.COMPLETE,imeEvent);
					projectNameTxt.text = temporaryGroup.value;
					imeUI = null;
					temporaryGroup = null;
					break;
			}
		}
		private function selectFolder(e:MouseEvent):void
		{
			dispatchEvent(new ChangeDataEvent(ChangeDataEvent.SELECT_FOLDER));
		}
		private function enter(e:MouseEvent):void
		{
			goto = 1;
			dispatchEvent(new Event("goto"));
		}
	}
	
}
