package signUi.tools
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	
	import signUi.core.ActionBase;
	
	public class CameraGroup extends ActionBase
	{
		private var captureWidth:uint;
		private var captureHeight:uint;
		private var videoWidth:uint;
		private var videoHeight:uint;
		private var camerFrame:uint
		private var _camera:Camera;
		private var _video:Video;
		public function CameraGroup(captureWidth:uint,captureHeight:uint,videoWidth:uint,videoHeight:uint,camerFrame:uint)
		{
			this.captureWidth = captureWidth;
			this.captureHeight = captureHeight;
			this.videoWidth = videoWidth;
			this.videoHeight = videoHeight;
			this.camerFrame = camerFrame;
			init();
		}
		public function get video():Video{ return _video; }
		public function get camera():Camera{ return _camera; }
		private function init():void
		{
			_camera = Camera.getCamera();
			_camera.setMode(captureWidth,captureHeight,camerFrame);
			_camera.setQuality(0,100);
			_video = new Video(videoWidth,videoHeight);
			_video.attachCamera(_camera);
			this.addChild(_video);
		}
		public function photographByDraw():BitmapData
		{
			var bmpData:BitmapData = new BitmapData(captureWidth,captureHeight,false);
			_camera.drawToBitmapData(bmpData);
			return bmpData;
		}
		public function photographByCopyByt():BitmapData
		{
			var bmpData:BitmapData = new BitmapData(captureWidth,captureHeight,false);
			var rect:Rectangle = new Rectangle(0,0,captureWidth,captureHeight);
			var byt:ByteArray = new ByteArray();
			_camera.copyToByteArray(rect,byt);
			byt.position = 0;
			bmpData.setPixels(rect,byt);
			return bmpData;
		}
		public function drawVideo():BitmapData
		{
			var jpgData:BitmapData = new BitmapData(videoWidth, videoHeight);//定义截图数据的宽高
			var myMatrix:Matrix = new Matrix();//像素矩阵
			//myMatrix.scale(matrixA,matrixD);//缩放,video的实际窗口比看到的小，看到的是放大后的，将截取的图像放大相应倍数，就跟实际看到的一样了
			var scaleA:Number = videoWidth / 320;
			var scaleB:Number = videoHeight / 240;
			myMatrix.scale(scaleA, scaleB);//默认的视频窗口是320*240，视频窗口的设置 是直接缩放默认视频窗口
			jpgData.draw(_video,myMatrix);//绘制数据
			return jpgData;
		}
		public function closeCamera():void
		{
			video.clear();
			_camera = Camera.getCamera(null);
			_camera = null;
			video.attachCamera(null);
			this.removeChild(video)
		}
		public function openCamera():void
		{
			_camera = Camera.getCamera();
			_camera.setMode(captureWidth, captureHeight, camerFrame);
			video.attachCamera(_camera);
			this.addChild(video);
		}
	}
}