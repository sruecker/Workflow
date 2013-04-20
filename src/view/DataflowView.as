package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import model.DocumentModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.pin.PinView;
	import view.structure.StepView;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DataflowView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var pinCollection					:Array;				//Collection of PinsView
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function DataflowView(c:IController) {
			super(c);
			
			//initials
			pinCollection = new Array();
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param stepCollection
		 * 
		 */
		public function init(stepCollection:Array):void {
			
			//get pin data
			generatePins(WorkflowController(this.getController()).getPinsData(),stepCollection);
			
			//Listeners
			this.addEventListener(Event.CLEAR, toolTipCleared);
			this.addEventListener(OrlandoEvent.SELECT_PIN, clickPin);
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
		/**
		 * Generate pins.
		 *  
		 * @param data
		 * 
		 */
		private function generatePins(dataCollection:Array, stepCollecion):void {
			
			var pinView:PinView;
			var i:int = 0;
			
			//loop
			for each(var doc:DocumentModel in dataCollection) {
				
				//create pin view
				pinView = new PinView(this.getController(), doc.id);
				pinView.currentFlag = doc.currentStatus;
				pinView.tagged = doc.isTagged;
				pinView.currentStep = doc.currentStep;
				
				this.addChild(pinView);
				pinView.init();
				
				pinCollection.push(pinView);
				
				//------Pin position and step count box
				var stepBounds:Rectangle;
				
				for each(var sp:StepView in stepCollecion) {
					if (sp.acronym.toLowerCase() == doc.currentStep.toLowerCase()) {
						stepBounds = sp.getPositionForPin();
						break;
					}
				}
				
				//if iphone
				if (DeviceInfo.os() != "Mac") { 
					stepBounds.width = stepBounds.width * 2;
					stepBounds.height = stepBounds.height * 2;
					pinView.scaleX = pinView.scaleY = 2;
				}
				
				var ratioX:Number = Math.random(); // **
				var ratioY:Number = Math.random(); // **
				
				pinView.ratioPos = {w:ratioX, h:ratioY};
				
				//random position inside the step active area.
				var xR:Number = stepBounds.x + pinView.width/2 + (ratioX * (stepBounds.width - pinView.width));
				var yR:Number = stepBounds.y + pinView.height/2 + (ratioY * (stepBounds.height - pinView.height));
				
				pinView.x = xR;
				pinView.y = yR;
				
				//animation
				//and
				//change  counbox in the step just on the start of the animation
				TweenMax.from(pinView,1.5,{alpha:0, scaleX:0, scaleY:0, delay:2+(i*.15), ease:Back.easeOut, onStart: WorkflowController(this.getController()).addPinToStep, onStartParams: [pinView.id, sp.id]});
				//TweenMax.from(pinView,2,{x:-100, y:350, delay:2+(i*.2), ease:Back.easeOut, onStart: WorkflowController(this.getController()).addPinToStep, onStartParams: [pinView.id, item.id]});
				//TweenMax.from(pinView,2,{scaleX:50, scaleY:50, alpha:0, delay:2+(i*.2), ease:Bounce.easeOut, onStart: WorkflowController(this.getController()).addPinToStep, onStartParams: [pinView.id, item.id]});
				//TweenMax.from(pinView,2,{z:-1000, alpha:0, delay:2+(i*.2), ease:Bounce.easeOut, onStart: WorkflowController(this.getController()).addPinToStep, onStartParams: [pinView.id, item.id]});
				//TweenMax.from(pinView,2,{x:info.x + pinView.width/2, y:info.y + pinView.height/2, alpha:0, delay:2+(i*.2), ease:Back.easeOut, onStart: WorkflowController(this.getController()).addPinToStep, onStartParams: [pinView.id, item.id]});
				
				i++;
			}
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function toolTipCleared(event:Event):void {
			for each (var pin:PinView in pinCollection) {
				if (pin.status == "selected") {
					pin.changeStatus("deselected");
				}
			}
			
		}
		
		
		//****************** PUBLIC METHODS - GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinById(id:int):PinView {
			for each(var pinView:PinView in pinCollection) {
				if (pinView.id == id) {
					return pinView;
				}
			}
			return null;
		}
	
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPinCollection():Array {
			return pinCollection;
		}
		
		
		//****************** PUBLIC METHODS - ACTIONS ****************** ****************** ******************
		

		/**
		 * 
		 * @param pin
		 * 
		 */
		public function selectPin(pin:PinView):void {
			this.setChildIndex(pin, this.numChildren-1);
		}
		

		/**
		 * 
		 * @param id
		 * @param data
		 * 
		 */
		public function updatePin(id:int, data:Object):void {
			
			var pin:PinView = getPinById(id);
			
			if (data.flag) pin.flag = data.flag
			if (data.currentStep) pin.currentStep = data.currentStep
			if (data.ratioPos) pin.ratioPos = data.ratioPos;	
			
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function clickPin(event:OrlandoEvent):void {
			selectPin(event.target as PinView)
		}
	
	}
}