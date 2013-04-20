package view {
	
	//import
	import com.greensock.TweenMax;
	import com.greensock.TweenProxy;
	
	import flash.display.Sprite;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import model.GroupModel;
	import model.StepModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.structure.GroupView;
	import view.structure.StepView;
	import view.util.scroll.Scroll;
	import view.util.scroll.ScrollEvent;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var stepCollection				:Array;				//Collection of StepView
		protected var groupCollection				:Array;				//Collection of GroupsView
		
		protected var stepContainer					:Sprite;			//**
		protected var containerMask					:Sprite;
		
		protected var scroll						:Scroll;
		
		protected var connectionLines				:Sprite;			//line connection
		
		protected var slot							:int = 150;			//Horizontal Slot
		protected var xPos							:int = 150;			//Initial Horizonal Postition
		protected var yPos							:int = 325;			//Initial Vertical Position
		
		private var currentScale					:Number = 1;
		private var minScale						:Number = 1;
		private var maxScale						:Number = 6;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function StructureView(c:IController) {
			super(c);
			
			//strar collection
			stepCollection = new Array();
			groupCollection = new Array();
			
			//Space and position if iPhone
			if (DeviceInfo.os() != "Mac") {
				slot = 300;
				xPos = 300;
				yPos = 650;
			}
			
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {

			yPos = this.stage.stageHeight/2;
			
			//Containers
			stepContainer = new Sprite();//*
			stepContainer.graphics.beginFill(0xFFFFFF,0);
			stepContainer.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			stepContainer.graphics.endFill();
			this.addChild(stepContainer);  //*
			
			//get data and start building the layout
			generateSteps(WorkflowController(this.getController()).getStepCollection());
			generateGroups(WorkflowController(this.getController()).getGroupCollection());
			lineGen(); // Draw connections
			
			//scroll system
			//mask for container
			containerMask = new Sprite();
			containerMask.graphics.beginFill(0xFFFFFF,0);
			containerMask.graphics.drawRect(stepContainer.x, stepContainer.y, this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(containerMask);
			stepContainer.mask = containerMask
			
			//add scroll system
			scroll = new Scroll();
			scroll.direction = "both";
			scroll.target = stepContainer;
			scroll.maskContainer = containerMask;
			scroll.friction = .9;
			this.addChild(scroll);
			scroll.init();
			
			//listenter
			WorkflowController(this.getController()).getModel("structure").addEventListener(OrlandoEvent.UPDATE_STEP, updateStep);
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
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
				
				stepContainer.addChildAt(stepView,0); 
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
				stepContainer.addChildAt(groupView,0);
				
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
			stepContainer.addChildAt(connectionLines,0);
		}
		
		
		//****************** PUBLIC METHODS - GETTERS ****************** ****************** ******************
		
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
		 * @return 
		 * 
		 */
		public function getStepCollection():Array {
			return stepCollection.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepContainer():Sprite {
			return stepContainer;
		}
	
	
		//****************** EVENTS - ACTIONS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function updateStep(e:OrlandoEvent):void {
			var step:StepModel = StepModel(e.data.step);
			var stepView:StepView = getStepById(step.id);
			
			//update countbox
			stepView.updateCounter(step.docCount);
		}
		
		
		//****************** EVENTS - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function zoom(event:TransformGestureEvent):void {
			
			var myProxy:TweenProxy = TweenProxy.create(stepContainer);	
			var currentScale:Number;;
			
			switch (event.phase) {
				
				case "begin":
					myProxy.registration = new Point(event.stageX, event.stageY);
					currentScale = myProxy.scale;
					break;
				
				case "update":
					myProxy.scale *= event.scaleX;
					currentScale = myProxy.scale;
					//scalePins();
					break;
				
				case "end":
					
					currentScale = myProxy.scale;
					
					//prevent smaller then scale min scale
					if (myProxy.scaleX < minScale) {
						TweenMax.to(myProxy, 1, {scaleX:minScale, scaleY:minScale, onUpdate:disptachEnertiaUpdate});
						TweenMax.to(stepContainer, 1, {x:0, y:0});
						currentScale = minScale;
					}
					
					//prevent bigger then scale max scale
					if (myProxy.scaleX > maxScale) {
						TweenMax.to(myProxy, 1, {scaleX:maxScale, scaleY:maxScale, onUpdate:disptachEnertiaUpdate})
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
		protected function disptachEnertiaUpdate():void {
			this.dispatchEvent(new ScrollEvent(ScrollEvent.INERTIA,"update", stepContainer.x, stepContainer.y));
		}
		
		/**
		 * 
		 * @param scale
		 * 
		 */
		protected function changeStepsAppearence(scale:Number):void {
			for each(var stepView:StepView in stepCollection) {
				stepView.semanticZoom(scale);
			}
		}	
		
	}
}