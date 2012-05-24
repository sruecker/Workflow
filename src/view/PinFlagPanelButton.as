package view {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public final class PinFlagPanelButton extends PinFlagPanel {
		
		//properties
		private var label:String;
		private var spot:Sprite;
		private var rect:Sprite;
		private var ball:Sprite;
		private var labelStyle:TextFormat = new TextFormat("Arial",12,0x333333,true);
		
		public function PinFlagPanelButton(id:int, _label:String, color:uint) {
		
			super(id);
			
			_id = id;
			
			label = _label;
			
			this.buttonMode = true;
			this.mouseChildren = false;
			
			//spot color
			var spot:Sprite = new Sprite();
			spot.graphics.lineStyle(1,0x333333)
			spot.graphics.beginFill(color);
			spot.graphics.drawRect(0,0,18,18);
			spot.graphics.endFill();
			addChild(spot);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			this.addEventListener(MouseEvent.CLICK, _click);
			
			ball = new Sprite()
			ball.graphics.beginFill(0x333333);
			ball.graphics.drawCircle(0,0,2);
			ball.graphics.endFill();
			ball.x = spot.width/2;
			ball.y = spot.height/2;
			ball.visible = false;
			spot.addChild(ball);
			
			//label
			rect = new Sprite();
			
			//text box
			var TF:TextField = new TextField();
			TF.autoSize = "left";
			TF.selectable = false;
			TF.text = label;
			TF.setTextFormat(labelStyle);
			
			rect.addChild(TF);
			
			rect.graphics.lineStyle(1,0x333333)
			rect.graphics.beginFill(0xFFFFFF);
			rect.graphics.drawRect(0,0,72,TF.height);
			rect.graphics.endFill();
			
			rect.x = spot.width;
				
			addChildAt(rect,0);
		}
		
		public function _over(e:MouseEvent):void {
			ball.visible = true;
		}
		
		public function _out(e:MouseEvent):void {
			ball.visible = false;
		}
		
		public function _click(e:MouseEvent):void {
			workflowController.changePinFlag(_id, label);
		}
	}
}