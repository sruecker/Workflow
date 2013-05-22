package view.pin.big.style.knob.panels {
	
	//imports
	import flash.display.Sprite;
	
	import model.StatusFlag;
	
	import mvc.IController;
	
	import settings.Settings;
	
	import view.pin.big.AbstractPanel;
	
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinControlPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected const options				:Array = ["Start", "Working", "Incomplete", "Complete"];		//hold available options
		protected var _startAngle:Number;
		protected var buttonCollection		:Array;
		
		protected var button				:PinControlButton;			//Buttons
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function PinControlPanel(c:IController) {
			
			super(c);
			
			buttonCollection = new Array();
			
			//current available options
			
			var imageFilePath:String = "images/icons/";
			
			//container
			container = new Sprite();
			addChild(container)
						
			//loop in the buttons
			startAngle = -45;
			var iterationAngle:Number = startAngle;
			var arcLength:Number = (360/options.length);

			for each (var option:String in options) {
				
				var flag:StatusFlag = Settings.getFlagByName(option);
				
				if (flag) {
					
					button = PinControlButtonFactory.addPinControlButton(flag);
					button.init(iterationAngle, arcLength);
					container.addChild(button);
					
					buttonCollection.push(button);
					
					//update arch
					iterationAngle += arcLength;
				}
				
			}
			
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get startAngle():Number {
			return _startAngle;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getOptionsNum():int {
			return options.length;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getIndexPosition(value:String):int {
			var index:int = options.indexOf(value);
			return index;
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getSliceById(value):PinControlButton {
			var slice:PinControlButton = buttonCollection[value];
			return slice;
		}
		
		
		//****************** SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set startAngle(value:Number):void {
			_startAngle = value;
		}
		
		
		//****************** Public Methods ****************** ****************** ******************

		public function highlightOption(value:int):void {
			
			var select:Boolean = false;
			
			for each(var button:PinControlButton in buttonCollection) {
				select = false;
				if (buttonCollection.indexOf(button) == value) {
					select = true;
				}
				button.highlight(select);
			}
			
		}
		
	}
}