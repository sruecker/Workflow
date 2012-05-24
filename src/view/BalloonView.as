package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mvc.IController;
	
	import view.graphic.Balloon;
	
	
	public class BalloonView extends OrlandoView {	
		
		// properties
		private var _id:int;							// Article's id

		private var maxWidth:Number = 150;				// Balloon max width
		private var minHeight:Number = 20;				// Balloom min height
		private var round:Number = 10;					// Round corners
		private var margin:Number = 2;					// Margin size
		private var _arrowDirection:String = "bottom";	// Arrow point direction
		
		private var verticalOffset:Number = 10;			// Vertical Offtset
		private var horizontalOffset:Number = 0;		// Vertical Offtset
		

		private var shapeBox:Balloon;					//Shape of the balloon;
		private var closeButton:CloseButton				//Close Button
		
		private var titleTF:TextField;					// Title Textfield
		private var titleStyle:TextFormat = new TextFormat("Arial Narrow", 12, 0x646363,true,null,null,null,null,"center");
		
		
		//Constructor
		public function BalloonView(c:IController, idValue:int) {
			
			super(c);
			
			//save properties
			_id = idValue;
			
		}
		
		public function initialize(data:Object):void {
			
			//set
			this.x = data.x;
			this.y = data.y - verticalOffset;
			
			//----------title
			titleTF = new TextField();
			titleTF.multiline = true;
			titleTF.wordWrap = true;
			titleTF.selectable = false;
			titleTF.autoSize = "center";
			titleTF.text = data.title;
			titleTF.setTextFormat(titleStyle);
			
			titleTF.x = margin;
			titleTF.y = margin;
			
			addChild(titleTF);
			
			//shape
			shapeBox = new Balloon(titleTF.width + (2 * margin), titleTF.height + (2 * margin));
			addChildAt(shapeBox,0);
			
			//close button
			closeButton = new CloseButton();
			addChild(closeButton);
			
			//elements Position
			shapeBox.x = -shapeBox.width/2;
			shapeBox.y = -shapeBox.height;
			
			titleTF.x = shapeBox.x + margin;
			titleTF.y = shapeBox.y + margin;
			
			closeButton.x = shapeBox.x + shapeBox.width;
			closeButton.y = shapeBox.y;
			
			
			//test if this is off the screen
			//test vertical
			
			if (this.y - this.height < 0) {
				this.y = data.y + verticalOffset;
				_arrowDirection = "top";
				shapeBox.changeOrientation(_arrowDirection);
				shapeBox.y = 0;
				closeButton.y = shapeBox.y + 4;
				titleTF.y = shapeBox.y + shapeBox.height - titleTF.height;
				
			}
			
			
			//test horizontal
			if (this.x < margin) {
				horizontalOffset = this.x - margin;
				this.x = margin;		
			} else  if (this.x + this.width > this.stage.stageWidth - margin) {
				horizontalOffset = (this.x + this.width) - (this.stage.stageWidth - margin);
				this.x = this.stage.stageWidth - this.width - margin;
			}
			
			if (horizontalOffset != 0) {
				shapeBox.arrowOffsetH(horizontalOffset);
			}
			
			
			
			//transition
			switch (_arrowDirection) {
				case "bottom":
					TweenMax.from(this, 1, {y: this.y + 20, alpha: 0});
					break
				
				case "top":
					TweenMax.from(this, 1, {y: this.y - 20, alpha: 0});
					break;
			}
			
			//listeners
			this.addEventListener(MouseEvent.MOUSE_UP, _changeLayer)
			closeButton.addEventListener(MouseEvent.MOUSE_UP, _closebutton);
		}
		
		private function _closebutton(e:MouseEvent):void {
			workflowController.killBalloon(id)
		}
		//change layer
		private function _changeLayer(e:MouseEvent):void {
			OrlandoView(this.parent).changeLayer(this);
		}
		
		
		//------- gets
		
		public function get id():int {	
			return _id;
		}

		public function get arrowDirection():String {
			return _arrowDirection;
		}


	}
}