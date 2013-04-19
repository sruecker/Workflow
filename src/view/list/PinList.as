package view.list {
	
	//imports
	import flash.display.Sprite;
	
	import model.DocumentModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.graphic.ShadowLine;
	import view.util.scroll.Scroll;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinList extends AbstractView {
		
		//****************** Proprieties ****************** ****************** ******************
		private var _maxHeight					:Number							//Maximum Height
		private var _minWidth					:Number = 125;					//Minimun Width (depends on the OS – DPI)
		
		private var itemCollection				:Array;							//Colletion of Items
							
		private var container					:Sprite;						//Container
		private var containerMask				:Sprite;						//Mask
		
		private var itemList					:PinListItem;
		private var scroll						:Scroll;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function PinList(c:IController) {
			super(c);
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function initialize(data:Array):void {
			
			_minWidth = Settings.pinListWidth;
			
			_maxHeight = stage.stageHeight;
			
			//background
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x666666);
			bg.graphics.drawRect(0,0,_minWidth,_maxHeight);
			bg.graphics.endFill();
			addChild(bg);
			
			//container
			container = new Sprite();
			this.addChild(container)
			
			//shadow
			var shadow:ShadowLine = new ShadowLine(_maxHeight);
			shadow.rotation = -90;
			shadow.x = _minWidth;
			shadow.y = _maxHeight;
			this.addChild(shadow);
			
			//loop
			data.sortOn("title");
			
			itemCollection = new Array();		
			var posY:Number = 0;
			
			for each (var doc:DocumentModel in data) {
				
				//create pin view and pass the information
				itemList = new PinListItem(doc.id);
				itemList.title = doc.title;
				itemList.currentFlag = doc.currentStatus;
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
		
		
		//****************** PRIVATE METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param contructor
		 * @param diff
		 * 
		 */
		private function testForScroll(contructor:Boolean = true, diff:Number = 0):void {
			
			if (container.height + diff > _maxHeight) {
				
				//mask for container
				containerMask = new Sprite();
				containerMask.graphics.beginFill(0xFFFFFF,0);
				containerMask.graphics.drawRect(container.x,container.y, this.width, _maxHeight);
				this.addChild(containerMask);
				container.mask = containerMask
				
				//add scroll system
				scroll = new Scroll();
				scroll.target = container;
				scroll.maskContainer = containerMask;
				this.addChild(scroll);
				scroll.init();
				scroll.x -= 1;;
				
			}
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getItemById(id:int):PinListItem {
			for each(itemList in itemCollection) {
				if (itemList.id == id) {
					return itemList;
				}
			}
			
			return null;
		}
		
		public function changePinStatus(id:int, status:String):void {
			var pin:PinListItem = getItemById(id);
			pin.changeStatus(status);
		}
			
		
	}
}