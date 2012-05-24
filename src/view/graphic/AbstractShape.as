package view.graphic {
	
	//imports
	import flash.display.Sprite;
	
	public class AbstractShape extends Sprite {
		
		//properties
		internal var _type:String;
		internal var _wDef:Number;
		internal var _hDef:Number;
		internal var _radius:Number;
		internal var _round:Boolean;
		private var _color:uint = 0xcccccc;
		
		private var _lineColor:uint = 0xcccccc;
		private var _lineThickness:uint = 0;
		
		
		public function AbstractShape(t:String) {
			super();
			type = t;
		}
		
		public function drawShape():void {
			
		}

		internal function get type():String{
			return _type;
		}

		internal function set type(value:String):void{
			_type = value;
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

		public function set color(value:uint):void {
			_color = value;
		}
		
		public function set lineColor(value:uint):void {
			_lineColor = value;
		}
		
		public function get lineColor():uint {
			return _lineColor;
		}

		public function set lineThickness(value:uint):void {
			_lineThickness = value;
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


	}
}