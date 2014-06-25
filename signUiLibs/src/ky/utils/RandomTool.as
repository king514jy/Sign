package ky.utils
{
	public class RandomTool
	{
		public static function selectList(length:uint,amount:uint):Vector.<uint>
		{
			var indexList:Vector.<uint> = new Vector.<uint>();
			if(length < amount)
			{
				throw new Error("目标长度大于列表长度");
			}
			else
			{
				var b:Boolean;
				var i:int;
				while(i<amount)
				{
					b=true;
					var index:int = Math.floor(Math.random() * length);
					for(var j:int=0;j<indexList.length;j++)
					{
						if(index==indexList[j])
						{
							b=false;
						}
					}
					if(b)
					{
						indexList.push(index);
						i++;
					}
				}
			}
			return indexList;
		}
	}
}