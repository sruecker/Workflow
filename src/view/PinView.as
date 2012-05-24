package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mvc.IController;
	
	import view.graphic.Rect;
	
	public class PinView extends OrlandoView {
		
		//properties
		internal var _id:int;																//Pin ID: Relatated to the doc
		private var _actualStep:String;														//Pin actual step
		
		private var _tagged:Boolean = false;												//Pin Tagged
		private var star:Sprite;															//star tag
		
		private var shape:Sprite;															//Pin Shape Object
		private var shapeSize:int = 6;														//pinsize
		
		internal var flags:Array = new Array({name:"Start", color: 0xFFFFFF},
											{name:"Working", color: 0x3299CC},
											{name:"Working Complete", color: 0x3299CC},
											{name:"Incomplete", color: 0xD7352D},
											{name:"Complete", color: 0x8A964A});		//Color Options
		
		private var _actualFlag:String = flags[0].name;											//Actual Flag
		private var ActualFlagColor:Object;													//Color related to the Actual Flag
		
		internal var _originalPosition:Object;												//Save position to go back if the drop target is not valid
		private var clickCount:int = 0;														//Count click number [0 - stop drag // 1 - single click // 2 -double click]
		
		private var timer:Timer = new Timer(400,1);											//Timer between single and double click
		
		private var _balloonActive:Boolean = false;											//Switch between show and hide info balloon
		private var bigView:Boolean = false;												//Switch between small and big view
		
		private var pinControlPanel:PinControlPanel;										//Control panel for the big view
		private var pinInfoPanel:PinInfoPanel;												//Info panel for the big view
		
		private var pinHistoryPanel:PinHistoryPanel;										//History panel for the big view
		private var historyPanelOpen:Boolean = false;
		private var pinFlagPanel:PinFlagPanel;												//Flag panel for the big view
		private var flagPanelOpen:Boolean = false;
		
		public function PinView(idValue:int) {
			
			super(workflowController);
			
			//save properties
			_id = idValue;
			
		}
		
		override public function init():void {
			
			
			//go
			ActualFlagColor = new Object();
			ActualFlagColor.color = defineColor(_actualFlag);
			
			shape = new Sprite();
			drawShape();
			addChild(shape);
			
			//fx
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x333333, .9);
			fxs.push(fxGlow);
			shape.filters = fxs;
			
			//tagged
			if(_tagged) {
				drawStar();
			}
			
			//actions
			shape.buttonMode = true;
			shape.addEventListener(MouseEvent.MOUSE_DOWN, _controlMouseDown);
		}
		
		/**
		 * Returns the default controller for this view.
		 */
		/*
		override public function defaultController (model:Observable):IController {
			return new PinController(model);
		}
		*/
		
		private function drawShape():void {
			shape.graphics.clear()
			shape.graphics.beginFill(ActualFlagColor.color);
			shape.graphics.drawCircle(0,0,shapeSize);
			shape.graphics.endFill();
			
			
		}
		
		private function drawStar():void {
			
			star = new Sprite();
			star.mouseEnabled = false;
			star.alpha = .5;
			
			var r:int = shapeSize;
			
			var ir:Number = 0.382 * r;
			
			//define color by flag
			
			if (_actualFlag == flags[0].name) {
				star.graphics.beginFill(0x666666);
			} else {
				star.graphics.beginFill(0xFFFFFF);
			}

			star.graphics.moveTo(0, -r);
			
			for (var i:int = 1; i <= 10; i++) {
				var inter:int = i % 2;
				var rad:Number = (inter) ? ir : r;
				
				var a:Number = -Math.PI / 2 + i * Math.PI / 5;
				var p:Point = new Point( Math.cos(a), Math.sin(a));
				p.normalize( rad );
				//star.graphics.lineStyle(0,0xFFFFFF)
				star.graphics.lineTo( p.x, p.y );
			}
			star.graphics.endFill();
			
			addChild(star)
		}
		
		// fx
		internal function getBitmapFilter(colorValue:uint, a:Number):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 2;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);
		}
		
		/**
		 * Define color related to the flag
		 **/
		private function defineColor(value:String):uint {
			var color:uint;
			
			for each(var colorFlag:Object in flags) {
				if (colorFlag.name == value) {
					color = colorFlag.color;
					return color;
				}
			}
			
			
			//test bug
			return 0x000000;
		}
		
		private function _controlMouseDown(e:MouseEvent):void {
			//move depth
			OrlandoView(this.parent).changeLayer(this);
			
			//test for movement
			this.addEventListener(MouseEvent.MOUSE_MOVE, _drag);
			this.addEventListener(MouseEvent.MOUSE_UP, _click);
			
		}
		
		private function _drag(e:MouseEvent):void {
			
			//save position
			_originalPosition = {x:this.x, y:this.y};
			
			//dragging
			this.startDrag();
			clickCount = 0;
			
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, _drag);
			this.removeEventListener(MouseEvent.MOUSE_UP, _click);
			this.addEventListener(MouseEvent.MOUSE_UP, _endDrag);
			
			//remove balloonif it is active
			if (balloonActive) {
				workflowController.killBalloon(_id);
			}
			
			//do the step hit test
			OrlandoView(this.parent).hitTest(this);
		}
		
		private function _endDrag(e:MouseEvent):void {
			//stop draggin
			this.stopDrag();
			
			this.removeEventListener(MouseEvent.MOUSE_UP, _endDrag);
			
			//do pin transfer
			OrlandoView(this.parent).hitTestEnd(this);
		}
		
		private function _click(e:MouseEvent):void {
			//test for single or double click
			if (!timer.running) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, _testforMultipleClick);
				timer.start();
			}
			
			//add to click count
			clickCount++;
			
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, _drag);
			this.removeEventListener(MouseEvent.MOUSE_UP, _click);
		}
		
		private function _testforMultipleClick(e:TimerEvent):void {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _testforMultipleClick);
			timer.reset();

			switch(clickCount) {
				case 1:
					_singleClick();
					break;
				case 2:
					_doubleClick();
					break;
			}
		}
		
		private function _singleClick():void {
			
			//reset clickCount
			clickCount = 0;
			
			//if balloon is not active:create one. - if exist already, remove it.
			if (!balloonActive) {
				var title:String = workflowController.getPinTitle(_id);
				var obj:Object = {id:_id, title:title, x:this.x, y:this.y};
				OrlandoView(this.parent).createBalloon(obj);
				balloonActive = !balloonActive;
			} else {
				workflowController.killBalloon(_id);
			}
		}
		
		private function _doubleClick():void {
			clickCount = 0;

			if (!bigView) {
				goBig();
			}
		}
		
		private function goBig():void {
			
			bigView = !bigView;
			
			_originalPosition = new Object();
			_originalPosition.x = this.x;
			_originalPosition.y = this.y;
			
			//anim
			TweenMax.to(shape,2,{width:70, height:70, ease:Back.easeOut, onUpdate:align});
			
			//remove balloonif it is active
			if (balloonActive) {
				workflowController.killBalloon(_id);
			}
			
			//add the control panel
			pinControlPanel = new PinControlPanel(_id);
			pinControlPanel.init();
			addChildAt(pinControlPanel,0);
			
			
			//add info Panel
			pinInfoPanel = new PinInfoPanel(_id);
			pinInfoPanel.x = - pinInfoPanel.width/2;
			pinInfoPanel.y = - pinInfoPanel.height - (pinControlPanel.height/2) - 10;
			addChildAt(pinInfoPanel,0);
			
			//create star and modify click behavior
			bigBehavior();
			
			//animation
			TweenMax.from(pinControlPanel,2,{scaleX:0, scaleY:0, ease:Back.easeOut});
			TweenMax.from(pinInfoPanel,2,{y:- pinInfoPanel.height, alpha:0, delay: 1, ease:Back.easeOut});
		}
		
		private function bigBehavior():void {
			
			//create star
			if(_tagged) {
				TweenMax.to(star,2,{alpha:1});
			} else {
				drawStar();
			}
			
			TweenMax.to(star,2,{width:22, height:22, ease:Back.easeOut});
			
			
			shape.removeEventListener(MouseEvent.MOUSE_DOWN, _controlMouseDown);
			shape.addEventListener(MouseEvent.CLICK, _controlClickBigView);
		}
		
		private function align():void {
			
			//get bounds
			var outdideBounds:Rectangle = this.getBounds(parent);
			var offset:int = 5;
			var diff:Number;
			
		
			//top margin
			if (outdideBounds.y < offset) {
				TweenMax.to(this,1,{y:this.y - outdideBounds.y + offset});
			}
			
			//left margin
			if (outdideBounds.x < offset) {
				TweenMax.to(this,1,{x:this.x - outdideBounds.x + offset});
			}
			
			//right margin
			if (outdideBounds.x + outdideBounds.width > stage.stageWidth - offset) {
				diff = (outdideBounds.x + outdideBounds.width) - stage.stageWidth + offset;
				TweenMax.to(this,1,{x:this.x - diff});
			}
			
			//bottom
			if (outdideBounds.y + outdideBounds.height > stage.stageHeight) {
				diff = (outdideBounds.y + outdideBounds.height) - stage.stageHeight + offset;
				TweenMax.to(this,1,{y:this.y - diff});
			}
			
			
		}
		
		private function _controlClickBigView(e:MouseEvent):void {
			_tagged = !_tagged;
			
			if(_tagged) {
				star.alpha = 1;
			} else {
				star.alpha = .5;
			}
			
			//send to model
			workflowController.tagPin(_id,_tagged);
		}
		
		public function historyBox(show:Boolean):void {
			
			if (show) {
				historyPanelOpen = true;
				pinHistoryPanel = new PinHistoryPanel(_id);
				pinHistoryPanel.x = -pinHistoryPanel.width - (pinControlPanel.width/2) - 35;
				pinHistoryPanel.y = -pinHistoryPanel.windowHeight/2;
				addChildAt(pinHistoryPanel,0);
				
				TweenMax.from(pinHistoryPanel,2,{x:-pinHistoryPanel.width/2, alpha:0, ease:Back.easeOut, onUpdate:align});
				//TweenMax.from(pinHistoryPanel,2,{y:0, height: 20, delay:1, ease:Back.easeOut});
			
			} else {
				historyPanelOpen = false;
				TweenMax.to(pinHistoryPanel,2,{x:-pinHistoryPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[pinHistoryPanel]});
			}
		}
		
		public function flagBox(show:Boolean):void {
			
			if (show) {
				flagPanelOpen = true;
				pinFlagPanel = new PinFlagPanel(_id);
				pinFlagPanel.init();
				pinFlagPanel.x = (pinControlPanel.width/2) + 20;
				pinFlagPanel.y = -pinFlagPanel.height/2;
				addChildAt(pinFlagPanel,0);
				
				TweenMax.from(pinFlagPanel,2,{x:-pinFlagPanel.width/2, alpha:0, ease:Back.easeOut, onUpdate:align});
				
			} else {
				flagPanelOpen = false;
				TweenMax.to(pinFlagPanel,2,{x:-pinFlagPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[pinFlagPanel]});
			}
		}
		
		public function closeBigView():void {
			bigView = !bigView;
			
			//change behavior
			shape.removeEventListener(MouseEvent.CLICK, _controlClickBigView);
			shape.addEventListener(MouseEvent.MOUSE_DOWN, _controlMouseDown);
			
			
			//anim
			TweenMax.to(this,2,{x:_originalPosition.x, y:_originalPosition.y, ease:Back.easeOut});
			TweenMax.to(shape,2,{width:shapeSize*2, height:shapeSize*2, ease:Back.easeOut});
			
			//star
			if(_tagged) {
				TweenMax.to(star,2,{width:shapeSize*2, height:shapeSize*2, alpha:.5, ease:Back.easeOut});
			} else {
				removeChild(star)
			}
			
			
			//remove panels
			
			TweenMax.to(pinControlPanel,1,{scaleX:0, scaleY:0, onComplete:removeItem, onCompleteParams:[pinControlPanel]});
			TweenMax.to(pinInfoPanel,.4,{y:- pinInfoPanel.height, alpha:0, onComplete:removeItem, onCompleteParams:[pinInfoPanel]});
			
			if(historyPanelOpen) {
				TweenMax.to(pinHistoryPanel,.4,{y:-pinHistoryPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[pinHistoryPanel]});
				historyPanelOpen = false;
			}
			
			if(flagPanelOpen) {
				TweenMax.to(pinFlagPanel,.4,{y:-pinFlagPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[pinFlagPanel]});
				flagPanelOpen = false;
			}
			
			
		}
		
		//----------------------------------- getters and setters -----------------------------------------
		
		public function get id():int {
			return _id;
		}

		public function get balloonActive():Boolean {
			return _balloonActive;
		}

		public function set balloonActive(value:Boolean):void {
			_balloonActive = value;
		}

		public function get originalPosition():Object {
			return _originalPosition;
		}

		public function get isTagged():Boolean {
			return _tagged;
		}

		public function set tagged(value:Boolean):void {
			_tagged = value;
		}

		public function get actualStep():String {
			return _actualStep;
		}

		public function set actualStep(value:String):void {
			_actualStep = value;
		}
		
		public function set flag(value:String):void {
			actualFlag = value;
			
			var cor:uint = defineColor(value);
			TweenMax.to(ActualFlagColor,1,{hexColors:{color:cor}, onUpdate:drawShape});
			
			//update info if it is open
			if (bigView) {
				pinInfoPanel.updateFlagInfo();
			}
			
			//update log if it is open
			if (historyPanelOpen) {
				pinHistoryPanel.addNewItemLog();
			}
			
			if (star) {
				if (_actualFlag == flags[0].name) {
					TweenMax.to(star,.5,{tint:0x666666});
				} else {
					TweenMax.to(star,.5,{tint:0xFFFFFF});
				}
			}
			 
		}

		public function get actualFlag():String {
			return _actualFlag;
		}

		public function set actualFlag(value:String):void {
			_actualFlag = value;
		}


	}
}