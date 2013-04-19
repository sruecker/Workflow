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
		private static var _pinTrail					:Boolean		//Turn on and Off pin trail
		
		//groups
		private static var _contractableGroups		:Boolean		//Whether groups can or cannot contracts
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//-- Pins
			if (DeviceInfo.os() == "iPad") {
				pinListWidth = 250;
			} else {
				pinListWidth = 125;
			}
			_pinTrail = true;
			
			
			//--flags
			_statusFlags = new Array();
			_statusFlags[0] = new StatusFlag("Start",0xFFFFFF);
			_statusFlags[1] = new StatusFlag("Working",0x3299CC);
			_statusFlags[2] = new StatusFlag("Working Complete",0x3299CC);
			_statusFlags[3] = new StatusFlag("Incomplete",0xD7352D);
			_statusFlags[4] = new StatusFlag("Complete",0x8A964A);
			
			//--groups
			_contractableGroups = false;
			
		}
		
		//****************** GETTERS - PIN ****************** ****************** ******************
		
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
		public static function get pinTrail():Boolean {
			return _pinTrail;
		}
		
		
		//****************** GETTERS - FLAG ****************** ****************** ******************

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
		
		
		//****************** GETTERS - STRUCTURE ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get contractableGroups():Boolean {
			return _contractableGroups;
		}
		
		//****************** SETTERS - PIN ****************** ****************** ******************
		
		/**
		 *  
		 * @return:String
		 * 
		 */
		public static function set pinListWidth(value:int):void {
			_pinListWidth = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set pinTrail(value:Boolean):void {
			_pinTrail = value;
		}

		
	}
}