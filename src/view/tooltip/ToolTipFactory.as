package view.tooltip {
	
	//imports
	import settings.Settings;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ToolTipFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * ToolTip. Static function to add tooltips. It creates the appropriate tooltip according to the OS and the orientation chose. 
		 * 
		 */
		static public function addToolTip(id:int = 0):ToolTip {	
			
			var toolTip:ToolTip = new ToolTip(id);
			
			switch (Settings.platformTarget) {
				
				case "mobile":
					toolTip.fontSize = 24;
					toolTip.TFWidth = 200;
					break;
				
				default:
					toolTip.fontSize = 12;
					break;
				
			}
			
			return toolTip;
		}
	}
}