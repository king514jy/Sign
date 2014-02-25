package signUi.mode
{

	public class ModuleEventMode
	{
		/**
		 * 操作端完成后，保存图片（object{picID:String,folderName:FolderNameMode,byt:ByteArray}）
		 */
		public static const SAVE_PIC:String = "save_pic";
		/**
		 * 发送图片信息(object{type:NetWorkEventMode,picID:String,byt:ByteArray})
		 */
		public static const SEND_PIC:String = "send_pic";
		/**
		 * 发送图片状态(object{type:NetWorkEventMode,picID:String,x:Number,y:Number,rotation:Number,scale:Number})
		 */
		public static const SEND_PIC_STATUS:String = "send_pic_status";
		/**
		 * 刷新图片(object{type:NetWorkEventMode,picID:String,byt:ByteArray})
		 */
		public static const REFRESH_PIC:String = "refresh_pic";
		/**
		 * 拍照(图片从相机获取后，回注入模块)
		 */
		public static const PHOTOGRAPH:String = "photograph";
		public function ModuleEventMode()
		{
		}
	}
}