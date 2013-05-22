package view.pin.big {
	
	//imports
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import controller.WorkflowController;
	
	import view.pin.PinView;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class AbstractBigPin {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var target					:PinView;						//target
		
		protected var _pinControlPanel			:AbstractPanel;				//Control panel for the big view
		protected var _infoPanel				:AbstractPanel;						//Info panel for the big view
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		public function AbstractBigPin(pin:PinView) {
			target = pin;
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			//to override
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get pinControlPanel():AbstractPanel {
			return _pinControlPanel;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get infoPanel():AbstractPanel {
			return _infoPanel;
		}
		
		
		//****************** EVENTS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function tagIt(e:MouseEvent):void {
			target.tagged = !target.tagged;
			target.star.active = target.tagged;
			
			//send to model
			WorkflowController(target.getController()).tagPin(target.id,target.tagged);
		}
		
		
		//****************** PRIVATE METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param item
		 * 
		 */
		protected function removeItem(item:DisplayObject):void {
			target.removeChild(item);
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function close():void {
			//to override
		}
		
		public function drawShape():void {
			//to override
		}

	}
}