package view.pin.big.style.knob.panels {
	
	//imports
	//import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.WorkflowController;
	
	import events.WorkflowEvent;
	
	import model.DocLogItem;
	
	import mvc.IController;
	
	import view.graphic.ShadowLine;
	import view.pin.big.AbstractPanel;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HistoryLogPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var logItemCollection			:Array;					//log collection
		protected var itemLog					:HistoryLogItem;
		
		protected var headerTF					:TextField;
		protected var headerStyle				:TextFormat;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function HistoryLogPanel(c:IController) {
			super(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		override public function init(id:int = 0):void {
			
			//init
			pinId = id;
			super.windowed = true;
			
			//this log table has 4 columns. The width proportion is: Date (40%), step (20%), flag (20%), responsible (20%)
			var dateW:Number = this.hMax * .4;
			var stepW:Number = this.hMax * .2;
			var flagW:Number = this.hMax * .2;
			var respW:Number = this.hMax * .2;
			
			var porportionsArray:Array = new Array(dateW,stepW,flagW,respW);
			
			HistoryLogItem.columnProportion = porportionsArray;
			
			var posY:Number = margin;
			
			//add Header
			itemLog = new HistoryLogItem(0,"Date","Step","flag","resp.","header");
			
			itemLog.x = margin;
			itemLog.y = posY - 5;
			
			posY += itemLog.height -5;
			
			this.addChild(itemLog)
			
			//--------
			
			//get info
			var data:Array = WorkflowController(this.getController()).getPinLog(pinId);
			
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
	
			for each(var logItem:DocLogItem in data) {
				
				itemLog = new HistoryLogItem(
											logItemCollection.length,
											logItem.date,
											logItem.step,
											logItem.status,
											logItem.responsible);
				
				itemLog.x = margin;
				itemLog.y = posY
				
				posY += itemLog.height + 3;
					
				container.addChild(itemLog)
				
				logItemCollection.push(itemLog);

			}
			
			//shadow line
			/*
			var lineStart:ShadowLine = new ShadowLine(hMax);
			lineStart.y = scrolledArea.y
			this.addChild(lineStart);
			*/
			
			//line
			var line:Shape = new Shape();
			line.graphics.lineStyle(1,0x999999);
			line.graphics.moveTo(-50,0);
			line.graphics.lineTo(hMax,0);
			line.y = scrolledArea.y;
			this.addChild(line);
			
			//scroll
			testForScroll();
			
			//add shape
			if (!super.windowed) this.addChildAt(panelShape,0);
			
			//listener
			this.getController().getModel("data").addEventListener(WorkflowEvent.UPDATE_PIN, addNewItemLog);
			
		}
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function addNewItemLog(event:WorkflowEvent):void {
			
			//move list
			var offset:Number;
			for each(var item:Sprite in logItemCollection) {
				item.y = item.y + item.height + 3;
			}
			
			//get Data
			var log:DocLogItem = WorkflowController(this.getController()).getPinLastLog(pinId);
			
			
			itemLog = new HistoryLogItem(logItemCollection.length,
										log.date,
										log.step,
										log.status,
										log.responsible);
			
			
			itemLog.x = margin;
			itemLog.y = 5;
			
			container.addChild(itemLog)
			logItemCollection.push(itemLog);
			
			TweenMax.from(itemLog,2,{alpha:0, ease:Back.easeOut});
			
			//scroll?
			if (!scroll) {
				testForScroll(false);
			} else {
				scroll.target = container;
			}
			
			//centralize
			TweenMax.to(this,1,{y:-this.panelShapeHeight/2});
			
		}

	}
}