package signUi
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class SignShowUICore extends Sprite
	{
		protected var bytList:Vector.<ByteArray>;
		protected var nowByt:ByteArray;
		public function SignShowUICore()
		{
			bytList = new Vector.<ByteArray>();
		}
		public function init():void
		{
			
		}
		public function injectPic(byt:ByteArray,newPic:Boolean=true):void
		{
			bytList.push(byt);
		}
		/**
		 *播放为id为传入值的交互动画 
		 * @param id 交互动画ID
		 * 
		 */		
		public function playSmallAnimation(id:int):void
		{
			
		}
	}
}