package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	final public class PinControlPanelButton extends PinControlPanel {
		
		//properties
		private var _buttonLabel:String;
		private var shape:Shape;
		private var icon:Sprite;
		private var _clicked:Boolean = false;
		private var url:URLRequest;
		private var loader:Loader;
		
		public function PinControlPanelButton(id:int, starPos:Number, arcLength:Number, iconName:String) {
			
			super(id);
			
			_id = id
			
			_buttonLabel = iconName;
				
			//init
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, _buttonDown);
			this.addEventListener(MouseEvent.MOUSE_UP, _buttonUp);
				
			shape = new Shape();
			addChild(shape);
			
			
			//push icon
			var file:String;
			switch(iconName) {
				case "history":
					file = "images/icons/log.png";
					break;
				
				case "flagAction":
					file = "images/icons/arrow.png";
					break;
				
				case "flag":
					file = "images/icons/flag.png";
					break;
				
				case "user":
					file = "images/icons/user.png";
					break;
				
				case "star":
					file = "images/icons/star.png";
					break;
				case "view":
					file = "images/icons/eye.png";
					break;
				
				case "close":
					file = "images/icons/x.png";
					break;
			}
			
			if(file) {
				icon = new Sprite();
				this.addChild(icon);
				
				url = new URLRequest(file);
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _iconComplete)
				loader.load(url);
				icon.addChild(loader)
				
			}
				
			//draw the slice
			drawArc(0, 0, 60, starPos/360, arcLength/360, 20);

		}

		private function drawArc(centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:Number):void {
			
			shape.graphics.lineStyle(2, 0x6D6E70);
			
			//if is close
			if (_buttonLabel == "close") {
				shape.graphics.beginGradientFill("radial",[0x999999,0xbbbbbb],[1,1],[100,150]);
			} else {
				shape.graphics.beginGradientFill("radial",[0xCCCCCC,0xFFFFFF],[1,1],[100,150]);
			}
			
			
		
			
			//	shape.graphics.beginFill(0xFFFFFF);
			//
			// Rotate the point of 0 rotation 1/4 turn counter-clockwise.
			startAngle -= .25;
			//
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			var angle:Number = 0;
			
			
			
			//shape.graphics.lineTo(radius, 0);
			shape.graphics.lineTo(xx, yy);
			for(var i:Number=1; i<=steps; i++){
				angle = startAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				shape.graphics.lineTo(xx, yy);
				
				//icon position
				if(i == steps/2) {
					icon.x = centerX + Math.cos(angle * twoPI) * (radius-12);
					icon.y = centerY + Math.sin(angle * twoPI) * (radius-12);
				}
			}
			shape.graphics.lineTo(0, 0);
			shape.graphics.endFill();
		}
		
		private function iconPosition(xx:Number, yy:Number,r:Number):void {
			icon.x = xx - icon.width/2 - (r/5);
			icon.y = yy; - icon.height/2 - (r/5);
		}
		
		private function _iconComplete(e:Event):void {
			
			loader.width = loader.height = 16;

			loader.x = -loader.width/2;
			loader.y = -loader.height/2;
		}
		
		public function _buttonDown(e:MouseEvent):void {
			//TweenMax.to(this,1,{scaleX:1.05, scaleY:1.05});
			TweenMax.to(shape,1,{colorTransform:{tint:0x2F99C9, tintAmount:.5}});
			//TweenMax.to(this, .2, {bevelFilter:{blurX:10, blurY:10, strength:1, distance:10}});
			
		}
		
		public function _buttonOut(e:MouseEvent):void {
			//TweenMax.to(this,1,{scaleX:1.05, scaleY:1.05});
			TweenMax.to(shape,1,{colorTransform:{tint:0xFFFF00, tintAmount:0}});
			//TweenMax.to(this, .2, {bevelFilter:{blurX:10, blurY:10, strength:1, distance:10}});
			
		}
		
		public function _buttonUp(e:MouseEvent):void {
			//TweenMax.to(this,1,{scaleX:1, scaleY:1});
			//TweenMax.to(this, 1, {bevelFilter:{blurX:0, blurY:0, strength:0, distance:0, remove:true}});
			
			_clicked = !_clicked;
			
			if(_clicked) {
				TweenMax.to(shape,1,{colorTransform:{tint:0x2F99C9, tintAmount:.5}});
			} else {
				TweenMax.to(shape,1,{colorTransform:{tint:0xFFFF00, tintAmount:0}});
			}
		}
		
		/// -------------------------- Getter and Setter ------------------------
		
		public function get label():String {
			return _buttonLabel;
		}
		
		public function set label(value:String):void {
			_buttonLabel = value;
		}
		
		public function isClicked():Boolean {
			return _clicked;
		}
		
		public function set clicked(value:Boolean):void {
			_clicked = value;
		}

	}
}