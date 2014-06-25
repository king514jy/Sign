package ky.utils
 {  
    public class PassHandler
	{   
		
        public function PassHandler()
		{   
            throw new Error("PassHandler class is static container only");   
        }   
		/**
		 * 加密
		 */
		public static function encryption(str:String):String
		{
			var vc:Array = new Array(3,1,2,4,0);
			var newStr:String;
			var s0:String = str.slice(0,10);
			var s1:String = str.slice(10,15);
			var s2:String = str.slice(15);
			var s3:String="QINBABA";
			for(var qin:int;qin<5;qin++)
			{
				var ss:String = s1.charAt(vc[qin]);
				s3=s3+ss;
			}
			
			newStr = s0+s3+s2;
			return newStr;
		}
		/**
		 * 解密
		 */
		public static function decryption(str:String):String
		{
			var vc:Array = new Array(4,1,2,0,3);
			var newStr:String;
			var s0:String = str.slice(0,10);
			var s1:String = str.substr(17,5);
			var s2:String = str.slice(22); 
			var s3:String="";
			for(var qin:int;qin<5;qin++)
			{
				var ss:String = s1.charAt(vc[qin]);
				s3=s3+ss;
			}
			newStr = s0+s3+s2;
			return newStr;
		}
    }   
}  