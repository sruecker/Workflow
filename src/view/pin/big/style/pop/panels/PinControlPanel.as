package view.pin.big.style.pop.panels {
	
	//imports
	import flash.display.Sprite;
	
	import mvc.IController;
	import view.pin.big.AbstractPanel;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinControlPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var menuOptions			:Array;						//Menu Option
		
		//protected var container				:Sprite;					//Control Panel container
		protected var button				:PinControlButton;			//Buttons
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function PinControlPanel(c:IController) {
			
			super(c);
			
			//complete whell
			/*menuOptions = [{label:"flagAction", file:"arrow.png"},
						   {label:"history", file:"log.png"},
						   {label:"flag", file:"flag.png"},
						   {label:"user", file:"user.png"},
						   {label:"star", file:"star.png"},
						   {label:"view", file:"eye.png"}];*/
			
			//current available options
			menuOptions = [{label:"close", file:"x.png"},
						   {label:"flagAction", file:"arrow.png"},
						   {label:"history", file:"log.png"}];
			
			var imageFilePath:String = "images/icons/";
			
			//container
			container = new Sprite();
			addChild(container)
			
			//loop in the buttons
			var startAngle:Number = 330;
			var arcLength:Number = (360/menuOptions.length);
			
			for each(var option:Object in menuOptions) {
				
				//firt position
				if (menuOptions.indexOf(option) == 0) {
					arcLength = 60;
				} else {
					arcLength = (450/menuOptions.length);
				}
				
				button = new PinControlButton(option.label);
				button.icon = imageFilePath + option.file;
				button.init(startAngle, arcLength);
				container.addChild(button);
				
				//update arch
				startAngle += arcLength;
				
			}
			
		}
		
	}
}