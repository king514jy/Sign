package signUi.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.NetDataEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import signUi.mode.FolderNameMode;
	import signUi.mode.ModuleEventMode;
	import signUi.mode.NetWorkEventMode;

	public class NetworkPicGroup extends Sprite
	{
		public var id:String;
		private var _picBmpData:BitmapData;
		private var pic:Bitmap;
		public function NetworkPicGroup(id:String)
		{
			this.id = id;
		}
		public function get picBmpData():BitmapData
		{
			return _picBmpData; 
		}
		public function getByt():ByteArray
		{
			var byt:ByteArray = new ByteArray();
			if(_picBmpData)
				byt = _picBmpData.encode(new Rectangle(0,0,_picBmpData.width,_picBmpData.height),new JPEGEncoderOptions());
			return byt;
		}
		public function draw(display:DisplayObject,isAdd:Boolean=false,isCenter:Boolean=true,scale:Number=1):void
		{
			if(_picBmpData)
			{
				_picBmpData.dispose();
				_picBmpData = null;
			}
			_picBmpData = new BitmapData(display.width,display.height,false);
			var mat:Matrix = new Matrix();
			mat.scale(scale,scale);
			_picBmpData.draw(display,mat);
			if(isAdd)
			{
				if(!pic)
					pic = new Bitmap(_picBmpData,"auto",true);
				if(isCenter)
				{
					pic.x = -pic.width * 0.5;
					pic.y = -pic.height * 0.5;
				}
				this.addChild(pic);
			}
		}
		public function send(type:String,customObj:Object=null):void
		{
			var obj:Object = new Object();
			switch(type)
			{
				case ModuleEventMode.SAVE_PIC:
					obj.id = this.id;
					obj.folderName = FolderNameMode.SIGN_DISPLAY;
					obj.byt = getByt();
					break;
				case ModuleEventMode.SAVE_PRINT_PIC:
					obj.id = this.id;
					obj.folderName = FolderNameMode.SIGN_PRINT;
					obj.byt = getByt();
					break;
				case ModuleEventMode.SEND_PIC:
					obj.type = NetWorkEventMode.PICTURE_TRANSPORT;
					obj.id = this.id;
					obj.byt = getByt();
					break;
				case ModuleEventMode.SEND_PIC_SEPARATE:
					obj.type = NetWorkEventMode.PICTURE_SEPARATE;
					obj.id = this.id;
					break;
				case ModuleEventMode.SEND_PIC_STATUS:
					obj.type = NetWorkEventMode.PICTURE_CHANGE_STATUS;
					obj.id = this.id;
					obj.x = this.x;
					obj.y = this.y;
					obj.rotation = this.rotation;
					obj.scale = this.scaleX;
					break;
				case ModuleEventMode.REFRESH_PIC:
					obj.type = NetWorkEventMode.PICTURE_REFRESH;
					obj.id = this.id;
					obj.byt = getByt();
					break;
				case ModuleEventMode.SEND_CUSTOM_INFORMATION:
					obj.type = NetWorkEventMode.MODULE_CUSTOM_INFORMATION;
					obj.info = customObj;
					break;
			}
			dispatchEvent(new NetDataEvent(type,false,false,0,obj));
		}
		public function dispose():void
		{
			if(this.numChildren>1)
				this.removeChildren();
			if(_picBmpData)
				_picBmpData.dispose();
		}
	}
}