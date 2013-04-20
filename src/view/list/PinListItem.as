package view.list {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import events.WorkflowEvent;
	
	import model.StatusFlag;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class PinListItem extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var _id							:int;							//Pin ID: Relatated to the doc
		protected var _title						:String							//Pin Title 
		protected var _currentFlag					:StatusFlag;					//Actual Flag
		protected var _itemSelected					:Boolean = false;
		protected var _controlView					:Boolean = false;
		protected var _status						:String = "deselected";
		
		protected var shape							:Sprite;						//Pin Shape Object
		protected var titleTF						:TextField;
		
		protected var timer							:Timer;
		
		protected var titleStyle					:TextFormat;
		protected var titleSelectedStyle			:TextFormat;
		protected var titleStyleStart				:TextFormat;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id_
		 * 
		 */
		public function PinListItem(id:int) {
			
			//initial
			_id = id;
			
			currentFlag = Settings.getFlagByName("start");	//default
			
			//styles
			titleStyle = new TextFormat();
			titleStyle.font = "Arial";
			titleStyle.size = 10;
			titleStyle.color = 0xFFFFFF;
			
			titleSelectedStyle = new TextFormat();
			titleSelectedStyle.font = "Arial";
			titleSelectedStyle.size = 10;
			titleSelectedStyle.color = 0xFFFFFF;
			
			titleStyleStart = new TextFormat();
			titleStyleStart.font = "Arial";
			titleStyleStart.size = 10;
			titleStyleStart.color = 0x666666;
			
			//TitleTF
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
			
			//shape
			shape = new Sprite();
			
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {

			//separate line
			var line:Sprite = new Sprite();
			line.graphics.lineStyle(1,0xFFFFFF,.3);
			line.graphics.beginFill(0x000000);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(125, 0);
			line.graphics.endFill();
			addChild(line);			
			
			//shape
			shape.graphics.beginFill(currentFlag.color);
			shape.graphics.drawRect(0,0,10,this.height-1);
			shape.graphics.endFill();
			
			addChildAt(shape,0)
			
			//base
			var base:Sprite = new Sprite();
			base.graphics.beginFill(0xFFFFFF,0);
			base.graphics.drawRect(0,0,125,this.height);
			base.graphics.endFill();
			
			addChildAt(base,0)
			
			//interaction
			this.mouseChildren = false;
			this.buttonMode = true;
			this.doubleClickEnabled = true;
			
			//listeners
			this.addEventListener(MouseEvent.CLICK, OnClick);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClick);
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get itemSelected():Boolean {
			return _itemSelected;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get controlView():Boolean {
			return _controlView;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get currentFlag():StatusFlag {
			return _currentFlag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get status():String {
			return _status;
		}
		
		
		
		//****************** SETTERS ****************** ****************** ******************

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set id(value:int):void {
			_id = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set title(value:String):void {
			titleTF.text = value;
			_title = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set itemSelected(value:Boolean):void {
			_itemSelected = value;
			
			//change visual
			if (itemSelected) {
				TweenMax.to(shape,.5,{width: 110});
				if(currentFlag.name == "Start") {
					titleTF.setTextFormat(titleStyleStart);
				}
				
			} else {
				titleTF.setTextFormat(titleStyle);
				TweenMax.to(shape,.5,{width: 10});
			}
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set controlView(value:Boolean):void {
			_controlView = value;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set currentFlag(value:StatusFlag):void {
			_currentFlag = value;
		}
		
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function set flag(value:StatusFlag):void {
			
			currentFlag = value
			TweenMax.to(shape,1,{tint:currentFlag.color});
			
			if(currentFlag.name.toLowerCase() == "start") {
				if (_status.toLowerCase() == "deselected") {
					titleTF.setTextFormat(titleStyle);
				} else {
					titleTF.setTextFormat(titleStyleStart);
				}
			} else {
				titleTF.setTextFormat(titleStyle);
			}

		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		public function changeStatus(value:String):void {
			
			//set new status
			_status = value;
			
			switch (value.toLowerCase()) {
				
				case "deselected":
					titleTF.setTextFormat(titleStyle);
					TweenMax.to(shape,.5,{width: 10});
					break;
				
				case "selected":
					if(currentFlag.name.toLowerCase() == "start") {
						titleTF.setTextFormat(titleStyleStart);
					} else {
						titleTF.setTextFormat(titleSelectedStyle);
					}
					TweenMax.to(shape,.5,{width: 110});
					break;
				
				case "edit":
					if(currentFlag.name.toLowerCase() == "start") {
						titleTF.setTextFormat(titleStyleStart);
					} else {
						titleTF.setTextFormat(titleSelectedStyle);
					}
					TweenMax.to(shape,.5,{width: 125});
					break;
			}
			
		}
		
		
		//****************** EVENTS ****************** ****************** ******************

		/**
		 * 
		 * @param event
		 * 
		 */
		protected function OnClick(event:MouseEvent):void {
			timer = new Timer(250,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
			timer.start();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function OnDoubleClick(event:MouseEvent):void {
			// 2 CLICKS
			if (timer != null) {
				
				//stop timer
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
				timer = null;
				
				//chang status
				if (status == "edit") {
					changeStatus("deselected");
				} else {
					changeStatus("edit");
				}
				
				//send event
				var data:Object = {};
				data.id = this.id;
				data.status = this.status;
				
				this.dispatchEvent(new WorkflowEvent(WorkflowEvent.SELECT, data));
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function OnTimerComplete(e:TimerEvent ):void {
			// 1 CLICK
			//change status
			if (status == "deselected") {
				changeStatus("selected");
			} else {
				changeStatus("deselected");
			}
			
			//send event
			var data:Object = {};
			data.id = this.id;
			data.status = this.status;
			
			this.dispatchEvent(new WorkflowEvent(WorkflowEvent.SELECT, data));
		}

	}
}