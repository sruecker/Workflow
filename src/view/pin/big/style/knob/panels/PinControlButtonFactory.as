package view.pin.big.style.knob.panels {
	
	//imports
	import model.StatusFlag;
	
	import mvc.IController;
	
	import settings.Settings;
	
	import util.DeviceInfo;
	
	/**
	 * PinControlButton Factory.
	 * Fabricates Control Buttons according to the specifications.
	 * OS:
	 * 	- iPhone (iPad Retina Display)
	 *  - Mac OS
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinControlButtonFactory {
		
		//****************** STATIC PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 * PinControlButton Factory.
		 * Fabricates Control Buttons according to the specifications.
		 * OS:
		 * 	- iPhone (iPad Retina Display)
		 *  - Mac OS
		 * 
		 * @author lucaju
		 * 
		 */
		static public function addPinControlButton(flag:StatusFlag):PinControlButton {	
			
			var item:PinControlButton;
			item = new PinControlButton(flag);
			
			var imageFilePath:String = "images/icons/";
			
			//switch style
			switch (Settings.platformTarget) {
				case "air":
					item.icon = imageFilePath + getSDIcon(flag);
					break;
				
				case "mobile":
					item.icon = imageFilePath + getHDIcon(flag);
					break;
			}
			
			return item;
		}
		
		
		//****************** STATIC PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * Get SD icon
		 * 
		 * @param flag
		 * @return 
		 * 
		 */
		static protected function getSDIcon(flag:StatusFlag):String {
			
			var icon:String;
			var baseFlag:StatusFlag = Settings.getFlagByName(flag.name);
			
			//Switch Flag
			switch (flag.name) {
				
				case "Start":
					icon = "start_circle.png";
					break;
				
				case "Working":
					icon = "working_circle.png";
					break;
				
				case "Working Complete":
					icon = "working_circle.png";
					break;
				
				case "Incomplete":
					icon = "incomplete_circle.png";
					break;
				
				case "Complete":
					icon = "complete_circle.png";
					break;
			}
			
			baseFlag.icon = icon;
			
			return icon;
		}
		
		/**
		 * 
		 * Get HD icon
		 * 
		 * @param flag
		 * @return 
		 * 
		 */
		static protected function getHDIcon(flag:StatusFlag):String {
			
			var icon:String;
			var baseFlag:StatusFlag = Settings.getFlagByName(flag.name);
			
			//Switch Flag
			switch (flag.name) {
				
				case "Start":
					icon = "start_circle@2x.png";
					break;
				
				case "Working":
					icon = "working_circle@2x.png";
					break;
				
				case "Working Complete":
					icon = "working_circle@2x.png";
					break;
				
				case "Incomplete":
					icon = "incomplete_circle@2x.png";
					break;
				
				case "Complete":
					icon = "complete_circle@2x.png";
					break;
			}
			
			baseFlag.icon = icon;
			
			return icon;
		}
		
	}
}