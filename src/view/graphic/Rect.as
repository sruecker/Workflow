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
			//line
			if (hasLine) {
				this.graphics.lineStyle(lineThickness,lineColor,1,true);
			}

			this.graphics.beginFill(color);
			this.graphics.drawRect(0,0,wDef,hDef);
			this.graphics.endFill();
		}
	}
}