package view {
	
	//imports
	import flash.display.Sprite;
	
	import view.graphic.*;
	
	public class ContractButton extends Sprite {
		
		//properties
		private var contractAction:Boolean;
		private var icon:Sprite;
		public var origX:Number;
		public var origY:Number;
		
		public function ContractButton(contract:Boolean = true) {
			
			super();
			
			//save parameters
			contractAction = contract;
			
			//make ui
			makeButton();
		}
		
		private function makeButton():void {
			//button
			var shape:AbstractShape;
			shape = new RoundRect(15,15,10);
			shape.color = 0x444444;
			shape.lineThickness = 2;
			shape.lineColor = 0xC6C7C9;
			
			shape.drawShape();
			
			shape.x = -shape.width/2;
			shape.y = -shape.height/2;
			
			addChild(shape);
			
			//icon
			icon = new Sprite();
			changeIcon(contractAction)
			addChild(icon);
		}
		
		public function changeIcon(contract:Boolean):void {
			
			icon.graphics.clear();
			icon.graphics.lineStyle(2,0xFFFFFF);
			icon.graphics.beginFill(0xFFFFFF);
			icon.graphics.lineTo(6,0);
			
			if(!contract) {
				icon.graphics.moveTo(3,-3);
				icon.graphics.lineTo(3,3);	
			}
			
			icon.graphics.endFill();
			
			icon.x = -icon.width/2;
			icon.y = -1;
		}
		
	}
}