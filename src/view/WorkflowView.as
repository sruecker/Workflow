package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import controller.WorkflowController;
	
	import events.WorkflowEvent;
	
	import model.DocumentModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.ZoomGesture;
	
	import settings.Settings;
	
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
		
		protected var logo							:Sprite;
		
		protected var topBar						:TopBar
		
		protected var splash					:Sprite;
		
		protected var structureView					:StructureView;
		protected var dataflowView					:DataflowView;
		
		protected var pinList						:PinList;			
		protected var toolTipManager				:ToolTipManager;
		
		private var currentScale					:Number = 1;
		private var minScale						:Number = 1;
		private var maxScale						:Number = 6;
		
		protected var zoomGesture					:ZoomGesture;
		
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param c
		 * 
		 */
		public function WorkflowView(c:IController) {
			super(c);
			
			splash = new Sprite();
			this.addChild(splash);
			
			var loaderimageLoader:Loader = new Loader();
			var img:String;
			switch (Settings.platformTarget) {
				
				case "mobile":
					img = "images/splash@2x.png";
					break;
				
				default:
					img = "images/splash_1260x700.png";
					break;
				
			}
			
			loaderimageLoader.load(new URLRequest(img));
			splash.alpha = .8
			splash.addChild(loaderimageLoader);
			loaderimageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, splashLoad);
		}
		
		protected function splashLoad(event:Event):void {
			//splash.x = (this.stage.stageWidth/2) - (splash.width/2)
			//splash.y = (this.stage.stageHeight/2) - (splash.height/2)
		}		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			TweenMax.to(splash,.5,{alpha:0, delay:2, onComplete:initiate});
		}
		
		/**
		 * 
		 * 
		 */
		private function initiate():void {
			
			//remove splash
			this.removeChild(splash);
			splash = null;
			
			//1. Get controller
			var wController:WorkflowController = this.getController() as WorkflowController;
			
			//2. logo
			logo = new Sprite();
			this.addChild(logo);
			
			var loaderLogo:Loader = new Loader();
			loaderLogo.contentLoaderInfo.addEventListener(Event.COMPLETE, loadLogo)
			loaderLogo.load( new URLRequest("images/logoBW.png"));
			logo.addChild(loaderLogo);
			logo.blendMode = "multiply";
			logo.alpha = .4;
			logo.cacheAsBitmap = true;
			logo.mouseChildren = false;
			logo.mouseEnabled = false;
			
			//3. base Background
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			//4. Top Bar
			topBar = new TopBar(this.getController());
			this.addChild(topBar);
			topBar.init();
			
			//5. add structure
			structureView = new StructureView(this.getController());
			this.addChildAt(structureView,0);
			//structureView.y = topBar.height;
			//var activeArea:Rectangle = new Rectangle(structureView.x,structureView.y,this.stage.stageWidth, this.stage.stageHeight - topBar.height);
			var activeArea:Rectangle = new Rectangle(0,0,this.stage.stageWidth, this.stage.stageHeight);
			structureView.init(activeArea);
			
			//6. add dataflow
			dataflowView = new DataflowView(this.getController());
			//dataflowView.y = topBar.height;
			this.addChildAt(dataflowView,1);
			dataflowView.init(structureView.getStepCollection());
			
			//7. tooltip
			toolTipManager = new ToolTipManager(dataflowView);
			dataflowView.addEventListener(Event.CLEAR, toolTipClear);	
			
			//8. listenter
			wController.getModel("data").addEventListener(WorkflowEvent.UPDATE_PIN, updatePin);
			this.addEventListener(ScrollEvent.SCROLL, pinSemanticZoomUpdate);
			this.addEventListener(ScrollEvent.INERTIA, pinSemanticZoomUpdate);
			topBar.addEventListener(WorkflowEvent.SELECT, topBarAction);
			
			dataflowView.addEventListener(WorkflowEvent.DRAG_PIN, hitTest);
			dataflowView.addEventListener(WorkflowEvent.SELECT, clickPin);
			
			//zoom
			if (Settings.platformTarget == "mobile") {
				zoomGesture = new ZoomGesture(this);
				zoomGesture.addEventListener(GestureEvent.GESTURE_BEGAN, zoomBegin);
			} else {
				structureView.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoom);
			}
		}
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function loadLogo(event:Event):void {
			var img:Bitmap = event.currentTarget.content;
			img.x = -img.width/2;
			img.y = -img.height/2;
			
			logo.x = (logo.width/2) + 10;
			
			if (Settings.platformTarget == "mobile") {
				logo.y = (logo.height/2) + 80;
			} else {
				logo.y = (logo.height/2) + 40;
			}
			
			
			TweenMax.from(logo,3,{alpha:0, x:-img.width/2, rotation:-400, delay:1, ease: Back.easeOut});
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param target
		 * 
		 */
		protected function removeElement(target:Sprite):void {
			this.removeChild(target);
		}
		
		
		//****************** EVENTS - TOOLBAR & PINLIST ****************** ****************** ******************
		
		protected function topBarAction(event:WorkflowEvent):void {
			
			switch (event.data.label) {
				case "list":
					
					if (event.data.toggle) {
						
						pinList = new PinList(this.getController());
						pinList.y = topBar.height;
						this.addChildAt(pinList,2);
						pinList.initialize(WorkflowController(this.getController()).getPinsData(), this.stage.stageHeight - topBar.height);
						pinList.addEventListener(WorkflowEvent.SELECT, pinListSelect);
						TweenMax.from(pinList,.6,{x:-pinList.width});
						
						TweenMax.to(logo,1.2,{x:pinList.width + (logo.width/2) + 10, ease: Back.easeOut});
						TweenMax.to(logo, .6,{rotation:90, yoyo: true, repeat:1});
						
					} else {
						pinList.removeEventListener(WorkflowEvent.SELECT, pinListSelect);
						TweenMax.to(pinList,.6,{x:-pinList.width, onComplete:removeElement, onCompleteParams:[pinList]});
						pinList = null;
						
						TweenMax.to(logo,1.2,{x:(logo.width/2) + 10, ease: Back.easeOut});
						TweenMax.to(logo, .6,{rotation:-90, yoyo: true, repeat:1});
					}
					
					break;
			}
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
			if (pinList) pinList.clearSelection();
		}	
		
		
		//****************** EVENTS - PIN & PINLIST ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function clickPin(event:WorkflowEvent):void {
			
			if (pinList) pinList.changePinStatus(event.data.id, event.data.status);
			
			var pin:PinView = dataflowView.getPinById(event.data.id);
			manageToolTip(pin, event.target.status);
			
			event.stopPropagation();
			event.stopImmediatePropagation();
			
			//unblock structure zoom and pan
			if (Settings.platformTarget == "mobile") {
				zoomGesture.enabled = true;
				structureView.scrollEnable = true;
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function pinListSelect(event:WorkflowEvent):void {
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
		protected function hitTest(event:WorkflowEvent):void {
			if (event.phase == "end") {
				hitTestEnd(event.target as PinView);
				
				//unblock structure zoom and pan
				if (Settings.platformTarget == "mobile") {
					zoomGesture.enabled = true;
					structureView.scrollEnable = true;
				}
				
			} else {
				hitTester(event.target as PinView);
				
				//block structure zoom and pan
				if (Settings.platformTarget == "mobile") {
					zoomGesture.enabled = false;
					structureView.scrollEnable = false;
				}
			}
			
		}
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		protected function hitTester(pin:PinView):void {
			
			pin.stepHitInside = false;			
			var hitter:StepView;
			
			for each(var stepView:StepView in structureView.getStepCollection()) {
				if(pin.hitTestObject(stepView)) {
					
					if (stepView.acronym.toLowerCase() == pin.currentStep.toLowerCase()) {
						pin.stepHitInside = true;
					} else {
						pin.stepHitInside = false;
						stepView.highlight(true);
					}
					
					hitter = stepView;
					
				} else {
					stepView.highlight(false);
				}	
			}
			
			if(!hitter) {
				pin.stepHit = null;
			} else {
				pin.stepHit = hitter;
			}
			
		}
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		protected function hitTestEnd(pin:PinView):void {
			
			if (pin.stepHit == null) { // pin return to the origin
				TweenMax.to(pin,1,{x:pin.originalPosition.x, y:pin.originalPosition.y, ease:Back.easeOut});
			} else {
				
				if (!pin.stepHitInside) { // pin Change step
					WorkflowController(this.getController()).changePinLocation(pin.id, pin.stepHit.id);
					pin.stepHit.highlight(false);
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
			pin.stepHit = null;
			pin.stepHitInside = false;
		}

		
		//****************** EVENT - ACTION ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function updatePin(event:WorkflowEvent):void {
			
			var doc:DocumentModel = event.data.document as DocumentModel;
			
			//update list
			if (pinList) {
				var itemList:PinListItem = pinList.getItemById(doc.id);
				itemList.flag = doc.currentStatus;
			}
			
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
				var sp:StepView = structureView.getStepByAcronym(doc.currentStep);
				var stepActiveBounds:Rectangle = sp.getPositionForPin();
				
				var globalP:Point = new Point(pin.x, pin.y); 
				var localP:Point = sp.globalToLocal(globalP);
				
				var xR:Number = localP.x/stepActiveBounds.width;
				var yR:Number = localP.y/stepActiveBounds.height;
				
				data.ratioPos = {w:xR, h:yR};
				
			}
			
			//send update to pin
			dataflowView.updatePin(doc.id,data);
			
		}
		
		
		//****************** EVENT - INTERFACE ****************** ****************** ******************
		
		protected function zoomBegin(event:GestureEvent):void {
			structureView.zoomBegin(event);
			
			zoomGesture.addEventListener(GestureEvent.GESTURE_CHANGED, zoomChanged);
			zoomGesture.addEventListener(GestureEvent.GESTURE_ENDED, zoomEnded);
		}
		
		protected function zoomChanged(event:GestureEvent):void {
			structureView.zoomChanged(event);
			pinSemanticZoomUpdate();
		}
		
		protected function zoomEnded(event:GestureEvent):void {
			structureView.zoomEnded(event);
			pinSemanticZoomUpdate();
		}
		
		
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
					pinSemanticZoomUpdate();
					break;
				
				case "end":
					pinSemanticZoomUpdate();
					break;
			}
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function pinSemanticZoomUpdate(event:ScrollEvent = null):void {
			
			var pinCollection:Array = dataflowView.getPinCollection();
			
			//for each pin
			for each(var pinView:PinView in pinCollection) {
				
				//------Get step ounds
				var sp:StepView = structureView.getStepByAcronym(pinView.currentStep);
				var stepBounds:Rectangle = sp.getPositionForPin();
				
				//iphone
				if (Settings.platformTarget == "mobile") { 
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
				
				//update tooltip position
				ToolTipManager.moveToolTips(pinView.id,pGlobal.x,pGlobal.y);
				
			}	
			
		}
		
	}
}