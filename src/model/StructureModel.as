package model {
	
	//imports
	import mvc.Observable;
	
	public class StructureModel extends Observable {
		
		//properties
		private var stepCollection:Array;			//Collection of steps
		private var abstractStep:AbstractStep;		//Generic AbstractStep Object
		
		private var groupCollection:Array;			//Collection of groups
		private var abstractGroup:AbstractGroup;	//Generic AbstractGroup Object
		
		public function StructureModel() {
			
			super();
			
			//define name
			this.name = "structure";
			
			//init
			stepCollection = new Array();
			groupCollection = new Array();
			
			createStructure(initData());
		}
		
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
				{id:13,title:"Revision",acronym:"REV",level:-1,group:""}];
			
			return data;
		}
		
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
				abstractStep = new AbstractStep(step.id);
				
				abstractStep.title = step.title;
				abstractStep.acronym = step.acronym;
				abstractStep.level = step.level;
				
				// set a group if belong to one
				if (step.group) {
					var abstractGroup:AbstractGroup = getGroup(step.group, step.level);
					abstractGroup.addStep(step.id);
					abstractStep.group = abstractGroup.id;
				}
				
				//put in the collection
				stepCollection.push(abstractStep);
				
				//clear
				abstractStep = null;
				abstractGroup = null;		
			}
				
		}
	
		/**
		 * Abstract Group builder
		 * Return GroupStep
		 * If exist just get the instance; if not, create.
		 * 
		 * @param	name	String - group name
		 */
		private function getGroup(name:String, level:Number):AbstractGroup {
			//looking for the group name
			for each(abstractGroup in groupCollection) {
				if (abstractGroup.title == name) {
					return abstractGroup;
				}
			}
			
			//create new group
			abstractGroup = new AbstractGroup(groupCollection.length+1, name, level);
			
			//add group view to a collection
			groupCollection.push(abstractGroup);
			
			return abstractGroup;
		}
		
		
		public function getStepCollection():Array {
			return stepCollection.concat();
		}
		
		public function getGroupsCollection():Array {
			return groupCollection.concat();
		}
		
		public function getStep(id:int):AbstractStep {
			for each(var step:AbstractStep in stepCollection) {
				if(step.id == id) {
					return step;
					break;
				}
			}
			return null;
		}
		
		public function getStepByAcronym(acron:String):int {
			for each(var step:AbstractStep in stepCollection) {
				if(step.acronym.toLowerCase() == acron) {
					return step.id;
					break;
				}
			}
			return undefined;
		}
		
		
		public function getStepAcronym(id:int):String {
			var step:AbstractStep = getStep(id)
			return step.acronym;
		}
		
		public function getStepTitleByAcronym(acron:String):String {
			for each(var step:AbstractStep in stepCollection) {
				if(step.acronym.toLowerCase() == acron) {
					return step.title;
					break;
				}
			}
			return undefined;
		}
		
		public function addPinToStep(stepId:int, pinId:int):AbstractStep {
			var step:AbstractStep = getStep(stepId)
			step.addDoc(pinId);
			return step;
		}
		
		public function removePinFromStep(stepId:int, pinId:int):AbstractStep {
			var step:AbstractStep = getStep(stepId);
			step.removeDoc(pinId);
			return step;
		}
		
	}
}