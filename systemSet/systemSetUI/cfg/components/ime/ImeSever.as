package systemSetUI.cfg.components.ime 
{
	/**
	 * ...
	 * @author Q·JY
	 * 2013/6/19 15:31
	 */
	public class ImeSever 
	{
		private var dataLe:uint;
		public function ImeSever() 
		{
			dataLe = PYLib.data.length;
		}
		public function getTetterByCode(str:String):Array
        {
            var findArray:Array = new Array();
            var count:int = 0;
            findArray = [];
            while (count < dataLe)
            {
                
                if (PYLib.data[count].indexOf(str) == 0)
                {
                    findArray = findArray.concat(str2Arr(PYLib.data[count]));
                }
                count++;
            }
            return findArray;
        }
        private function str2Arr(str:String) : Array
        {
            var ar:Array = new Array();
            var reg:RegExp = null;
            ar = str.split(",");
            reg = /[a-z'']""[a-z']/g;
            ar[0] = String(ar[0]).replace(reg, "");
            return ar;
        }
	}

}