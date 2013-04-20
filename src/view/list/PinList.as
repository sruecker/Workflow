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
		protected var _maxHeight					:Number							//Maximum Height
		protected var _minWidth						:Number = 125;					//Minimun Width (depends on the OS – DPI)
		
		protected var itemCollection				:Array;							//Colletion of Items
							
		protected var container						:Sprite;						//Container
		protected var containerMask					:Sprite;						//Mask
		
		protected var itemList						:PinListItem;
		protected var scroll						:Scroll;
		
		
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
		public function initialize(data:Array, maxH:Number):void {
			
			_minWidth = Settings.pinListWidth;
			
			_maxHeight = maxH;
			
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
			var shadow:ShadowLine = new ShadowLine(_maxHeight,"vertical",0);
			shadow.x = bg.width - shadow.width;
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
			var item:PinListItem = getItemById(id);
			item.changeStatus(status);
		}
			
		
		public function clearSelection():void {
			for each(var item:PinListItem in itemCollection) {
				if (item.status == "selected") {
					item.changeStatus("deselected");
				}
			}
			
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxHeight():Number {
			return _maxHeight;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
		}

	}
}