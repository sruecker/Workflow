package view.pin {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	import events.WorkflowEvent;
	
	import model.StatusFlag;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.TapGesture;
	
	import settings.Settings;
	
	import view.pin.big.AbstractBigPin;
	import view.pin.big.BigPinFactory;
	import view.structure.StepView;
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
		
		protected var _shape					:Sprite;						//Pin Shape Object
		protected var _shapeSize				:int = 12;						//pinsize
		
		protected var _star						:Star;							//star tag
		protected var _tagged					:Boolean = false;				//Pin Tagged
		
		protected var bigPin					:AbstractBigPin;						//Control Class for big Pin View
		protected var _bigView					:Boolean = false;				//Switch between small and big view
		
		protected var clickCount				:int = 0;						//Count click number [0 - stop drag // 1 - single click // 2 -double click]
		protected var timer						:Timer;							//Timer between single and double click
		
		protected var pinTrail					:PinTrail						//trail dureing movement
		
		protected var _tap						:TapGesture						//mutltitouch gestures
		protected var _longPress					:LongPressGesture				//mutltitouch gestures
		
		protected var _stepHit					:StepView;
		protected var _stepHitInside				:Boolean;
		
		//****************** Constructor ****************** ******************  ****************** 
		
		public function PinView(c:IController, id:int) {
			
			super(c);
			
			//save properties
			_id = id;
			
			currentFlag = Settings.getFlagByName("start");	//default
			timer = new Timer(400,1);	
			
			//trails
			if (Settings.pinTrail) pinTrail = new PinTrail(this);
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		public function init():void {
			
			if (Settings.platformTarget == "mobile") {
				shapeSize = 18;
			}
			
			//shape
			shape = new Sprite();
			this.drawShape();
			addChild(shape);
			
			//tagged
			if(tagged) {
				var color:uint = 0xFFFFFF;
				if (currentFlag.color == color) color = 0x666666
				
				star = new Star(shapeSize,color);
				this.addChild(star);
			}
			
			shape.buttonMode = true;
			
			//listeners
			
			if (Settings.platformTarget == "mobile") {
				tap = new TapGesture(shape);
				tap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, tapEvent);
				
				shape.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
				
				longPress = new LongPressGesture(shape);
				longPress.addEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
				
			} else {
				shape.addEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
			}
			
		}		
		
		//****************** PROTECTED METHODS - DRAWING ****************** ******************  ******************
		
		/**
		 * 
		 * 
		 */
		protected function drawShape(flagColor:Object = null):void {
			
			
			var pinColor:uint;
			
			if (flagColor == null) {
				pinColor = currentFlag.color;
			} else {
				pinColor = flagColor.color;
			}
			
			if (bigView) {
				bigPin.drawShape();
			} else {
				shape.graphics.clear();
				shape.graphics.lineStyle(1,0x333333,1,false,"none");
				
				if (currentFlag.color == 0xFFFFFF) {
					shape.blendMode = "normal";
					shape.graphics.beginFill(pinColor,.75);
				} else {
					shape.blendMode = "multiply";
					shape.graphics.beginFill(pinColor);
				}
				
				shape.graphics.drawCircle(0,0,shapeSize);
				shape.graphics.endFill();
			}
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
			
			//bring to front
			this.parent.setChildIndex(this,this.parent.numChildren-1);
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
			
			//Start pinTrail
			if (!pinTrail) pinTrail.start();;
			
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, pinStartDrag);
			this.removeEventListener(MouseEvent.MOUSE_UP, pinClick);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, pinMoving);
			this.addEventListener(MouseEvent.MOUSE_UP, pinEndDrag);
			
			//dispatch event
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "start"));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinMoving(event:MouseEvent):void {
			//dispatch event
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "update"));	
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function pinEndDrag(e:MouseEvent):void {
			//stop draggin
			this.stopDrag();
			
			//stop pinTrail
			if (!pinTrail) pinTrail.stop();
			
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, pinMoving);
			this.removeEventListener(MouseEvent.MOUSE_UP, pinEndDrag);
			
			//dispatch event
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "end"));
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
				
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.SELECT, data, this.status));
		}
		
		
		//****************** EVENTS GESTURE/TOUCH ****************** ******************  ******************
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function tapEvent(event:GestureEvent):void {
			this.changeStatus("selected");
			
			//Dispatch Event
			var data:Object = {};
			data.id = this.id;
			data.status = this.status;
			
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.SELECT, data, this.status));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function longPressBeganEvent(event:GestureEvent):void {
			
			//trace ("longPress");
			
			shape.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			shape.removeEventListener(TouchEvent.TOUCH_END, touchMoveEnd);
			shape.removeEventListener(TouchEvent.TOUCH_OUT, touchMoveOut);
	
			this.changeStatus("edit");
			
			//Dispatch Event
			var data:Object = {};
			data.id = this.id;
			data.status = this.status;
			
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.SELECT, data, this.status));
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchBegin(event:TouchEvent):void {
			
			//trace ("touch Begin")
			
			//dragging
			this.startTouchDrag(event.touchPointID);
			
			//move to front
			this.parent.setChildIndex(this,this.parent.numChildren-1);
			
			if (bigPin) {
				shape.addEventListener(TouchEvent.TOUCH_END, touchMoveEndBigPin);
			} else {
			
				//save position
				_originalPosition = {x:this.x, y:this.y};
				
				//Start pinTrail
				if (!pinTrail) pinTrail.start();;
				
				//Start pinTrail
				if (!pinTrail) pinTrail.start();
				
				shape.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
				shape.addEventListener(TouchEvent.TOUCH_END, touchMoveEnd);
				shape.addEventListener(TouchEvent.TOUCH_OUT, touchMoveOut);
				
				this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "start"));
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchMove(event:TouchEvent):void {
			
			if (timer.running) {
				timer.reset();
			}
			
			//listeners
			longPress.removeEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
			
			//dispatch event
			
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "update"));
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function touchMoveEnd(event:TouchEvent):void {
			//trace ("TouchEndMOve")
			touchEnd(event.touchPointID);
			
			if (timer.running) {
				timer.reset();
			}
		}
		
		protected function touchMoveOut(event:TouchEvent):void {
			//trace ("TouchMoveOUT");
			var touchId:int = event.touchPointID;
			
			if (!timer.running) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
				timer.start();
			}
			
			var target:Sprite = this;
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "update"));

			function timeOut(event:TimerEvent):void {
				//trace ("endOutiside")
				
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
				timer.reset();
				
				target.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "update"));
				
				touchEnd(touchId);
			}
		}
		
		protected function touchEnd(touchID:int):void {
			
			//trace ("TouchendFinal")
			
			//stopDrag
			this.stopTouchDrag(touchID);
			
			//stop pinTrail
			if (!pinTrail) pinTrail.stop();
			
			//listeners
			longPress.addEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
			
			shape.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			shape.removeEventListener(TouchEvent.TOUCH_END, touchMoveEnd);
			shape.removeEventListener(TouchEvent.TOUCH_OUT, touchMoveOut);
			
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.DRAG_PIN, null, "end"));
		}
		
		protected function touchMoveEndBigPin(event:TouchEvent):void {
			this.stopTouchDrag(event.touchPointID);
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
			if (Settings.platformTarget == "mobile") {
				tap.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, tapEvent);
				tap = null;
				longPress.removeEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
				longPress = null;
			} else {
				shape.removeEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
			}
			
			//change blendMode
			shape.blendMode = "normal";
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .3);
			fxs.push(fxGlow);
			this.filters = fxs;
			
			bigPin = BigPinFactory.addBigPin(this);
			bigPin.init();	
		}
		
		/**
		 * 
		 * 
		 */
		public function closeBigView():void {
			//Change behavior back
			bigView = !bigView;
			
			bigPin.close();
			bigPin = null;
			
			//change visual
			if (currentFlag.color == 0xFFFFFF) {
				shape.blendMode = "normal";
			} else {
				shape.blendMode = "multiply";
			}
			this.filters = [];
			
			//change behavior
			if (Settings.platformTarget == "mobile") {
				
				tap = new TapGesture(shape);
				tap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, tapEvent);
				
				shape.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
				
				longPress = new LongPressGesture(shape);
				longPress.addEventListener(GestureEvent.GESTURE_BEGAN, longPressBeganEvent);
				
			} else {
				shape.addEventListener(MouseEvent.MOUSE_DOWN, controlMouseDown);
			}
			
			
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
		public function get shapeSize():int {
			return _shapeSize;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get shape():Sprite {
			return _shape;
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
		public function get star():Star {
			return _star;
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
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stepHitInside():Boolean {
			return _stepHitInside;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stepHit():StepView {
			return _stepHit;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tap():TapGesture {
			return _tap;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get longPress():LongPressGesture {
			return _longPress;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shapeSize(value:int):void {
			_shapeSize = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set shape(value:Sprite):void {
			_shape = value;
		}
		
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
			this.updatePosition(this.x,this.y);
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
			
			
			var nFlag:StatusFlag = newFlag;
			
			
			var currentFlagColor:Object = {color:currentFlag.color}
			TweenMax.to(currentFlagColor,.5,{hexColors:{color:newFlag.color}, onUpdate:drawShape, onUpdateParams:[currentFlagColor], onComplete:changeFlag});
			
			currentFlag = newFlag;
			
			function changeFlag():void {
			//	currentFlag = newFlag;
			}
			
			//update info if it is open
			if (bigView) {
				//bigPin.infoPanel.updateFlagInfo();
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
		public function set star(value:Star):void {
			_star = value;
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
		public function updatePosition(newX:Number, newY:Number):void {
			_originalPosition = {x:newX, y:newY};
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set stepHitInside(value:Boolean):void {
			_stepHitInside = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set stepHit(value:StepView):void {
			_stepHit = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tap(value:TapGesture):void {
			_tap = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set longPress(value:LongPressGesture):void {
			_longPress = value;
		}


	}
}