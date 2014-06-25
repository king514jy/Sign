package systemSetUI
{
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import flash.events.MouseEvent;

	public class SetTemplate extends SetBase
	{
		private var _comfigAddress:String;
		private var titleTxt:TextField;
		private var preBtn:SimpleButton;
		private var nextBtn:SimpleButton;
		private var selectBtn:SimpleButton;
		private var codingList:Vector.<String>;
		private var hasConfigList:Vector.<Boolean>;
		private var folder:String;
		private var status:String = "next";
		private var count:int;
		private var nowBmp:Bitmap;
		public function SetTemplate()
		{
			titleTxt = this.getChildByName("title_txt") as TextField;
			preBtn = this.getChildByName("pre_btn") as SimpleButton;
			nextBtn = this.getChildByName("next_btn") as SimpleButton;
			selectBtn = this.getChildByName("select_btn") as SimpleButton;
			this.mask = mask_mc;
			codingList = new Vector.<String>();
			nextBtn.addEventListener(MouseEvent.CLICK,clickChange);
			preBtn.addEventListener(MouseEvent.CLICK,clickChange);
			selectBtn.addEventListener(MouseEvent.CLICK,selectTemplate);
		}
		public function set comfigAddress(str:String):void
		{
			if(str!=_comfigAddress)
			{
				_comfigAddress = str;
				setSelf();
			}
		}
		public function get comfigAddress():String{ return _comfigAddress;}
		private function setSelf():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(_comfigAddress));
			urlLoader.addEventListener(Event.COMPLETE,loadComplete);
		}
		private function loadComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var xml:XML = XML(urlLoader.data);
			folder = String(xml.address.@folder);
			var le:uint = xml.template.length();
			for(var i:int=0;i<le;i++)
			{
				codingList.push(xml.template[i].@coding);
			}
			urlLoader.removeEventListener(Event.COMPLETE,loadComplete);
			urlLoader = null;
			if(codingList.length<2)
			{
				preBtn.visible = false;
				nextBtn.visible = false;
			}
			loadPic();
		}
		private function loadPic():void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(folder+codingList[count]+"/legend.jpg"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadPicComplete);
		}
		private function loadPicComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			var bmp:Bitmap = loader.content as Bitmap;
			var closeX:Number;
			if(status == "next")
				closeX = (-512)-1024;
			else
				closeX = (-512)+1024;
			bmp.x = -closeX;
			bmp.y = -297;
			this.addChild(bmp);
			TweenLite.to(bmp,1,{x:-512,ease:Quint.easeInOut,onComplete:setNow,onCompleteParams:[bmp]});
			if(nowBmp)
				TweenLite.to(nowBmp,1,{x:closeX,ease:Quint.easeInOut});
		}		
		private function setNow(bmp:Bitmap):void
		{
			if(nowBmp)
			{
				this.removeChild(nowBmp);
				nowBmp.bitmapData.dispose();
				nowBmp = null;
			}
			nowBmp = bmp;
		}
		private function clickChange(e:MouseEvent):void
		{
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			if(btn == nextBtn)
			{
				if(!preBtn.visible)
					preBtn.visible = true;
				if(count<codingList.length-1)
				{
					count++;
					if(count==codingList.length-1)
						nextBtn.visible = false;
				}
			}
			else
			{
				if(!nextBtn.visible)
					nextBtn.visible = true;
				if(count>0)
				{
					count--;
					if(count==0)
						preBtn.visible = false;
				}
			}
			loadPic();
		}
		private function selectTemplate(e:MouseEvent):void
		{
			value = codingList[count];
			goto = 999;
			dispatchEvent(new Event("goto"));
		}
		override public function setValue(str:String):void
		{
			count = int(str);
		}
	}
	
}
