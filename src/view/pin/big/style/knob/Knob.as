package view.pin.big.style.knob {

	//imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import settings.Settings;

	/**
	 * @author Luciano Frizzera (lucaju@gmail.com) [Base on Romuald Quantin's work (romu@soundstep.com)]
	 */
	public class Knob extends Sprite {

		//****************** Properties ****************** ******************  ****************** 
		
		protected var _radiusX					:Number;
		protected var _radiusY					:Number;
		protected var _handler					:DisplayObject;
		protected var _sector					:Sector;
		
		protected var _stylePathColor			:uint = 0xCCCCCC;
		protected var _stylePathAlpha			:Number = 1;
		protected var _stylePathThickness		:Number = 0;
		
		protected var _styleHandleSize			:Number = 20;
		protected var _styleHandleColor			:uint = 0xFFFFFF;
		protected var _styleHandleAlpha			:Number = .3;
		
		protected var _type						:String							//Knob type: inner, outter;
		protected var _pivotPoint				:Number = 0;
		
		
		//****************** Constructor ****************** ******************  ****************** 

		/**
		 * 
		 * @param radiusX
		 * @param radiusY
		 * @param handler
		 * 
		 */
		public function Knob(radiusX:Number = 100, radiusY:Number = 100, type:String = "inner") {
			_type = type;
			setRadius(radiusX, radiusY);
		}
		
		//****************** INITIALIZE ****************** ******************  ******************
		
		public function init(handler:DisplayObject = null):void {
			setHandler(handler);
			updatePositionFromDegree(-90);
		}
		
		//****************** PRIVATE METHODS ****************** ******************  ****************** 

		private function setRadius(radiusX:Number, radiusY:Number):void {
			_radiusX = radiusX;
			_radiusY = radiusY;
			if (!_sector) _sector = new Sector(0, _radiusX, _radiusY);
			draw();
			updatePosition();
		}

		private function setHandler(value:DisplayObject):void {
			disposeDragabble();
			_handler = (!value) ? createNewHandler() : value;
			setHandlerListeners();
			addChild(_handler);
			updatePosition();
		}

		private function setHandlerListeners():void {
			
			if (Settings.platformTarget == "mobile") {
				_handler.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			} else {
				_handler.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}

		private function removeHandlerListeners():void {
			if (Settings.platformTarget == "mobile") {
				_handler.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
				this.parent.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
				this.parent.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
				//stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			} else {
				_handler.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			}
		}

		private function mouseLeaveHandler(event:Event):void {
			stopDragging();
		}

		private function mouseDownHandler(event:MouseEvent):void {
			startDragging();
		}
		
		private function touchBeginHandler(event:TouchEvent):void {
			setPivotPoint(event.stageX, event.stageY);
			startDragging();
		}

		private function mouseUpHandler(event:MouseEvent):void {
			stopDragging();
		}
		
		private function touchEndHandler(event:TouchEvent):void {
			stopDragging();
		}

		private function startDragging():void {
			if (Settings.platformTarget == "mobile") {
				this.parent.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
				this.parent.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
				this.parent.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
				this.parent.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
				//stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
				//stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
				stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			}
			
		}

		private function stopDragging():void {
			if (Settings.platformTarget == "mobile") {
				this.parent.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
				this.parent.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
				//stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			}
			
		}

		private function mouseMoveHandler(event:MouseEvent):void {
			updatePosition();
		}
		
		private function touchMoveHandler(event:TouchEvent):void {
			updateTouchPosition(event.stageX, event.stageY);
		}

		private function updatePosition():void {
			var ratio:Number = _radiusX / _radiusY;
			var angle:Number = Math.atan2(mouseX, mouseY);
			updatePositionFromDegree(90 - (Math.atan2(Math.sin(angle), Math.cos(angle) * ratio)) * (180 / Math.PI));
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function updateTouchPosition(touchX:Number, touchY:Number):void {
			
			var localPoint:Point = this.parent.globalToLocal(new Point(touchX,touchY));
			
			var ratio:Number = _radiusX / _radiusY;
			var angle:Number = Math.atan2(localPoint.x, localPoint.y);
			updatePositionFromDegree(90 - (Math.atan2(Math.sin(angle), Math.cos(angle) * ratio)) * (180 / Math.PI));
			dispatchEvent(new Event(Event.CHANGE));
			
			setPivotPoint(touchX, touchY);
		}

		private function updatePositionFromDegree(value:Number):void {
			_sector.degree = value;
			_sector.radiusX = _radiusX;
			_sector.radiusY = _radiusY;
			if (_handler) {
				if (type == "inner") {
					_handler.x = _sector.x;
					_handler.y = _sector.y;
				}
			}
		}

		private function createNewHandler():DisplayObject {
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(_styleHandleColor,_styleHandleAlpha);
			circle.graphics.drawCircle(0, 0, _styleHandleSize);
			
			if (type == "outter") {
				circle.graphics.drawCircle(0, 0, _styleHandleSize * .55);
			}
			
			return circle;
		}

		private function draw():void {
			graphics.clear();
			graphics.lineStyle(_stylePathThickness, _stylePathColor, _stylePathAlpha);
			graphics.moveTo(_sector.x, _sector.y);
			var i:Number = 0;
			var l:Number = 360;
			for (; i <= l; ++i) {
				_sector.degree = i;
				_sector.radiusX = _radiusX;
				_sector.radiusY = _radiusY;
				graphics.lineTo(_sector.x, _sector.y);
			}
			graphics.endFill();
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ******************
		
		public function disposeDragabble():void {
			if (!_handler) return;
			removeHandlerListeners();
			if (_handler.hasOwnProperty("dispose")) {
				_handler['dispose']();
			}
			removeChild(_handler);
			_handler = null;
		}
		
		public function dispose():void {
			disposeDragabble();
			_sector = null;
		}
		
		public function changeHandlerRotation(value:Number):void {
			_handler.rotation = value
		}
		
		public function setPivotPoint(touchX:Number, touchY:Number):void {
			var localPoint:Point = this.parent.globalToLocal(new Point(touchX,touchY));
			
			var ratio:Number = _radiusX / _radiusY;
			var angle:Number = Math.atan2(localPoint.x, localPoint.y);
			_pivotPoint = 90 - (Math.atan2(Math.sin(angle), Math.cos(angle) * ratio)) * (180 / Math.PI)
			
		}
		
		public function getPivotPoint():Number {
			return _pivotPoint + 90;
		}
		
		//****************** GETTERS AND SETTERS ****************** ******************  ****************** 

		public function get radiusX():Number {
			return _radiusX;
		}

		public function set radiusX(value:Number):void {
			setRadius(value, _radiusY);
		}

		public function get radiusY():Number {
			return _radiusY;
		}

		public function set radiusY(value:Number):void {
			setRadius(_radiusX, value);
		}

		public function get handler():DisplayObject {
			return _handler;
		}

		public function set handler(value:DisplayObject):void {
			setHandler(value);
		}

		public function get value():Number {
			return _sector.degree + 90;
		}

		public function set value(value:Number):void {
			updatePositionFromDegree(value - 90);
		}

		public function get valuePercent():Number {
			return value / 360;
		}

		public function set valuePercent(value:Number):void {
			this.value = 360 * Math.min(1, Math.max(0, value));
		}

		public function get stylePathColor():uint {
			return _stylePathColor;
		}

		public function set stylePathColor(value:uint):void {
			_stylePathColor = value;
			draw();
		}

		public function get stylePathAlpha():Number {
			return _stylePathAlpha;
		}

		public function set stylePathAlpha(value:Number):void {
			_stylePathAlpha = value;
			draw();
		}

		public function get stylePathThickness():Number {
			return _stylePathThickness;
		}

		public function set stylePathThickness(value:Number):void {
			_stylePathThickness = value;
			draw();
		}

		public function get styleHandleSize():Number
		{
			return _styleHandleSize;
		}

		public function set styleHandleSize(value:Number):void {
			_styleHandleSize = value;
		}

		public function get styleHandleColor():uint {
			return _styleHandleColor;
		}

		public function set styleHandleColor(value:uint):void {
			_styleHandleColor = value;
		}

		public function get styleHandleAlpha():Number {
			return _styleHandleAlpha;
		}

		public function set styleHandleAlpha(value:Number):void {
			_styleHandleAlpha = value;
		}
		
		public function get type():String {
			return _type;
		}


	}
}

class Sector {

	public var degree:Number;
	public var radiusX:Number;
	public var radiusY:Number;

	public function Sector(degree:Number = 0, radiusX:Number = 10, radiusY:Number = 10) {
		this.degree = degree;
		this.radiusX = radiusX;
		this.radiusY = radiusY;
	}

	public function get x():Number {
		return radiusX * Math.cos(degree * Math.PI / 180);
	}

	public function get y():Number {
		return radiusY * Math.sin(degree * Math.PI / 180);
	}

	public function toString():String {
		return "[Sector] degree: " + degree + ", radiusX: " + radiusX + ", radiusY: " + radiusY + ", x: " + x + ", y: " + y;
	}
}
