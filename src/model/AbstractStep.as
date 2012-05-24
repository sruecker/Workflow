package model {
	
	//imports
	
	public class AbstractStep {
		
		//properties
		private var _id:uint;					//ID
		private var _title:String;				//Title
		private var _acronym:String;			//Acronym
		private var _level:Number;				//Level domain
		private var _group:int;					//Group domain
		private var _docCollection:Array;		//Collecton of docs in this step.
		
		public function AbstractStep(idValue:uint) {

			//save properties
			_id = idValue;
			
			//init
			_docCollection = new Array();
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function get title():String {
			return _title;
		}
		
		public function set title(value:String):void {
			_title = value;
		}
		
		public function get acronym():String {
			return _acronym;
		}
		
		public function set acronym(value:String):void {
			_acronym = value;
		}
		
		public function get level():Number {
			return _level;
		}
		
		public function set level(value:Number):void {
			_level = value;
		}
		
		public function get group():int {
			return _group;
		}
		
		public function set group(value:int):void {
			_group = value;
		}
		
		public function get docCollection():Array {
			return _docCollection.concat();
		}
		
		public function get docCount():int {
			return _docCollection.length;
		}
		
		public function addDoc(id:int):void {
			_docCollection.push(id);
		}
		
		public function removeDoc(id:int):void {
			for (var i:int = 0; i < _docCollection.length; i++) {
				if (_docCollection[i] == id) {
					_docCollection.splice(i,1);
				}
			}
		}
		
	}
}