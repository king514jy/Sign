package signUi.display
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import signUi.core.IPicBox;
	import signUi.mode.FolderNameMode;
	import signUi.mode.ModuleEventMode;
	import signUi.mode.NetWorkEventMode;

	public class PicBox extends Sprite implements IPicBox
	{
		public var informationObj:Object;
		public var picID:String;
		private var _picBmpData:BitmapData;
		public function PicBox()
		{
			
		}
		public function get picBmpData():BitmapData
		{
			drawBmpdata();
			return _picBmpData; 
		}
		public function getByt():ByteArray
		{
			var byt:ByteArray = new ByteArray();
			drawBmpdata();
			byt = _picBmpData.encode(new Rectangle(0,0,_picBmpData.width,_picBmpData.height),new JPEGEncoderOptions(100));
			return byt;
		}
		private function drawBmpdata():void
		{
			if(!_picBmpData)
				_picBmpData = new BitmapData(this.width,this.height,false);
			_picBmpData.draw(this);
		}
		public function send(type:String):void
		{
			var obj:Object = new Object();
			switch(type)
			{
				case ModuleEventMode.SAVE_PIC:
					obj.picID = this.picID;
					obj.folderName = FolderNameMode.SIGN_DISPLAY;
					obj.byt = getByt();
					informationObj = obj;
					break;
				case ModuleEventMode.SEND_PIC:
					obj.type = NetWorkEventMode.PICTURE_TRANSPORT;
					obj.picID = this.picID;
					obj.byt = getByt();
					informationObj = obj;
					break;
				case ModuleEventMode.SEND_PIC_STATUS:
					obj.type = NetWorkEventMode.PICTURE_CHANGE_STATUS;
					obj.picID = this.picID;
					obj.x = this.x;
					obj.y = this.y;
					obj.rotation = this.rotation;
					obj.scale = this.scaleX;
					informationObj = obj;
					break;
				case ModuleEventMode.REFRESH_PIC:
					obj.type = NetWorkEventMode.PICTURE_REFRESH;
					obj.picID = this.picID;
					obj.byt = getByt();
					informationObj = obj;
					break;
			}
			dispatchEvent(new Event(type));
		}
	}
}