package view {
	
	//imports
	
	import flash.display.Sprite;
	
	import view.graphic.ShadowLine;
	import view.util.scroll.Scroll;
	
	import util.DeviceInfo;
	
	public class PinList extends OrlandoView {
		
		//properties
		private var itemCollection:Array;
		private var itemList:PinListItem;
		
		private var scrolledArea:Sprite;
		private var container:Sprite;
		//private var containerMask:BlitMask;
		private var containerMask:Sprite;
		
		private var scroll:Scroll;
		private var scrolling:Boolean = false;
		
		private var _maxHeight:Number
		private var _minWidth:Number = 125;
		
		public function PinList() {
			super(workflowController);
		}
		
		public function initialize(data:Array):void {
			
			if (DeviceInfo.os() != "Mac") {
				_minWidth = 250;
			} else {
				_minWidth = 125;
			}
			
			_maxHeight = this.stage.stageHeight;
			
			//background
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x666666);
			bg.graphics.drawRect(0,0,_minWidth,_maxHeight);
			bg.graphics.endFill();
			
			addChild(bg);
			
			//container
			container = new Sprite();
			addChild(container)
			
			//shadow
			var shadow:ShadowLine = new ShadowLine(_maxHeight);
			shadow.rotation = -90;
			shadow.x = _minWidth;
			shadow.y = _maxHeight;
			addChild(shadow);
			
			itemCollection = new Array();
			
			var posY:Number = 0;
			
			for (var i:int = 0; i< data.length; i++) {
				
				//create pin view and pass the information
				itemList = new PinListItem(data[i].id);
				itemList.title = workflowController.getPinTitle(data[i].id);
				itemList.actualFlag = workflowController.getPinActualFlag(data[i].id);
				itemList.init();
				
				if (DeviceInfo.os() != "Mac") {
					itemList.scaleX = itemList.scaleY = 2;
				}
				
				itemList.y = posY;
				
				//add pin view to a collection
				itemCollection.push(itemList);
				
				//add to screen
				container.addChild(itemList);

				posY += itemList.height - 1;
				
			}
			
			testForScroll();
		}
		
		private function testForScroll(contructor:Boolean = true, diff:Number = 0):void {
			
			if (container.height + diff > _maxHeight) {
				scrolling = true;
				
				//mask for container
				containerMask = new Sprite();
				containerMask.graphics.beginFill(0xFFFFFF,0);
				containerMask.graphics.drawRect(container.x,container.y, this.width, _maxHeight);
				this.addChild(containerMask);
				container.mask = containerMask
				
				//containerMask = new BlitMask(container, container.x, container.y, this.width, _maxHeight, true);
				//containerMask.disableBitmapMode();
				
				//add scroll system
				scroll = new Scroll(0xFFFFFF);
				scroll.x = this.width - 6;
				scroll.y = container.y;
				this.addChild(scroll);
				
				scroll.target = container;
				scroll.maskContainer = containerMask;
				
			}
			
		}
		
		public function getItemById(id:int):PinListItem {
			for each(itemList in itemCollection) {
				if (itemList.id == id) {
					return itemList;
					break;
				}
			}
			
			return null;
		}
	
		
		
		
	}
}