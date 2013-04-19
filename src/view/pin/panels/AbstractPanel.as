package view.pin.panels {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.util.scroll.Scroll;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractPanel extends AbstractView {
		
		//****************** Proprieties ****************** ****************** ******************
		protected var pinId						:int;					//pinId;
		
		protected var margin					:uint = 3;				//Margins
		protected var hMax						:int = 180;				//Max Width
		protected var vMax						:int = 200;				//Max Height
		
		protected var itemCollection			:Array;					//collection
		
		protected var panelShape				:Shape;					//Panel shape
		protected var titleTF					:TextField;
		
		protected var scrolledArea				:Sprite;
		protected var container					:Sprite;
		protected var containerMask				:Sprite;
		protected var scroll					:Scroll;
		
		protected var panelTitleStyle			:TextFormat;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function AbstractPanel(c:IController) {

			super(c);
			
			//styles
			panelTitleStyle = new TextFormat("Arial",14,0x333333,true,null,null,null,null,"center");
			
			//panel Shape
			panelShape = new Shape();
			
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get panelShapeHeight():int {
			return panelShape.height;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function createTF():TextField {
			var TFGeneric:TextField = new TextField();
			TFGeneric.autoSize = "left";
			TFGeneric.selectable = false;
			return TFGeneric;
		}
		
		/**
		 * 
		 * 
		 */
		protected function drawShape():void {
			
			panelShape.graphics.beginFill(0xFFFFFF,1);
			
			if(scroll) {
				panelShape.graphics.drawRoundRect(0,0,hMax,scrolledArea.x + vMax,10,10);
			} else {
				panelShape.graphics.drawRoundRect(0,0,hMax,this.height + (2*margin),10,10);
			}
			
			panelShape.graphics.endFill();
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			this.filters = fxs;
		}
		
		// fx
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
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
		
		/**
		 * 
		 * @param contructor
		 * @param diff
		 * 
		 */
		protected function testForScroll(contructor:Boolean = true, diff:Number = 0):void {
			
			if (container.height + diff > vMax) {
				
				//mask for container
				containerMask = new Sprite();
				containerMask.graphics.beginFill(0xFFFFFF,0);
				containerMask.graphics.drawRect(container.x, scrolledArea.y, hMax, vMax - scrolledArea.y);
				this.addChild(containerMask);
				container.mask = containerMask;
				
				//add scroll system
				scroll = new Scroll();
				scroll.target = container;
				scroll.maskContainer = containerMask;
				scroll.hasRoll = false;
				scrolledArea.addChild(scroll);
				scroll.init();
				
				//create background
				container.graphics.clear();
				container.graphics.beginFill(0xFFFFFF,0);
				container.graphics.drawRect(0,0,container.width,container.height);
				container.graphics.endFill();
				
				//shape
				panelShape.graphics.clear();
				drawShape();
				
				//draw bg
				scrolledArea.graphics.beginFill(0xFF0000,0);
				scrolledArea.graphics.drawRect(0,0,containerMask.width,containerMask.height);
				scrolledArea.graphics.endFill();
			}
			
			if(contructor) {
				drawShape()
			} else {
				
				//Scale shape if not scrolling // if gos to scroll, correct the scale
				if(!scroll) {
					TweenMax.to(panelShape,.4,{height:this.height + (2*margin) + diff});
				} else {
					panelShape.scaleY = 1;
				}
			}
			
		}

	}
}