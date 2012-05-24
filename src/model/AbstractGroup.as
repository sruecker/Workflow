package model {
	
	public class AbstractGroup {
		
		//properties
		private var _id:int;							//ID
		private var _title:String;						//Title
		private var _level:Number;						//Group level
		private var _contract:Boolean = false;			//Group Appearance - Contracted or Expanded
		private var _sequenced:Boolean = false;			//Group Type: Sequenced or non-Sequenced
		private var _stepCollection:Array;				//Collect of step in the group

		
		public function AbstractGroup(id_:int, t:String, l:Number) {
		
			//save properties
			_id = id_;
			_title = t;
			_level = l;
			
			//init
			_stepCollection = new Array();
		}
		
		public function get id():int {
			return _id;
		}

		public function get title():String {
			return _title;
		}
		
		public function get level():Number {
			return _level;
		}

		public function get isContract():Boolean {
			return _contract;
		}

		public function set contract(value:Boolean):void {
			_contract = value;
		}

		public function get isSequenced():Boolean {
			return _sequenced;
		}

		public function set sequenced(value:Boolean):void {
			_sequenced = value;
		}

		public function get stepCollection():Array {
			return _stepCollection;
		}

		public function addStep(step:int):void {
			_stepCollection.push(step);
		}

	}
}