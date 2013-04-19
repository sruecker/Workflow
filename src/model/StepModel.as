package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StepModel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _id					:uint;					//ID
		protected var _title				:String;				//Title
		protected var _acronym				:String;				//Acronym
		protected var _level				:Number;				//Level domain
		protected var _group				:int;					//Group domain
		protected var _docCollection		:Array;					//Collecton of docs in this step.
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function StepModel(idValue:uint) {

			//save properties
			_id = idValue;
			
			//init
			_docCollection = new Array();
		}
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():uint {
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
		public function get acronym():String {
			return _acronym;
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
		public function get group():int {
			return _group;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get docCollection():Array {
			return _docCollection.concat();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get docCount():int {
			return _docCollection.length;
		}
		
		
		//****************** SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			_title = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set acronym(value:String):void {
			_acronym = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set level(value:Number):void {
			_level = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set group(value:int):void {
			_group = value;
		}
		
		
		//****************** PUBLIC METJODS ****************** ****************** ******************
		
		
		/**
		 * 
		 * @param docId
		 * 
		 */
		public function addDoc(docId:int):void {
			_docCollection.push(docId);
		}
		
		/**
		 * 
		 * @param docId
		 * 
		 */
		public function removeDoc(docId:int):void {
			for (var i:int = 0; i < _docCollection.length; i++) {
				if (_docCollection[i] == docId) {
					_docCollection.splice(i,1);
				}
			}
		}
		
		
	}
}