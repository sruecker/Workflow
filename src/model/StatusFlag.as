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
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function StatusFlag(name:String, color:uint) {
			_name = name;
			_color = color;
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
		
	}
}