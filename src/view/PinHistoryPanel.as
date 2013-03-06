package view {
	
	//imports
	//import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import view.graphic.ShadowLine;
	import view.util.scroll.Scroll;
	
	public class PinHistoryPanel extends PinView {
		
		//Properties
		private var pinId:int;										//pinId;
		private var _shape:Shape;									//shape
		private var TF:TextField;									//Textfield
		
		
		private const margin:uint = 3;
		private const wide:int = 180;
		private const _maxHeight:int = 200;
		
		private var data:Array;
		
		private var logItemCollection:Array;
		private var itemLog:Sprite;
		
		private var scrolledArea:Sprite;
		private var container:Sprite;
		private var containerMask:Sprite;
		//private var containerMask:BlitMask;
		
		private var scroll:Scroll;
		private var scrolling:Boolean = false;
		
		private var titleStyle:TextFormat = new TextFormat("Arial",14,0x333333,true,null,null,null,null,"center");
		private var headerStyle:TextFormat = new TextFormat("Arial",10,0x333333,true);
		private var textStyle:TextFormat = new TextFormat("Arial",10,0x333333);
		
		public function PinHistoryPanel(id:int) {

			super(id);
			
			_id = id;
			
			//init
			shape = new Shape();
			var posY:Number = margin;
			
			//title
			TF = createTF();
			TF.text = "History";
			TF.setTextFormat(titleStyle);
			
			TF.x = (wide/2) - TF.width/2;
			TF.y = posY;
			this.addChild(TF);
			
			posY += TF.height + 5;
			
			
			// header
			var bar:Shape = new Shape();
			bar.graphics.beginFill(0xD1D2D4);
			bar.graphics.drawRect(0,0,wide,10);
			bar.graphics.endFill();
			bar.y = posY;
			addChild(bar)
			
			//date
			TF = createTF();
			TF.text = "Date";
			TF.setTextFormat(headerStyle);
			
			TF.x = 20;
			TF.y = posY - 3;
			this.addChild(TF);
			
			//step
			TF = createTF();
			TF.text = "Step";
			TF.setTextFormat(headerStyle);
			
			TF.x = 70;
			TF.y = posY - 3;
			this.addChild(TF);

			//flag
			TF = createTF();
			TF.text = "Flag";
			TF.setTextFormat(headerStyle);
			
			TF.x = 105;
			TF.y = posY - 3;
			this.addChild(TF);
			
			//Responsible
			TF = createTF();
			TF.text = "Resp.";
			TF.setTextFormat(headerStyle);
			
			TF.x = 140;
			TF.y = posY - 3;
			this.addChild(TF);
			
			
			// ---------------------------------------------------------
			posY += TF.height - 5;
			
			//get info
			data = workflowController.getPinLog(_id);
			
			//scrolled area
			scrolledArea = new Sprite();
			scrolledArea.y = posY;
			this.addChild(scrolledArea);
			
			//list container
			container = new Sprite();
			scrolledArea.addChild(container);
			
			posY = 5;
			
			//inverted loop
			logItemCollection = new Array;
			data.reverse();
			
			for each(var logItem:Object in data) {
				
				itemLog = addItemLog(logItem);
				itemLog.x = margin;
				itemLog.y = posY
				
				posY += itemLog.height + 2
					
				container.addChild(itemLog)
				
				logItemCollection.push(itemLog);
				

			}
			
			//shadow line
			var lineStart:ShadowLine = new ShadowLine(wide);
			lineStart.scaleY = -1;
			lineStart.y = scrolledArea.y
			addChild(lineStart);
			
			
			testForScroll();
			
			//scroll
			
			
			//shadow line
			//var lineEnd:ShadowLine = new ShadowLine(wide);
			//lineEnd.y = shape.y + shape.height;
			//addChild(lineEnd);
			
			
			//add shape
			this.addChildAt(shape,0);
			
		}
		
		private function testForScroll(contructor:Boolean = true, diff:Number = 0):void {
			
			
			if (container.height + diff > _maxHeight) {
				scrolling = true;
				
				//mask for container
				containerMask = new Sprite();
				containerMask.graphics.beginFill(0xFFFFFF,0);
				containerMask.graphics.drawRect(container.x, scrolledArea.y, wide, _maxHeight - scrolledArea.y);
				this.addChild(containerMask);
				container.mask = containerMask
				
				//containerMask = new BlitMask(container, container.x, container.y, wide, _maxHeight -scrolledArea.y, true);
				//containerMask.disableBitmapMode();
				
				//add scroll system
				scroll = new Scroll();
				scroll.x = wide - 6;
				scroll.y = container.y;
				scrolledArea.addChild(scroll);
				
				scroll.target = container;
				scroll.maskContainer = containerMask;
				
				//create background
				container.graphics.clear();
				container.graphics.beginFill(0xFFFFFF,0);
				container.graphics.drawRect(0,0,container.width,container.height);
				container.graphics.endFill();
				
				//shape
				shape.graphics.clear();
				drawShape();
			}
			
			if(contructor) {
				drawShape()
			} else {
				
				//grow shape if not scrollin // if gos to scroll, correct the scale
				if(!scrolling) {
					TweenMax.to(shape,.4,{height:this.height + (2*margin) + diff});
				} else {
					shape.scaleY = 1;
				}
			}
			
				
		}
		
		
		
		public function addNewItemLog():void {
			
			//move list
			var offset:Number;
			for each(var item:Sprite in logItemCollection) {
				item.y = item.y + item.height + 2
				//TweenMax.to(item,.4,{y:item.y + item.height + 2});
			}
			
			data = workflowController.getPinLog(_id);
			
			itemLog = addItemLog(data[data.length-1]);
			itemLog.x = margin;
			itemLog.y = 5;
			
			container.addChild(itemLog)
			
			logItemCollection.unshift(itemLog);
			
			TweenMax.from(itemLog,2,{alpha:0, ease:Back.easeOut});
			
			
			if (!scrolling) {
				testForScroll(false, 0);
			} else {
				scroll.target = container;
			}
			
			//centralize
			TweenMax.to(this,1,{y:-this.windowHeight/2});
		}
		
		private function addItemLog(info:Object):Sprite {
			var item:Sprite = new Sprite();
			
			//date
			TF = createTF();
			TF.text = info.date;
			TF.setTextFormat(textStyle);
			TF.x = margin;
			item.addChild(TF);
			
			//step
			TF = createTF();
			TF.text = info.step.toUpperCase();
			TF.setTextFormat(textStyle);
			TF.x = 70;
			item.addChild(TF);
		
			//flag
			var ball:Sprite = drawCircle(info.flag)
			ball.x = 110;
			item.addChild(ball);
			
			//Responsible
			TF = createTF();
			TF.text = info.resp;
			TF.setTextFormat(textStyle);
			TF.x = 140;
			item.addChild(TF);
			
			return item;
		}
		
		private function drawCircle(value:String):Sprite {
			var circle:Sprite = new Sprite();
			
			//define color
			var color:uint;
			for each(var colorFlag:Object in flags) {
				if (colorFlag.name == value) {
					color = colorFlag.color;
					break;
				}
			}
			
			///put a line if it is white color
			if (color == 0xFFFFFF) {
				circle.graphics.lineStyle(1, 0x666666);
			}
			
			//draw
			circle.graphics.beginFill(color);
			circle.graphics.drawCircle(6,8,6);
			circle.graphics.endFill();
			
			return circle;
		}
		
		
		private function createTF():TextField {
			var TFGeneric:TextField = new TextField();
			TFGeneric.autoSize = "left";
			TFGeneric.selectable = false;
			return TFGeneric;
		}
		
		private function drawShape():void {
			
			shape.graphics.beginFill(0xFFFFFF,1);
				
			if(scrolling) {
				shape.graphics.drawRoundRect(0,0,wide,scrolledArea.x + _maxHeight + margin,10,10);
			} else {
				shape.graphics.drawRoundRect(0,0,wide,this.height + (2*margin),10,10);
			}
			
			shape.graphics.endFill();
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			this.filters = fxs;
		}

		public function get windowHeight():int {
			return shape.height;
		}

		public function get shape():Shape {
			return _shape;
		}

		public function set shape(value:Shape):void {
			_shape = value;
		}


	}
}