package view.graphic {
	
	//imports
	import view.graphic.AbstractShape;
	
	public class Rect extends AbstractShape {
		
		//properties
		
		public function Rect(w:Number, h:Number) {
			
			super("rect")
			
			_wDef = w;
			_hDef = h;
		}
		
		override public function drawShape():void {
			
			//create shape
			this.graphics.beginFill(color);
			this.graphics.drawRect(0,0,wDef,hDef);
			this.graphics.endFill();
		}
	}
}