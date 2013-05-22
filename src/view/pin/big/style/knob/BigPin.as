package view.pin.big.style.knob {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	import controller.WorkflowController;
	
	import events.WorkflowEvent;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.TapGesture;
	
	import settings.Settings;
	
	import view.pin.PinView;
	import view.pin.Star;
	import view.pin.big.AbstractBigPin;
	import view.pin.big.AbstractPanel;
	import view.pin.big.PanelFactory;
	import view.pin.big.style.knob.panels.PinControlPanel;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class BigPin extends AbstractBigPin {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var window					:Window
		
		protected var _historyPanel				:AbstractPanel;					//History panel for the big view
		protected var historyPanelOpen			:Boolean = false;
		
		protected var knob						:Knob;
		
		protected var bigPinTap					:TapGesture;
		protected var bigPinLongPress			:LongPressGesture;
		
		protected var style						:int = 2;
		
		
		//****************** Constructor ****************** ******************  ******************		
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		public function BigPin(pin:PinView) {
			super(pin);
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		override public function init():void {
			
			//add the control panel
			_pinControlPanel = PanelFactory.addPanel(target.getController(),"control");
			target.addChildAt(_pinControlPanel,0);
			
			//add windows
			window = new Window(target.getController(),style);
			window.init(target.id);
			target.addChildAt(window,0);
			
			//add info Panel to window
			_infoPanel = PanelFactory.addPanel(target.getController(),"info");
			window.addPanel(_infoPanel);
			
			//add history
			_historyPanel = PanelFactory.addPanel(target.getController(),"history");
			window.addPanel(_historyPanel);
			
			//star
			if(!target.tagged) {
				var color:uint = 0xFFFFFF;
				if (target.currentFlag.color == color) color = 0x666666;
				
				target.star = new Star(target.shapeSize,color);
				target.addChild(target.star);
				
			} else {
				TweenMax.to(target.star,2,{alpha:1});
			}
			
			
			//change shape
			drawShape();
			
			
			//animation
			
			
			switch (style) {
				case 1:
					window.x = - window.hMax/2;
					window.y = - window.vMax - (_pinControlPanel.height/2) - 10;
					TweenMax.from(window,2,{y:- window.height, alpha:0, delay: 1, ease:Back.easeOut});
					break;
				
				case 2:
					window.x = _pinControlPanel.width/4;
					window.y = - _pinControlPanel.height/2
					TweenMax.from(window,2,{x:0, alpha:0, delay: 1, ease:Back.easeOut});
					break;	
			}
			
			//TweenMax.from(target.shape,2,{width:45, height:45, onUpdate:alignPanels});
			TweenMax.to(target.star,2,{width:45, height:45, ease:Back.easeOut, onUpdate:alignPanels});
			TweenMax.from(_pinControlPanel,2,{scaleX:0, scaleY:0, ease:Back.easeOut, onComplete:addKnob});
			
			
			//Modify Interaction behavior
			//listeners
			if (Settings.platformTarget == "mobile") {
				
				bigPinTap = new TapGesture(target.shape);
				bigPinTap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, biPinTapEvent);
				
				bigPinLongPress = new LongPressGesture(target.shape);
				bigPinLongPress.addEventListener(GestureEvent.GESTURE_BEGAN, bigPinLongPressBeganEvent);
				
			} else {
				//_pinControlPanel.addEventListener(MouseEvent.CLICK, controlPanelClick);
				target.shape.addEventListener(MouseEvent.CLICK, tagIt);
			}
			
		}			
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get historyPanel():AbstractPanel {
			return _historyPanel;
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		protected function addKnob():void {
			//knob
			knob = new Knob(50, 50, "outter");
			knob.stylePathAlpha = 0;
			knob.styleHandleAlpha = 0;
			
			if (knob.type == "outter") knob.styleHandleSize = 90;
			
			target.addChild(knob);
			knob.init();
			
			//Get control and its data
			var pinControlPanel:PinControlPanel = _pinControlPanel as PinControlPanel;
			var numOptions:int = pinControlPanel.getOptionsNum();
			var controlCurrentPosition:int = pinControlPanel.getIndexPosition(target.currentFlag.name);
			var rotation:Number = (controlCurrentPosition/numOptions)*360;
			
			switch (knob.type) {
				
				case "inner":
					TweenMax.to(knob,2,{shortRotation:{value:rotation}, delay:1, ease:Back.easeOut});
					TweenMax.to(target.shape,2,{shortRotation:{rotation:rotation}, delay:1, ease:Back.easeOut});
					break;
					
				case "outter":
					//rotation CCW
					rotation = (rotation - 360) * -1;
					TweenMax.to(_pinControlPanel,2,{shortRotation:{rotation:rotation}, ease:Back.easeOut});
					break;
			}
			
			//listerner
			knob.addEventListener(TouchEvent.TOUCH_BEGIN, knobTouchBegin);
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function knobShape(active:Boolean):void {
			
			if (active) {
				drawShape()
			} else {
				//circle
				target.shape.graphics.clear();
				target.shape.graphics.lineStyle(1,0x333333,1,false,"none");
				target.shape.graphics.beginFill(target.currentFlag.color);
				target.shape.graphics.drawCircle(0,0,target.shapeSize);
				target.shape.graphics.endFill();
				target.shape.blendMode = "multiply";
			}
			
		}
		
		override public function drawShape():void {
			target.shape.graphics.clear();
			target.shape.graphics.beginFill(target.currentFlag.color,1);
			target.shape.graphics.lineStyle(1.6907050609588623,5000268);
			target.shape.graphics.moveTo(10,-48);
			target.shape.graphics.lineTo(0,-63);
			target.shape.graphics.lineTo(-10,-48);
			target.shape.graphics.cubicCurveTo(-32,-43,-48,-23,-48,0);
			target.shape.graphics.cubicCurveTo(-48,26,-26,48,0,48);
			target.shape.graphics.cubicCurveTo(27,48,49,26,49,0);
			target.shape.graphics.cubicCurveTo(49,-24,32,-43,10,-48);
			target.shape.graphics.endFill();
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function alignPanels():void {
			
			//get bounds
			var outsideBounds:Rectangle = target.getRect(target.parent);
			var offset:int = 35;
			var diff:Number;
			
			var params:Object = new Object();
			
			//top 
			if (outsideBounds.y < offset) params.y = target.y - outsideBounds.y + offset;
			
			//left
			if (outsideBounds.x < offset) params.x = target.x - outsideBounds.x + offset;
			
			//right
			if (outsideBounds.x + outsideBounds.width > target.stage.stageWidth - offset) {
				diff = (outsideBounds.x + outsideBounds.width) - target.stage.stageWidth + offset;
				params.x = target.x - diff;
			}
			
			//bottom
			if (outsideBounds.y + outsideBounds.height > target.stage.stageHeight) {
				diff = (outsideBounds.y + outsideBounds.height) - target.stage.stageHeight + offset;
				params.y = target.y - diff;
			}
			
			
			//animation
			TweenMax.to(target,1,params);
			
		}
		
		
		//****************** EVENTS ****************** ******************  ****************** 
		
		protected function knobChange(event:Event):void {
			
			//Get control and its data
			var pinControlPanel:PinControlPanel = _pinControlPanel as PinControlPanel;
			var startAngle:Number = pinControlPanel.startAngle;
			var numOptions:int = pinControlPanel.getOptionsNum();
			var optionRange:Number = 360/numOptions;
			
			var poinintTo:Number;
			
			switch (knob.type) {
				case "inner":
					// rotate knob
					target.shape.rotation = knob.value;
					
					//highlight
					poinintTo = Math.floor((knob.value-startAngle)/optionRange);
					if (poinintTo > numOptions - 1) poinintTo = 0;
					pinControlPanel.highlightOption(poinintTo);
					
					break;
				
				case "outter":
					//rotate control panel based on the touch pivor point.
					_pinControlPanel.rotation += knob.value - knob.getPivotPoint();
					
					//get current rotation
					var rotationValue:Number = _pinControlPanel.rotation;
					if (rotationValue < 0) rotationValue = 360 + rotationValue;
					
					//because the logic is counter-clockwise, we have to transform it back to the clockwise reference
					var rotationValueCW:Number = (rotationValue - 360) * -1;
					
					//highlight
					poinintTo = Math.floor((rotationValueCW-startAngle)/optionRange);
					if (poinintTo > numOptions - 1) poinintTo = 0;
					pinControlPanel.highlightOption(poinintTo);
					
					break;
			}
			
		}
		
		
		//****************** EVENTS GESTURE/TOUCH ****************** ******************  ******************
		
		protected function biPinTapEvent(event:GestureEvent):void {
			target.tagged = !target.tagged;
			target.star.active = target.tagged;
			
			//send to model
			WorkflowController(target.getController()).tagPin(target.id,target.tagged);
		}	
		
		protected function bigPinLongPressBeganEvent(event:GestureEvent):void {
			target.closeBigView();
		}
		
		protected function knobTouchBegin(event:TouchEvent):void {
			knob.addEventListener(TouchEvent.TOUCH_END, knobTouchEnd);
			knob.addEventListener(Event.CHANGE, knobChange);
		}
		
		protected function knobTouchEnd(event:TouchEvent):void {
			
			//Get control and its data
			var pinControlPanel:PinControlPanel = _pinControlPanel as PinControlPanel;
			
			var startAngle:Number = pinControlPanel.startAngle;
			var numOptions:int = pinControlPanel.getOptionsNum();
			var optionRange:Number = 360/numOptions;
			
			//define values
			var newPosition:Number;
			var rotation:Number;
			var optionLabel:String;
			
			switch (knob.type) {
				case "inner":
					
					//new position
					newPosition = Math.floor((knob.value-startAngle)/optionRange);
					
					//not greater than possible
					if (newPosition > numOptions - 1) newPosition = 0;
					
					//new control position
					rotation = (newPosition/numOptions)*360;
					
					pinControlPanel.highlightOption(-1); // remove highlight
					
					//new
					optionLabel = pinControlPanel.getSliceById(newPosition).flag.name;
					
					//animations - save after
					TweenMax.to(knob,.5,{shortRotation:{value:rotation}, ease:Back.easeOut});
					TweenMax.to(target.shape,.5,{shortRotation:{rotation:rotation}, ease:Back.easeOut, onComplete:saveOption, onCompleteParams:[optionLabel]});
					
					break;
				
				case "outter":
					
					//get current rotation
					var rotationValue:Number = _pinControlPanel.rotation;
					if (rotationValue < 0) rotationValue = 360 + rotationValue;
					
					//because the logic is counter-clockwise, we have to transform it back to the clockwise reference
					var rotationValueCW:Number = (rotationValue - 360) * -1;
					
					//new position
					newPosition = Math.floor((rotationValueCW-startAngle)/optionRange);
					
					//not greater than possible
					if (newPosition > numOptions - 1) newPosition = 0;
					
					//new control position
					rotation = (newPosition/numOptions)*360;
					
					//rotation CCW
					rotation = (rotation - 360) * -1;
					
					pinControlPanel.highlightOption(-1); // remove highlight
					
					//new
					optionLabel = pinControlPanel.getSliceById(newPosition).flag.name;
					
					//animations - save after
					TweenMax.to(_pinControlPanel,.5,{shortRotation:{rotation:rotation}, ease:Back.easeOut, onComplete:saveOption, onCompleteParams:[optionLabel]});
					
					break;
			
			}
			
			
		}
		
		protected function saveOption(optionLabel):void {
			//trace ("save")
			WorkflowController(target.getController()).updatePinFlag(target.id, optionLabel);
		}

				
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		override public function close():void {
			
			if (Settings.platformTarget == "mobile") {
				bigPinTap.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, biPinTapEvent);
				bigPinTap = null;
				bigPinLongPress.removeEventListener(GestureEvent.GESTURE_BEGAN, bigPinLongPressBeganEvent);
				bigPinLongPress = null;
			} else {
				target.shape.removeEventListener(MouseEvent.CLICK, tagIt);
			}
			
			//Add behavior
			
			
			//knob off
			knobShape(false);
			target.removeChild(knob);
			
			//anim
			TweenMax.to(target,2,{x:target.originalPosition.x, y:target.originalPosition.y, ease:Back.easeOut});
			TweenMax.to(target.shape,2,{width:target.shapeSize*2, height:target.shapeSize*2, ease:Back.easeOut});
			
			//star
			if(target.tagged) {
				TweenMax.to(target.star,2,{width:target.shapeSize*2, height:target.shapeSize*2, alpha:.5, ease:Back.easeOut});
			} else {
				target.removeChild(target.star)
			}
			
			//remove panels
			
			TweenMax.to(_pinControlPanel,1,{scaleX:0, scaleY:0, onComplete:removeItem, onCompleteParams:[_pinControlPanel]});
			TweenMax.to(window,.4,{y:- _infoPanel.height, alpha:0, onComplete:removeItem, onCompleteParams:[window]});
			
			//change status
			target.changeStatus("deselected");
			
			//Dispatch Event
			var data:Object = {};
			data.id = target.id;
			data.status = target.status;
			
			target.dispatchEvent(new WorkflowEvent(WorkflowEvent.SELECT, data, target.status));
			
		}

	}
}