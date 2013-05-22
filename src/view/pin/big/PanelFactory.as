package view.pin.big {
	
	//imports
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import settings.Settings;
	
	import view.pin.big.style.knob.panels.InfoPanel;
	import view.pin.big.style.knob.panels.PinControlPanel;
	import view.pin.big.style.knob.panels.HistoryLogPanel;
	import view.pin.big.style.pop.panels.FlagPanel;
	import view.pin.big.style.pop.panels.HistoryLogPanel;
	import view.pin.big.style.pop.panels.InfoPanel;
	import view.pin.big.style.pop.panels.PinControlPanel;
	
	/**
	 * Panel Factory.
	 * Fabricates Panels according to the specifications.
	 * Type:
	 * 	- Flag
	 * 	- History
	 *  - Info
	 *  - Controller
	 * 
	 * OS:
	 * 	- iPhone (iPad Retina Display)
	 *  - Mac OS
	 * 
	 * Style:
	 *  - pop
	 *  - knob
	 *  
	 * @author lucaju
	 * 
	 */
	public class PanelFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * Add Button Bar
		 * Return a built panel according to the specifications.
		 * Type:
		 * 	- Flag
		 * 	- History
		 *  - Info
		 *  - Controller
		 * 
		 * OS:
		 * 	- iPhone (iPad Retina Display)
		 *  - Mac OS
		 * 
		 * Style:
		 *  - pop
		 *  - knob
		 * 
		 * @param title:String
		 * @param location:String
		 * @return ButtonBar
		 * 
		 */
		static public function addPanel(c:IController, type:String):AbstractPanel {	
			
			var item:AbstractPanel;
			
			//switch style
			switch (Settings.bigPinCurrentStyle) {
				case "pop":
					item = getPopPanel(c,type);
					break;
				
				case "knob":
					item = getKnobPanel(c,type);
					break;
			}
			
			return item;
		}
		
		
		//****************** STATIC PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * Get Pop Panels
		 * 
		 * @param c
		 * @param type
		 * @return 
		 * 
		 */
		static protected function getPopPanel(c:IController, type:String):AbstractPanel {
			
			var item:AbstractPanel;
			
			//Switch type
			switch (type) {
				
				case "control":
					item = new view.pin.big.style.pop.panels.PinControlPanel(c);
					break;
				
				case "info":
					item = new view.pin.big.style.pop.panels.InfoPanel(c);
					break;
				
				case "history":
					item = new view.pin.big.style.pop.panels.HistoryLogPanel(c);
					break;
				
				case "flag":
					item = new FlagPanel(c);
					break;
			}
			
			return item;
		}
		
		/**
		 * 
		 * Get Knob Panels
		 * 
		 * @param c
		 * @param type
		 * @return 
		 * 
		 */
		static protected function getKnobPanel(c:IController, type:String):AbstractPanel {
			
			var item:AbstractPanel;
			
			//Switch type
			switch (type) {
				
				case "control":
					item = new view.pin.big.style.knob.panels.PinControlPanel(c);
					break;
				
				case "info":
					item = new view.pin.big.style.knob.panels.InfoPanel(c);
					break;
				
				case "history":
					item = new view.pin.big.style.knob.panels.HistoryLogPanel(c);
					break;
			}
			
			return item;
		}
		
	}
}