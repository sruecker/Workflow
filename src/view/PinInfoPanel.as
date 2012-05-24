package view {
	
	//imports
	import flash.display.Shape;
	import flash.filters.BitmapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mvc.IController;

	
	final public class PinInfoPanel extends PinView {
		
		//Properties
		private var shape:Shape;									//shape
		private var titleTF:TextField;								//Title
		private var authorityTF:TextField;							//Authority
		private var sourceTF:TextField;								//Source
		private var stageTF:TextField;								//Stage
		private var statusTF:TextField;								//status
		
		private const margin:uint = 5;
		private const wide:int = 165;
		
		
		private var titleStyle:TextFormat = new TextFormat("Arial",14,0x333333,true);
		private var nameStyle:TextFormat = new TextFormat("Arial",10,0x333333,true);
		private var textStyle:TextFormat = new TextFormat("Arial",10,0x333333);
		
		public function PinInfoPanel(id:int) {
			
			super(id);
			
			_id = id;
			
			//init
			shape = new Shape();
			var posY:Number = margin;
			
			//title
			var title:String = workflowController.getPinTitle(id);
			
			titleTF = createTF();
			titleTF.text = title;
			titleTF.setTextFormat(titleStyle);
			
			titleTF.y = posY;
			this.addChild(titleTF);
			
			posY += titleTF.height;
			
			//Authority
			var authority:String = workflowController.getPinAuthority(id);
				
			authorityTF = createTF();
			authorityTF.text = "Authority: "+ authority;
			authorityTF.setTextFormat(nameStyle,0,10);
			authorityTF.setTextFormat(textStyle,10,authorityTF.length);
			
			authorityTF.y = posY;
			this.addChild(authorityTF);
			
			posY += authorityTF.height;
			
			//Source
			var source:String = workflowController.getPinSource(_id);
			
			sourceTF = createTF();
			sourceTF.text = "Source: "+ source;
			sourceTF.setTextFormat(nameStyle,0,7);
			sourceTF.setTextFormat(textStyle,7,sourceTF.length);
			
			sourceTF.y = posY;
			this.addChild(sourceTF);
			
			posY += sourceTF.height;
			
			//Stage
			var stepAcronym:String = workflowController.getPinActualStep(_id);
			var stepTitle:String = workflowController.getStepTitleByAcronym(stepAcronym);
			
			stageTF = createTF();
			stageTF.text = "Stage: "+ stepTitle + " (" +stepAcronym.toUpperCase() + ")";
			stageTF.setTextFormat(nameStyle,0,7);
			stageTF.setTextFormat(textStyle,7,stageTF.length);
			
			stageTF.y = posY;
			this.addChild(stageTF);
			
			posY += stageTF.height;
			
			//status
			var statusInfo:String = workflowController.getPinActualFlag(_id);
			
			statusTF = createTF();
			statusTF.text = "Status: "+ statusInfo;
			statusTF.setTextFormat(nameStyle,0,7);
			statusTF.setTextFormat(textStyle,7,statusTF.length);
			
			statusTF.y = posY;
			this.addChild(statusTF);
			
			//shape
			drawShape();
			this.addChildAt(shape,0);
			
		}
		
		private function createTF():TextField {
			var TF:TextField = new TextField();
			TF.width = wide - (2*margin)
			TF.autoSize = "left";
			TF.wordWrap = true;
			TF.selectable = false;
			TF.x = margin;
			return TF;
		}
		
		private function drawShape():void {
			
			shape.graphics.beginFill(0xFFFFFF,1);
			shape.graphics.drawRoundRect(0,0,wide,this.height + (2*margin),10,10);
			shape.graphics.endFill();
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			this.filters = fxs;
		}
		
		public function updateFlagInfo():void {
			var statusInfo:String = workflowController.getPinActualFlag(_id);
			statusTF.text = "Status: "+ statusInfo;
			statusTF.setTextFormat(nameStyle,0,7);
			statusTF.setTextFormat(textStyle,7,statusTF.length);
		}
	}
}