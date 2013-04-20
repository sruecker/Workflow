package view.pin.panels {
	
	//imports
	//import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.WorkflowController;
	
	import model.DocLogItem;
	
	import mvc.IController;
	
	import view.graphic.ShadowLine;
	
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
		public function HistoryLogPanel(c:IController, id:int) {

			super(c);
			
			//init
			pinId = id;
			
			//styles
			headerStyle = new TextFormat("Arial",10,0x333333,true);
			
			hMax = 180;
			
			//Start positioning
			var posY:Number = margin;
			
			//------------------
			//Build Layout
			
			//1. title
			headerTF = createTF();
			headerTF.text = "History";
			headerTF.setTextFormat(panelTitleStyle);
			
			headerTF.x = (hMax/2) - headerTF.width/2;
			headerTF.y = posY;
			this.addChild(headerTF);
			
			posY += headerTF.height + 5;
			
			// 2. header
			var bar:Shape = new Shape();
			bar.graphics.beginFill(0xD1D2D4);
			bar.graphics.drawRect(0,0,hMax,10);
			bar.graphics.endFill();
			bar.y = posY;
			addChild(bar)
			
			// 3. date
			headerTF = createTF();
			headerTF.text = "Date";
			headerTF.setTextFormat(headerStyle);
			
			headerTF.x = 20;
			headerTF.y = posY - 3;
			this.addChild(headerTF);
			
			//4. step
			headerTF = createTF();
			headerTF.text = "Step";
			headerTF.setTextFormat(headerStyle);
			
			headerTF.x = 70;
			headerTF.y = posY - 3;
			this.addChild(headerTF);

			//5. flag
			headerTF = createTF();
			headerTF.text = "Flag";
			headerTF.setTextFormat(headerStyle);
			
			headerTF.x = 105;
			headerTF.y = posY - 3;
			this.addChild(headerTF);
			
			//6. Responsible
			headerTF = createTF();
			headerTF.text = "Resp.";
			headerTF.setTextFormat(headerStyle);
			
			headerTF.x = 140;
			headerTF.y = posY - 3;
			this.addChild(headerTF);
			
			
			// ---------------------------------------------------------
			posY += headerTF.height - 5;
			
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
				
				posY += itemLog.height + 2
					
				container.addChild(itemLog)
				
				logItemCollection.push(itemLog);

			}
			
			//shadow line
			var lineStart:ShadowLine = new ShadowLine(hMax);
			lineStart.y = scrolledArea.y
			addChild(lineStart);
			
			//scroll
			testForScroll();

			//add shape
			this.addChildAt(panelShape,0);
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function addNewItemLog():void {
			
			//move list
			var offset:Number;
			for each(var item:Sprite in logItemCollection) {
				item.y = item.y + item.height + 2;
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