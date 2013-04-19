package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class GroupModel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _id					:int;						//ID
		protected var _title				:String;					//Title
		protected var _level				:Number;					//Group level
		protected var _contract				:Boolean = false;			//Group Appearance - Contracted or Expanded
		protected var _sequenced			:Boolean = false;			//Group Type: Sequenced or non-Sequenced
		protected var _stepCollection		:Array;						//Collect of step in the group

		
		//****************** Contructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param title
		 * @param level
		 * 
		 */
		public function GroupModel(id:int, title:String, level:Number) {
		
			//save properties
			_id = id;
			_title = title;
			_level = level;
			
			//init
			_stepCollection = new Array();
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get level():Number {
			return _level;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get isContract():Boolean {
			return _contract;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get isSequenced():Boolean {
			return _sequenced;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get stepCollection():Array {
			return _stepCollection;
		}
		
		//****************** SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set contract(value:Boolean):void {
			_contract = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set sequenced(value:Boolean):void {
			_sequenced = value;
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param stepId
		 * 
		 */
		public function addStep(stepId:int):void {
			_stepCollection.push(stepId);
		}

	}
}