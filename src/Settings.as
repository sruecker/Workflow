package {
	import model.StatusFlag;
	
	import util.DeviceInfo;
	
	/**
	 * Settings.
	 * This class holds configuration settings of this app.
	 * 
	 * @author lucaju
	 * 
	 */
	public class Settings {
		
		//****************** Properties ****************** ****************** ******************
		
		//flags
		private static var _statusFlags				:Array			//Color Options
		
		//pins
		private static var _pinListWidth			:int;			//Holds Pin List min width
		
		//groups
		private static var _contractableGroups		:Boolean		//Whether groups can or cannot contracts
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//--flags
			_statusFlags = new Array();
			_statusFlags[0] = new StatusFlag("Start",0xFFFFFF);
			_statusFlags[1] = new StatusFlag("Working",0x3299CC);
			_statusFlags[2] = new StatusFlag("Working Complete",0x3299CC);
			_statusFlags[3] = new StatusFlag("Incomplete",0xD7352D);
			_statusFlags[4] = new StatusFlag("Complete",0x8A964A);
			
			//-- Pins
			
			//Pin List Width
			if (DeviceInfo.os() == "iPad") {
				pinListWidth = 250;
			} else {
				pinListWidth = 125;
			}
			
			//--groups
			_contractableGroups = false;
			
		}
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return:String
		 * 
		 */
		public static function get pinListWidth():int {
			return _pinListWidth
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get statusFlags():Array {
			return _statusFlags.concat();
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public static function getFlagByName(value:String):StatusFlag {
			
			for each (var sf:StatusFlag in statusFlags) {
				if (sf.name.toLowerCase() == value.toLowerCase()) {
					return sf;
				}
			}
			
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get contractableGroups():Boolean {
			return _contractableGroups;
		}
		
		//****************** SETTER ****************** ****************** ******************
		
		/**
		 *  
		 * @return:String
		 * 
		 */
		public static function set pinListWidth(value:int):void {
			_pinListWidth = value;
		}
		
	}
}