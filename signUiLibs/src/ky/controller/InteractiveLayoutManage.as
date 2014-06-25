package ky.controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ky.events.MenuClickEvent;
	import ky.mode.InteractiveLayoutMode;
	
	public class InteractiveLayoutManage extends Sprite
	{
		private var _space:Number;
		private var _direction:String;
		private var _interactiveList:Vector.<InteractiveObject>;
		private var pointList:Vector.<Point>;
		private var _autoAssemble:Boolean;
		private var _isSpread:Boolean;
		public function InteractiveLayoutManage(space:Number,direction:String="left",autoAssemble:Boolean=true)
		{
			_space = space;
			_direction = direction;
			_autoAssemble = autoAssemble;
			_interactiveList = new Vector.<InteractiveObject>();
			pointList = new Vector.<Point>();
		}
		public function get isSpread():Boolean{ return _isSpread; }
		public function addInteractiveObject(interactiveObject:InteractiveObject):void
		{
			if(_interactiveList.length!=0)
			{
				interactiveObject.alpha = 0;
			}
			interactiveObject.mouseEnabled = false;
			var point:Point = new Point();
			switch(_direction)
			{
				case InteractiveLayoutMode.LEFT:
					point.x = -(_interactiveList.length * _space);
					break;
				case InteractiveLayoutMode.RIGHT:
					break;
				case InteractiveLayoutMode.UP:
					point.y = -(_interactiveList.length * _space);
					break;
				case InteractiveLayoutMode.DOWN:
					break;
				case InteractiveLayoutMode.ARC:
					break;
				case InteractiveLayoutMode.SCATTERING:
					break;
				
			}
			this.addChildAt(interactiveObject,0);
			_interactiveList.push(interactiveObject);
			pointList.push(point);
		}
		public function addMouseEvent():void
		{
			_interactiveList[0].mouseEnabled = true;
			_interactiveList[0].addEventListener(MouseEvent.CLICK,clickHandle);
		}
		public function removeMouseEvent():void
		{
			_interactiveList[0].mouseEnabled = false;
			_interactiveList[0].removeEventListener(MouseEvent.CLICK,clickHandle);
		}
		private function clickHandle(e:MouseEvent):void
		{
			var interactiveObject:InteractiveObject = e.currentTarget as InteractiveObject;
			var index:int = _interactiveList.indexOf(interactiveObject);
			if(index==0)
			{
				if(!_isSpread)
				{
					_isSpread = true;
					spread();
				}
				else
				{
					_isSpread = false;
					assemble();
				}
			}
			else
			{
				if(_autoAssemble)
				{
					_isSpread = false;
					assemble();
				}
			}
			dispatchEvent(new MenuClickEvent(MenuClickEvent.IS_CLICK,index));
		}
		private function spread():void
		{
			if(!_isSpread)
				_isSpread = true;
			for(var i:int=1;i<_interactiveList.length;i++)
			{
				switch(_direction)
				{
					case InteractiveLayoutMode.LEFT:
						TweenLite.to(_interactiveList[i],0.5+i*0.1,{alpha:1,x:pointList[i].x,ease:Quint.easeInOut});
						break;
					case InteractiveLayoutMode.RIGHT:
						break;
					case InteractiveLayoutMode.UP:
						TweenLite.to(_interactiveList[i],0.5+i*0.1,{alpha:1,y:pointList[i].y,ease:Quint.easeInOut});
						break;
					case InteractiveLayoutMode.DOWN:
						break;
					case InteractiveLayoutMode.ARC:
						break;
					case InteractiveLayoutMode.SCATTERING:
						break;
					
				}
				_interactiveList[i].mouseEnabled = true;
				_interactiveList[i].addEventListener(MouseEvent.CLICK,clickHandle);
			}
			
		}
		public function assemble():void
		{
			if(_isSpread)
				_isSpread = false;
			for(var i:int=1;i<_interactiveList.length;i++)
			{
				TweenLite.to(_interactiveList[i],0.5+i*0.1,{alpha:0,x:0,y:0,ease:Quint.easeInOut});
				_interactiveList[i].mouseEnabled = false;
				_interactiveList[i].removeEventListener(MouseEvent.CLICK,clickHandle);
			}
		}
	}
}