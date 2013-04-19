package view.pin.panels {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinControlButton extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _label					:String;					//label
		protected var _selected					:Boolean = false;			//Whether button is selected or not
		
		protected var shape						:Shape;
		protected var _icon						:Sprite;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param label_
		 * 
		 */
		public function PinControlButton(label:String = "") {
			_label = label;
				
			//init
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, _buttonDown);
			this.addEventListener(MouseEvent.MOUSE_UP, _buttonUp);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param starPos
		 * @param arcLength
		 * 
		 */
		public function init(starPos:Number, arcLength:Number):void {
			
			shape = new Shape();
			addChildAt(shape,0);
				
			//draw the slice
			drawArc(0, 0, 60, starPos/360, arcLength/360, 20);

		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}
		
		
		//****************** SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set icon(value:String):void {
			_icon = new Sprite();
			this.addChild(_icon);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _iconComplete)
			loader.load(new URLRequest(value));
			_icon.addChild(loader)
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************

		/**
		 * 
		 * @param centerX
		 * @param centerY
		 * @param radius
		 * @param startAngle
		 * @param arcAngle
		 * @param steps
		 * 
		 */
		protected function drawArc(centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:Number):void {
			
			//line
			shape.graphics.lineStyle(2, 0x6D6E70);
			
			//fill
			//if it is the close button
			if (_label == "close") {
				shape.graphics.beginGradientFill("radial",[0x999999,0xbbbbbb],[1,1],[100,150]);
			} else {
				shape.graphics.beginGradientFill("radial",[0xCCCCCC,0xFFFFFF],[1,1],[100,150]);
			}
			
			// Rotate the point of 0 rotation 1/4 turn counter-clockwise.
			startAngle -= .25;
			//
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			var angle:Number = 0;
			
			//draw arch
			shape.graphics.lineTo(xx, yy);
			for(var i:Number=1; i<=steps; i++){
				angle = startAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				shape.graphics.lineTo(xx, yy);
				
				//icon position
				if (_icon) {
					if(i == steps/2) {
						_icon.x = centerX + Math.cos(angle * twoPI) * (radius-12);
						_icon.y = centerY + Math.sin(angle * twoPI) * (radius-12);
					}
				}
			}
			shape.graphics.lineTo(0, 0);
			shape.graphics.endFill();
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _iconComplete(event:Event):void {
			
			//icon size
			event.target.content.width = event.target.content.height = 16;
			
			//icon position
			event.target.content.x = -event.target.content.width/2;
			event.target.content.y = -event.target.content.height/2;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _buttonDown(e:MouseEvent):void {
			TweenMax.to(shape,1,{colorTransform:{tint:0x2F99C9, tintAmount:.5}});
			//TweenMax.to(this,1,{scaleX:1.05, scaleY:1.05});
			//TweenMax.to(this, .2, {bevelFilter:{blurX:10, blurY:10, strength:1, distance:10}});
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _buttonOut(e:MouseEvent):void {
			TweenMax.to(shape,1,{colorTransform:{tint:0xFFFF00, tintAmount:0}});
			//TweenMax.to(this,1,{scaleX:1.05, scaleY:1.05});
			//TweenMax.to(this, .2, {bevelFilter:{blurX:10, blurY:10, strength:1, distance:10}});
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		public function _buttonUp(e:MouseEvent):void {
			
			//toggle
			_selected = !_selected;
			
			//animation
			if(_selected) {
				TweenMax.to(shape,1,{colorTransform:{tint:0x2F99C9, tintAmount:.5}});
			} else {
				TweenMax.to(shape,1,{colorTransform:{tint:0xFFFF00, tintAmount:0}});
			}
			
			//TweenMax.to(this,1,{scaleX:1, scaleY:1});
			//TweenMax.to(this, 1, {bevelFilter:{blurX:0, blurY:0, strength:0, distance:0, remove:true}});
		}

	}
}