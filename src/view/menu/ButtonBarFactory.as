package view.menu {
	
	//imports
	import util.DeviceInfo;
	
	/**
	 * Button Bar Factory.
	 * Fabricates Button Bars according to the speciications.
	 * Location:
	 * 	- Topbar
	 * OS:
	 * 	- iPhone (iPad Retina Display)
	 *  - Mac OS
	 *  
	 * @author lucaju
	 * 
	 */
	public class ButtonBarFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * Add Button Bar
		 * Return a built Button Bars according to the speciications.
		 * Location:
		 * 	- Topbar
		 * OS:
		 * 	- iPhone (iPad Retina Display)
		 *  - Mac OS
		 * 
		 * @param title:String
		 * @return ButtonBar
		 * 
		 */
		static public function addButtonBar(title:String):ButtonBar {	
			
			//create new Button Bar
			var item:ButtonBar = new ButtonBar();
			var titleLower:String = title.toLowerCase();
			
			if (DeviceInfo.os() == "iPhone") {
				item.iconFile = getIconFileForIphone(titleLower);
			} else {
				item.iconFile = getIconFileForMac(titleLower);
			}
	
			//initiate
			item.init(title);
			
			titleLower = null;
			
			return item;
		}
		
		
		//****************** STATIC PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * Get Icon File for Mac
		 *  
		 * @param titleLower:Strinf
		 * @return String
		 * 
		 */
		static private function getIconFileForMac(titleLower:String):String {
			
			var file:String;
			
			switch(titleLower) {
				
				case "list":
					file = "/images/" + titleLower + ".png";
					break;
				
			}
			
			return file;
		}
		
		/**
		 * Get Icon File for iPhone (iPad retina Display)
		 *  
		 * @param titleLower:Strinf
		 * @return String
		 * 
		 */
		static private function getIconFileForIphone(titleLower:String):String {
			
			var file:String;
			
			switch(titleLower) {
				
				case "list":
					file = "/images/" + titleLower + "@2x.png";
					break;

			}
			
			return "";
		}
	}
}