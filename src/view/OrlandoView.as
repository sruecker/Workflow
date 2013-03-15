package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import model.AbstractDoc;
	import model.AbstractStep;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	public class OrlandoView extends AbstractView {
		
		//properties
		static public var workflowController:WorkflowController				//controller
		
		private var stepCollection:Array;								//Collection of StepView
		private var groupCollection:Array;								//Collection of GroupsView
		private var pinCollection:Array;								//Collection of PinsView
		private var balloonCollection:Array;							//collection of ballons
		
		private var stepsContainer:Sprite;								//**
		private var stepsSuperContainer:Sprite;							//**
		private var stepsSize:Object;
		private var stepView:StepView;									//Gerneric StepView
		
		private var groupView:GroupView;								//Gerneric GroupView
		private var pinView:PinView;									//Gerneric PinView
		private var pinList:PinList;									//PinList
		private var balloon:BalloonView									//Balloon
		
		private var lines:Sprite;										//line connection
		
		internal var slot:int = 150;									//Horizontal Slot
		internal var xPos:int = 150;									//Initial Horizonal Postition
		internal var yPos:int = 325;									//Initial Vertical Position
		
		private var stepHit:StepView;
		private var stepHitInside:Boolean;
		
		private var regiPoint:Point;
		
		private var actualScale:Number = 1;
		private var minScale:Number = 1;
		private var maxScale:Number = 6;
		
		/**
		 * Contructor
		 **/
		public function OrlandoView(c:IController) {
			
			
			super(c);
			
			workflowController = WorkflowController(c);
			
		}
		
		public function init():void {
			
			if (DeviceInfo.os() != "Mac") {
				slot = 300;
				xPos = 300;
				yPos = 650;
			}
			
			//base
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			//init
			yPos = this.stage.stageHeight/2;
			
			stepCollection = new Array();
			groupCollection = new Array();
			pinCollection = new Array();
			
			
			//listenter
			workflowController.addEventListener(OrlandoEvent.UPDATE_STEP, updateStep);
			workflowController.addEventListener(OrlandoEvent.UPDATE_PIN, updatePin);
			workflowController.addEventListener(OrlandoEvent.KILL_BALLOON, removeBalloon);
			workflowController.addEventListener(OrlandoEvent.ACTIVATE_PIN, activatePin);
			
			//get structure data
			stepsSuperContainer = new Sprite();//*
			stepsContainer = new Sprite();  //*
			stepsSuperContainer.addChild(stepsContainer)//*
			addChild(stepsSuperContainer);  //*
			
			generateSteps(workflowController.getStepsData());
			
			//get group data
			generateGroups(workflowController.getGroupsData());
			
			//draw lines
			lineGen();
			
			//get pin data
			generatePins(workflowController.getPinsData());
			
			//Pin List
			pinList = new PinList();
			addChild(pinList);
			pinList.initialize(workflowController.getPinsData());
				
			//registration
			regiPoint = new Point(stage.stageWidth/2, stage.stageHeight);
			
			//*
			
			
			stepsContainer.x = -stepsContainer.width/2;
			stepsContainer.y = -stepsContainer.height/2;
			
			stepsSuperContainer.x = stepsSuperContainer.width/2;
			stepsSuperContainer.y = stepsSuperContainer.height/2;
			
			stepsSize = {w:stepsSuperContainer.width, h:stepsSuperContainer.height};
			
			//
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			this.addEventListener(TransformGestureEvent.GESTURE_PAN, pan);
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
				
				
				if (DeviceInfo.os() != "Mac") { 
					stepView.scaleX = stepView.scaleY = 2;
				}
					
				//add to screen
				stepsContainer.addChildAt(stepView,0);   //**
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
					stepView.y = 20;
					stepView.x = this.stage.stageWidth - ((stepView.level*-1) * slot);
						
				}
				
				//clear
				stepView = null;
			}
			
			
			
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
				stepsContainer.addChildAt(groupView,0);
				
				//position
				groupView.x = xPos + (groupView.level * slot) - 15;
				
				//create UI
				groupView.createUI(yPos);
				
				
			}
			
		}
		
		
		/**
		 * Line Conection Generator
		 * 
		 **/
		private function lineGen():void {
			lines = new Sprite();
			
			
			if (DeviceInfo.os() != "Mac") { 
				
				lines.x = xPos + 100;
				lines.y = yPos + 100;
				
				lines.graphics.lineStyle(20,0xCCCCCC,0.3);
				lines.graphics.beginFill(0xFFFFFF);
				lines.graphics.lineTo(1480,0);
				lines.graphics.lineTo(1480,300);
				lines.graphics.lineTo(1180,300);
				lines.graphics.lineTo(1180,0);
				
			} else {
				
				lines.x = xPos + 50;
				lines.y = yPos + 50;
				
				lines.graphics.lineStyle(10,0xCCCCCC,0.3);
				lines.graphics.beginFill(0xFFFFFF);
				lines.graphics.lineTo(740,0);
				lines.graphics.lineTo(740,150);
				lines.graphics.lineTo(590,150);
				lines.graphics.lineTo(590,0);
			}
			
			
			lines.graphics.endFill();
			
			
			
			lines.blendMode = "multiply";
			
			stepsContainer.addChildAt(lines,0);
			
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
				
				
				if (DeviceInfo.os() != "Mac") { 
					pinView.scaleX = pinView.scaleY = 2;
				}
				
				//add pin view to a collection
				pinCollection.push(pinView);
				
				//add to screen
				addChild(pinView);
				
				
				//------Pin position and step count box
				for each(var item:StepView in stepCollection) {
					if (item.acronym.toLowerCase() == data[i].actualStep) {
						var info:Object = item.getPositionForPin();
						
						if (DeviceInfo.os() != "Mac") { 
							info.width = info.width * 2;
							info.height = info.height * 2;
						}
						
						var ratioX:Number = Math.random(); // **
						var ratioY:Number = Math.random(); // **
						
						pinView.ratioPos = {w:ratioX, h:ratioY};
						
						//random position inside the step active area.
						var xR:Number = info.x + pinView.width/2 + (ratioX * ((info.width) - pinView.width));
						var yR:Number = info.y + pinView.height/2 + (ratioY * (info.height - pinView.height));
						
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
			
			if (DeviceInfo.os() != "Mac") { 
				balloon.scaleX = balloon.scaleY = 2;
			}
			
			balloonCollection.push(balloon);
			addChild(balloon);
			
			balloon.initialize(info);
			
			//send event to the list
			var data:Object = new Object();
			data.source = "workflow";
			data.action = "single";
			data.selected = true;
			data.controlView = false;
			
			workflowController.activatePin(info.id,data);
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
			
			//send event to the list
			var data:Object = new Object();
			data.source = "workflow";
			data.action = "single";
			data.selected = false;
			data.controlView = false;
			
			workflowController.activatePin(e.id,data);
			
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
		
		public function getPinInTheList(id:int):PinView {
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
			stepHitInside = false;			
			var hitter:StepView;
			
			for each(stepView in stepCollection) {
				if(pinView.hitTestObject(stepView)) {
					
					if (stepView.acronym.toLowerCase() == pinView.actualStep.toLowerCase()) {
						stepHitInside = true;
					} else {
						stepHitInside = false;
						stepView.highlight(15);
					}
					
					hitter = stepView;
					
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
				if (!stepHitInside) {
					workflowController.changePinLocation(pin.id, stepHit.id);
					stepHit.highlight(5);
				}
			}
			
			//reset variables;
			stepHit = null;
			stepHitInside = false;
		}

		private function updateStep(e:OrlandoEvent):void {
			var step:AbstractStep = AbstractStep(e.data);
			stepView = getStepById(step.id);
			
			//update countbox
			stepView.updateCounter(step.docCount);
		}
		
		private function updatePin(e:OrlandoEvent):void {
			
			
			var doc:AbstractDoc = AbstractDoc(e.data);
			
			//in the workflow
			pinView = getPinById(doc.id);
			
			//in the list
			var itemList:PinListItem = pinList.getItemById(doc.id);
			
			//update flag
			pinView.flag = doc.actualFlag;
			itemList.flag = doc.actualFlag;
			
			//test if step was changed
			var history:Array = doc.history;
			
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
		
		private function activatePin(e:OrlandoEvent):void {
			
			var data:Object = Object(e.data);
			
			
			//from the list to the workflow
			if (data.source == "list") {
				
				pinView = getPinById(e.id);
				
				if (data.action == "single") {
					
					if (pinView.bigView) {
						pinView.closeBigView();
					} else {
						pinView.onSingleClick();
					}
					
				} else if (data.action == "double" && !data.controlView) {
					pinView.closeBigView();
				} else if (data.action == "double" && data.controlView) {
					pinView.onDoubleClick();
				}
			}
			
			//from the workflow to the list
			if (data.source == "workflow") {
				var itemList:PinListItem = pinList.getItemById(e.id);
				itemList.changeStatus(data);
			}
			
		}
		
		private function zoom(e:TransformGestureEvent):void {
			
			if (!(e.target is PinListItem) || !(e.target is PinList)) {
			
				//scale
				stepsSuperContainer.scaleX *= e.scaleX;
				stepsSuperContainer.scaleY *= e.scaleY;
				
				actualScale = stepsSuperContainer.scaleX;
				
				//limit zoom
				if (e.phase == "end") {
					if (stepsSuperContainer.scaleX < minScale || stepsSuperContainer.scaleY < minScale) {
						TweenMax.to(stepsSuperContainer,.5,{x:stepsSize.w/2, y:stepsSize.h/2, scaleX:minScale, scaleY:minScale, onUpdate:scalePins});
						actualScale = minScale;
					} else if (stepsSuperContainer.scaleX > maxScale || stepsSuperContainer.scaleY > maxScale) {
						TweenMax.to(stepsSuperContainer,.5,{x:stepsSize.w/2, y:stepsSize.h/2, scaleX:maxScale, scaleY:maxScale, onUpdate:scalePins});
						actualScale = maxScale;
					}
				}
				
				//change steps appearance
				changeStepsAppearence(actualScale);
				
				//pan
				pan(e);
			}
		
		}
		
		private function pan(e:TransformGestureEvent):void { 
			
			
			
			if (!(e.target is PinListItem) || !(e.target is PinList)) {
			
				//scale pins
				if (actualScale != 1) {
					scalePins();
				}
					
				if (stepsSuperContainer.scaleX > minScale) {
				
					if (stepsSuperContainer.x - (stepsSuperContainer.width/2) > 0) {
						
						stepsSuperContainer.x = stepsSuperContainer.width/2 ;
						
					} else if (stepsSuperContainer.x + (stepsSuperContainer.width/2) < 500) {
						
						stepsSuperContainer.x = (-stepsSuperContainer.width/2) + 500;
						
					} else {
						
						if (DeviceInfo.os() != "Mac") {
							stepsSuperContainer.x += 2 * e.offsetX;
						} else {
							stepsSuperContainer.x -= 2 * e.offsetX;
						}
						
					}
					
					if (stepsSuperContainer.y - (stepsSuperContainer.height/2) > 0) {
						
						stepsSuperContainer.y = stepsSuperContainer.height/2 ;
						
					} else if (stepsSuperContainer.y + (stepsSuperContainer.height/2) < 640) {
						
						stepsSuperContainer.y = (-stepsSuperContainer.height/2) + 640 ;
						
					} else {
						
						if (DeviceInfo.os() != "Mac") {
							stepsSuperContainer.y += 2 * e.offsetY;
						} else {
							stepsSuperContainer.y -= 2 * e.offsetY;
						}
						
					}
				
				}
			}
			
		}
		
		private function scalePins():void {
			for each(pinView in pinCollection) {
				/*
				var pLocal:Point = new Point(pinView.x,pinView.y)
				var pGlobal:Point = stepsSuperContainer.localToGlobal(pLocal);
				
				pinView.x = pGlobal.x - stepsSuperContainer.width/2;
				pinView.y = pGlobal.y - stepsSuperContainer.height/2;
				
				trace (pLocal,pGlobal)
				*/
				
				
				//------Pin position and step count box
				for each(var item:StepView in stepCollection) {
					if (item.acronym.toLowerCase() == pinView.actualStep) {
						var info:Object = item.getPositionForPin();
						
						if (DeviceInfo.os() != "Mac") { 
							info.width = info.width * 2;
							info.height = info.height * 2;
						}
						
						var ration:Object = pinView.ratioPos;
						var xR:Number = info.x + pinView.width/2 + (ration.w * (info.width - pinView.width));
						var yR:Number = info.y + pinView.height/2 + (ration.h * (info.height - pinView.height));
						
						var pLocal:Point = new Point(xR,yR)
						var pGlobal:Point = stepsSuperContainer.localToGlobal(pLocal);
						
						pinView.x = pGlobal.x - (stepsSuperContainer.width/2);
						pinView.y = pGlobal.y - (stepsSuperContainer.height/2);
						
						break;
					}
				}
				
			}	
			
		}
	
		private function changeStepsAppearence(scale:Number):void {
			
			for each(stepView in stepCollection) {
				stepView.changeView(scale);
			}
		}
	
	}
}