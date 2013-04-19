package view.pin {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	import events.OrlandoEvent;
	
	import model.StatusFlag;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.tooltip.ToolTipManager;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinView extends AbstractView {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _id						:int;							//Pin ID: Relatated to the doc
		protected var _status					:String = "deselected";			//pin Status
		protected var _currentStep				:String;						//current step
		protected var _currentFlag				:StatusFlag;					//Current Flag
		
		protected var _originalPosition			:Object;						//Save position to go back if the drop target is not valid
		protected var _ratioPos					:Object; 						//**
		
		internal var shape						:Sprite;						//Pin Shape Object
		internal var shapeSize					:int = 6;						//pinsize
		
		internal var star						:Star;							//star tag
		protected var _tagged					:Boolean = false;				//Pin Tagged
		
		protected var bigPin					:BigPin;						//Control Class for big Pin View
		protected var _bigView					:Boolean = false;				//Switch between small and big view
		
		protected var clickCount				:int = 0;						//Count click number [0 - stop drag // 1 - single click // 2 -double click]
		protected var timer						:Timer;							//Timer between single and double click
		
		//****************** Constructor ****************** ******************  ****************** 
		
		public function PinView(c:IController, id:int) {
			
			super(c);
			
			//save properties
			_id = id;
			
			currentFlag = Settings.getFlagByName("start");	//default
			timer = new Timer(400,1);	
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		public function init():void {
			
			if (DeviceInfo.os() != "Mac") { 
				shapeSize = 9;
			}
			
			//shape
			shape = new Sprite();
			this.drawShape();
			addChild(shape);
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			shape.filters = fxs;
			
			//tagged
			if(tagged) {
				var color:uint = 0xFFFFFF;
				if (currentFlag.color == color) color = 0x666666
				
				star = new Star(shapeSize,color);
				this.addChild(star);
			}
			
			//actions
			shape.buttonMode = true;
			shape.addEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
		}
		
		
		//****************** PROTECTED METHODS - DRAWING ****************** ******************  ******************
		
		/**
		 * 
		 * 
		 */
		protected function drawShape():void {
			shape.graphics.clear()
			shape.graphics.beginFill(currentFlag.color);
			shape.graphics.drawCircle(0,0,shapeSize);
			shape.graphics.endFill();
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
		
		
		//****************** EVENTS - LITTLE PIN ****************** ******************  ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function controlMouseDown(e:MouseEvent):void {
			
			//test for movement
			this.addEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			this.addEventListener(MouseEvent.MOUSE_UP, pinClick);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function pinStartDrag(e:MouseEvent):void {
			
			//save position
			_originalPosition = {x:this.x, y:this.y};
			clickCount = 0;
			
			//dragging
			this.startDrag();
			
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			this.removeEventListener(MouseEvent.MOUSE_UP, pinClick);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, pinMoving);
			this.addEventListener(MouseEvent.MOUSE_UP, pinEndDrag);
			
			//dispatch event
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.DRAG_PIN, null, "start"));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinMoving(event:MouseEvent):void {
			//dispatch event
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.DRAG_PIN, null, "update"));	
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function pinEndDrag(e:MouseEvent):void {
			//stop draggin
			this.stopDrag();
			
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, pinMoving);
			this.removeEventListener(MouseEvent.MOUSE_UP, pinEndDrag);
			
			//dispatch event
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.DRAG_PIN, null, "end"));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinClick(event:MouseEvent):void {
			
			//test for single or double click
			if (!timer.running) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, testforMultipleClicks);
				timer.start();
			}
			
			//add to click count
			clickCount++;
			
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			this.removeEventListener(MouseEvent.MOUSE_UP, pinClick);
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function testforMultipleClicks(e:TimerEvent):void {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, testforMultipleClicks);
			timer.reset();

			switch(clickCount) {
				case 1:
					this.changeStatus("selected");
					break;
				case 2:
					this.changeStatus("edit");
					break;
			}
			
			//reset clickCount
			clickCount = 0;
			
			//Dispatch Event
			var data:Object = {};
			data.id = this.id;
			data.status = this.status;
				
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.SELECT_PIN, data, this.status));
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function changeStatus(value:String):void {
			
			_status = value;
			
			switch (value) {
				
				case "deselected":
					if (bigView) closeBigView();
					break;
				
				case "selected":
					if (bigView) closeBigView();
					break;
				
				case "edit":
					if (!bigView) {
						goBig();
						ToolTipManager.removeToolTip(this.id);
					}
					break;
			}
			
		}
		
		
		//****************** BIG PIN METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * 
		 */
		protected function goBig():void {
			
			bigView = !bigView;
			
			//Save Position
			this._originalPosition = {x:this.x, y:this.y};
			
			//change behavior
			shape.removeEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
			
			bigPin = new BigPin(this)
			bigPin.init();	
		}
		
		/**
		 * 
		 * 
		 */
		public function closeBigView():void {
			//Change behavior back
			bigView = !bigView;
			
			shape.addEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
			bigPin.close();
			bigPin = null;
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get originalPosition():Object {
			return _originalPosition;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get ratioPos():Object {
			return _ratioPos;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentStep():String {
			return _currentStep;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentFlag():StatusFlag {
			return _currentFlag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tagged():Boolean {
			return _tagged;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get status():String {
			return _status;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bigView():Boolean {
			return _bigView;
		}
	
		
		//****************** SETTERS ****************** ******************  ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set ratioPos(value:Object):void {
			if(!_ratioPos) {
				_ratioPos = new Object
			}
			_ratioPos = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentStep(value:String):void {
			_currentStep = value;
			updatePosition();
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentFlag(value:StatusFlag):void {
			_currentFlag = value;
		}
		
		/**
		 * 
		 * @param newFlag
		 * 
		 */
		public function set flag(newFlag:StatusFlag):void {
			
			currentFlag = newFlag;
			
			var cor:uint = newFlag.color;
			
			TweenMax.to(currentFlag,1,{hexColors:{color:cor}, onUpdate:drawShape});
			
			//update info if it is open
			if (bigView) {
				
				bigPin.infoPanel.updateFlagInfo();
				
				//update log if it is open
				if (bigPin.historyPanel) bigPin.historyPanel.addNewItemLog();
			}
			
			if (star) {
				var color:uint = 0xFFFFFF;
				if (currentFlag.color == color) color = 0x666666;
				TweenMax.to(star,.5,{tint:color});
			}
			 
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tagged(value:Boolean):void {
			_tagged = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set bigView(value:Boolean):void {
			_bigView = value;
		}
		
		/**
		 * 
		 * 
		 */
		public function updatePosition():void {
			_originalPosition = {x:this.x, y:this.y};
		}
		
	}
}