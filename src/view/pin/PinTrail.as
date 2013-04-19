package view.pin {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import events.OrlandoEvent;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinTrail {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var target			:PinView;
		protected var canvas			:Sprite;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param _target
		 * 
		 */
		public function PinTrail(_target:PinView) {
			target = _target;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function start():void {
			target.addEventListener(OrlandoEvent.DRAG_PIN, draw);
			
			canvas = new Sprite();
			canvas.mouseEnabled = false;
			canvas.mouseChildren = false;
			target.stage.addChildAt(canvas,1);
			
			canvas.graphics.lineStyle(4,0x999999,.3);
			canvas.graphics.moveTo(target.x,target.y);
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x999999, .9);
			fxs.push(fxGlow);
			canvas.filters = fxs;
		}
		
		/**
		 * 
		 * 
		 */
		public function stop():void {
			TweenMax.to(canvas,2,{alpha:0, y:canvas.y + 10, blurFilter:{blurX:50, bluxY:50}, onComplete:kill, onCompleteParams:[canvas]});
			target.removeEventListener(OrlandoEvent.DRAG_PIN, draw);
			canvas = null;
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function draw(event:OrlandoEvent):void {
			canvas.graphics.lineTo(event.target.x, event.target.y);
		}
		
		/**
		 * 
		 * @param currentTrail
		 * 
		 */
		public function kill(currentTrail:Sprite):void {
			currentTrail.graphics.clear();
			target.stage.removeChild(currentTrail);
			currentTrail = null;
		}
		
		/**
		 * 
		 * @param colorValue
		 * @param a
		 * @return 
		 * 
		 */
		protected function getBitmapFilter(colorValue:uint, a:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 10;
			var blurY:Number = 10;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter (color,alpha,blurX,blurY,strength,quality);
		}
		
	}
}