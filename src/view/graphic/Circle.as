package view.graphic {
	
	//imports
	import view.graphic.AbstractShape;
	
	public class Circle extends AbstractShape {
		
		//properties
		private var radius:Number;
		
		public function Circle(r:Number) {
			
			super("circle")
			
			radius = r;
			
		}
		
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