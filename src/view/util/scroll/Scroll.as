package view.util.scroll {		//imports	import com.greensock.TweenMax;		import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TransformGestureEvent;	import flash.geom.Point;		import org.gestouch.events.GestureEvent;	import org.gestouch.gestures.PanGesture;	import org.gestouch.gestures.PanGestureDirection;		import util.DeviceInfo;
		/**	 * Scroll Class.	 * 	 * This class manage scrolling content. The target have to be masked, with witch the scroll will use as scroll limits.	 * It works using Pan gesture to move the content UP and DOWN or LEFT and RIGHT. It has building inertia.	 *  	 * @author lucaju	 * 	 */	public class Scroll extends Sprite {				//****************** Proprieties ****************** ****************** ******************				public const VERTICAL			:String = "vertical";					//Direction: Vertical		public const HORIZONTAL			:String = "horizontal";					//Direction: Horizontal				private var _enable				:Boolean = true;				private var _gestureInput		:String = "native";				private var _direction			:String = VERTICAL;						//Direction: Horizontal or Vertical. Default: Vertical		private var _friction			:Number = .88;							//Inertia: Friction rate. Default: 0.98;		private var _speed				:Point = new Point(0,0);				//Intertia: speed.				private var _wMax				:Number = 0;							//Max width if horizontal		private var _hMax				:Number = 0;							//Max height if vertical		private var _offset				:Number = 0;							//Offset (when the scroll area is not fixed to 0)		private var _ratePageX			:Number;		private var _ratePageY			:Number;				private var _hasRoll			:Boolean = true;		private var _hasTrack			:Boolean = false;				private var _target				:Sprite;								//Target scrolled object		private var _mask				:Sprite;								//Target's mask object		private var roll				:Roll;									//Roll		private var track				:Track;									//Track				private var _color				:uint = 0x000000;						//Color.				private var panGesture			:PanGesture				//****************** Constructor ****************** ****************** ******************				/**		 * [Exclude(name="Sprite", kind="method")] 		 * Constructor.		 * <p>You have to set some attributes to make the scroll works</p>		 * <p>Required:</p>		 * <p>TARGET: Set the target using the function target.</p> 		 * <p>MASK: Set the target mask using the function maskContainer.</p> 		 * <br />		 * <p>Optional:</p>		 * <p>DIRECTION: Set the sroll direction using the function direction. You can choose between "vertical" and "horizontal". If you don't set this, the scroll will the default VERTICAL direction</p>		 * <p>COLOR: Set Roll and Track colors usinf the function color. The default is 0x000000 (Black).</p>		 * 		 * <p>The construct add an event. Whenever it is added to the screen, it will add the other iteractive events.</p>		 */		public function Scroll() {			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}						//****************** INITIALIZE ****************** ****************** ******************				/**		 * 		 * 		 */		public function init():void {						if (direction != "both") {								//track				if (hasTrack) {					track = new Track();					addChild(track);				}								//roll				if (hasRoll) {					roll = new Roll(color);					roll.init(direction);					addChild(roll);				}								//position and size				if (direction == "vertical") {					if (roll) roll.height = _hMax / _ratePageY;					if (track) track.height = _hMax;					this.y = target.y;					this.x = target.width - this.width;				} else {					if (roll) roll.width = _wMax / _ratePageX;					if (track) track.width = _wMax;					this.x = target.x;					this.y = _mask.height - this.height;				}			}					}				//****************** PROTECTED METHODS ****************** ****************** ******************				/**		 * Add Events at the momment that it is added to the stage		 * @param e:Event		 * 		 */		protected function addedToStageHandler(e:Event):void{						//touch events			if (this.gestureInput == "gestouch") {				panGesture = new PanGesture(target.parent);				panGesture.maxNumTouchesRequired = 1;				if (this._direction == this.HORIZONTAL) {					panGesture.direction = PanGestureDirection.HORIZONTAL;				} else if (this._direction == this.VERTICAL) {					panGesture.direction = PanGestureDirection.VERTICAL;				}			}						//add listeners			addEvents();		}				/**		 * Add Scroll Event Listeners		 * 		 */		protected function addEvents():void {						switch (this.gestureInput) {				case "native":					target.parent.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);								target.parent.addEventListener(TransformGestureEvent.GESTURE_PAN, handlePan);					break;								case "gestouch":					panGesture.addEventListener(GestureEvent.GESTURE_BEGAN, gesturePanBegan);					panGesture.addEventListener(GestureEvent.GESTURE_CHANGED, gesturePanChange);					panGesture.addEventListener(GestureEvent.GESTURE_ENDED, gesturePanEnd);					break;			}		}				/**		 * Remove Scroll Event Listeners		 * 		 */		protected function removeEvents():void {						switch (this.gestureInput) {				case "native":					target.parent.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);								target.parent.removeEventListener(TransformGestureEvent.GESTURE_PAN, handlePan);					break;								case "gestouch":					panGesture.removeEventListener(GestureEvent.GESTURE_BEGAN, gesturePanBegan);					panGesture.removeEventListener(GestureEvent.GESTURE_CHANGED, gesturePanChange);					panGesture.removeEventListener(GestureEvent.GESTURE_ENDED, gesturePanEnd);					break;			}		}				protected function gesturePanBegan(event:GestureEvent):void {			var panGesture:PanGesture = event.target as PanGesture;						this.removeEventListener(Event.ENTER_FRAME, throwObject);			TweenMax.killChildTweensOf(this);			if (roll) roll.alpha = 1;			if (track) track.alpha = 1;						if (_speed.x * -panGesture.offsetX <= 0) _speed.x = 0;			if (_speed.y * -panGesture.offsetY <= 0) _speed.y = 0;						//dispatch event			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"begin",_target.x, _target.y, _speed.x, _speed.y));					}				protected function gesturePanChange(event:GestureEvent):void {						var panGesture:PanGesture = event.target as PanGesture;						switch (panGesture.direction) {				case PanGestureDirection.HORIZONTAL:					_target.x += panGesture.offsetX;					if (roll) roll.x = -_target.x / _ratePageX;					_speed.x = panGesture.offsetX;					break;								case PanGestureDirection.VERTICAL:					_target.y += panGesture.offsetY;					if (roll) roll.y = -_target.y / _ratePageY;					_speed.y = panGesture.offsetY;					break;								default:					_target.x += panGesture.offsetX;					_target.y += panGesture.offsetY;					if (roll) roll.x = -_target.x / _ratePageX;					if (roll) roll.y = -_target.y / _ratePageY;					_speed.x = panGesture.offsetX;					_speed.y = panGesture.offsetY;					break;								}						event.stopImmediatePropagation();									this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"update",_target.x, _target.y, _speed.x, _speed.y));		}				protected function gesturePanEnd(event:GestureEvent):void {						if (_speed.x == 0 && _speed.y == 0) {				if (roll) TweenMax.to(roll,.3,{alpha:0,delay:.4});				if (track) TweenMax.to(track,.3,{alpha:0,delay:.6});			}						this.addEventListener(Event.ENTER_FRAME, throwObject);			this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"start", _target.x, _target.y, _speed.x, _speed.y));		}				/**		 * Manage MouseDown Event		 *  		 * @param event:Event		 * 		 */		protected function handleMouseDown(event:MouseEvent):void {			_speed.y = 0;			_speed.x = 0;			tweenComplete();						//dispatch event			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"stop", _target.x, _target.y));		}				/**		 * Manage Pan Gesture Event		 * 		 * @param e:transformGestureEvent		 * 		 */		protected function handlePan(e:TransformGestureEvent):void {			//1.			switch (direction) {								case "vertical":					if (DeviceInfo.os() != "Mac") {						_target.y += 2 * (e.offsetY);						if (roll) roll.y = _target.y / _ratePageY;					} else {						_target.y -= 2 * (e.offsetY);						if (roll) {							if (roll.y >= 0) {								roll.y = -_target.y / _ratePageY;							}						}					}					break;												case "horizontal":					if (DeviceInfo.os() != "Mac") {						_target.x += 2 * (e.offsetX);						if (roll) roll.x = _target.x / _ratePageX;					} else {						_target.x -= 2 * (e.offsetX);						if (roll) roll.x = -_target.x / _ratePageX;					}					break;												case "both":					if (DeviceInfo.os() != "Mac") {												_target.x += 2 * (e.offsetX);						_target.y += 2 * (e.offsetY);											if (roll) roll.x = _target.x / _ratePageX;						if (roll) roll.y = _target.y / _ratePageY;											} else {												_target.x -= 2 * (e.offsetX);						_target.y -= 2 * (e.offsetY);												if (roll) roll.x = -_target.x / _ratePageX;						if (roll) roll.y = -_target.y / _ratePageY;					}					break;							}						//2. Event Phases			switch (e.phase) {								case "begin":					this.removeEventListener(Event.ENTER_FRAME, throwObject);					TweenMax.killChildTweensOf(this);					if (roll) roll.alpha = 1;					if (track) track.alpha = 1;										if (_speed.x * -e.offsetX <= 0) _speed.x = 0;					if (_speed.y * -e.offsetY <= 0) _speed.y = 0;										//dispatch event					this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,e.phase,_target.x, _target.y, _speed.x, _speed.y));										break;								case "update":					this.removeEventListener(Event.ENTER_FRAME, throwObject);										if (DeviceInfo.os() != "Mac") {						_speed.x += e.offsetX;						_speed.y += e.offsetY;					} else {												if (e.offsetX == 0) {							_speed.x = 0;						} else {							_speed.x -= e.offsetX;						}												if (e.offsetY == 0) {							_speed.y = 0;						} else {							_speed.y -= e.offsetY;						}												//dispatch event						this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,e.phase,_target.x, _target.y, _speed.x, _speed.y));					}										break;								case "end":					//target.parent.mouseChildren = false;					this.addEventListener(Event.ENTER_FRAME, throwObject);					this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"start", _target.x, _target.y, _speed.x, _speed.y));					break;			}					}				//****************** PUBLIC METHODS ****************** ****************** ******************				/**		 * 		 * 		 */		public function update():void {			//_hMax = _mask.height;			//_wMax = _mask.width;		}				//****************** PRIVATE METHODS ****************** ****************** ******************				/**		 * Rate Page: Calculate the page rate.		 * 		 * <p>For VERTICAL direction, it divides the TARGET HEIGHT by MASK HEIGHT.</p>		 * <p>For HORIZONTAL direction, it divides TARGET WIDTH by MASK WIDTH.</p>		 * 		 * <p>It automatically calls scrollSize function.</p>		 */		private function ratePage():void {						switch (direction) {				case "vertical":					_ratePageY = _target.height / _mask.height;					break;								case "horizontal":					_ratePageX = _target.width / _mask.width;					break;								case "both":					_ratePageX = _target.width / _mask.width;					_ratePageY = _target.height / _mask.height;					break;			}						scrollSize();		}				/**		 * Scroll Size: Resize roll and track.		 * 		 * <p>For VERTICAL direction, TRACK heiht is resized to match hMax and ROLL height is resized to match hMax/ratePage</p> 		 * <p>For HORIZONTAL direction, TRACK width is resized to match wMax and ROLL width is resized to match wMax/ratePage</p>		 * 		 */		private function scrollSize():void {						switch (direction) {				case "vertical":					if (roll) roll.height = _hMax / _ratePageY;					if (track) track.height = _hMax;					break;								case "horizontal":					if (roll) roll.width = _wMax / _ratePageX;					if (track) track.height = _wMax;					break;								case "both":										if (roll) {						roll.width = _wMax / _ratePageX;						roll.height = _hMax / _ratePageY;					}										if (track) {						track.height = _wMax;						track.height = _hMax;					}					break;			}		}				/**		 * ThrowObject handles the inertia movement. It keeps the scroll momevent after the user stop the interaction.		 * It uses friction to slower movement. I also test the boundaries and does not allow the target goes beyond the limits.		 * @param e:Event		 * 		 */		private function throwObject(e:Event):void {								//test boundaries - Horizontally				if (direction == "both" || direction == "horizontal") {										if (_target.x > 0 + offset) {						TweenMax.to(_target, .3, {x:0 + offset, onUpdate:disptachEnertiaUpdate});						if (roll)TweenMax.to(roll, .3, {x:0});						_speed.x = 0;					} else if (_target.x < -_target.width + _wMax) {						TweenMax.to(_target, .3, {x:-_target.width + _wMax, onUpdate:disptachEnertiaUpdate});						if (roll)TweenMax.to(roll, .3, {x:_wMax - roll.width});						_speed.x = 0;					} else {						//move						_target.x += _speed.x;						if (roll) roll.x += - _speed.x/_ratePageX;												//apply friction						_speed.x *= friction;												//limit inertia												if (_speed.x > -.88 && _speed.x < .88) {							_speed.x = 0;						}					}								}								//test boundaries - vertically				if (direction == "both" || direction == "vertical") {										if (_target.y > 0 + offset) {						TweenMax.to(_target, .3, {y:0 + offset, onUpdate:disptachEnertiaUpdate});						if (roll)TweenMax.to(roll, .3, {y:0});						_speed.y = 0;					} else if (_target.y < -_target.height + _hMax) {						TweenMax.to(_target, .3, {y:-_target.height + _hMax, onUpdate:disptachEnertiaUpdate});						if (roll)TweenMax.to(roll, .3, {y:_hMax - roll.height});						_speed.y = 0;					} else {						//move						_target.y += _speed.y;						if (roll) roll.y += - _speed.y/_ratePageY;												//apply friction						_speed.y *= friction;												//limit inertia						if (_speed.y > -.88 && _speed.y < .88) {							_speed.y = 0;						}											}									}							if (_speed.x == 0 && _speed.y == 0) {				//end inertia				this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"end", _target.x, _target.y, _speed.x, _speed.y));				this.removeEventListener(Event.ENTER_FRAME, throwObject);				tweenComplete();			} else {				//update inertia				this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"update", _target.x, _target.y, _speed.x, _speed.y));			}		}				private function disptachEnertiaUpdate():void {			this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"update", _target.x, _target.y, _speed.x, _speed.y));		}				/**		 *  TweenComplete listen to the end of movement and set the scroll to its static condition.		 * 		 */		private function tweenComplete():void {			this.removeEventListener(Event.ENTER_FRAME, throwObject);			//_mask.disableBitmapMode();			this.parent.mouseChildren = true;			if (roll) TweenMax.to(roll, .3, {alpha:0, delay: .6});			if (track) TweenMax.to(track, .3, {alpha:0, delay: .4});						//dispatch event			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,"stop", _target.x, _target.y));		}						//****************** GETTERS ****************** ****************** ******************				/**		 * 		 * @return 		 * 		 */		public function get enable():Boolean {			return _enable;		}				/**		 * 		 * @return 		 * 		 */		public function get gestureInput():String {			return _gestureInput;		}				/**		 * 		 * @return 		 * 		 */		public function get friction():Number {			return _friction;		}				/**		 * Target. Returns the current scroll target. 		 * @return 		 * 		 */		public function get target():Sprite {			return _target;		}				/**		 * Direction. Returns the current scroll direction. 		 * @return 		 * 		 */		public function get direction():String {			return _direction;		}				/**		 * Offset. Returns the current offset used in the scroll.		 * @return Number		 * 		 */		public function get offset():Number {			return _offset;		}				/**		 * 		 * @return 		 * 		 */		public function get hasRoll():Boolean {			return _hasRoll;		}				/**		 * 		 * @return 		 * 		 */		public function get hasTrack():Boolean {			return _hasTrack;		}				/**		 * Color. Returns the current color used on Roll and Track objects. 		 * @return uint		 * 		 */		public function get color():uint {			return _color;		}				/**		 * getRatePage. Returns the current page rate in the scroll.		 * @return 		 * 		 */		public function getRatePageX():Number {			return _ratePageX;		}				/**		 * getRatePage. Returns the current page rate in the scroll.		 * @return 		 * 		 */		public function getRatePageY():Number {			return _ratePageY;		}				/**		 * Roll Visible. Get Roll visibility		 * @param value		 * 		 */		public function get rollVisible():Boolean {			return roll.visible;		}				//****************** SETTERS ****************** ****************** ******************				/**		 * 		 * @param value		 * 		 */		public function set enable(value:Boolean):void {			_enable = value;						if (!_enable) {				removeEvents();			} else {				addEvents();			}					}				/**		 * 		 * @param value		 * 		 */		public function set gestureInput(value:String):void {			_gestureInput = value;		}				/**		 * 		 * @param value		 * 		 */		public function set friction(value:Number):void {			_friction = value;		}				/**		 * Set scroll direction.		 * 		 * <p>Values: "vertical" or "horizontal".</p> 		 * <p>Default: "vertical".</p>		 * 		 * @param value:String		 * 		 */		public function set direction(value:String):void {			_direction = value;		}				/**		 * Set offset position where the scroll is an relation to the target's parent.		 * 		 * @param value:Number		 * 		 */		public function set offset(value:Number):void {			_offset = value;		}				/**		 * 		 * @param value		 * 		 */		public function set hasRoll(value:Boolean):void {			_hasRoll = value;		}				/**		 * 		 * @param value		 * 		 */		public function set hasTrack(value:Boolean):void {			_hasTrack = value;		}				/**		 * Define Roll and Track colors.		 *  		 * @param value:uint		 * 		 */		public function set color(value:uint):void {			_color = value;		}				/**		 * Target: Set scroll target. 		 * 		 * <p>It automatically calls ratePage function if mask is set.</p>		 * 		 * @param value:Sprite		 * 		 */		public function set target(value:Sprite):void {			_target = value;						if (_mask != null) ratePage();			}				/**		 * Roll Visible. Sel Roll visibility		 * @param value		 * 		 */		public function set rollVisible(value:Boolean):void {			roll.visible = value;		}				/**		 * Mask: Set shape to mask the target.		 * 		 * <p>In VERTICAL direction, MASK height defines hMax.</p>		 * <p>In HORIZONTAL direction, MASK width defines wMax.</p>		 * 		 * <p>It automatically calls ratePage function if target is set.</p>		 *  		 * @param value:Sprite		 * 		 */		public function set maskContainer(value:Sprite):void {			_mask = value;						switch (direction) {				case "vertical":					_hMax = _mask.height;					break;								case "horizontal":					_wMax = _mask.width;					break;								case "both":					_hMax = _mask.height;					_wMax = _mask.width;			}						if (_target != null) ratePage();					}			}}

