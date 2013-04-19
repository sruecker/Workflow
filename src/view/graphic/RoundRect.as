package view.graphic {
	
	//imports
	import view.graphic.AbstractShape;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RoundRect extends AbstractShape {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var radius			:Number;
		
		
		//****************** Contructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * @param h
		 * @param r
		 * 
		 */
		public function RoundRect(w:Number, h:Number, r:Number = 0) {
			
			super("roundRect");
			
			_wDef = w;
			_hDef = h;
			radius = r;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function drawShape():void {
			
			//create shape
			
			//line
			if (hasLine) {
				this.graphics.lineStyle(lineThickness,lineColor,1,true);
			}
			
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(0,0,wDef,hDef,radius);
			this.graphics.endFill();
		}
	}
}