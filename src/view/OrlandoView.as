package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.TweenProxy;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import model.DocumentModel;
	import model.GroupModel;
	import model.StepModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.list.PinList;
	import view.list.PinListItem;
	import view.pin.PinView;
	import view.step.GroupView;
	import view.step.StepView;
	import view.tooltip.ToolTipManager;
	import view.util.scroll.Scroll;
	import view.util.scroll.ScrollEvent;
	
	public class OrlandoView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var stepCollection				:Array;				//Collection of StepView
		protected var groupCollection				:Array;				//Collection of GroupsView
		protected var pinCollection					:Array;				//Collection of PinsView
		
		protected var stepsContainer				:Sprite;			//**
		protected var stepsSuperContainer			:Sprite;			//**
		protected var workflowContainerSize			:Object;
		
		protected var pinList						:PinList;			//PinList
		protected var toolTipManager				:ToolTipManager;
		
		protected var scroll						:Scroll;
		
		protected var scrolledArea					:Sprite;
		protected var shapeContainer				:Sprite;
		protected var containerMask					:Sprite;
		
		protected var connectionLines				:Sprite;			//line connection
		
		protected var slot							:int = 150;			//Horizontal Slot
		protected var xPos							:int = 150;			//Initial Horizonal Postition
		protected var yPos							:int = 325;			//Initial Vertical Position
		
		protected var stepHit						:StepView;
		protected var stepHitInside					:Boolean;
		
		private var currentScale					:Number = 1;
		private var minScale						:Number = 1;
		private var maxScale						:Number = 6;
		
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param c
		 * 
		 */
		public function OrlandoView(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//Get controller
			var wController:WorkflowController = this.getController() as WorkflowController;
			
			//Space and position if iPhone
			if (DeviceInfo.os() != "Mac") {
				slot = 300;
				xPos = 300;
				yPos = 650;
			}
			
			//base Background
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			//initials
			yPos = this.stage.stageHeight/2;
			stepCollection = new Array();
			groupCollection = new Array();
			pinCollection = new Array();
			
			//Containers
			stepsSuperContainer = new Sprite();//*
			stepsSuperContainer.graphics.beginFill(0xFFFFFF,0);
			stepsSuperContainer.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			stepsSuperContainer.graphics.endFill();
			this.addChild(stepsSuperContainer);  //*
			
			stepsContainer = new Sprite();  //*
			stepsSuperContainer.addChild(stepsContainer)//*
			
			
			//get structure data
			generateSteps(wController.getStepCollection());
			
			//get group data
			generateGroups(wController.getGroupCollection());
			
			//draw lines
			lineGen();
			
			//get pin data
			generatePins(wController.getPinsData());
			
			//Pin List
			pinList = new PinList(this.getController());
			addChild(pinList);
			pinList.initialize(wController.getPinsData());
			
			
			workflowContainerSize = {w:stepsSuperContainer.width, h:stepsSuperContainer.height};
			
			//tooltip
			toolTipManager = new ToolTipManager(this);
			this.addEventListener(Event.CLEAR, toolTipClear);
			
			//scroll system
			//mask for container
			containerMask = new Sprite();
			containerMask.graphics.beginFill(0xFFFFFF,0);
			containerMask.graphics.drawRect(stepsSuperContainer.x, stepsSuperContainer.y, this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(containerMask);
			stepsSuperContainer.mask = containerMask
			
			//add scroll system
			scroll = new Scroll();
			scroll.direction = "both";
			scroll.target = stepsContainer;
			scroll.maskContainer = containerMask;
			scroll.friction = .9;
			this.addChild(scroll);
			scroll.init();
			
			//listenter
			wController.getModel("data").addEventListener(OrlandoEvent.UPDATE_PIN, updatePin);
			wController.getModel("structure").addEventListener(OrlandoEvent.UPDATE_STEP, updateStep);
			pinList.addEventListener(OrlandoEvent.SELECT_PIN, pinListSelect);
			stepsSuperContainer.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			this.addEventListener(ScrollEvent.SCROLL, scalePins);
			this.addEventListener(ScrollEvent.INERTIA, scalePins);
		}		
		
		
		//****************** PRIVATE METHODS - BUILD ****************** ****************** ******************
		
		/**
		 * Generate all steps view.
		 * 1. Steps
		 * 2. Groups
		 * 3. Line connections
		 *  
		 * @param data
		 * 
		 */
		private function generateSteps(data:Array):void {
			
			var stepView:StepView;
			
			//loop
			for each (var stepMoldel:StepModel in data) {
				
				//create new step view
				stepView = new StepView(this.getController(), stepMoldel);
				stepCollection.push(stepView);
				
				stepsContainer.addChildAt(stepView,0); 
				stepView.cacheAsBitmap;
				
				//scale if iphone
				if (DeviceInfo.os() != "Mac") { 
					stepView.scaleX = stepView.scaleY = 2;
				}
				
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
				
			}
			
		}
		
		/**
		 * Group Generator
		 *  
		 * @param data
		 * 
		 */
		private function generateGroups(data:Array):void {
			
			var groupView:GroupView;
			
			//loop
			for each (var groupModel:GroupModel in data) {
				
				//create groupView
				groupView = new GroupView(this.getController(), groupModel);
				groupCollection.push(groupView)
				stepsContainer.addChildAt(groupView,0);
				
				//add stepView to the group
				for each(var s:StepView in stepCollection) {
					if(s.group == groupModel.id) {
						groupView.addStep(s);
					}
				}
				
				//position
				groupView.x = xPos + (groupView.level * slot) - 15;
				
				//create UI
				groupView.init(yPos);
			}
			
		}
		
		/**
		 * Line Conection Generator
		 * 
		 **/
		private function lineGen():void {
			
			connectionLines = new Sprite();
			
			if (DeviceInfo.os() != "Mac") { 
				
				connectionLines.x = xPos + 100;
				connectionLines.y = yPos + 100;
				
				connectionLines.graphics.lineStyle(20,0xCCCCCC,0.3);
				connectionLines.graphics.beginFill(0xFFFFFF);
				connectionLines.graphics.lineTo(1480,0);
				connectionLines.graphics.lineTo(1480,300);
				connectionLines.graphics.lineTo(1180,300);
				connectionLines.graphics.lineTo(1180,0);
				
			} else {
				
				connectionLines.x = xPos + 50;
				connectionLines.y = yPos + 50;
				
				connectionLines.graphics.lineStyle(10,0xCCCCCC,0.3);
				connectionLines.graphics.beginFill(0xFFFFFF);
				connectionLines.graphics.lineTo(740,0);
				connectionLines.graphics.lineTo(740,150);
				connectionLines.graphics.lineTo(590,150);
				connectionLines.graphics.lineTo(590,0);
			}
			
			
			connectionLines.graphics.endFill();
			
			connectionLines.blendMode = "multiply";
			stepsContainer.addChildAt(connectionLines,0);
		}
		
		/**
		 * Generate pins.
		 *  
		 * @param data
		 * 
		 */
		private function generatePins(data:Array):void {
		
			var pinView:PinView;
			var i:int = 0;
			
			//loop
			for each(var doc:DocumentModel in data) {
				
				//create pin view
				pinView = new PinView(this.getController(), doc.id);
				pinView.currentFlag = doc.currentStatus;
				pinView.tagged = doc.isTagged;
				pinView.currentStep = doc.currentStep;
				
				this.addChild(pinView);
				pinView.init();
				
				pinCollection.push(pinView);
				
				//listeners
				pinView.addEventListener(OrlandoEvent.DRAG_PIN, hitTest);
				pinView.addEventListener(OrlandoEvent.SELECT_PIN, clickPin);
				
				//------Pin position and step count box
				var stepBounds:Rectangle;
				
				for each(var sp:StepView in stepCollection) {
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
			
			//animation
			initMainAnimation();
			
		}
		
		/**
		 * Initial Animation
		 * 
		 **/
		private function initMainAnimation():void {
			TweenMax.allFrom(stepCollection,2,{alpha:0},.05);
			TweenMax.allFrom(groupCollection,1,{alpha:0},.1);
			TweenMax.from(connectionLines,1.5,{alpha:0});
		}
		
		
		//****************** EVENTS - TOOLTIP ****************** ****************** ******************
		
		/**
		 * Add or remove tooltip depending on the pinView status
		 * 
		 * @param pin
		 * @param status
		 * 
		 */
		protected function manageToolTip(pin:PinView, status:String):void {
			
			switch (status) {
				case "deselected":
					ToolTipManager.removeToolTip(pin.id);
					break;
				
				case "selected":  //add Tooltip
					
					if (!ToolTipManager.hasToolTip(pin.id)) {
						var obj:Object = new Object();
						obj.position = new Point(pin.x,pin.y);
						obj.source = pin;
						obj.id = pin.id;
						obj.info = WorkflowController(this.getController()).getPinTitle(pin.id);
						
						ToolTipManager.addToolTip(obj);
					} else {
						ToolTipManager.sendToFront(pin.id);
					}
					
					break;
				
				case "edit":
					ToolTipManager.removeToolTip(pin.id);
					break;
			}
			
		}
		
		/**
		 * Remove all tooltips
		 *  
		 * @param event
		 * 
		 */
		protected function toolTipClear(event:Event):void {
			for each (var pin:PinView in pinCollection) {
				if (pin.status == "selected") {
					pin.changeStatus("deselected");
					pinList.changePinStatus(pin.id, "deselected");
				}
			}
			
		}
		
		
		//****************** EVENTS - PIN & PINLIST ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function clickPin(event:OrlandoEvent):void {
			var pin:PinView = event.target as PinView;

			this.setChildIndex(pin, this.numChildren-1);			
			pinList.changePinStatus(event.data.id, event.data.status);
			manageToolTip(pin, event.target.status);
			
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinListSelect(event:OrlandoEvent):void {
			var pin:PinView = this.getPinById(event.data.id);
			
			this.setChildIndex(pin, this.numChildren-1);
			pin.changeStatus(event.data.status);
			manageToolTip(pin, event.data.status);
		}
		
		
		//****************** EVENT - HIT TEST ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function hitTest(event:OrlandoEvent):void {
			if (event.phase == "end") {
				hitTestEnd(event.target as PinView);
			} else {
				hitTester(event.target as PinView);
			}
		}
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		protected function hitTester(pin:PinView):void {
			
			stepHitInside = false;			
			var hitter:StepView;
			
			for each(var stepView:StepView in stepCollection) {
				if(pin.hitTestObject(stepView)) {
					
					if (stepView.acronym.toLowerCase() == pin.currentStep.toLowerCase()) {
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
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		protected function hitTestEnd(pin:PinView):void {
			
			if (stepHit == null) { // pin return to the origin
				TweenMax.to(pin,1,{x:pin.originalPosition.x, y:pin.originalPosition.y, ease:Back.easeOut});
			} else {
				
				if (!stepHitInside) { // pin Change step
					WorkflowController(this.getController()).changePinLocation(pin.id, stepHit.id);
					stepHit.highlight(5);
				} else {
					pin.updatePosition();
					//position - new Ratio
					var sp:StepView = this.getStepByAcronym(pin.currentStep);
					var stepActiveBounds:Rectangle = sp.getPositionForPin();
					
					var globalP:Point = new Point(pin.x, pin.y); 
					var localP:Point = sp.globalToLocal(globalP);
					
					var xR:Number = localP.x/stepActiveBounds.width;
					var yR:Number = localP.y/stepActiveBounds.height;
					
					pin.ratioPos = {w:xR, h:yR}	
				}
				
			}
			
			//reset variables;
			stepHit = null;
			stepHitInside = false;
		}

		private function updateStep(e:OrlandoEvent):void {
			var step:StepModel = StepModel(e.data.step);
			var stepView:StepView = getStepById(step.id);
			
			//update countbox
			stepView.updateCounter(step.docCount);
		}
		
		
		//****************** EVENT - ACTION ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updatePin(event:OrlandoEvent):void {
			
			var doc:DocumentModel = event.data.document as DocumentModel;
			
			//get targets
			var pin:PinView = getPinById(doc.id);
			var itemList:PinListItem = pinList.getItemById(doc.id);
			
			//update flag
			pin.flag = doc.currentStatus;
			itemList.flag = doc.currentStatus;
			
			//test if step was changed
			var history:Array = doc.history;
			
			if(history[history.length-1].step != history[history.length-2].step) {

				//update current step
				pin.currentStep = doc.currentStep;
				
				//position - new Ratio
				var sp:StepView = this.getStepByAcronym(pin.currentStep);
				var stepActiveBounds:Rectangle = sp.getPositionForPin();
				
				var globalP:Point = new Point(pin.x, pin.y); 
				var localP:Point = sp.globalToLocal(globalP);
				
				var xR:Number = localP.x/stepActiveBounds.width;
				var yR:Number = localP.y/stepActiveBounds.height;
				
				pin.ratioPos = {w:xR, h:yR}	
				
			}
			
		}
		
		
		//****************** EVENT - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function zoom(event:TransformGestureEvent):void {
			
			var myProxy:TweenProxy = TweenProxy.create(stepsContainer);	
			var currentScale:Number;;
			
			switch (event.phase) {
				
				case "begin":
					myProxy.registration = new Point(event.stageX, event.stageY);
					currentScale = myProxy.scale;
					break;
				
				case "update":
					myProxy.scale *= event.scaleX;
					currentScale = myProxy.scale;
					scalePins();
					break;
				
				case "end":
					
					currentScale = myProxy.scale;
					
					//prevent smaller then scale min scale
					if (myProxy.scaleX < minScale) {
						TweenMax.to(myProxy, 1, {scaleX:minScale, scaleY:minScale, onUpdate:scalePins});
						TweenMax.to(stepsContainer, 1, {x:0, y:0});
						currentScale = minScale;
					}
					
					//prevent bigger then scale max scale
					if (myProxy.scaleX > maxScale) {
						TweenMax.to(myProxy, 1, {scaleX:maxScale, scaleY:maxScale, onUpdate:scalePins});
						currentScale = maxScale;
					}
					
					break;
			}
			
			//Step semantic zoom 
			changeStepsAppearence(currentScale);
		}
		
		
		/**
		 * 
		 * 
		 */
		private function scalePins(event:ScrollEvent = null):void {
			
			//trace (event.type, event.phase)
			//trace (event.speedX, event.speedY)
			
			//for each pin
			for each(var pinView:PinView in pinCollection) {
				
				//------Get pin position
				var sp:StepView = this.getStepByAcronym(pinView.currentStep);
				var stepBounds:Rectangle = sp.getPositionForPin();
				
				//iphone
				if (DeviceInfo.os() != "Mac") { 
					stepBounds.width = stepBounds.width * 2;
					stepBounds.height = stepBounds.height * 2;
				}
				
				//calculate relative position
				var pinPosRatio:Object = pinView.ratioPos;
				var xR:Number = stepBounds.x + pinView.width/2 + (pinPosRatio.w * (stepBounds.width - pinView.width));
				var yR:Number = stepBounds.y + pinView.height/2 + (pinPosRatio.h * (stepBounds.height - pinView.height));
				//trace (pinPosRatio.w)
				//transform from local to global
				var pLocal:Point = new Point(xR,yR)
				var pGlobal:Point = stepsContainer.localToGlobal(pLocal);
				
				//new position
				pinView.x = pGlobal.x
				pinView.y = pGlobal.y
				
			}	
			
		}
	
		/**
		 * 
		 * @param scale
		 * 
		 */
		private function changeStepsAppearence(scale:Number):void {
			for each(var stepView:StepView in stepCollection) {
				stepView.semanticZoom(scale);
			}
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStepById(id:int):StepView {
			for each(var stepView:StepView in stepCollection) {
				if (stepView.id == id) {
					return stepView;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getStepByAcronym(value:String):StepView {
			for each(var stepView:StepView in stepCollection) {
				if (stepView.acronym.toLowerCase() == value.toLowerCase()) {
					return stepView;
				}
			}
			return null;
		}
		
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
	
	}
}