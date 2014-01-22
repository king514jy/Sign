package view.conmponents
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * 冷却特效-扇形
	 * @author blank
	 * 
	 */
	public class CoolDownEffect
	{
		/**
		 * 目标
		 */
		private var _target:DisplayObject;
		
		/**
		 * 将目标对象的一个灰色背景显示到底部.
		 */
		private var targetBg:Sprite;
		
		/**
		 * 遮罩(_target被遮罩),在此遮罩上绘制不断改变的扇形,以达到特效效果.
		 */
		private var fanMask:Shape;
		
		/**
		 * 冷却时间显示
		 */
		private var coolText:TextField;
		
		/**
		 * 开始时间
		 */
		private var startTime:int;
		
		/**
		 * 持续时间
		 */
		private var _duration:int;
		
		/**
		 * 初始角度
		 */
		private var _initAngle:Number;
		
		/**
		 * 冷却特效显示完成时的回调.
		 */
		private var _completeCallback:Function;
		
		/**
		 * 冷却倒计时显示
		 */
		private var _coolTimeTextFormat:TextFormat;
		
		/**
		 * 是否正在播放特效
		 */
		private var _isPlaying:Boolean;
		
		/**
		 * 扇形的半径
		 */
		private var radius:Number;
		
		/**
		 * 扇形的中心点X坐标
		 */
		private var centerX:Number;
		
		/**
		 * 扇形的中心点Y坐标
		 */
		private var centerY:Number;
		
		/**
		 * 上一次绘制扇形的角度
		 */
		private var lastAngle:Number;
		
		/**
		 * 灰色滤镜
		 */
		public static const GRAY_FILTERS:Array=[
			new ColorMatrixFilter([
				0.25,         0.25,         0.25,         0,         0,
				0.25,         0.25,         0.25,         0,         0,
				0.25,         0.25,         0.25,         0,         0,                 
				0,                 0,                 0,                 1,         0
			])
		];
		
		/**
		 * 将倒计时文本显示中心点
		 * 
		 */
		private function toCenterCoolText():void{
			coolText.width = coolText.textWidth + 4;
			coolText.height = coolText.textHeight + 4;
			coolText.x = targetBg.x + (targetBg.width - coolText.width) / 2;
			coolText.y = targetBg.y + (targetBg.height - coolText.height) / 2;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		private function enterFrameHandler(event:Event):void{
			var interval:int= getTimer() - startTime;
			if(interval >= _duration){
				stop(true);
			}
			
			var endAngle:Number = _initAngle + 360 * (interval / _duration);
			ShapeDraw.drawFan(fanMask.graphics, radius, lastAngle, endAngle, centerX, centerY, 4);
			
			if(_coolTimeTextFormat){
				var remainingTime:int = Math.ceil((_duration - interval) / 1000);
				if(remainingTime != int(coolText.text)){
					coolText.text = String(remainingTime);
					toCenterCoolText();
				}
			}
			lastAngle = endAngle;
		}
		
		/**
		 * 播放扇形冷却特效
		 * @param target 目标
		 * @param duration 持续时间
		 * @param initAngle 初始角度
		 * @param completeCallback 执行完成时的回调
		 * @param coolTextTextFormat 倒计时文本的格式
		 * @param coolTextFilters 倒计时文本的滤镜
		 * @param fanBgFilters 播放时显示到背景上的滤镜,默认为灰色滤镜 
		 * 
		 */
		public function play(target:DisplayObject, duration:int, initAngle:Number = 0, completeCallback:Function = null, coolTextTextFormat:TextFormat = null, coolTextFilters:Array = null, fanBgFilters:Array = null):void{
			var parent:DisplayObjectContainer = null;
			
			if(duration <= 0){
				return;
			}
			
			if(target && target.stage && !_isPlaying){
				_isPlaying = true;
				_target = target;
				_duration = duration;
				_initAngle = initAngle;
				_completeCallback = completeCallback;
				_coolTimeTextFormat = coolTextTextFormat;
				parent = target.parent;
				
				var targetBmp:BitmapData = new BitmapData(target.width, target.height, true, 0);
				targetBmp.draw(target);
				//BitmapDraw.drawBitmap(targetBg.graphics, targetBmp);
				
				targetBg.graphics.beginBitmapFill(targetBmp);
				targetBg.graphics.drawRect(0,0,target.width, target.height);
				
				targetBg.filters = fanBgFilters || GRAY_FILTERS;
				targetBg.x = target.x;
				targetBg.y = target.y;
				parent.addChildAt(targetBg, parent.getChildIndex(target));
				if(target is Sprite){
					(target as Sprite).hitArea = targetBg;
				}
				
				fanMask.x = targetBg.x;
				fanMask.y = targetBg.y;
				parent.addChild(fanMask);
				target.mask = fanMask;
				
				if(coolTextTextFormat){
					coolText.filters = coolTextFilters;
					coolText.defaultTextFormat = coolTextTextFormat;
					coolText.setTextFormat(coolTextTextFormat);
					coolText.text = String(duration / 1000);
					toCenterCoolText();
					parent.addChildAt(coolText, (parent.getChildIndex(target) + 1));
				}
				
				radius = Math.sqrt(target.width * target.width + target.height * target.height) / 2;
				centerX = target.width / 2;
				centerY = target.height / 2;
				startTime = getTimer();
				lastAngle = initAngle;
				fanMask.graphics.clear();
				fanMask.graphics.beginFill(16711680, 0.5);
				targetBg.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		/**
		 * 停止特效播放
		 * 
		 */
		public function stop(over:Boolean):void{
			if(_isPlaying){
				_isPlaying = false;
				targetBg.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				if(_target is Sprite){
					(_target as Sprite).hitArea = null;
				}
				_target.mask = null;
				
				targetBg.graphics.clear();
				if(targetBg.parent){
					targetBg.parent.removeChild(targetBg);
				}
				
				fanMask.graphics.clear();
				if(fanMask.parent){
					fanMask.parent.removeChild(fanMask);
				}
				
				if(coolText.parent){
					coolText.parent.removeChild(coolText);
					coolText.filters = null;
				}
				
				if(_completeCallback && over){
					_completeCallback();
				}
			}
		}
		
		/**
		 * 冷却特效-扇形
		 * 
		 */
		public function CoolDownEffect(){
			targetBg = new Sprite();
			targetBg.mouseEnabled = false;
			fanMask = new Shape();
			coolText = new TextField();
			coolText.mouseEnabled = false;
		}
		
		/**
		 * 目标
		 * @return 
		 * 
		 */
		public function get target():DisplayObject{
			return _target;
		}
	}
}