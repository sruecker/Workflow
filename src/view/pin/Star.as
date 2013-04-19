package view.pin {
	
	//imports
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Star extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var radius				:Number;
		protected var _color				:uint;
		protected var _active				:Boolean
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param shapeSize
		 * @param color_
		 * 
		 */
		public function Star(shapeSize:int, color_:uint = 0xffffff) {
			
			radius = shapeSize;
			_color = color_;
			
			this.mouseEnabled = false;
			this.alpha = .5;
			
			drawStar();
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		protected function drawStar():void {
			var ir:Number = 0.382 * radius;
			
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.moveTo(0, -radius);
			
			for (var i:int = 1; i <= 10; i++) {
				var inter:int = i % 2;
				var rad:Number = (inter) ? ir : radius;
				var a:Number = -Math.PI / 2 + i * Math.PI / 5;
				var p:Point = new Point(Math.cos(a), Math.sin(a));
				p.normalize(rad);
				this.graphics.lineTo(p.x, p.y);
			}
			
			this.graphics.endFill();
			
		}		
		
		//****************** GETTERS ****************** ******************  ****************** 

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
		public function get active():Boolean {
			return _active;
		}

		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void {
			_color = value;
			drawStar;	//Redraw star
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set active(value:Boolean):void {
			_active = value;
			
			if(value) {
				this.alpha = 1;
			} else {
				this.alpha = .5;
			}
			
		}


	}
}