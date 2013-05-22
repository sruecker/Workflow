package view.structure {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.StepModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	
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
		
		protected var base						:Sprite;
		protected var activeArea				:AbstractShape;				//active Area
		protected var titleArea					:*;				//Title Area
		protected var shadow:ShadowLine;
		
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
			
			
			if (id != 10) {
				//activeArea
				activeArea = new Rect(80,80);
				activeArea.color = activeAreaColor;
				activeArea.drawShape()
				this.addChild(activeArea);
				
				//title Area
				titleArea = new Rect(activeArea.width,20);
				titleArea.color = titleAreaColor;
				titleArea.drawShape()
				titleArea.y = activeArea.height;
				this.addChild(titleArea);
				
				//shadow separation
				shadow = new ShadowLine(80,"horizontal",90);
				shadow.y = titleArea.y - shadow.height + 1;
				this.addChild(shadow);
				
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
				this.addChild(counterBox);
				
				//base
				base = new Sprite();
				base.graphics.lineStyle(1,0x666666,1,true,"none");
				base.graphics.drawRect(0,0,activeArea.width,activeArea.height + titleArea.height);
				base.graphics.endFill();
				this.addChildAt(base,0);
				
			} else {
				
				//activeArea
				activeArea = new Circle(70);
				//activeArea.x = 35;
				//activeArea.y = 50;
				activeArea.lineThickness = 1;
				activeArea.lineColor = 0x666666;
				activeArea.color = activeAreaColor;
				activeArea.drawShape()
				this.addChild(activeArea);
				
				//arc for circle radius 70
				titleArea = new Sprite();				
				titleArea.graphics.beginFill(titleAreaColor,1);
				titleArea.graphics.moveTo(0,0);
				titleArea.graphics.cubicCurveTo(12,14,31,23,52,23);
				titleArea.graphics.cubicCurveTo(72,23,91,14,104,0);
				titleArea.graphics.lineTo(0,0);
				titleArea.graphics.endFill();

				this.addChild(titleArea);
				
				titleArea.x = -titleArea.width/2;
				titleArea.y = (activeArea.height/2) - titleArea.height;
				
				//text
				titleTF = new TextField();
				titleTF.width = 65;
				titleTF.autoSize = "center";
				titleTF.selectable = false;
				titleTF.defaultTextFormat = titleFinalStyle;
				titleTF.text = acronym;
				
				titleTF.x = titleArea.x + (titleArea.width/2) - (titleTF.width/2);
				titleTF.y = titleArea.y + 2;
				this.addChild(titleTF);
				
				//shadow separation
				shadow = new ShadowLine(106,"horizontal",90);
				shadow.x = titleArea.x-1;
				shadow.y = titleArea.y -  shadow.height;
				this.addChild(shadow);
				
				//count box
				counterBox = new CounterBox();
				counterBox.y = -activeArea.height/2;
				addChild(counterBox);
				
			}
			
			//fx
			/*
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(glowBlur, 5);
			fxs.push(fxGlow);
			this.filters = fxs;
			*/
			
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
		public function highlight(value:Boolean):void {
			
			switch (Settings.platformTarget) {
				case "mobile":
					if (value) {
						TweenMax.to(activeArea, .5, {tint:0xFFFFFF});
					} else {
						TweenMax.to(activeArea, .5, {removeTint:true});
					}
					break;
				
				default:
					if (value) {
						TweenMax.to(this, .5, {glowFilter:{blurX:15, blurY:15}});
						glowBlur = 15;
					} else {
						TweenMax.to(this, .5, {glowFilter:{blurX:5, blurY:5}});
						glowBlur = 5;
					}

				break;
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
			if (counterBox) counterBox.count = value;
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
			if (this.id != 10) {
				titleArea.scaleY = (1/usableScale);
				titleArea.y = activeArea.height;
				
				base.height = activeArea.height + titleArea.height;

				//title
				titleTF.scaleX = titleTF.scaleY = (1/usableScale);
				titleTF.x = titleArea.width / 20;
				titleTF.y = titleArea.y + (titleArea.height / 20);;
			}
			
			//shadow
			shadow.scaleY = (1/usableScale)
			shadow.y = titleArea.y - shadow.height;
				
			if (currentScale > 3 && viewType == "normal") {
				viewType = "zoom";
				
				titleTF.text = title;
				if (this.id != 10) {
					titleTF.width = 200;
				}
				
			} else if (currentScale < 3 && viewType == "zoom") {
				viewType = "normal";
				
				titleTF.text = acronym;
				if (this.id != 10) {
					titleTF.width = 65;
				}
			}
			
		}

	}
}