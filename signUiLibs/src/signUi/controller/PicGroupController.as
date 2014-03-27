package signUi.controller
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import signUi.display.PicGroup;
	
	public class PicGroupController extends EventDispatcher
	{
		private var _picList:Vector.<PicGroup>;
		public function PicGroupController()
		{
			super();
			_picList = new Vector.<PicGroup>();
		}
		public function get picList():Vector.<PicGroup>{ return _picList; }
		public function addPicURL(url:String):void
		{
			var picGroup:PicGroup = new PicGroup();
			picGroup.loadURL(url);
			_picList.push(picGroup);
		}
		public function addPicByt(byt:ByteArray):void
		{
			var picGroup:PicGroup = new PicGroup();
			picGroup.loadByt(byt);
		}
		public function draw(display:DisplayObject,mt:Matrix=null,transparent:Boolean=false):void
		{
			var picGroup:PicGroup = new PicGroup();
			picGroup.draw(display,mt,transparent);
		}
		public function getPicGroup(index:int):PicGroup
		{
			return _picList[index];
		}
		public function checkComplete():Boolean
		{
			var b:Boolean = true;
			for each(var pic:PicGroup in _picList)
			{
				if(!pic.complete)
				{
					b = false;
					break;
				}
			}
			return b;
		}
	}
}