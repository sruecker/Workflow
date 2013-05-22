package settings {
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
		
		//general
		private static var _platformTarget				:String;			//["air","mobile","web"]
		private static var _debug						:Boolean;			//Debug
		
		//flags
		private static var _statusFlags					:Array				//Color Options
		
		//pins
		private static var _pinTrail					:Boolean			//Turn on and Off pin trail
		private static var _bigPinStyles				:Array;
		private static var _bigPinCurrentStyle			:String				//Pin Style
		
		//groups
		private static var _contractableGroups			:Boolean			//Whether groups can or cannot contracts
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * Constructor. Set default values 
		 * 
		 */
		public function Settings() {
			
			//--------default values
			
			//-- General
			_platformTarget = "air";
			_debug = false;
			
			//-- Pins
			_pinTrail = true;
			
			_bigPinStyles = new Array();
			_bigPinStyles[0] = "pop";
			_bigPinStyles[1] = "knob";
			
			_bigPinCurrentStyle = _bigPinStyles[1];
			
			
			//--flags
			_statusFlags = new Array();
			_statusFlags[0] = new StatusFlag("Start",0xFFFFFF,"start_circle.png");
			_statusFlags[1] = new StatusFlag("Working",0x3299CC,"working_circle.png");
			_statusFlags[2] = new StatusFlag("Working Complete",0x3299CC,"working_circle.png");
			_statusFlags[3] = new StatusFlag("Incomplete",0xD7352D,"incomplete_circle.png");
			_statusFlags[4] = new StatusFlag("Complete",0x8A964A,"complete_circle.png");
			
			//--groups
			_contractableGroups = false;
			
		}
		
		//****************** GETTERS & SETTERS - GENERAL ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get platformTarget():String {
			return _platformTarget;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get debug():Boolean {
			return _debug;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set platformTarget(value:String):void {
			_platformTarget = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set debug(value:Boolean):void {
			_debug = value;
		}

		
		//****************** GETTERS & SETTERS - PIN ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get pinTrail():Boolean {
			return _pinTrail;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get bigPinStyles():Array {
			return _bigPinStyles;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get bigPinCurrentStyle():String {
			return _bigPinCurrentStyle;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set pinTrail(value:Boolean):void {
			_pinTrail = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function set bigPinCurrentStyle(value:String):void {
			_bigPinCurrentStyle = value;
		}
		
		
		//****************** GETTERS & SETTERS - FLAG ****************** ****************** ******************

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
		
		
		//****************** GETTERS & SETTERS - STRUCTURE ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get contractableGroups():Boolean {
			return _contractableGroups;
		}
		
	}
}