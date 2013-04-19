package controller {
	
	//imports
	import model.DataModel;
	import model.DocLogItem;
	import model.StatusFlag;
	import model.StructureModel;
	
	import mvc.AbstractController;
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WorkflowController extends AbstractController {
		
		//****************** Proprieties ****************** ****************** ******************
		
		private var _model:Observable;			//generic model
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param modelList
		 * 
		 */
		public function WorkflowController(modelList:Array) {	
			super(modelList);
		}
		
		
		//****************** STRUCTURE METHODS - GETTERS ****************** ****************** ******************
	
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getStepCollection():Array {
			var mStrucutre:StructureModel = this.getModel("structure") as StructureModel;
			var stepCollection:Array = mStrucutre.getStepCollection();
			return stepCollection;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getGroupCollection():Array {
			var mStrucutre:StructureModel = this.getModel("structure") as StructureModel;
			var groupCollections:Array = mStrucutre.getGroupsCollection();
			return groupCollections;
		}
	
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getStepTitleByAcronym(value:String):String {
			var mStrucutre:StructureModel = this.getModel("structure") as StructureModel;
			var title:String = mStrucutre.getStepTitleByAcronym(value);
			return title;
		}
		
		
		//****************** STRUCTURE METHODS - ACTIONS ****************** ****************** ******************
		
		/**
		 * 
		 * @param pinId
		 * @param newStepId
		 * 
		 */
		public function addPinToStep(pinId:int, newStepId:int):void {
			var mStrucutre:StructureModel = this.getModel("structure") as StructureModel;
			mStrucutre.addPinToStep(newStepId,pinId);
		}
		
		
		//****************** DOCUMENT METHODS - GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPinsData():Array {
			var mData:DataModel = getModel("data") as DataModel;
			var pinsColletion:Array = mData.getDocumentCollection();
			return pinsColletion;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinTitle(id:int):String {
			var mData:DataModel = getModel("data") as DataModel;
			var title:String = mData.getDocumentTitle(id);
			return title;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinAuthority(id:int):String {
			var mData:DataModel = getModel("data") as DataModel;
			var authority:String = mData.getDocumentAuthority(id);
			return authority;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinSource(id:int):String {
			var mData:DataModel = getModel("data") as DataModel;
			var source:String = mData.getDocumentSource(id);
			return source;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinCurrentFlag(id:int):StatusFlag {
			var mData:DataModel = getModel("data") as DataModel;
			var currentFlag:StatusFlag = mData.getDocumentCurrentFlag(id);
			return currentFlag;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinCurrentStep(id:int):String {
			var mData:DataModel = getModel("data") as DataModel;
			var source:String = mData.getDocumentCurrentStep(id);
			return source;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinLog(id:int):Array {
			var mData:DataModel = getModel("data") as DataModel;
			var log:Array = mData.getDocumentLogHistory(id);
			return log;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinLastLog(id:int):DocLogItem {
			var log:Array = this.getPinLog(id);
			return log[log.length-1] as DocLogItem;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinCurrentResponsible(id:int):String {
			var mData:DataModel = getModel("data") as DataModel;
			var currentResponsible:String = mData.getDocumentCurrentResponsible(id);
			return currentResponsible;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getPinCurrentNote(id:int):String {
			var mData:DataModel = getModel("data") as DataModel;
			var curentNote:String = mData.getDocumentCurrentNote(id);
			return curentNote;
		}
		
		
		//****************** DOCUMENT METHODS - ACTIONS ****************** ****************** ******************
		
		/**
		 * 
		 * @param pinId
		 * @param newStepId
		 * 
		 */
		public function changePinLocation(pinId:int, newStepId:int):void {
			
			//call models
			var mStructure:StructureModel = getModel("structure") as StructureModel;
			var mData:DataModel = getModel("data") as DataModel;
			
			//get previous document step
			var prevStepAcronym:String = mData.getDocumentCurrentStep(pinId);
			
			//get new step
			var newStepAcronym:String = mStructure.getStepAcronym(newStepId);
			
			//update Document
			mData.updateDocument(pinId,"",newStepAcronym);
			
			//update pin counter - add to new step
			mStructure.addPinToStep(newStepId,pinId);
			
			//update pin counter - remove from the old step
			var prevPinId:int = mStructure.getStepIdByAcronym(prevStepAcronym);
			mStructure.removePinFromStep(prevPinId,pinId);
			
		}
		
		/**
		 * 
		 * @param pinId
		 * @param flag
		 * 
		 */
		public function updatePinFlag(pinId:int, flag:String):void {
			var mData:DataModel = getModel("data") as DataModel;
			mData.updateDocument(pinId,flag);
		}
		
		/**
		 * 
		 * @param pinId
		 * @param tag
		 * 
		 */
		public function tagPin(pinId:int, tag:Boolean):void {
			var mData:DataModel = getModel("data") as DataModel;
			mData.setDocumentTagged(pinId, tag);
		}
	}
}