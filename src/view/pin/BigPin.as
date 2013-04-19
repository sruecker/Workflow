package view.pin {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import controller.WorkflowController;
	
	import events.OrlandoEvent;
	
	import view.pin.panels.FlagPanel;
	import view.pin.panels.HistoryLogPanel;
	import view.pin.panels.InfoPanel;
	import view.pin.panels.PinControlButton;
	import view.pin.panels.PinControlPanel;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class BigPin {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var target					:PinView;						//target
		
		protected var _pinControlPanel			:PinControlPanel;				//Control panel for the big view
		protected var _infoPanel				:InfoPanel;						//Info panel for the big view
		
		protected var _historyPanel				:HistoryLogPanel;				//History panel for the big view
		protected var historyPanelOpen			:Boolean = false;
		
		protected var _flagPanel				:FlagPanel;						//Flag panel for the big view
		protected var flagPanelOpen				:Boolean = false;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param pin
		 * 
		 */
		public function BigPin(pin:PinView) {
			target = pin;
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//add the control panel
			_pinControlPanel = new PinControlPanel();
			target.addChildAt(_pinControlPanel,0);
			
			//add info Panel
			_infoPanel = new InfoPanel(target.getController(),target.id);
			_infoPanel.x = - _infoPanel.width/2;
			_infoPanel.y = - _infoPanel.height - (_pinControlPanel.height/2) - 10;
			target.addChildAt(_infoPanel,0);
			
			//star
			if(!target.tagged) {
				var color:uint = 0xFFFFFF;
				if (target.currentFlag.color == color) color = 0x666666;
				
				target.star = new Star(target.shapeSize,color);
				target.addChild(target.star);
				
			} else {
				TweenMax.to(target.star,2,{alpha:1});
			}
			
			//animation
			TweenMax.to(target.shape,2,{width:70, height:70, ease:Back.easeOut, onUpdate:alignPanels});
			TweenMax.from(_pinControlPanel,2,{scaleX:0, scaleY:0, ease:Back.easeOut});
			TweenMax.from(_infoPanel,2,{y:- _infoPanel.height, alpha:0, delay: 1, ease:Back.easeOut});
			TweenMax.to(target.star,2,{width:22, height:22, ease:Back.easeOut});
			
			//Modify Interaction behavior
			//listeners
			
			_pinControlPanel.addEventListener(MouseEvent.CLICK, controlPanelClick);
			target.shape.addEventListener(MouseEvent.CLICK, tagIt);
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get pinControlPanel():PinControlPanel {
			return _pinControlPanel;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get infoPanel():InfoPanel {
			return _infoPanel;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get historyPanel():HistoryLogPanel {
			return _historyPanel;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get flagPanel():FlagPanel {
			return _flagPanel;
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		protected function alignPanels():void {
			
			//get bounds
			var outsideBounds:Rectangle = target.getRect(target.parent);
			var offset:int = 5;
			var diff:Number;
			
			var params:Object = new Object();
			
			//top 
			if (outsideBounds.y < offset) params.y = target.y - outsideBounds.y + offset;
			
			//left
			if (outsideBounds.x < offset) params.x = target.x - outsideBounds.x + offset;
			
			//right
			if (outsideBounds.x + outsideBounds.width > target.stage.stageWidth - offset) {
				diff = (outsideBounds.x + outsideBounds.width) - target.stage.stageWidth + offset;
				params.x = target.x - diff;
			}
			
			//bottom
			if (historyPanelOpen) {
				
				var aproxH:Number = target.height - _historyPanel.height + _historyPanel.panelShapeHeight;
				
				if (outsideBounds.y + aproxH > target.stage.stageHeight) {
					diff = (outsideBounds.y + aproxH) - target.stage.stageHeight + offset;
					params.y = target.y - diff;
				}
			} else {
				if (outsideBounds.y + outsideBounds.height > target.stage.stageHeight) {
					diff = (outsideBounds.y + outsideBounds.height) - target.stage.stageHeight + offset;
					params.y = target.y - diff;
				}
			}
			
			//animation
			TweenMax.to(target,1,params);
			
		}
		
		/**
		 * 
		 * @param show
		 * 
		 */
		protected function manageHistoryPanel(show:Boolean):void {
			
			if (show) {
				historyPanelOpen = true;
				_historyPanel = new HistoryLogPanel(target.getController(), target.id);
				_historyPanel.x = -_historyPanel.width - (_pinControlPanel.width/2) - 35;
				_historyPanel.y = -_historyPanel.panelShapeHeight/2;
				target.addChildAt(_historyPanel,0);
				
				TweenMax.from(_historyPanel,2,{x:-_historyPanel.width/2, alpha:0, ease:Back.easeOut, onUpdate:alignPanels});
				
			} else {
				historyPanelOpen = false;
				TweenMax.to(_historyPanel,2,{x:-_historyPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[_historyPanel]});
			}
		}
		
		/**
		 * 
		 * @param show
		 * 
		 */
		protected function manageFlagPanel(show:Boolean):void {
			
			if (show) {
				flagPanelOpen = true;
				_flagPanel = new FlagPanel(target.getController(),target.id);
				_flagPanel.x = (_pinControlPanel.width/2) + 20;
				_flagPanel.y = -_flagPanel.height/2;
				target.addChildAt(_flagPanel,0);
				
				TweenMax.from(_flagPanel,2,{x:-_flagPanel.width/2, alpha:0, ease:Back.easeOut, onUpdate:alignPanels});
				
			} else {
				flagPanelOpen = false;
				TweenMax.to(_flagPanel,2,{x:-_flagPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[_flagPanel]});
			}
		}
		
		
		//****************** EVENTS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function tagIt(e:MouseEvent):void {
			target.tagged = !target.tagged;
			target.star.active = target.tagged;
			
			//send to model
			WorkflowController(target.getController()).tagPin(target.id,target.tagged);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function controlPanelClick(event:MouseEvent):void {
			
			if (event.target is PinControlButton) {
				
				var button:PinControlButton = event.target as PinControlButton;
				
				switch (button.label) {
					case "flagAction":
						manageFlagPanel(button.selected);
						break;
					case "history":
						manageHistoryPanel(button.selected);
						break;
					default: //close button
						target.closeBigView();
						break
				}
			}
			
		}
		
		
		//****************** PRIVATE METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @param item
		 * 
		 */
		private function removeItem(item:DisplayObject):void {
			target.removeChild(item);
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function close():void {
			
			//Add behavior
			target.shape.removeEventListener(MouseEvent.CLICK, tagIt);
			
			//anim
			TweenMax.to(target,2,{x:target.originalPosition.x, y:target.originalPosition.y, ease:Back.easeOut});
			TweenMax.to(target.shape,2,{width:target.shapeSize*2, height:target.shapeSize*2, ease:Back.easeOut});
			
			//star
			if(target.tagged) {
				TweenMax.to(target.star,2,{width:target.shapeSize*2, height:target.shapeSize*2, alpha:.5, ease:Back.easeOut});
			} else {
				target.removeChild(target.star)
			}
			
			//remove panels
			
			TweenMax.to(_pinControlPanel,1,{scaleX:0, scaleY:0, onComplete:removeItem, onCompleteParams:[_pinControlPanel]});
			TweenMax.to(_infoPanel,.4,{y:- _infoPanel.height, alpha:0, onComplete:removeItem, onCompleteParams:[_infoPanel]});
			
			if(historyPanelOpen) {
				TweenMax.to(_historyPanel,.4,{y:-_historyPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[_historyPanel]});
				historyPanelOpen = false;
			}
			
			if(flagPanelOpen) {
				TweenMax.to(_flagPanel,.4,{y:-_flagPanel.width/2, alpha:0, onComplete:removeItem, onCompleteParams:[_flagPanel]});
				flagPanelOpen = false;
			}
			
			//change status
			target.changeStatus("deselected");
			
			//Dispatch Event
			var data:Object = {};
			data.id = target.id;
			data.status = target.status;
			
			target.dispatchEvent(new OrlandoEvent(OrlandoEvent.SELECT_PIN, data, target.status));
			
		}

	}
}