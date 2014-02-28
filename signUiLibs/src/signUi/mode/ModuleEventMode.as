package signUi.mode
{

	public class ModuleEventMode
	{
		/**
		 * 操作端完成后，保存图片（object{picID:String,folderName:FolderNameMode,byt:ByteArray}）
		 */
		public static const SAVE_PIC:String = "save_pic";
		/**
		 * 操作端完成后，保存打印照片(object{picID:String,folderName:FolderNameMode,byt:ByteArray})
		 */
		public static const SAVE_PRINT_PIC:String = "save_print_pic";
		/**
		 * 发送图片(object{type:NetWorkEventMode.PICTURE_TRANSPORT,picID:String,byt:ByteArray})
		 */
		public static const SEND_PIC:String = "send_pic";
		/**
		 * 发送图片状态(object{type:NetWorkEventMode.PICTURE_CHANGE_STATUS,picID:String,x:Number,y:Number,rotation:Number,scale:Number})
		 */
		public static const SEND_PIC_STATUS:String = "send_pic_status";
		/**
		 * 发送图片脱离(object{type:NetWorkEventMode.PICTURE_SEPARATE,picID:String}),图片脱离后系统执行一次清理，执行模块的clear()方法;
		 */
		public static const SEND_PIC_SEPARATE:String = "send_pic_separate";
		/**
		 * 发送模块自由信息(object{type:NetWorkEventMode.MODULE_CUSTOM_INFORMATION,info:Object})
		 */
		public static const SEND_CUSTOM_INFORMATION:String = "send_custom_information";
		/**
		 * 刷新图片(object{type:NetWorkEventMode,picID:String,byt:ByteArray})
		 */
		public static const REFRESH_PIC:String = "refresh_pic";
		/**
		 * 拍照(图片从相机获取后，回注入模块)
		 */
		public static const PHOTOGRAPH:String = "photograph";
		//public static const CLEAR_MODULE:String = "clear_module";
		public function ModuleEventMode()
		{
		}
	}
}