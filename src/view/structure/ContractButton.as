package view.structure {
	
	//imports
	import flash.display.Sprite;
	
	import view.graphic.AbstractShape;
	import view.graphic.RoundRect;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ContractButton extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var contractAction			:Boolean;
		protected var icon						:Sprite;
		protected var _origX					:Number;
		protected var _origY					:Number;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param contract
		 * 
		 */
		public function ContractButton(contract:Boolean = true) {
			
			//save parameters
			contractAction = contract;
			
			//---build UI
			
			//button
			var shape:AbstractShape;
			shape = new RoundRect(15,15,10);
			shape.color = 0x444444;
			shape.lineThickness = 2;
			shape.lineColor = 0xC6C7C9;
			
			shape.drawShape();
			
			shape.x = -shape.width/2;
			shape.y = -shape.height/2;
			
			this.addChild(shape);
			
			//icon
			icon = new Sprite();
			changeIcon(contractAction)
			addChild(icon);
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param contract
		 * 
		 */
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
		
		
		//****************** GETTERS ****************** ******************  ****************** 

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get origX():Number {
			return _origX;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get origY():Number {
			return _origY;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set origX(value:Number):void {
			_origX = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set origY(value:Number):void {
			_origY = value;
		}

		
	}
}