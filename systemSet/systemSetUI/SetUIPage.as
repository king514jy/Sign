package systemSetUI
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	import systemSetUI.cfg.SetModlueConfig;
	import systemSetUI.events.SystemSetEvent;
	
	public class SetUIPage extends Sprite
	{
		private var queueList:Vector.<SetBase>;
		private var endX:uint = 512;
		private var startX:uint = 630;
		private var closeX:uint = 395;
		private var setProject:SetProject;
		private var setDirection:SetDirection;
		private var setTerminal:SetTerminal;
		private var setIP:SetIP;
		private var setTemplate:SetTemplate;
		private var nowUI:SetBase;
		private var oldIDList:Vector.<int>;
		private var backBtn:SimpleButton;
		private var templateListURL:String;
		public var storageDirectory:String;
		public function SetUIPage(templateListURL:String)
		{
			this.templateListURL = templateListURL;
			queueList = new Vector.<SetBase>();
			setProject = new SetProject();
			setDirection = new SetDirection();
			setTerminal = new SetTerminal();
			setIP = new SetIP();
			setTemplate = new SetTemplate();
			queueList.push(setProject,setDirection,setTerminal,setIP,setTemplate);
			for each(var sb:SetBase in queueList)
			{
				sb.addEventListener("goto",changeUI);
			}
			backBtn = this.getChildByName("back_btn") as SimpleButton;
			backBtn.visible = false;
			oldIDList = new Vector.<int>();
			openUI(queueList[0]);
		}
		public function set projectName(str:String):void{ setProject.projectName = str;}
		public function get projectName():String{ return setProject.projectName; }
		public function set projectPath(str:String):void{ setProject.projectPath = str; }
		public function get projectPath():String{ return setProject.projectPath;}
		public function set direction(str:String):void{ setDirection.setValue(str); }
		public function get direction():String{ return setDirection.value; }
		public function set terminal(str:String):void{ setTerminal.setValue(str); }
		public function get terminal():String{ return setTerminal.value; }
		public function set ip(str:String):void{ setIP.setValue(str); }
		public function get ip():String{ return setIP.value; }
		public function set template(str:String):void{ setTemplate.setValue(str); }
		public function get template():String{ return setTemplate.value; }
		private function openUI(sb:SetBase):void
		{
			sb.alpha = 0;
			sb.x = startX;
			sb.y = 380;
			this.addChild(sb);
			TweenLite.to(sb,1,{alpha:1,x:endX,ease:Quint.easeInOut,onComplete:runComplete,onCompleteParams:[sb]});
		}
		private function closeUI():void
		{
			oldIDList.push(queueList.indexOf(nowUI));
			TweenLite.to(nowUI,1,{alpha:0,x:closeX,ease:Quint.easeInOut});
		}
		private function runComplete(sb:SetBase):void
		{
			backBtn.addEventListener(MouseEvent.CLICK,backUI);
			if(nowUI)
			{
				nowUI.removeMouseEvent();
				this.removeChild(nowUI);
				nowUI = null;
			}
			nowUI = sb;
			nowUI.addMouseEvent();
		}
		private function changeUI(e:Event):void
		{
			var sb:SetBase = e.target as SetBase;
			if(sb.goto!=999)
			{
				if(sb.goto==4)
				{
					setTemplate.comfigAddress = templateListURL;
				}
				openUI(queueList[sb.goto]);
				closeUI();
			}
			else
			{
				dispatchEvent(new SystemSetEvent(SystemSetEvent.SET_COMPLETE));
			}
			if(!backBtn.visible)
				backBtn.visible = true;
		}
		private function backUI(e:MouseEvent):void
		{
			backBtn.removeEventListener(MouseEvent.CLICK,backUI);
			TweenLite.to(nowUI,1,{alpha:0,x:startX,ease:Quint.easeInOut});
			var sb:SetBase = queueList[oldIDList.pop()];
			sb.x = closeX;
			sb.y = 380;
			sb.alpha = 0;
			this.addChild(sb);
			TweenLite.to(sb,1,{alpha:1,x:endX,ease:Quint.easeInOut,onComplete:runComplete,onCompleteParams:[sb]});
			if(oldIDList.length<1)
				backBtn.visible = false;
		}
	}
	
}
