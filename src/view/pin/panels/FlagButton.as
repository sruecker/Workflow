package view.pin.panels {
	
	//imports
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public final class FlagButton extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		private var _label				:String;				//Button Label
		private var ball				:Sprite;				//Button Mark
		private var style				:TextFormat;			//Style
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @param _label
		 * @param color
		 * 
		 */
		public function FlagButton(label:String, color:uint) {
			
			//initial
			style = new TextFormat("Arial",12,0x333333,true);
			
			_label = label;
			
			//---Layout
			//1.spot color
			var spot:Sprite = new Sprite();
			spot.graphics.lineStyle(1,0x333333)
			spot.graphics.beginFill(color);
			spot.graphics.drawRect(0,0,18,18);
			spot.graphics.endFill();
			addChild(spot);
			
			//2. Mark ball
			ball = new Sprite()
			ball.graphics.beginFill(0x333333);
			ball.graphics.drawCircle(0,0,2);
			ball.graphics.endFill();
			ball.x = spot.width/2;
			ball.y = spot.height/2;
			ball.visible = false;
			spot.addChild(ball);
			
			//3. Label
			var rect:Sprite = new Sprite();
			
			//3.1 text box
			var TF:TextField = new TextField();
			TF.autoSize = "left";
			TF.selectable = false;
			TF.text = label;
			TF.setTextFormat(style);
			
			//3.2 bg
			rect.addChild(TF);
			
			rect.graphics.lineStyle(1,0x333333)
			rect.graphics.beginFill(0xFFFFFF);
			rect.graphics.drawRect(0,0,72,TF.height);
			rect.graphics.endFill();
			
			rect.x = spot.width;
				
			addChildAt(rect,0);
			
			//listeners
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		public function get label():String {
			return _label;
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _over(e:MouseEvent):void {
			ball.visible = true;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _out(e:MouseEvent):void {
			ball.visible = false;
		}

	}
}