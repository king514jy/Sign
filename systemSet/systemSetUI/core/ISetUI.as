package systemSetUI.core
{
	public interface ISetUI
	{
		function set path(str:String):void;
		function get path():String;
		function set progress(n:Number):void;
		function set complete(b:Boolean):void;
		function get complete():Boolean;
	}
}