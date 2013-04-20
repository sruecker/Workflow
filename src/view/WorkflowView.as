package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import model.DocumentModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.list.PinList;
	import view.list.PinListItem;
	import view.pin.PinView;
	import view.structure.StepView;
	import view.tooltip.ToolTipManager;
	import view.util.scroll.ScrollEvent;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WorkflowView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var structureView					:StructureView;
		protected var dataflowView					:DataflowView;
		
		protected var pinList						:PinList;			
		protected var toolTipManager				:ToolTipManager;
		
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
		public function WorkflowView(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1. Get controller
			var wController:WorkflowController = this.getController() as WorkflowController;
			
			//2. base Background
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			//3. add structure
			structureView = new StructureView(this.getController());
			this.addChild(structureView);
			structureView.init();
			
			//4. add dataflow
			dataflowView = new DataflowView(this.getController());
			this.addChild(dataflowView);
			dataflowView.init(structureView.getStepCollection());
			
			//5. tooltip
			toolTipManager = new ToolTipManager(dataflowView);
			dataflowView.addEventListener(Event.CLEAR, toolTipClear);
			
			//6. Pin List
			pinList = new PinList(this.getController());
			addChild(pinList);
			pinList.initialize(wController.getPinsData());	
			
			//7. listenter
			wController.getModel("data").addEventListener(OrlandoEvent.UPDATE_PIN, updatePin);
			this.addEventListener(ScrollEvent.SCROLL, scalePins);
			this.addEventListener(ScrollEvent.INERTIA, scalePins);
			structureView.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			dataflowView.addEventListener(OrlandoEvent.DRAG_PIN, hitTest);
			dataflowView.addEventListener(OrlandoEvent.SELECT_PIN, clickPin);
			pinList.addEventListener(OrlandoEvent.SELECT_PIN, pinListSelect);
			
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
		 * 
		 * @param event
		 * 
		 */
		protected function toolTipClear(event:Event):void {
			pinList.clearSelection();
		}
		
		
		//****************** EVENTS - PIN & PINLIST ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function clickPin(event:OrlandoEvent):void {
			
			pinList.changePinStatus(event.data.id, event.data.status);
			
			var pin:PinView = dataflowView.getPinById(event.data.id);
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
			var pin:PinView = dataflowView.getPinById(event.data.id);
			
			dataflowView.selectPin(pin)
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
			
			for each(var stepView:StepView in structureView.getStepCollection()) {
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
					pin.updatePosition(pin.x,pin.y);
					//position - new Ratio
					var sp:StepView = structureView.getStepByAcronym(pin.currentStep);
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

		
		//****************** EVENT - ACTION ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updatePin(event:OrlandoEvent):void {
			
			var doc:DocumentModel = event.data.document as DocumentModel;
			
			//update list
			var itemList:PinListItem = pinList.getItemById(doc.id);
			itemList.flag = doc.currentStatus;
			
			//update pin
			var data:Object = new Object();
			data.flag = doc.currentStatus;
			
			//test if step was changed
			var history:Array = doc.history;
			if (history[history.length-1].step != history[history.length-2].step) {

				//save current step
				data.currentStep = doc.currentStep;
				
				//position - new Ratio
				var pin:PinView = dataflowView.getPinById(doc.id);
				var sp:StepView = structureView.getStepByAcronym(pin.currentStep);
				var stepActiveBounds:Rectangle = sp.getPositionForPin();
				
				var globalP:Point = new Point(pin.x, pin.y); 
				var localP:Point = sp.globalToLocal(globalP);
				
				var xR:Number = localP.x/stepActiveBounds.width;
				var yR:Number = localP.y/stepActiveBounds.height;
				
				data.ratioPos = {w:xR, h:yR};
				
			}
			
			//send update to pin
			dataflowView.updatePin(doc.id,data)
			
		}
		
		
		//****************** EVENT - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function zoom(event:TransformGestureEvent):void {
			switch (event.phase) {
				
				case "begin":
					break;
				
				case "update":
					scalePins();
					break;
				
				case "end":
					scalePins();
					break;
			}
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function scalePins(event:ScrollEvent = null):void {
			
			//for each pin
			for each(var pinView:PinView in dataflowView.getPinCollection()) {
				
				//------Get step ounds
				var sp:StepView = structureView.getStepByAcronym(pinView.currentStep);
				var stepBounds:Rectangle = sp.getPositionForPin();
				
				//iphone
				if (DeviceInfo.os() != "Mac") { 
					stepBounds.width = stepBounds.width * 2;
					stepBounds.height = stepBounds.height * 2;
				}
				
				//calculate relative position
				var pinPosRatio:Object = pinView.ratioPos;
				var xR:Number = stepBounds.x + pinView.shapeSize/2 + (pinPosRatio.w * (stepBounds.width - pinView.shapeSize));
				var yR:Number = stepBounds.y + pinView.shapeSize/2 + (pinPosRatio.h * (stepBounds.height - pinView.shapeSize));
				
				//transform from local to global
				var pLocal:Point = new Point(xR,yR)
				var pGlobal:Point = structureView.getStepContainer().localToGlobal(pLocal);
				
				//update pin position
				pinView.updatePosition(pGlobal.x,pGlobal.y);
				
				//new position
				if (pinView.status != "edit") {
					pinView.x = pGlobal.x;
					pinView.y = pGlobal.y;
				}
				
			}	
			
		}
		
	}
}