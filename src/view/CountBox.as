package view {
	
	//imports
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import view.graphic.*;
	
	public class CountBox extends Sprite {
		
		//properties
		private var textField:TextField						//Display the number
		private var style:TextFormat = new TextFormat("Arial", 13, 0x605F5F,true,null,null,null,null,"center");
		
		public function CountBox() {
			super();
			
			this.buttonMode = true;
			
			var shape:AbstractShape;
			shape = new RoundRect(15,15,10);
			shape.color = 0xCCCCCC;
			shape.lineThickness = 1;
			shape.lineColor = 0x999999;
			
			shape.drawShape();
			
			shape.x = -shape.width/2;
			shape.y = -shape.height/2;
			
			addChild(shape);
			
			//text
			textField = new TextField();
			textField.selectable = false;
			textField.autoSize = "center";
			textField.text = "0";
			textField.setTextFormat(style);
			
			textField.x = shape.x + shape.width/2 - textField.width/2 - 1;
			textField.y = shape.y - 2;
			
			addChild(textField);
		}
		
		public function set count(value:int):void {
			textField.text = value.toString();
			textField.setTextFormat(style);
		}
	}
}