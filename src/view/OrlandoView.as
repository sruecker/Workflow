package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.AbstractDoc;
	import model.AbstractStep;
	
	import mvc.AbstractView;
	import mvc.IController;
	import mvc.Observable;
	
	public class OrlandoView extends AbstractView {
		
		//properties
		static public var workflowController:WorkflowController				//controller
		
		private var stepCollection:Array;								//Collection of StepView
		private var groupCollection:Array;								//Collection of GroupsView
		private var pinCollection:Array;								//Collection of PinsView
		private var balloonCollection:Array;							//collection of ballons
		
		private var stepView:StepView;									//Gerneric StepView
		private var groupView:GroupView;								//Gerneric GroupView
		private var pinView:PinView;									//Gerneric PinView
		private var balloon:BalloonView										//Balloon
		
		private var lines:Sprite;										//line connection
		
		internal var slot:int = 180;									//Horizontal Slot
		internal var xPos:int = 50;										//Initial Horizonal Postition
		internal var yPos:int = 325;									//Initial Vertical Position
		
		private var stepHit:StepView;
		
		
		/**
		 * Contructor
		 **/
		public function OrlandoView(c:IController) {
			
			
			super(c);
			
			workflowController = WorkflowController(c);
			
		}
		
		public function init():void {
			
			//init
			
			stepCollection = new Array();
			groupCollection = new Array();
			pinCollection = new Array();
			
			
			//listenter
			workflowController.addEventListener(OrlandoEvent.UPDATE_STEP, updateStep);
			workflowController.addEventListener(OrlandoEvent.UPDATE_PIN, updatePin);
			workflowController.addEventListener(OrlandoEvent.KILL_BALLOON, removeBalloon);
			
			//get structure data
			generateSteps(workflowController.getStepsData());
			
		}
		
		/**
		 * Returns the default controller for this view.
		 */
		/*
		override public function defaultController (model:Observable):IController {
			return new WorkflowController(model);
		}
		*/
		
		/**
		 * Generate all the steps view in the screen.
		 * 1. Steps
		 * 2. Groups
		 * 3. Line connections
		 */
		
		private function generateSteps(data:Array):void {
			
			for (var i:int = 0; i< data.length; i++) {
				
				//create step view and pass the information
				stepView = new StepView(workflowController, data[i]);
				
				//add step view to a collection
				stepCollection.push(stepView)
				
				//add to screen
				addChildAt(stepView,0);
				stepView.cacheAsBitmap;
				
				//------positioning
				
				//general
				if (stepView.level >= 0) {
					stepView.y = yPos;
					stepView.x = xPos + (stepView.level * slot);
					
					//enhance
					if (stepView.level == 6) {
						stepView.y = yPos + slot;
						stepView.x = xPos + ((stepView.level-1) * slot);
					}
					
					//out of sequence
				} else {
					stepView.y = 10;
					stepView.x = 1100 - ((stepView.level*-1) * slot);
				}
				
				//clear
				stepView = null;
			}
			
			//get group data
			generateGroups(workflowController.getGroupsData());
		}
		
	
		/**
		 * Group Generator
		 * 
		 * @param	name	lenght - lenght of group collection 
		 */
		private function generateGroups(data:Array):void {
			
			for (var i:int = 0; i < data.length; i++) {
				
				
				//create step view and pass the information
				groupView = new GroupView(workflowController, data[i]);
				
				//add stepviews to the group
				for each(var s:StepView in stepCollection) {
					if(s.group == data[i].id) {
						groupView.addStep(s);
					}
				}
				
				//add step view to a collection
				groupCollection.push(groupView)
				
				//add to screen
				//addChildAt(groupView,0);
				addChildAt(groupView,0);
				
				//position
				groupView.x = xPos + (groupView.level * slot) - 15;
				
				//create UI
				groupView.createUI(yPos);
				
				
			}
			
			
			//draw lines
			lineGen();
		}
		
		
		/**
		 * Line Conection Generator
		 * 
		 **/
		private function lineGen():void {
			lines = new Sprite();
			lines.x = xPos + 50;
			lines.y = yPos + 50;
			
			lines.graphics.lineStyle(10,0xCCCCCC,0.3);
			lines.graphics.beginFill(0xFFFFFF);
			lines.graphics.lineTo(885,0);
			lines.graphics.lineTo(885,180);
			lines.graphics.lineTo(700,180);
			lines.graphics.lineTo(700,0);
			lines.graphics.endFill();
			
			lines.blendMode = "multiply";
			
			addChildAt(lines,0);
			
			
			//get pin data
			generatePins(workflowController.getPinsData());
		}
		
		
		/**
		 * Generate all the pins view on the screen.
		 */
		
		private function generatePins(data:Array):void {
		
			for (var i:int = 0; i< data.length; i++) {
				
				//create pin view and pass the information
				pinView = new PinView(data[i].id);
				pinView.actualFlag = data[i].actualFlag
				pinView.tagged = data[i].isTagged;
				pinView.actualStep = data[i].actualStep;
				pinView.init();
				
				//add pin view to a collection
				pinCollection.push(pinView);
				
				//add to screen
				addChild(pinView);
				
				
				//------Pin position and step count box
				for each(var item:StepView in stepCollection) {
					if (item.acronym.toLowerCase() == data[i].actualStep) {
						var info:Object = item.getPositionForPin();
						
						//random position inside the step active area.
						var xR:Number = info.x + pinView.width/2 + (Math.random() * (info.width - pinView.width));
						var yR:Number = info.y + pinView.height/2 + (Math.random() * (info.height - pinView.height));
						
						pinView.x = xR;
						pinView.y = yR;
						
						//animation
						//and
						//change the counbox in the step just on the start of the animation
						TweenMax.from(pinView,1.5,{alpha:0, scaleX:0, scaleY:0, delay:2+(i*.15), ease:Back.easeOut, onStart: workflowController.addPinToStep, onStartParams: [pinView.id, item.id]});
						//TweenMax.from(pinView,2,{x:-100, y:350, delay:2+(i*.2), ease:Back.easeOut, onStart: workflowController.addPinToStep, onStartParams: [pinView.id, item.id]});
						//TweenMax.from(pinView,2,{scaleX:50, scaleY:50, alpha:0, delay:2+(i*.2), ease:Bounce.easeOut, onStart: workflowController.addPinToStep, onStartParams: [pinView.id, item.id]});
						//TweenMax.from(pinView,2,{z:-1000, alpha:0, delay:2+(i*.2), ease:Bounce.easeOut, onStart: workflowController.addPinToStep, onStartParams: [pinView.id, item.id]});
						//TweenMax.from(pinView,2,{x:info.x + pinView.width/2, y:info.y + pinView.height/2, alpha:0, delay:2+(i*.2), ease:Back.easeOut, onStart: workflowController.addPinToStep, onStartParams: [pinView.id, item.id]});
						
						//step count box
						//change the counbox in the step
						//workflowController.addPinToStep(pinView.id, item.id);
						
						break;
					}
				}
			
			}
			
			//animation
			initMainAnimation();
			
		}
		
		/**
		 * Initial Animation
		 * 
		 **/
		private function initMainAnimation():void {
			//animationt
			TweenMax.allFrom(stepCollection,2,{alpha:0},.05);
			TweenMax.allFrom(groupCollection,1,{alpha:0},.1);
			TweenMax.from(lines,1.5,{alpha:0});
		}
		
		
		/**
		 * Create Baloon
		 * 
		 **/
		public function createBalloon(info:Object):void {
			
			//start balloon collection if it is not set already
			if(!balloonCollection) {
				balloonCollection = new Array();
			}
			
			//create an instace of a balloon
			balloon = new BalloonView(workflowController, info.id);
			
			balloonCollection.push(balloon);
			addChild(balloon);
			
			balloon.initialize(info);
		}
		
		//change balloon layer
		public function changeLayer(target:Sprite):void {
			this.setChildIndex(target, this.numChildren-1);
		}
		
		public function removeBalloon(e:OrlandoEvent):void {
			
			//get balloon
			for (var i:int = 0; i< balloonCollection.length; i++) {
				
				
				if (balloonCollection[i].id == e.id) {
					
					balloon = balloonCollection[i];
					
					//evaluate vertical
					var orig:Number;
					switch (balloon.arrowDirection) {
						case "bottom":
							orig = balloon.y + 20;
							break
						
						case "top":
							orig = balloon.y - 20;
							break;
					}
					//animation
					TweenMax.to(balloon, 1, {y: orig, alpha: 0, onComplete:removeItem, onCompleteParams:[balloon]});
					
					//remove from the list
					balloonCollection.splice(i,1);
					
					//deactive ballon in pin
					getPinById(balloon.id).balloonActive = false;
					
					break;
				}
			}
			
			
		}
		
		internal function removeItem(item:DisplayObject):void {
			//remove from the screen
			removeChild(item);
		}
		
		public function getStepById(id:int):StepView {
			for each(stepView in stepCollection) {
				if (stepView.id == id) {
					return stepView;
					break;
				}
			}
			return null;
		}
		
		public function getPinById(id:int):PinView {
			for each(pinView in pinCollection) {
				if (pinView.id == id) {
					return pinView;
					break;
				}
			}
			
			return null;
		}
		
		
		public function hitTest(item:PinView):void {
			item.addEventListener(Event.ENTER_FRAME, hitTester);
		}
		
		private function hitTester(e:Event):void {
			pinView = PinView(e.target);
			var hitter:StepView;
			
			for each(stepView in stepCollection) {
				if(pinView.hitTestObject(stepView)) {
					if (stepView.acronym.toLowerCase() != pinView.actualStep.toLowerCase()) {
						stepView.highlight(15);
						hitter = stepView;
					}
				} else {
					stepView.highlight(5);
				}	
			}
			
			if(!hitter) {
				stepHit = null;
			} else {
				stepHit = hitter;
			}
		}
		
		public function hitTestEnd(pin:PinView):void {
			pin.removeEventListener(Event.ENTER_FRAME, hitTester);
			
			// pin return to the origin
			if (stepHit == null) {
				TweenMax.to(pin,1,{x:pin.originalPosition.x, y:pin.originalPosition.y, ease:Back.easeOut});
			} else {
				workflowController.changePinLocation(pin.id, stepHit.id);
				stepHit.highlight(5);
			}
			
			stepHit = null
		}

		private function updateStep(e:OrlandoEvent):void {
			var step:AbstractStep = AbstractStep(e.data);
			stepView = getStepById(step.id);
			
			//update countbox
			stepView.updateCounter(step.docCount);
		}
		
		private function updatePin(e:OrlandoEvent):void {
			var doc:AbstractDoc = AbstractDoc(e.data);
			pinView = getPinById(doc.id);
			
			//update flag
			pinView.flag = doc.actualFlag;
			
			//test if step was changed
			var history:Array = doc.history;
			trace (history[history.length-1].step)
			if(history[history.length-1].step != history[history.length-2].step) {

				//update actual step
				pinView.actualStep = doc.actualStep;
				
				//position
				for each(var item:StepView in stepCollection) {
					if (item.acronym.toLowerCase() == pinView.actualStep) {
						var info:Object = item.getPositionForPin();
						
						//random position inside the step active area.
						var xR:Number = info.x + pinView.width/2 + (Math.random() * (info.width - pinView.width));
						var yR:Number = info.y + pinView.height/2 + (Math.random() * (info.height - pinView.height));
						
						TweenMax.to(pinView,3,{x:xR, y:yR, ease:Back.easeOut});
						
						break;
					}
				}
			
			}
			
		}
	}
}