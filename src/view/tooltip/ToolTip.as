package view.tooltip {
	
	//
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ToolTip extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _id						:int;						//Holds ToolTip Id
		protected var _sourceId					:int;						//Holds Source Id
		protected var _source					:Sprite
		
		protected var margin					:Number = 4;				// Margin size
		protected var _arrowDirection			:String = "bottom";			// Arrow point direction
		
		protected var _balloonColor				:uint 	= 0xFFFFFF;			//Balloon Color
		protected var _balloonAlpha				:Number = 1;				//Balloon Alpha
		protected var _textColor				:uint	= 0x000000;			//Text Color
		
		protected var shapeBox					:Balloon;
		protected var textTF					:TextField;
		protected var style						:TextFormat;
		protected var _fontSize					:uint;
		
		
		//****************** Properties ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param id_
		 * 
		 */
		public function ToolTip(id_:int = 0) {
			_id = id_;
			
			style = new TextFormat();
			textTF = new TextField();
		}
			
		//****************** INITIALIZE ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param data
		 * @param orientation_
		 * 
		 */
		public function init(data:Object, orientation_:String = "bottom"):void {
			
			source = data.source;
			
			_arrowDirection = orientation_;
			if (data.id) _sourceId = data.id;
		
			//style
			style.font = "Arial Narrow";
			style.size = _fontSize;
			style.bold = true;
			style.color = _textColor;
			style.align = "center";
			
			//title
			textTF.selectable = false;
			textTF.multiline = true;
			textTF.mouseWheelEnabled = false;
			textTF.mouseEnabled = false;
			textTF.wordWrap = true;
			textTF.autoSize = "left";
			
			textTF.htmlText = data.info;
			
			textTF.setTextFormat(style);
			
			addChild(textTF);
			
			//shape
			shapeBox = new Balloon();
			shapeBox.color = _balloonColor;
			shapeBox.alpha = _balloonAlpha;
			shapeBox.arrowDirection = _arrowDirection;
			shapeBox.glow(true);
			shapeBox.init(this.width + margin + margin, this.height);
			
			this.addChildAt(shapeBox,0);
			
			//elements Position
			shapeBox.x = -shapeBox.width/2;
			shapeBox.y = -shapeBox.height;
			
			textTF.x = shapeBox.x + (shapeBox.activeArea.width/2) - (textTF.width/2);
			textTF.y = shapeBox.y + (shapeBox.activeArea.height/2) - (textTF.height/2);
			
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {	
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get sourceId():int {	
			return _sourceId;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowDirection():String {
			return _arrowDirection;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get source():Sprite {
			return _source;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function set arrowDirection(value:String):void {
			_arrowDirection = value;
			shapeBox.changeOrientation(value);
			
			textTF.y = shapeBox.y + shapeBox.activeArea.y + (shapeBox.activeArea.height/2) - (textTF.height/2);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set balloonColor(value:uint):void{
			_balloonColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set balloonAlpha(value:Number):void {
			_balloonAlpha = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textColor(value:uint):void {
			_textColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set fontSize(value:uint):void {
			_fontSize = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set source(value:Sprite):void {
			_source = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set TFWidth(value:Number):void {
			textTF.width = value;
		}
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param offset
		 * 
		 */
		public function arrowOffsetH(offset:Number):void {
			shapeBox.arrowOffsetH(offset);
		}

	}
}