package ky.utils
{
	import com.google.zxing.BarcodeFormat;
	import com.google.zxing.EncodeHintType;
	import com.google.zxing.common.BitMatrix;
	import com.google.zxing.common.flexdatatypes.HashTable;
	import com.google.zxing.qrcode.QRCodeWriter;
	import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class QRCode
	{
		/**
		 *生成二维码 
		 * @param content 内容
		 * @param parameter 二维码的参数
		 * @param logo logo图
		 * @return 二维码图片
		 * 
		 */
		public static function write(content:String,parameter:QRCodeParameter,logo:BitmapData = null):Bitmap
		{
			var w:uint = parameter.w;
			var h:uint = parameter.h;
			var re:Rectangle;
			if(logo)
				re = new Rectangle((w-logo.width)*0.5,(h-logo.height)*0.5,logo.width,logo.height);
			var hst:HashTable = new HashTable();
			hst.Add(EncodeHintType.ERROR_CORRECTION,ErrorCorrectionLevel.Q);
			hst.Add(EncodeHintType.CHARACTER_SET,"UTF-8");
			var qw:QRCodeWriter = new QRCodeWriter();
			QRCodeWriter.QUIET_ZONE_SIZE = parameter.frame;
			var bitM:BitMatrix = qw.encode(content,BarcodeFormat.QR_CODE,w,h,hst) as BitMatrix;
			var bmpData:BitmapData = new BitmapData(w,h,parameter.transparent,0xffffff);
			bmpData.lock();
			for(var i:int = 0;i<w;i++)
			{
				for(var j:int=0;j<h;j++)
				{
					if(bitM._get(j,i))
					{
						if(logo)
						{
							if(!re.contains(j,i))
							{
								bmpData.setPixel32(j,i,parameter.color);
							}
						}
						else
						{
							bmpData.setPixel32(j,i,parameter.color);
						}
					}
				}
			}
			bmpData.unlock();
			var bmp:Bitmap = new Bitmap(bmpData);
			var qrBmp:Bitmap = new Bitmap();
			if(logo)
			{
				var spr:Sprite = new Sprite();
				var logoBmp:Bitmap = new Bitmap(logo);
				spr.addChild(bmp);
				logoBmp.x = (w-logo.width) * 0.5;
				logoBmp.y = (h-logo.height) * 0.5;
				spr.addChild(logoBmp);
				var qrBd:BitmapData = new BitmapData(w,h,parameter.transparent,0xffffff);
				qrBd.draw(spr);
				qrBmp.bitmapData = qrBd;
			}
			else
			{
				qrBmp.bitmapData = bmp.bitmapData;
			}
			return qrBmp;
		}
	}
}