package view.graphic {
	
	//imports
	import view.graphic.AbstractShape;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Circle extends AbstractShape {
		
		//****************** Proprieties ****************** ****************** ******************
		protected var radius				:Number;
		
		
		//****************** Proprieties ****************** ****************** ******************
		
		/**
		 * 
		 * @param r
		 * 
		 */
		public function Circle(r:Number) {
			super("circle")
			radius = r;	
		}
		
		
		//****************** PUBLIC FUNCTION ****************** ****************** ******************
		
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
			this.graphics.drawCircle(0,0,radius);
			this.graphics.endFill();
		}
	}
}