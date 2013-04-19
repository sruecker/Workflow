package view.graphic {
	
	//imports
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractShape extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _type				:String;
		protected var _wDef				:Number;
		protected var _hDef				:Number;
		protected var _radius			:Number;
		protected var _round			:Boolean;
		
		protected var _color			:uint = 0xcccccc;
		protected var _lineColor		:uint = 0xcccccc;
		protected var _lineThickness	:uint = 0;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function AbstractShape(t:String) {
			super();
			type = t;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		public function drawShape():void {
			
		}

		
		//****************** GETTERS ****************** ****************** ******************
		
		public function get type():String{
			return _type;
		}
		
		public function get wDef():Number {
			return _wDef;
		}
		
		public function get hDef():Number {
			return _hDef;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function get lineColor():uint {
			return _lineColor;
		}
		
		public function get lineThickness():uint {
			return _lineThickness;
		}
		
		public function get hasLine():Boolean {
			if (_lineThickness <= 0) {
				return false;
			} else {
				return true;
			}
		}
		
		
		//****************** SETTERS ****************** ****************** ******************

		public function set type(value:String):void{
			_type = value;
		}

		public function set color(value:uint):void {
			_color = value;
		}
		
		public function set lineColor(value:uint):void {
			_lineColor = value;
		}
		
		public function set lineThickness(value:uint):void {
			_lineThickness = value;
		}

	}
}