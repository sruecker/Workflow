package model {
	
	//imports
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DocumentModel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _id					:int;					//Article's ID
		protected var _title				:String;				//Article's Title
		protected var _authority			:String;				//Article's Authority
		protected var _source				:String;				//Article's Source
		protected var _history				:Array;					//History collection
		protected var _tagged				:Boolean = false;		//Tag as important - Deafult: False
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param idNumber
		 * 
		 */
		public function DocumentModel(idNumber:int) {
			
			//save properties
			_id = idNumber;
			
			//init
			_history = new Array();
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
		public function get authority():String {
			return _authority;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get source():String {
			return _source;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentStep():String {
			var log:DocLogItem = history[history.length-1] as DocLogItem;
			return log.step;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentStatus():StatusFlag {
			var log:DocLogItem = history[history.length-1] as DocLogItem;
			return log.status;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentResponsible():String {
			var log:DocLogItem = history[history.length-1] as DocLogItem;
			return log.responsible;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentNote():String {
			var log:DocLogItem = history[history.length-1] as DocLogItem;
			return log.note;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get isTagged():Boolean {
			return _tagged;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get history():Array {
			return _history.concat();
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
		public function set authority(value:String):void {
			_authority = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set source(value:String):void {
			_source = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tagged(value:Boolean):void {
			_tagged = value;
		}
	
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param flag
		 * @param step
		 * @param resp
		 * @param note
		 * @param date
		 * 
		 */
		public function addLog(flag:String = "", step:String = "", resp:String = "", note:String = "", date:String = ""):void {
			var log:DocLogItem = new DocLogItem(history.length, date, flag, step, resp, note);
			_history.push(log);
		}
	
	}
}