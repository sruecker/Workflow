package view.pin.big.style.knob {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	public class Pagination extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _currentPage					:int = 0;
		protected var pageCollection				:Array;
		protected var pageContainer					:Sprite;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function Pagination() {
			
			pageCollection = new Array();
			
			pageContainer = new Sprite();
			this.addChild(pageContainer);
		
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param label
		 * 
		 */
		public function addPage(label:String = ""):void {
			
			var page:Sprite = new Sprite();
			page.name = label;
			page.graphics.beginFill(0x000000);
			page.graphics.drawCircle(0,0,2);
			page.graphics.endFill();
			
			page.x = (page.width + 2) * pageCollection.length;
			
			this.addChild(page);
			
			pageCollection.push(page);
			
			//selection
			//if (pageCollection.length == 1) currentPage = pageCollection.length;
			if (pageCollection.length != 1) page.alpha = .6;
			
			//align
			pageContainer.x = pageContainer.width/2;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function changeCurrentpage(value:int):void {
			
			currentPage = value;
			
			for (var i:int = 0; i < pageCollection.length; i++) {
				if (i == currentPage) {
					pageCollection[i].alpha = 1;
				} else {
					pageCollection[i].alpha = .6;
				}
					
			}
		}
		
		
		//****************** GETTERS ****************** ******************  ******************

		public function get currentPage():int {
			return _currentPage;
		}
		
		public function get totalPages():int {
			return pageCollection.length;
		}
		
		
		//****************** SETTERS ****************** ******************  ******************

		public function set currentPage(value:int):void {
			_currentPage = value;
		}

		
	}
}