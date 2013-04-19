package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DocLogItem {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _id				:int;
		protected var _date				:Date;
		protected var _step				:String;
		protected var _status			:StatusFlag;
		protected var _responsible		:String;
		protected var _note				:String;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * @param date_
		 * @param status_
		 * @param step_
		 * @param resp_
		 * @param note_
		 * 
		 */
		public function DocLogItem(id:int,
							   date:String,
							   status:String = "",
							   step:String = "",
							   resp:String = "",
							   note:String = "") {
			
			_id = id;
			_date = convertDate(date);
			if (step) _step = step;
			if (status) _status = convertStatus(status);
			if (resp) _responsible = resp;
			if (note) _note = note;
			
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
		public function get date():Date {
			return _date;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get step():String {
			return _step;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get status():StatusFlag {
			return _status;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get responsible():String {
			return _responsible;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get note():String {
			return _note;
		}

		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param sourceDate
		 * @return 
		 * 
		 */
		protected function convertDate(sourceDate:String):Date {
			
			var treatedDate:Date = new Date();
			
			if (sourceDate == "") {
				treatedDate = new Date();
			} else {
				
				//treat date
				sourceDate = sourceDate.toLowerCase();
				
				var fullDate:String = sourceDate;
				var dateBreak:Array = fullDate.split(" ");
				
				var day:String = dateBreak[0];
				var month:String = dateBreak[1];
				var year:String = dateBreak[2];
				
				//Convert month
				switch(month) {
					case "january":
						month = "0";
						break;
					case "february":
						month = "1";
						break;
					case "march":
						month = "2";
						break;
					case "april":
						month = "3";
						break;
					case "may":
						month = "4";
						break;
					case "june":
						month = "5";
						break;
					case "july":
						month = "6";
						break;
					case "august":
						month = "7";
						break;
					case "september":
						month = "8";
						break;
					case "october":
						month = "9";
						break;
					case "november":
						month = "10";
						break;
					case "december":
						month = "11";
						break;
				}
				
				treatedDate.setFullYear(year,month,day);
			}
			
			return treatedDate;
		}
		
		/**
		 * 
		 * @param sourceStatus
		 * @return 
		 * 
		 */
		protected function convertStatus(sourceStatus:String):StatusFlag {
			
			var treatedStatus:StatusFlag;
			
			sourceStatus = sourceStatus.toLowerCase();
			switch(sourceStatus) {
				case "o":
					treatedStatus = Settings.getFlagByName("start");
					break;
				case "p":
					treatedStatus = Settings.getFlagByName("Working");
					break;
				case "pc":
					treatedStatus = Settings.getFlagByName("Working Complete");
					break;
				case "i":
					treatedStatus = Settings.getFlagByName("Incomplete");
					break;
				case "c":
					treatedStatus = Settings.getFlagByName("Complete");
					break;
				case "start":
					treatedStatus = Settings.getFlagByName("start");
					break;
				case "working":
					treatedStatus = Settings.getFlagByName("Working");
					break;
				case "working complete":
					treatedStatus = Settings.getFlagByName("Working Complete");
					break;
				case "incomplete":
					treatedStatus = Settings.getFlagByName("Incomplete");
					break;
				case "complete":
					treatedStatus = Settings.getFlagByName("Complete");
					break;
				default:  //debug
					treatedStatus = Settings.getFlagByName("start");
					break;
			}
			
			return treatedStatus;
		}
		
	}
}