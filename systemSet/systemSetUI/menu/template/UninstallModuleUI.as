package systemSetUI.menu.template
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import systemSetUI.events.SetUIEvent;
	
	public class UninstallModuleUI extends Sprite
	{
		private var picBox:Sprite;
		private var nextBtn:SimpleButton;
		private var prevBtn:SimpleButton;
		private var deleteBtn:SimpleButton;
		private var path:String;
		private var templateList:Vector.<String>;
		private var nowTemplate:String;
		private var count:int;
		public function UninstallModuleUI()
		{
			picBox = this.getChildByName("pic_box_mc") as Sprite;
			nextBtn = this.getChildByName("next_btn") as SimpleButton;
			prevBtn = this.getChildByName("prev_btn") as SimpleButton;
			deleteBtn = this.getChildByName("delete_btn") as SimpleButton;
			this.addEventListener(Event.ADDED_TO_STAGE,addMouseEvent);
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(picBox.x,picBox.y);
			picBox.transform.perspectiveProjection = pp;
		}
		public function get deleteTemplate():String{ return nowTemplate; }
		public function set deleteComplete(b:Boolean):void
		{ 
			if(b)
			{
				count=0;
				disappear();
			}
		}
		public function init(path:String,templateList:Vector.<String>):void
		{
			this.path = path;
			this.templateList = templateList;
			loadPic();
		}
		private function addMouseEvent(e:Event=null):void
		{
			nextBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			prevBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function removeMouseEvent(e:Event=null):void
		{
			nextBtn.removeEventListener(MouseEvent.CLICK,clickHandle);
			prevBtn.addEventListener(MouseEvent.CLICK,clickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			removeMouseEvent();
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			switch(btn)
			{
				case nextBtn:
					nextPic();
					break;
				case prevBtn:
					prevPic();
					break;
				case deleteBtn:
					deletePic();
					break;
			}
		}
		private function loadPic():void
		{
			if(count==0)
				deleteBtn.visible = false;
			else
				deleteBtn.visible = true;
			picBox.rotationY = -90;
			var loader:Loader = new Loader();
			var url:String = path+templateList[count]+"/legend.jpg";
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
		}
		private function loadComplete(e:Event):void
		{
			nowTemplate = templateList[count];
			var loader:Loader = LoaderInfo(e.target).loader;
			var bmp:Bitmap = loader.content as Bitmap;
			bmp.x = -bmp.width * 0.5;
			bmp.y = -bmp.height * 0.5;
			picBox.addChild(bmp);
			TweenLite.to(picBox,1,{rotationY:0,ease:Quint.easeInOut});
			addMouseEvent();
		}
		private function nextPic():void
		{
			if(!prevBtn.visible)
				prevBtn.visible = true;
			count++;
			if(count<=templateList.length-1)
			{
				disappear();
				if(count==templateList.length-1)
					nextBtn.visible = false;
			}
		}
		private function prevPic():void
		{
			if(!nextBtn.visible)
				nextBtn.visible = true;
			count--;
			if(count>=0)
			{
				disappear();
				if(count==0)
					prevBtn.visible = false;
			}
			
		}
		private function disappear():void
		{
			TweenLite.to(picBox,1,{rotationY:90,ease:Quint.easeInOut,onComplete:loadPic});
		}
		private function deletePic():void
		{
			dispatchEvent(new SetUIEvent(SetUIEvent.UNINSTALL_BEGIN));
		}
	}
}