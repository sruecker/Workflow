package model {
	
	//imports
	import events.OrlandoEvent;
	
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StructureModel extends Observable {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var stepCollection				:Array;					//Collection of steps
		protected var groupCollection				:Array;					//Collection of groups
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function StructureModel() {
			
			super();
			
			//define name
			this.name = "structure";
			
			//init
			stepCollection = new Array();
			groupCollection = new Array();
			
			createStructure(initData());
		}
		
		
		//****************** PRIVATE INITIAL DATA ****************** ****************** ******************
		
		/**
		 * Initial data for the structure.
		 * Return	Array - with the data.
		 */
		private function initData():Array {
			var data:Array = [
				{id:1,title:"Submit",acronym:"SUB",level:0,group:""},
				{id:2,title:"Research, write and Tag",acronym:"RWT",level:1,group:""},
				{id:3,title:"Review by volume author",acronym:"RBV",level:2,group:"Pilot Queue"},
				{id:4,title:"Check against sources",acronym:"CAS",level:2,group:"Pilot Queue"},
				{id:5,title:"Check for Tagging",acronym:"CFT",level:3,group:"Pilot"},
				{id:6,title:"Check for Bibliographic Practice",acronym:"CFB",level:3,group:"Pilot"},
				{id:7,title:"Tag Cleanup",acronym:"TC",level:3,group:"Pilot"},
				{id:8,title:"Publication readthrough",acronym:"PUBR",level:3,group:"Pilot"},
				{id:9,title:"Publish",acronym:"PUB",level:4,group:""},
				{id:10,title:"Public",acronym:"PUBLIC",level:5,group:""},
				{id:11,title:"Enhance",acronym:"ENH",level:6,group:""},
				{id:12,title:"Tag Cleanup",acronym:"TC",level:-2,group:""},
				{id:13,title:"Revision",acronym:"REV",level:-1,group:""}
			];
			
			return data;
		}
		
		
		//****************** PROCESS DATA ****************** ****************** ******************
		
		/**
		 * Create the step structure of the workflow.
		 * Save all properties in an AbstractStep Class
		 * Push the steps to a collection
		 * 
		 * @param	data	Array - Structure data
		 */
		private function createStructure(data:Array):void {
			//lenght
			var lenght:uint = data.length;
			
			for each(var step:Object in data) {
				//add steps to the collection
				var stepModel:StepModel = new StepModel(step.id);
				
				stepModel.title = step.title;
				stepModel.acronym = step.acronym;
				stepModel.level = step.level;
				
				// set a group if belong to one
				if (step.group) {
					var groupModel:GroupModel = getGroup(step.group);
					
					if (!groupModel) groupModel = addGroup(step.group, step.level);
					
					groupModel.addStep(step.id);
					stepModel.group = groupModel.id;
					
				}
				
				//put in the collection
				stepCollection.push(stepModel);
				
				//clear
				stepModel = null;
				groupModel = null;		
			}
				
		}
		
		
		//****************** PROTECTED METHODS - GROUPS ****************** ****************** ******************
	
		/**
		 * Return GroupStep
		 * 
		 * @param	name	String - group name
		 */
		protected function getGroup(name:String):GroupModel {
			for each(var groupModel:GroupModel in groupCollection) {
				if (groupModel.title == name) {
					return groupModel;
				}
			}
			
			return null;
		}
		
		/**
		 * Group Model builder
		 * 
		 * @param name
		 * @param level
		 * @return GroupModel
		 * 
		 */
		protected function addGroup(name:String, level:Number):GroupModel {
			var groupModel:GroupModel = new GroupModel(groupCollection.length+1, name, level);
			groupCollection.push(groupModel);
			return groupModel;
		}
		
		
		//****************** PUBLIC METHODS - GETTERS ****************** ****************** ******************
		
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
		public function getGroupsCollection():Array {
			return groupCollection.concat();
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getStepById(id:int):StepModel {
			for each(var step:StepModel in stepCollection) {
				if(step.id == id) {
					return step;
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
		public function getStepAcronym(id:int):String {
			var step:StepModel = getStepById(id)
			return step.acronym;
		}
		
		/**
		 * 
		 * @param acronym
		 * @return 
		 * 
		 */
		public function getStepByAcronym(acronym:String):StepModel {
			for each(var step:StepModel in stepCollection) {
				if(step.acronym.toLowerCase() == acronym.toLowerCase()) {
					return step;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param acronym
		 * @return 
		 * 
		 */
		public function getStepIdByAcronym(acronym:String):int {
			var step:StepModel = getStepByAcronym(acronym);
			
			if(step) return step.id;
			
			return null;
		}
		
		/**
		 * 
		 * @param acronym
		 * @return 
		 * 
		 */
		public function getStepTitleByAcronym(acronym:String):String {
			var step:StepModel = getStepByAcronym(acronym);
			
			if(step) return step.title;
			
			return null;
		}
		
		
		//****************** PUBLIC METHODS - ACTIONS ****************** ****************** ******************
		
		/**
		 * 
		 * @param stepId
		 * @param pinId
		 * @return 
		 * 
		 */
		public function addPinToStep(stepId:int, pinId:int):void {
			var step:StepModel = getStepById(stepId)
			step.addDoc(pinId);
			
			//dispatch Event
			var data:Object = {};
			data.step = step;
			
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.UPDATE_STEP, data));
			
		}
		
		/**
		 * 
		 * @param stepId
		 * @param pinId
		 * @return 
		 * 
		 */
		public function removePinFromStep(stepId:int, pinId:int):void {
			var step:StepModel = getStepById(stepId);
			step.removeDoc(pinId);
			
			//dispatch Event
			var data:Object = {};
			data.step = step;
			
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.UPDATE_STEP, data));
		}
		
	}
}