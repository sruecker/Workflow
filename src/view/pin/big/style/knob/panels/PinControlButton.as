package view.pin.big.style.knob.panels {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import model.StatusFlag;
	
	import settings.Settings;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinControlButton extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var radius					:Number = 90;
		
		protected var _flag						:StatusFlag
		
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
		public function PinControlButton(flag:StatusFlag) {
			_flag = flag;
			_label = flag.name;
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
			drawArc(0, 0, radius, starPos/360, arcLength/360, 20);

		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flag():StatusFlag {
			return _flag;
		}
		
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
			shape.graphics.lineStyle(1, 0x6D6E70);
			shape.graphics.beginGradientFill("radial",[flag.color,flag.color],[1,1],[100,150]);
			
			// Rotate the point of 0 rotation 1/4 turn counter-clockwise.
			var iAngle:Number = startAngle;
			iAngle -= .25;
			//
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			var xx:Number = centerX + Math.cos(iAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(iAngle * twoPI) * radius;
			var angle:Number = 0;
			
			//draw arch
			shape.graphics.lineTo(xx, yy);
			for(var i:Number=1; i<=steps; i++){
				angle = iAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				shape.graphics.lineTo(xx, yy);
				
				//icon position
				if (_icon) {
					if(i == steps/2) {
						_icon.x = centerX + Math.cos(angle * twoPI) * (radius-24);
						_icon.y = centerY + Math.sin(angle * twoPI) * (radius-24);
						_icon.rotation = (startAngle + (arcAngle/2)) * 360;
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
			//event.target.content.width = event.target.content.height = 16;
			
			if (Settings.platformTarget == "mobile") {
				event.target.content.scaleX = event.target.content.scaleY = .5;
			}
			
			//icon position
			event.target.content.x = -event.target.content.width/2;
			event.target.content.y = -event.target.content.height/2;
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function highlight(value:Boolean):void {
			
			if (value != selected) {
				
				selected = value;
				
				if (selected) {
					TweenMax.to(shape, 1, {glowFilter:{color:flag.color, alpha:1, blurX:30, blurY:30,strength:1}});
					
					if (flag.color == 0xFFFFFF) {
						TweenMax.to(_icon, 1, {tint:0x000000});
					} else {
						TweenMax.to(_icon, 1, {tint:0xFFFFFF});
					}
					
				} else {
					TweenMax.to(shape, 1, {glowFilter:{color:flag.color, alpha:0, blurX:0, blurY:0,strength:0,remove:true}});
					TweenMax.to(_icon, 1, {removeTint:true});
				}
			}
		}

	}
}