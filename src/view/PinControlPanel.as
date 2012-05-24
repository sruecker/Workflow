package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import mvc.IController;
	
	public class PinControlPanel extends PinView {
		
		//properties
		
		//private var menuOptions:Array = ["flagAction", "history", "flag", "user", "star", "view"];	
		private var menuOptions:Array = ["close","flagAction", "history"];										//Menu Option
		
		private var container:Sprite;																			//Control Panel container
		private var button:PinControlPanelButton;																//Buttons
		
		
		public function PinControlPanel(id:int) {
			
			super(_id);
			
			_id = id;
		}
		
		override public function init():void {
			
			//container
			container = new Sprite();
			addChild(container)
			
			//loop in the buttons
			var startAngle:Number = 330;
			var numOptions:Number = (360/menuOptions.length);
			
			for(var i:int; i < menuOptions.length; i++) {
				if (i==0) {
					numOptions = 60;
				} else {
					numOptions = (450/menuOptions.length);
				}
				
				button = new PinControlPanelButton(_id,startAngle, numOptions,menuOptions[i]);
				button.label = menuOptions[i];
				container.addChild(button);
				
				button.addEventListener(MouseEvent.CLICK, _buttonClick);
				
				startAngle += numOptions;
				
			}
			
		}
		
		
		
		private function _buttonClick(e:MouseEvent):void {
			
			button = PinControlPanelButton(e.currentTarget);
			
			switch (button.label) {
				case "flagAction":
					PinView(this.parent).flagBox(button.isClicked());
					break;
				case "history":
					PinView(this.parent).historyBox(button.isClicked());
					break;
				default: //close button
					PinView(this.parent).closeBigView();
					break
			}
		}
		
	}
}