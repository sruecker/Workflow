package view.pin.big {
	
	//imports
	import settings.Settings;
	
	import view.pin.PinView;
	import view.pin.big.style.knob.BigPin;
	import view.pin.big.style.pop.BigPin;
	
	/**
	 * Big Pin Factory.
	 * Fabricates Big pin according to the specifications.
	 * Style:
	 * 	- pop
	 * 	- knob
	 *  
	 * @author lucaju
	 * 
	 */
	public class BigPinFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * Big Pin Factory.
		 * Fabricates Big pin according to the specifications.
		 * Style:
		 * 	- pop
		 * 	- knob
		 *  
		 * @author lucaju
		 * 
		 */
		static public function addBigPin(target:PinView):AbstractBigPin {	
			
			var item:AbstractBigPin;
			
			//Switch Location
			switch (Settings.bigPinCurrentStyle) {
				
				case "pop":
					item = new view.pin.big.style.pop.BigPin(target)
					break;
				
				case "knob":
					item = new view.pin.big.style.knob.BigPin(target);
					break;
			}
			
			return item;
		}
		
	}
}