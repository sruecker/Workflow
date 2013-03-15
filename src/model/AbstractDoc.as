package model {
	
	//imports
	
	public class AbstractDoc {
		
		//properties
		private var _id:int;								//Article's ID
		private var _title:String;							//Article's Title
		private var _authority:String;						//Article's Authority
		private var _source:String;							//Article's Source
		private var _tagged:Boolean = false;				//Tag as important - Deafult: False
		
		private var flags:Array = ["Start", "Working", "Working Complete", "Incomplete", "Complete"];			//One of the
		private var _history:Array;
		
		
		public function AbstractDoc(idNumber:int) {

			super();
			
			//save properties
			_id = idNumber;
			
			//init
			_history = new Array();
		}

		public function get id():int {
			return _id;
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}

		public function get authority():String {
			return _authority;
		}

		public function set authority(value:String):void {
			_authority = value;
		}

		public function get source():String {
			return _source;
		}

		public function set source(value:String):void {
			_source = value;
		}

		public function get actualStep():String {
			return _history[_history.length-1].step;
		}

		public function get actualFlag():String {
			return _history[_history.length-1].flag;
		}

		public function get isTagged():Boolean {
			return _tagged;
		}

		public function set tagged(value:Boolean):void {
			_tagged = value;
		}
		
		public function addLog(date:String, resp:String = "", flag:String = "", _step:String = ""):void {
			var obj:Object = new Object();
			
			//analize, transform and save data.
			
			//id
			obj.id = _history.length;
			
			//treat date
			date = date.toLowerCase();
			var fullDate:String = date;
			var dateBreak:Array = fullDate.split(" ");
			var day:String = dateBreak[0];
			var month:String = dateBreak[1];
			var year:String = dateBreak[2];
			
			//day
			if(day.length == 1) {
				day = "0" + day;
			}
			
			//month
			switch(month) {
				case "january":
					month = "01";
					break;
				case "february":
					month = "02";
					break;
				case "march":
					month = "03";
					break;
				case "april":
					month = "04";
					break;
				case "may":
					month = "05";
					break;
				case "june":
					month = "06";
					break;
				case "july":
					month = "07";
					break;
				case "august":
					month = "08";
					break;
				case "september":
					month = "09";
					break;
				case "october":
					month = "10";
					break;
				case "november":
					month = "11";
					break;
				case "december":
					month = "12";
					break;
			}
			
			if (month.length == 1) {
				month = "0" + month;
			}
			
			//add date
			obj.date = day + "." + month + "." + year;
			
			//responsable
			obj.resp = resp;				//don't have data about the user at the time. So, it will show just the ancronym.
			
			//step
			obj.step = _step.toLowerCase();
			
			//flag
			if (flag) {	
				flag = flag.toLowerCase();
			}
			
			switch(flag) {
				case "o":
					obj.flag = flags[0];
					break;
				case "p":
					obj.flag = flags[1];
					break;
				case "pc":
					obj.flag = flags[2];
					break;
				case "i":
					obj.flag = flags[3];
					break;
				case "c":
					obj.flag = flags[4];
					break;
				case "start":
					obj.flag = flags[0];
					break;
				case "working":
					obj.flag = flags[1];
					break;
				case "working complete":
					obj.flag = flags[2];
					break;
				case "incomplete":
					obj.flag = flags[3];
					break;
				case "complete":
					obj.flag = flags[4];
					break;
				default:  //debug
					obj.flag = flags[0];
					break;
			}
			
			_history.push(obj);
			
			
		}

		public function get history():Array {
			return _history.concat();
		}

	
	}
}