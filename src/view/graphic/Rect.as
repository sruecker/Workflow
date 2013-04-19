package view.graphic {
	
	//imports
	import view.graphic.AbstractShape;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Rect extends AbstractShape {
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * @param h
		 * 
		 */
		public function Rect(w:Number, h:Number) {
			
			super("rect")
			
			_wDef = w;
			_hDef = h;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function drawShape():void {
			this.graphics.beginFill(color);
			this.graphics.drawRect(0,0,wDef,hDef);
			this.graphics.endFill();
		}
	}
}