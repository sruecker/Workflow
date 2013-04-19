package view.step {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.StepModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.graphic.AbstractShape;
	import view.graphic.Circle;
	import view.graphic.Rect;
	import view.graphic.ShadowLine;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepView extends AbstractView {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _id						:uint;						//ID
		protected var _title					:String;					//Title
		protected var _acronym					:String;					//Acronym
		protected var _level					:Number;					//Level domain
		protected var _group					:int;						//Group domain
		
		protected var glowBlur					:uint = 5;
		protected var viewType					:String = "normal";
		
		protected var activeArea				:AbstractShape;				//active Area
		protected var titleArea					:AbstractShape;				//Title Area
		
		protected var counterBox				:CounterBox					//display number of steps
		protected var pinCount					:int = 0;					//pin count
		
		protected var titleTF					:TextField;
		
		protected var titleStyle				:TextFormat;
		protected var titleFinalStyle			:TextFormat;
		
		protected var activeAreaColor			:uint
		protected var titleAreaColor			:uint
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param c
		 * @param stepModel
		 * 
		 */
		public function StepView(c:IController, stepModel:StepModel = null) {
			super(c);
			
			//save properties
			if (stepModel) {
				_id = stepModel.id;
				title = stepModel.title;
				acronym = stepModel.acronym;
				level = stepModel.level;
				group = stepModel.group;
			}
			
			//load styles
			titleStyle = new TextFormat();
			titleStyle.font = "Arial";
			titleStyle.size = 10;
			titleStyle.color = 0xFFFFFF;
			titleStyle.bold = true;
			
			titleFinalStyle = new TextFormat();
			titleFinalStyle.font = "Arial";
			titleFinalStyle.size = 13;
			titleFinalStyle.color = 0xFFFFFF;
			titleFinalStyle.bold = true;
			
			activeAreaColor = 0xDDDDDD;
			titleAreaColor = 0x666666;
			
			// --- Creat UI	
			var shadow:ShadowLine;
			
			if (id != 10) {
				//activeArea
				activeArea = new Rect(80,80);
				activeArea.color = activeAreaColor;
				activeArea.drawShape()
				this.addChild(activeArea);
				
				//shadow separation
				shadow = new ShadowLine(80);
				shadow.y = activeArea.height;
				this.addChild(shadow);
				
				//title Area
				titleArea = new Rect(activeArea.width,20);
				titleArea.color = titleAreaColor;
				titleArea.drawShape()
				titleArea.y = activeArea.height;
				this.addChild(titleArea);
				
				//text
				titleTF = new TextField();
				titleTF.width = 65;
				titleTF.autoSize = "left";
				titleTF.wordWrap = true;
				titleTF.selectable = false;
				titleTF.defaultTextFormat = titleStyle;
				
				titleTF.text = acronym;
				
				titleTF.x = titleArea.width / 20;
				titleTF.y = titleArea.y + (titleArea.height / 20);
				this.addChild(titleTF);
				
				//count box
				counterBox = new CounterBox();
				addChild(counterBox);
				
			} else {
				
				//activeArea
				activeArea = new Circle(70);
				activeArea.x = 35;
				activeArea.y = 50;
				activeArea.color = activeAreaColor;
				activeArea.drawShape()
				this.addChild(activeArea);
				
				//arc
				var centerX:Number = activeArea.x;
				var centerY:Number = activeArea.y;
				var radius:Number = 70;
				var startAngle:Number = 130/360;
				var arcAngle:Number = 100/360;
				var steps:Number = 20;
				
				var arc:Shape = new Shape();
				
				arc.graphics.lineStyle(2, 0x6D6E70);
				arc.graphics.beginFill(titleAreaColor);
				//arc.graphics.beginGradientFill("radial",[0xCCCCCC,0xFFFFFF],[1,1],[100,150]);
				
				// Rotate the point of 0 rotation 1/4 turn counter-clockwise.
				startAngle -= .25;
				
				var twoPI:Number = 2 * Math.PI;
				var angleStep:Number = arcAngle/steps;
				var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
				var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
				var angle:Number = 0;
				
				
			//	arc.graphics.moveTo(radius, 0);
				arc.graphics.moveTo(xx, yy);
				for(var i:Number=1; i<=steps; i++){
					
					angle = startAngle + i * angleStep;
					xx = centerX + Math.cos(angle * twoPI) * radius;
					yy = centerY + Math.sin(angle * twoPI) * radius;
					arc.graphics.lineTo(xx, yy);
					
				}
				//arc.graphics.lineTo(0, 0);
				arc.graphics.endFill();
				
				this.addChild(arc)
				
				//shadow separation
				shadow = new ShadowLine(110);
				shadow.x = -20;
				shadow.y = activeArea.height - arc.height - 19;
				this.addChild(shadow);
				
				//text
				titleTF = new TextField();
				titleTF.width = 65;
				titleTF.autoSize = "left";
				titleTF.selectable = false;
				titleTF.defaultTextFormat = titleFinalStyle;
				titleTF.text = acronym;
				
				titleTF.x = 8;
				titleTF.y = 98;
				this.addChild(titleTF);
				
				//count box
				counterBox = new CounterBox();
				counterBox.x = 35;
				counterBox.y = -22;
				addChild(counterBox);
			}
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(glowBlur, 5);
			fxs.push(fxGlow);
			this.filters = fxs;
			
		}
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param colorValue
		 * @param blur
		 * @return 
		 * 
		 */
		protected function getBitmapFilter(colorValue:uint, blur:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = .5;
			var blurX:Number = blur;
			var blurY:Number = blur;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():uint {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get acronym():String {
			return _acronym;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get level():Number {
			return _level;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get group():int {
			return _group;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			_title = value;
			
			if (titleTF) {
				titleTF.text = value;
				titleTF.setTextFormat(titleStyle);
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set acronym(value:String):void {
			_acronym = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set level(value:Number):void {
			_level = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set group(value:int):void {
			_group = value;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param blur
		 * 
		 */
		public function highlight(blur:uint):void {
			if (blur != glowBlur) {
				TweenMax.to(this, .8, {glowFilter:{blurX:blur, blurY:blur}});
				glowBlur = blur;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPositionForPin():Rectangle {
			var stepBounds:Rectangle = new Rectangle();
			stepBounds.x = this.x;
			stepBounds.y = this.y;
			stepBounds.width = activeArea.width;
			stepBounds.height = activeArea.height;
			return stepBounds;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function updateCounter(value:int):void {
			pinCount = value;
			counterBox.count = pinCount;
		}
		
		/**
		 * 
		 * @param currentScale
		 * 
		 */
		public function semanticZoom(currentScale:Number):void {
			
			var usableScale:Number = currentScale * .75;
			if (usableScale < 1) {
				usableScale = 1;
			}
			
			//title bar
			if (titleArea) {
				titleArea.scaleY = (1/usableScale);
				
				//title
				titleTF.scaleX = titleTF.scaleY = (1/usableScale);
				titleTF.x = titleArea.width / 20;
				titleTF.y = titleArea.y + (titleArea.height / 20);;
			}
				
			if (currentScale > 3 && viewType == "normal") {
				viewType = "zoom";
				
				titleTF.text = title;
				titleTF.width = 200;
				
			} else if (currentScale < 3 && viewType == "zoom") {
				viewType = "normal";
				
				titleTF.text = acronym;
				titleTF.width = 65;
			}
			
		}

	}
}