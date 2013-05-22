package view.pin.big.style.pop.panels {
	
	//imports
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import controller.WorkflowController;
	
	import model.StatusFlag;
	
	import mvc.IController;
	
	import settings.Settings;
	import view.pin.big.AbstractPanel;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class FlagPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected const options				:Array = ["Start", "Working", "Incomplete", "Complete"];		//hold available options
		
		protected var button				:FlagButton;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * @param id
		 * 
		 */
		public function FlagPanel(c:IController) {
			super(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		override public function init(id:int = 0):void {
			
			pinId = id;
			
			var container:Sprite = new Sprite();
			addChild(container)
			
			// options loop
			var label:String;
			var color:uint;
			for each (var option:String in options) {
				
				var flag:StatusFlag = Settings.getFlagByName(option);
				
				if (flag) {
					button = new FlagButton(flag.name, flag.color);
					button.y = this.height;
					container.addChild(button);
				}

			}
			
			var masc:Shape = drawShape();
			addChild(masc)
			
			container.mask = masc;
			
			//draw box//shape
			panelShape = drawShape();
			this.addChildAt(panelShape,0);
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			this.filters = fxs;
			
			//listener
			this.addEventListener(MouseEvent.CLICK, buttonClick);
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		override protected function drawShape():* {
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xFFFFFF,1);
			sh.graphics.drawRoundRect(0,0,this.width-2,this.height-2,10,10);
			sh.graphics.endFill();
			
			return sh;
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function buttonClick(event:MouseEvent):void {
			if (event.target is FlagButton) {
				var flag:FlagButton = event.target as FlagButton;
				WorkflowController(this.getController()).updatePinFlag(pinId, flag.label);
			}
			
		}	
	}
}