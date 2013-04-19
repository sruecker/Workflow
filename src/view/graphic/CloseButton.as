package view.graphic {
	
	//imports
	import flash.display.Sprite;
	
	
	public class CloseButton extends Sprite {
		
		//properties
		
		
		public function CloseButton() {
			
			
			
			var shape:AbstractShape;
			shape = new RoundRect(15,15,10);
			shape.color = 0x444444;
			shape.lineThickness = 2;
			shape.lineColor = 0xC6C7C9;
			
			shape.drawShape();
			
			shape.x = -shape.width/2;
			shape.y = -shape.height/2;
			
			addChild(shape);
			
			//x
			var shapeX:Sprite = new Sprite();
			shapeX.graphics.lineStyle(2,0xFFFFFF);
			shapeX.graphics.beginFill(0xFFFFFF,0);
			shapeX.graphics.moveTo(-2,-2);
			shapeX.graphics.lineTo(2,2);
			shapeX.graphics.moveTo(2,-2);
			shapeX.graphics.lineTo(-2,2)
			shapeX.graphics.endFill();
			shapeX.x = -1;
			shapeX.y = -1;
			this.addChild(shapeX);
			
			
			this.buttonMode = true;
		}
	}
}