package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import events.OrlandoEvent;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import view.PinList;
	
	public class PinListItem extends PinList {
		
		//properties
		internal var flags:Array = new Array({name:"Start", color: 0xFFFFFF},
			{name:"Working", color: 0x3299CC},
			{name:"Working Complete", color: 0x3299CC},
			{name:"Incomplete", color: 0xD7352D},
			{name:"Complete", color: 0x8A964A});		//Color Options
		
		private var _id:int;																//Pin ID: Relatated to the doc
		private var _title:String															//Pin Title 
		private var shape:Sprite;															//Pin Shape Object
		private var shapeSize:int = 6;														//pinsize
		private var _actualFlag:String = flags[0].name;											//Actual Flag
		private var titleStyle:TextFormat = new TextFormat("Arial",9,0xFFFFFF);
		private var titleSelectedStyle:TextFormat = new TextFormat("Arial",9,0xFFFFFF);
		private var titleStyleStart:TextFormat = new TextFormat("Arial",9,0x666666);
		private var titleTF:TextField;
		
		private var itemSelected:Boolean = false;
		private var controlView:Boolean = false;
		
		private var clickCount:int = 0;														//Count click number [0 - stop drag // 1 - single click // 2 -double click]
		
		private var timer:Timer = new Timer(400,1);											//Timer between single and double click
		
		
		public function PinListItem(id_:int) {
			super();
			
			id = id_;
			
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.multiline = true;
			titleTF.wordWrap = true;
			titleTF.autoSize = "left";
			titleTF.width = 105;
			titleTF.defaultTextFormat = titleStyle;
			
			titleTF.x = 10;
			titleTF.y = 2;
			
			addChild(titleTF);
			
			
			shape = new Sprite();
			
			
			
			
		}
		
		override public function init():void {

			//separate line
			var line:Sprite = new Sprite();
			line.graphics.lineStyle(1,0xFFFFFF,.3);
			line.graphics.beginFill(0x000000);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(125, 0);
			line.graphics.endFill();
			addChild(line);			
			
			//shape
			shape.graphics.beginFill(getColor(actualFlag));
			shape.graphics.drawRect(0,0,10,this.height-1);
			shape.graphics.endFill();
			
			addChildAt(shape,0)
			
			//base
			//base
			var base:Sprite = new Sprite();
			base.graphics.beginFill(0xFFFFFF,0);
			base.graphics.drawRect(0,0,125,this.height);
			base.graphics.endFill();
			
			addChildAt(base,0)
			
			//interaction
			this.mouseChildren = false;
			this.buttonMode = true;
			//this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			//this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMoueDown);
			
		}

		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			titleTF.text = value;
			_title = value;
		}

		public function get actualFlag():String {
			return _actualFlag;
		}

		public function set actualFlag(value:String):void {
			_actualFlag = value;
		}
		
		public function set flag(value:String):void {
			actualFlag = value;
			
			var cor:uint = getColor(value);
			TweenMax.to(shape,1,{tint:cor});
			
			if(_actualFlag == "Start") {
				titleTF.setTextFormat(titleStyleStart);
			}
			
		}
		
		private function getColor(name:String):uint {
			for(var i:int = 0; i < flags.length; i++) {
				
				if (flags[i].name == name) {
					return flags[i].color
				}
				
			}
			
			return null;
		}
		
		private function onOver(e:MouseEvent):void {
			TweenMax.to(shape,.5,{width: 125});
		}
		
		private function onOut(e:MouseEvent):void {
			TweenMax.to(shape,.5,{width: 10});
		}
		
		private function onMoueDown(e:MouseEvent):void {
			
			//test for movement
			this.addEventListener(MouseEvent.MOUSE_UP, _click);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void {
			//listeners
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, _click);
		}
		
		private function _click(e:MouseEvent):void {
			//test for single or double click
			if (!timer.running) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, _testforMultipleClick);
				timer.start();
			}
			
			//add to click count
			clickCount++;
			
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
			
			var update:OrlandoEvent = new OrlandoEvent(OrlandoEvent.ACTIVATE_PIN, id);
			
			controlView = false;
			itemSelected = !itemSelected;
			
			//change visual
			if (itemSelected) {
				TweenMax.to(shape,.5,{width: 110});
				if(_actualFlag == "Start") {
					titleTF.setTextFormat(titleStyleStart);
				}

			} else {
				titleTF.setTextFormat(titleStyle);
				TweenMax.to(shape,.5,{width: 10});
				
			}
			
			//send event
			var data:Object = new Object();
			data.source = "list";
			data.action = "single";
			data.controlView = controlView;
			data.selected = itemSelected;
			workflowController.activatePin(id,data)
		}
		
		private function _doubleClick():void {
			clickCount = 0;
			
			controlView = !controlView;
			
			//change visual
			if (controlView) {
				TweenMax.to(shape,.5,{width: 125});
				if(_actualFlag == "Start") {
					titleTF.setTextFormat(titleStyleStart);
				}
				
				itemSelected = true;
				
			} else {
				titleTF.setTextFormat(titleStyle);
				TweenMax.to(shape,.5,{width: 10});
				
				itemSelected = false;
			}
			
			//send event
			var data:Object = new Object();
			data.source = "list";
			data.action = "double";
			data.controlView = controlView;
			data.selected = itemSelected;
			workflowController.activatePin(id,data);
			
		}
		
		public function changeStatus(data:Object):void {
			
			itemSelected = data.selected;
			controlView = data.controlView;
			
			if (itemSelected && !controlView) {
				TweenMax.to(shape,.5,{width: 110});
				if(_actualFlag != "Start") {
					titleTF.setTextFormat(titleSelectedStyle);
				}
			} else if (controlView){
				if(_actualFlag != "Start") {
					titleTF.setTextFormat(titleSelectedStyle);
				}
				TweenMax.to(shape,.5,{width: 125});
			} else {
				titleTF.setTextFormat(titleStyle);
				TweenMax.to(shape,.5,{width: 10});
			}
			
		}
		
		
	}
}