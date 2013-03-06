package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import controller.WorkflowController;
	
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.AbstractStep;
	
	import mvc.AbstractView;
	import mvc.IController;
	import mvc.Observable;
	
	import view.graphic.*;
	
	public class StepView extends OrlandoView {
		
		//properties
		private var _id:uint;					//ID
		private var _title:String;				//Title
		private var _acronym:String = "";		//Acronym
		private var _level:Number;				//Level domain
		private var _group:int;					//Level domain
		
		private var activeArea:AbstractShape;
		private var shadow:ShadowLine
		
		private var titleArea:AbstractShape;
		
		private var countBox:CountBox			//display hte number of steps
		private var pinCount:int = 0;			//pin count
		
		private var titleTextField:TextField = new TextField();
		private var titleStyle:TextFormat = new TextFormat("Arial",10,0xffffff,true);
		private var titleFinalStyle:TextFormat = new TextFormat("Arial",13,0xffffff,true);
		
		private var glowBlur:uint = 5;
		
		public var viewType:String = "normal";
		
		
		public function StepView(c:IController, data:AbstractStep = null) {
			super(c);
			
			//save properties
			if (data) {
				id = data.id;
				title = data.title;
				acronym = data.acronym;
				level = data.level;
				group = data.group;
			}
			
			createUI();
		}
		
		/**
		 * Returns the default controller for this view.
		 */
		
		/*
		override public function defaultController (model:Observable):IController {
			return new WorkflowController(model);
		}
		*/
		
		private function createUI():void {
			
			
			if (_id != 10) {
				//activeArea
				activeArea = new Rect(80,80);
				activeArea.color = 0xdddddd;
				activeArea.drawShape()
				this.addChild(activeArea);
				
				//shadow separate
				shadow = new ShadowLine(80);
				shadow.y = activeArea.height;
				this.addChild(shadow);
				
				//title Area
				titleArea = new Rect(activeArea.width,20);
				titleArea.color = 0x666666;
				titleArea.drawShape()
				titleArea.y = activeArea.height;
				this.addChild(titleArea);
				
				//text
				titleTextField = new TextField();
				titleTextField.width = 65;
				titleTextField.autoSize = "left";
				titleTextField.wordWrap = true;
				//titleTextField.embedFonts = true;
				titleTextField.selectable = false;
				titleTextField.defaultTextFormat = titleStyle;
				
				titleTextField.text = acronym;
				
				titleTextField.x = titleArea.width / 20;
				titleTextField.y = titleArea.y + (titleArea.height / 20);
				this.addChild(titleTextField);
				
				//count box
				countBox = new CountBox();
				addChild(countBox);
			} else {
				//activeArea
				activeArea = new Circle(70);
				activeArea.x = 35;
				activeArea.y = 50;
				activeArea.color = 0xdddddd;
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
				arc.graphics.beginFill(0x666666);
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
				
				//shadow separate
				shadow = new ShadowLine(110);
				shadow.x = -20;
				shadow.y = activeArea.height - arc.height - 19;
				this.addChild(shadow);
				
				
				//text
				titleTextField = new TextField();
				titleTextField.width = 65;
				titleTextField.autoSize = "left";
				titleTextField.selectable = false;
				titleTextField.defaultTextFormat = titleFinalStyle;
				titleTextField.text = acronym;
				
				titleTextField.x = 8;
				titleTextField.y = 98;
				this.addChild(titleTextField);
				
				
				//count box
				countBox = new CountBox();
				countBox.x = 35;
				countBox.y = -22;
				addChild(countBox);
			}
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(glowBlur, 5);
			fxs.push(fxGlow);
			this.filters = fxs;
			
			
		}
		
		// fx
		internal function getBitmapFilter(colorValue:uint, blur:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = .5;
			var blurX:Number = blur;
			var blurY:Number = blur;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
		public function highlight(blur:uint):void {
			if (blur != glowBlur) {
				TweenMax.to(this, .8, {glowFilter:{blurX:blur, blurY:blur}});
				glowBlur = blur;
			}
		}
		
		
		
		
		public function get id():uint {
			return _id;
		}
		
		public function set id(value:uint):void {
			_id = value;
		}
		
		public function get title():String {
			return _title;
		}
		
		public function set title(value:String):void {
			_title = value;
			
			titleTextField.text = value;
			titleTextField.setTextFormat(titleStyle);
		}
		
		public function get acronym():String {
			return _acronym;
		}
		
		public function set acronym(value:String):void {
			_acronym = value;
		}
		
		public function get level():Number {
			return _level;
		}
		
		public function set level(value:Number):void {
			_level = value;
		}

		public function get group():int {
			return _group;
		}

		public function set group(value:int):void {
			_group = value;
		}
		
		
		public function getPositionForPin():Object {
			var obj:Object = new Object();
			obj.x = this.x;
			obj.y = this.y;
			obj.width = activeArea.width;
			obj.height = activeArea.height;
			
			return obj;
		}
		
		public function addPinToCounter():void {
			pinCount++;
			countBox.count = pinCount;
		}
		
		public function removePinToCounter():void {
			pinCount--;
			countBox.count = pinCount;
		}
		
		public function updateCounter(value:int):void {
			pinCount = value;
			countBox.count = pinCount;
		}
		
		public function changeView(actualScale:Number):void {
			
			var usableScale:Number = (3 * actualScale) /4;
			if (usableScale < 1) {
				usableScale = 1;
			}
			
			//title bar
			if (titleArea) {
				titleArea.scaleY = (1/usableScale);
				
				//title
				titleTextField.scaleX = titleTextField.scaleY = (1/usableScale);
				titleTextField.x = titleArea.width / 20;
				titleTextField.y = titleArea.y + (titleArea.height / 20);;
			
			}
				
			if (actualScale > 3 && viewType == "normal") {
				viewType = "zoom";
				
				titleTextField.text = title;
				titleTextField.width = 200;
				
			} else if (actualScale < 3 && viewType == "zoom") {
				viewType = "normal";
				
				titleTextField.text = acronym;
				titleTextField.width = 65;
			}
			
		}

	}
}