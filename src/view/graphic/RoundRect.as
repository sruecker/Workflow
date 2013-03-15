package view.graphic {
	
	//imports
	import view.graphic.AbstractShape;
	
	public class RoundRect extends AbstractShape {
		
		//properties
		private var radius:Number;
		
		public function RoundRect(w:Number, h:Number, r:Number = 0) {
			
			super("roundRect")
			
			_wDef = w;
			_hDef = h;
			radius = r;
		}
		
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