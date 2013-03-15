package view {
	
	//imports
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	
	public class PinFlagPanel extends PinView {
		
		//properties
		private const options:Array = ["Start", "Working", "Incomplete", "Complete"];
		
		private var shape:Shape;
		private var button:PinFlagPanelButton;
		
		
		public function PinFlagPanel(id:int) {
			
			super(id);
			
			_id = id;
			
		}
		
		override public function init():void {
			
			var container:Sprite = new Sprite();
			addChild(container)
			
			// options loop
			var label:String;
			var color:uint;
			for each (var option:String in options) {
				
				
				for each (var flag:Object in flags) {
					if (option == flag.name) {
						label = flag.name;
						color = flag.color;
						break;
					}
				}
				
				button = new PinFlagPanelButton(_id, label, color);
				button.y = this.height;
				container.addChild(button);
				
			}
			
			var masc:Shape = drawShape();
			addChild(masc)
			
			container.mask = masc;
			
			//draw box//shape
			shape = drawShape();
			this.addChildAt(shape,0);
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			this.filters = fxs;
			
		}
		
		private function drawShape():Shape {
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xFFFFFF,1);
			sh.graphics.drawRoundRect(0,0,this.width-2,this.height-2,10,10);
			sh.graphics.endFill();
			
			return sh;
		}
	}
}