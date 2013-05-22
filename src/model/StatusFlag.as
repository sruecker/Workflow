package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class StatusFlag {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _name			:String;
		protected var _color		:uint;
		protected var _icon			:String;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function StatusFlag(name:String, color:uint, icon:String = "") {
			_name = name;
			_color = color;
			_icon = icon;
		}
		
		//****************** GETTERS ****************** ****************** ******************

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get color():uint {
			return _color;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get icon():String {
			return _icon;
		}
		
		
		//****************** SETTERS ****************** ****************** ******************

		public function set icon(value:String):void {
			_icon = value;
		}
		
		public function set color(value:uint):void {
			_color = value;
		}
		
	}
}