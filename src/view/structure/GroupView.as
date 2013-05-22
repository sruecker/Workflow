package view.structure {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.GroupModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.graphic.AbstractShape;
	import view.graphic.RoundRect;
	import settings.Settings;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class GroupView extends AbstractView {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _id					:int;							//ID
		protected var _title				:String;						//Title
		protected var _level				:Number;						//Group level
		protected var _contract				:Boolean;						//Group Appearance - Contracted or Expanded
		protected var _sequenced			:Boolean;						//Group Type: Sequenced or non-Sequenced
		protected var _stepCollection		:Array;							//Collect of step in the group
		
		protected var margin				:uint = 20;						//Margin Space
		protected var stepWidth				:int;							//Width of the contained steps					
		protected var stepHeight			:int;							//Height of the contained steps
		protected var yOrigin				:Number							//vertical origin
		
		protected var boundaries			:AbstractShape;					//Shape
		protected var titleTF				:TextField;						//Textfield - Title
		protected var titleStyle			:TextFormat;					//Text Style
		protected var controlButton			:ContractButton;				//Trigger the contract/expand action
		
		protected var stepView				:StepView						//step view for contracted purpose.
			
		
		//****************** Properties ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param c
		 * @param groupModel
		 * 
		 */
		public function GroupView(c:IController, groupModel:GroupModel) {
			super(c);
			
			//save properties
			_id = groupModel.id;
			title = groupModel.title;
			level = groupModel.level;
			_contract = groupModel.isContract;
			sequenced = groupModel.isSequenced;
			
			//int
			_stepCollection = new Array();
			
			titleStyle = new TextFormat();
			titleStyle.font = "Arial";
			titleStyle.color = 0x666666;
			titleStyle.bold = true;
			titleStyle.align = "right";
			
			if (Settings.platformTarget == "mobile") {
				titleStyle.size = 18;
			} else {
				titleStyle.size = 12;
			}
			
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param yO
		 * 
		 */
		public function init(yO:Number):void {
			
			//save
			yOrigin = yO;
			
			//Make Boundaries
			drawBoundaries();
			
			//---------------Title
			//text
			titleTF = new TextField();
			titleTF.width = 80;
			titleTF.autoSize = "right";
			titleTF.selectable = false;
			titleTF.text = _title;
			titleTF.setTextFormat(titleStyle);
			
			titleTF.x = boundaries.x + boundaries.width - titleTF.width - (margin/2);
			titleTF.y = -4;
			this.addChild(titleTF);
			
			//---------------Control Button
			if (Settings.contractableGroups) {
				controlButton = new ContractButton(!isContracted());
				controlButton.x = controlButton.origX = this.width;
				controlButton.y = controlButton.origY = this.height - 7;
				this.addChild(controlButton);
				
				//controlButton.addEventListener(MouseEvent.CLICK, _controlClick);
				controlButton.addEventListener(MouseEvent.CLICK, _controlClick);
				
			}
			
			//distribute
			distribute();
			
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		public function get id():int {
			return _id;
		}
		
		public function get title():String {
			return _title;
		}
		
		public function get level():Number {
			return _level;
		}
		
		public function isContracted():Boolean {
			return _contract;
		}
		
		public function isSequenced():Boolean {
			return _sequenced;
		}
		
		public function getStepCollection():Array {
			return _stepCollection.concat();
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		public function set title(value:String):void {
			_title = value;
		}
		
		public function set contracted(value:Boolean):void {
			_contract = value;
		}
		
		public function set level(value:Number):void {
			_level = value;
		}
		
		public function set sequenced(value:Boolean):void {
			_sequenced = value;
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * Create Baundary rectangle
		 * 
		 **/
		protected function drawBoundaries():void {
			
			if (!isSequenced()) {
				boundaries = new RoundRect(stepWidth + (1*margin),(_stepCollection.length * stepHeight) + ((_stepCollection.length+1) * margin - margin/2),20);
			}
			
			boundaries.color = 0xEEEEEE;
			boundaries.lineThickness = 1;
			boundaries.lineColor = 0XCCCCCC;
			boundaries.drawShape();
			boundaries.y = -10;;
			addChild(boundaries);
		}
		
		/**
		 * 
		 * 
		 */
		protected function removeStepView():void {
			removeChild(stepView);
			stepView = null;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * Add Step View to the group.
		 * Store in a collection
		 * Define stepWidth and stepHeight
		 * 
		 * @param	value	StepView
		 */
		public function addStep(step:StepView):void {
		
			_stepCollection.push(step);
			
			//store size
			if (stepWidth == 0) {
				stepWidth = step.width;
			}
			
			if (stepHeight == 0) {
				stepHeight = step.height;
			}
			
		}
		

		/**
		 * Distribute: Contrac or expand the group
		 * 
		 * @param contract
		 * 
		 */
		public function distribute(contract:Boolean = true):void {
			
			if (contract) {
				// position aux var
				var pos:Number;
				
				//different ways for sequenced and non-sequenced
				if (_sequenced) {
					//TODO
				} else {
					pos = yOrigin - (((_stepCollection.length-1) * stepHeight) + ((_stepCollection.length-1) * margin))/2;
				}
				
				//final position
				this.y = pos - margin;
				
				//distribute steps inside the group
				for each(var stepItem:StepView in _stepCollection) {
					TweenMax.to(stepItem,0,{y:pos, autoAlpha:1});
					pos += stepItem.height + margin;
				}
			} else {
				pos = 325;
				for each(var stepItem_:StepView in _stepCollection) {
					TweenMax.to(stepItem_,1,{y:pos});
					pos += 5;
				}
			}
		}
		
		
		//****************** CONTRACT METHODS ****************** ******************  ****************** 
		
		/**
		 * Control: Contrac or expand the group
		 * 
		 * @param e
		 * 
		 */
		private function _controlClick(e:MouseEvent):void {
			doContract(true)
			//var infoUpdate:Object = {name: "contracter", id:id, action:!isContracted()}
			//StepController(getController()).click(infoUpdate);
		}
		
		/**
		 *  contract or expand the group
		 * 
		 * @param value
		 * 
		 */
		private function doContract(value:Boolean):void {
			
			if (!isContracted()) {
				TweenMax.to(boundaries,1,{autoAlpha:0, x:boundaries.width/2, y:boundaries.height/2, scaleX:0, scaleY:0,onComplete:showStepView,onCompleteParams:[boundaries.height]});
				TweenMax.to(titleTF,.3,{autoAlpha:0});
				TweenMax.to(controlButton,1,{x:"-10", y:boundaries.height/2 + 52});
				controlButton.changeIcon(isContracted())
				distribute(isContracted());
			} else {
				TweenMax.to(boundaries,1,{autoAlpha:.2, x:boundaries.width/2, y:-5, scaleX:1, scaleY:1});
				TweenMax.to(titleTF,.2,{autoAlpha:1,delay:.8});
				TweenMax.to(controlButton,1,{x:controlButton.origX, y:controlButton.origY});
				controlButton.changeIcon(isContracted())
				distribute(isContracted());
				removeStepView()
			}
			
			//change info
			contracted = value;
		}
		
		
		/**
		 * 
		 * @param h
		 * 
		 */
		private function showStepView(h:Number):void {
			/*
			//create pseudo Step
			stepView = new StepView(StepModel(getModel()), null);
			stepView.title = title;
			stepView.x = 10;
			stepView.y = h/2 - stepView.height/2;
			addChildAt(stepView,1);
			
			*/
			
			//hide step collection
			//TweenMax.allTo(_stepCollection,0,{autoAlpha:0});
		}


	}
}