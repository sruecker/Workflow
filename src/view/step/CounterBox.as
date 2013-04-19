package view.step {
	
	//imports
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import view.graphic.AbstractShape;
	import view.graphic.RoundRect;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class CounterBox extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var counterTF						:TextField
		protected var style							:TextFormat;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function CounterBox() {
			
			//shape
			var shape:AbstractShape;
			shape = new RoundRect(15,15,10);
			shape.color = 0xCCCCCC;
			shape.lineThickness = 1;
			shape.lineColor = 0x999999;
			
			shape.drawShape();
			
			shape.x = -shape.width/2;
			shape.y = -shape.height/2;
			
			this.addChild(shape);
			
			//style
			style = new TextFormat();
			style.font = "Arial";
			style.size = 13;
			style.color = 0x605F5F;
			style.bold = true;
			style.align = "center";
			
			//text
			counterTF = new TextField();
			counterTF.selectable = false;
			counterTF.autoSize = "center";
			counterTF.defaultTextFormat = style;
			counterTF.text = "0";
			//counterTF.setTextFormat(style);
			
			counterTF.x = shape.x + shape.width/2 - counterTF.width/2 - 1;
			counterTF.y = shape.y - 2;
			
			this.addChild(counterTF);
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set count(value:int):void {
			counterTF.text = value.toString();
		}
	}
}