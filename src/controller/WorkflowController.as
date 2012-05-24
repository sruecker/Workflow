package controller {
	
	//imports
	import events.OrlandoEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import model.DataModel;
	import model.StructureModel;
	
	import mvc.AbstractController;
	import mvc.Observable;
	
	public class WorkflowController extends AbstractController {
		
		//properties
		private var _model:Observable;			//generic model
		
		public function WorkflowController(list:Array) {
			
			super(list);
			
		}
	
		//---------- struture controls
		public function getStepsData():Array {
			_model = getModel("structure");
			var stepsColletion:Array = StructureModel(_model).getStepCollection();
			
			return stepsColletion;
		}
		
		public function getGroupsData():Array {
			_model = getModel("structure");
			var groupColletion:Array = StructureModel(_model).getGroupsCollection();
			
			return groupColletion;
		}
	
		public function addPinToStep(pinId:int, newStepId:int):void {
			_model = getModel("structure");
			//add to new step
			var updateObject:Object = StructureModel(_model).addPinToStep(newStepId,pinId);
			updateStep(newStepId, updateObject)
		}
		
		public function getStepTitleByAcronym(value:String):String {
			_model = getModel("structure");
			var title:String = StructureModel(_model).getStepTitleByAcronym(value);
			return title;
		}
		
		//---------- Pin Actions
		
		public function getPinsData():Array {
			_model = getModel("data");
			var pinsColletion:Array = DataModel(_model).getPinCollection();
			
			return pinsColletion;
		}
		
		/**
		 * Pin Click - Show the info Balloon.
		 * 1. Get the right title in the model
		 * 2. Create a balloon in the main view
		 */
		public function getPinTitle(id:int):String {
			_model = getModel("data");
			var title:String = DataModel(_model).getPinTitle(id);
			return title;
		}
		
		public function getPinAuthority(id:int):String {
			_model = getModel("data");
			var authority:String = DataModel(_model).getPinAuthority(id);
			return authority;
		}
		
		public function getPinSource(id:int):String {
			_model = getModel("data");
			var source:String = DataModel(_model).getPinSource(id);
			return source;
		}
		
		public function getPinActualFlag(id:int):String {
			_model = getModel("data");
			var source:String = DataModel(_model).getPinFlag(id);
			return source;
		}
		
		public function getPinActualStep(id:int):String {
			_model = getModel("data");
			var source:String = DataModel(_model).getPinStep(id);
			return source;
		}
		
		public function getPinLog(id:int):Array {
			_model = getModel("data");
			var log:Array = DataModel(_model).getPinLog(id);
			return log;
		}
		
		
		public function killBalloon(id:int):void {
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.KILL_BALLOON, id));
		}
		
		public function changePinLocation(pinId:int, newStepId:int):void {
			//gather the data into a object
			var data:Object = new Object();
			
			//get new date
			var today:Date = new Date();
			var date:String = today.getDate() + " " + today.getMonth() + " " + today.getFullYear();
			data.date = date;
			
			//get new responsable
			var resp:String = "WFM";
			data.responsible = resp;
			
			//get new step
			_model = getModel("structure");
			var newStepAcronym:String = StructureModel(_model).getStepAcronym(newStepId);
			data.step = newStepAcronym;
			
			//get new flag
			var flag:String = null;
			data.flag = flag;
			
			//get previous pin step
			_model = getModel("data");;
			var prevStepAcronym:String = DataModel(_model).getPinStep(pinId);	//save previous step reference
			
			//add to pin log
			var updateObject:Object = DataModel(_model).addPinLog(pinId, data);
			
			//update pin
			updatePin(newStepId, updateObject)
			
			//update pin counter - add to new step
			_model = getModel("structure");
			updateObject = StructureModel(_model).addPinToStep(newStepId,pinId);
			updateStep(newStepId, updateObject)
			
			//update pin counter - remove from the old step
			var prevPinId:int = StructureModel(_model).getStepByAcronym(prevStepAcronym);
			updateObject = StructureModel(_model).removePinFromStep(prevPinId,pinId);
			updateStep(newStepId, updateObject)

		}
		
		public function updatePin(pinId:int, data:Object):void {
			var update:OrlandoEvent = new OrlandoEvent(OrlandoEvent.UPDATE_PIN, pinId);
			update.data = data;
			this.dispatchEvent(update);
		}
		
		public function updateStep(stepId:int, data:Object):void {
			var update:OrlandoEvent = new OrlandoEvent(OrlandoEvent.UPDATE_STEP, stepId);
			update.data = data;
			this.dispatchEvent(update);
		}
		
		public function changePinFlag(pinId:int, flag:String):void {
			
			_model = getModel("data");
			
			//gather the data into a object
			var data:Object = new Object();
			
			//get new date
			var today:Date = new Date();
			var date:String = today.getDate() + " " + today.getMonth() + " " + today.getFullYear();
			data.date = date;
			
			//get new responsable
			var resp:String = "WFM";
			data.responsible = resp;
			
			//get actual step
			data.step = DataModel(_model).getPinStep(pinId);;
			
			//get new flag
			data.flag = flag;
			
			//add to pin log
			var updateObject:Object = DataModel(_model).addPinLog(pinId, data);
			
			//update pin
			updatePin(pinId, updateObject)
		}
		
		public function tagPin(pinId:int, tag:Boolean):void {
			_model = getModel("data");
			DataModel(_model).setPinTagged(pinId, tag);
		}
	}
}