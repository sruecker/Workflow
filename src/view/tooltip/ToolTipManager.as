package view.tooltip {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import view.StructureView;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ToolTipManager{	
		
		//****************** Properties ****************** ******************  ****************** 
		
		static protected var _toolTipBaseColor				:uint 	= 0xFFFFFF;			//Balloon Color
		static protected var _toolTipBaseAlpha				:Number = 1;				//Balloon Alpha
		static protected var _toolTiptextColor				:uint	= 0x000000;			//Text Color
		
		static protected var target							:Sprite;
		static protected var toolTipCollection				:Array;
		static protected var verticalOffset					:uint = 7;
		
		
		//****************** Contructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param target_
		 * 
		 */
		public function ToolTipManager(target_:Sprite) {
			
			target = target_;
		
			_toolTipBaseColor = 0xFFFFFF;
			_toolTiptextColor = 0x646363;
			
			toolTipCollection = new Array();
			
			target.stage.addEventListener(MouseEvent.CLICK, removeAll);
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  *****************
		
		/**
		 * 
		 * @param data
		 * 
		 */
		static public function addToolTip(data:Object, direction:String = "bottom"):void {
		
			
			var toolTip:ToolTip = ToolTipFactory.addToolTip(toolTipCollection.length);
			toolTip.balloonColor = _toolTipBaseColor;
			toolTip.balloonAlpha = _toolTipBaseAlpha;
			toolTip.textColor = _toolTiptextColor;
			toolTip.init(data);
			target.addChild(toolTip);
			
			toolTipCollection.push(toolTip);
			
			//set position
			toolTip.x = data.position.x;			
			var animOffset:int;
			
			switch (direction) {
				case "top":
					toolTip.y = data.position.y + toolTip.height + verticalOffset;
					animOffset = -5;
					break;
				
				case "bottom":
					animOffset = 5;
					toolTip.y = data.position.y - verticalOffset;
					break;
			}
			
			
			//test if this is off the screen
			//test top of the screen.
			if (toolTip.y - toolTip.height < 0) {
				
				toolTip.arrowDirection = "top";
				animOffset = -5;
				toolTip.y = data.position.y + toolTip.height + verticalOffset;
				
			}
			
			//test horizontal
			var horizontalOffset:Number = 0;
			
			if (toolTip.x - (toolTip.width/2) < 0) {
				
				horizontalOffset = toolTip.x - (toolTip.width/2);
				toolTip.x = toolTip.width/2;		
			
			} else if (toolTip.x + (toolTip.width/2) > target.stage.stageWidth) {
				
				horizontalOffset = (toolTip.x + (toolTip.width/2)) - target.stage.stageWidth;
				toolTip.x = target.stage.stageWidth - (toolTip.width/2);
			
			}
			
			//move Arrow
			if (horizontalOffset != 0) toolTip.arrowOffsetH(horizontalOffset);
			
			//Animation
			TweenMax.from(toolTip,.5,{autoAlpha:0, y:toolTip.y + animOffset});
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function get hasToolTips():Boolean {
			
			if (toolTipCollection.length > 0) {
				return true;	
			}
			
			return false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		static public function hasToolTip(value:int):Boolean {
			if (getToolTipBySourceId(value)) {
				return true;		
			}
			
			return false;
		}
		
		
		/**
		 * 
		 * @param id
		 * @param _x
		 * @param _y
		 * 
		 */
		static public function moveToolTips(id:int, _x:Number, _y:Number):void {
			var toolTip:ToolTip = getToolTipBySourceId(id);
			if (toolTip) {
				
				toolTip.x = _x;
				
				switch (toolTip.arrowDirection) {
					case "top":
						toolTip.y = _y + toolTip.height + verticalOffset;
						break;
					
					case "bottom":
						toolTip.y = _y - verticalOffset;
						break;
				}
				
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public static function sendToFront(value:int):void {
			
			var toolTip:ToolTip = getToolTipBySourceId(value);
			target.swapChildrenAt(target.getChildIndex(toolTip),target.numChildren-1);
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		static public function removeToolTip(value:int):void {
		
			var toolTip:ToolTip = getToolTipBySourceId(value);
			
			if (toolTip) {
				var animOffset:int;
						
				if (toolTip.arrowDirection == "bottom") {
					animOffset = 5;
				} else if (toolTip.arrowDirection == "top") {
					animOffset = -5;
				}
						
				TweenMax.to(toolTip,.5,{autoAlpha:0, y:toolTip.y + animOffset, onComplete:killToolTip, onCompleteParams:[toolTip]});
						
				toolTipCollection.splice(toolTipCollection.indexOf(toolTip),1);
			}
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		static public function removeAll(event:MouseEvent):void {
			
			if (event.target.parent is StructureView) {
			
				var animOffset:int;
				
				for each (var toolTip:ToolTip in toolTipCollection) {
					
					if (toolTip.arrowDirection == "bottom") {
						animOffset = 5;
					} else if (toolTip.arrowDirection == "top") {
						animOffset = -5;
					}
	
					TweenMax.to(toolTip,.5,{autoAlpha:0, y:toolTip.y + animOffset, onComplete:killToolTip, onCompleteParams:[toolTip]});
					
				}
				
				toolTipCollection = [];
				
				target.dispatchEvent(new Event(Event.CLEAR));
			}
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  *****************
		
		/**
		 * 
		 * @param toolTip
		 * 
		 */
		static protected function killToolTip(toolTip:ToolTip):void{
			target.removeChild(toolTip);
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		static public function getToolTipBySourceId(value:int):ToolTip {
			
			for each (var toolTip:ToolTip in toolTipCollection) {
				
				if (toolTip.sourceId == value) {
					return toolTip;	
				}
			}
			return null;
		}
		
		
	}
}