package ky.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class XMLTool
	{
		private static const xmlHead:String = '<?xml version="1.0" encoding="utf-8" ?>';
		public static function writeXML(file:File,xmlStr:String,encode:Boolean=false):void
		{
			var pattern:RegExp =  /\n/g;
			xmlStr = xmlStr.replace(pattern, "\r\n");
			var endXmlStr:String;
			if(encode)
				endXmlStr = PassHandler.encryption(Base64.encode(String(xmlHead + "\r\n" + xmlStr)));
			else
				endXmlStr = String(xmlHead + "\r\n" + xmlStr);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(endXmlStr);
			fileStream.close();
		}
	}
}