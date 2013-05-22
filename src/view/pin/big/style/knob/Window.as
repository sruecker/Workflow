package view.pin.big.style.knob {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.WorkflowController;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	
	import settings.Settings;
	
	import view.pin.big.AbstractPanel;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Window extends AbstractView {
		
		//****************** Proprieties ****************** ****************** ******************
		protected var pinId						:int;					//pinId;
		
		protected var margin					:uint = 3;				//Margins
		protected var _hMax						:int = 180;				//Max Width
		protected var _vMax						:int = 200;				//Max Height
		protected var hMargin					:int = 0;
		
		protected var panelContainer			:Sprite;				//
		protected var panelCollection			:Array;					//collection
		protected var panelMask					:Sprite;
		
		protected var shape						:Shape;					//shape
		protected var titleTF					:TextField;
		
		protected var pagination				:Pagination
		
		protected var _style					:int;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function Window(c:IController, style:int = 1) {
			
			super(c);
			
			_style = style;
			
			switch (style) {
				case 1:
					_hMax = 180;
					_vMax = 200;
					break;
				
				case 2:
					_hMax = 300;
					_vMax = 180;
					hMargin = 50;
					break;	
			}
			
			//panel Shape
			shape = new Shape();
			
			if (Settings.platformTarget == "mobile") {
				var swipe:SwipeGesture = new SwipeGesture(this);
				swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, swipeEvent);
			}
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function init(id:int = 0):void {
			pinId = id;
			
			if (!shape) shape = new Shape();
			shape.graphics.lineStyle(1,0x333333,1,true);
			shape.graphics.beginFill(0xFFFFFF,1);
			shape.graphics.drawRoundRect(0,0,hMax,vMax,10,10);
			shape.graphics.endFill();
			this.addChild(shape);
			
			//title
			var titleStyle:TextFormat = new TextFormat();
			titleStyle.font = "Arial";
			titleStyle.size = 16;
			titleStyle.leading = 1.5;
			titleStyle.color = 0x333333;
			titleStyle.bold = true;
			titleStyle.align = "center";
			
			var title:String = WorkflowController(this.getController()).getPinTitle(pinId);
			
			titleTF = new TextField();
			titleTF.autoSize = "center";
			titleTF.selectable = false;
			titleTF.width = hMax - 10;
			titleTF.wordWrap = true;
			titleTF.multiline = true;
			titleTF.defaultTextFormat = titleStyle;
			titleTF.text = title;
			
			titleTF.x = 5;
			titleTF.y = 5;
			this.addChild(titleTF);
			
			//title bg
			if (_style == 2) {
				
				titleTF.x = 10;
				titleTF.width = hMax - titleTF.x - 5;
				
				var titleBG:Sprite = new Sprite();
				titleBG.graphics.beginFill(0xDDDDDD,.5);
				titleBG.graphics.drawRoundRectComplex(0,0,hMax,titleTF.height + 5,10,10,0,0);
				titleBG.graphics.endFill();
				this.addChildAt(titleBG,1);
			}
				
			//container
			panelContainer = new Sprite();
			panelContainer.y = titleTF.y + titleTF.height;
			this.addChild(panelContainer);
			
			panelMask = new Sprite();
			panelMask.y = panelContainer.y;
			panelMask.graphics.beginFill(0xFFFFFF,0);
			panelMask.graphics.drawRoundRect(0,0,shape.width,shape.height - panelContainer.y ,10,10);
			panelMask.graphics.endFill();
			this.addChild(panelMask);
			
			panelContainer.mask = panelMask;
			
			panelCollection = new Array();
			
			//paginator
			pagination = new Pagination();
			pagination.x = shape.width/2;
			pagination.y = shape.height - 5;;
			this.addChild(pagination);
			pagination.addPage("info");
			pagination.addPage("history");
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get panelShapeHeight():int {
			return shape.height;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get hMax():int {
			return _hMax;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get vMax():int {
			return _vMax;
		}
		
		
		//****************** SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set hMax(value:int):void {
			_hMax = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set vMax(value:int):void {
			_vMax = value;
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		public function addPanel(source:AbstractPanel):void {
			source.x = shape.width * panelCollection.length + hMargin;
			source.hMax = this.hMax - hMargin;
			source.vMax = this.vMax - panelContainer.y;
			panelContainer.addChild(source);
			panelCollection.push(source);
			source.init(pinId);
		}
		
		//****************** EVENTS ****************** ******************  ****************** 
		
		private function swipeEvent(event:GestureEvent):void {
			
			var swipeGesture:SwipeGesture = event.target as SwipeGesture;
			var direction:Number;
			
			if (swipeGesture.offsetX > 0) {
				direction = 1;
			} else {
				direction = -1;
			}
			
			switch (direction) {
				
				case -1:
					if (pagination.currentPage < pagination.totalPages-1) {
						pagination.changeCurrentpage(pagination.currentPage - direction);
					}
					break;
				
				
				case 1:
					if (pagination.currentPage > 0) {
						pagination.changeCurrentpage(pagination.currentPage - direction);
					}
					break;
				
				
			}
			
			
			TweenMax.to(panelContainer,1,{x:hMax * -pagination.currentPage});
		}


	}
}