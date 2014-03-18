package signUi.core
{
	import flash.display.DisplayObject;

	public interface IAnimation
	{
		function addElement(display:DisplayObject):void;
		function play():void;
		function stop():void;
		function clear():void;
	}
}