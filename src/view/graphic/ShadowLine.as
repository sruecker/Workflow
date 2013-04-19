package view.graphic {
	
	//imports
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ShadowLine extends Sprite{
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param w
		 * 
		 */
		public function ShadowLine(w:uint) {
			var shadow:Sprite = new Sprite();
			
			shadow.graphics.beginGradientFill("linear",[0x000000,0xFFFFFF],[1,0],[0,255]);
			shadow.graphics.drawRect(0,0,255,w);
			shadow.graphics.endFill();
			shadow.alpha = .8;
			shadow.width = 20;
			//shadow.x = -shadow.height;
			shadow.rotation = -90;
			addChild(shadow);
			
			this.blendMode = "multiply";
			
		}
	}
}