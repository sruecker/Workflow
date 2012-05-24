package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.AbstractGroup;
	
	import mvc.AbstractView;
	import mvc.IController;
	import mvc.Observable;
	
	import view.graphic.*;
	
	public class GroupView extends OrlandoView {
		
		//properties
		private var _id:int;							//ID
		private var _title:String;						//Title
		private var _level:Number;						//Group level
		private var _contract:Boolean;					//Group Appearance - Contracted or Expanded
		private var _sequenced:Boolean;					//Group Type: Sequenced or non-Sequenced
		private var _stepCollection:Array;				//Collect of step in the group
		
		private var margin:uint = 20;					//Margin Space
		private var stepWidth:int;						//Width of the contained steps					
		private var stepHeight:int;						//Height of the contained steps
		private var yOrigin:Number						//vertical origin
		
		private var boundaries:AbstractShape;			//Shape
		private var titleTextField:TextField;			//Textfield - Title
		private var titleStyle:TextFormat;				//Text Style
		private var controlButton:ContractButton;		//Trigger the contract/expand action
		
		private var stepView:StepView					//step view for contracted purpose.
		
		/**
		* Constrcutor
		*/
		public function GroupView(c:IController, data:AbstractGroup) {
			super(c);
			
			//save properties
			_id = data.id;
			_title = data.title;
			_level = data.level;
			_contract = data.isContract;
			_sequenced = data.isSequenced;
			
			//int
			_stepCollection = new Array();
			titleStyle = new TextFormat("Arial",12,0x666666,true,null,null,null,null,"right");
			
		}
		
		
		/**
		 * Returns the default controller for this view.
		 */
		/*
		override public function defaultController(model:Observable):IController {
			return new StepController(model);
		}
		*/
		
		/**
		 * Add Step View to the group.
		 * Store in a collection
		 * Define stepWidth and stepHeight
		 * 
		 * @param	value	StepView
		 */
		public function addStep(s:StepView):void {
		
			_stepCollection.push(s);
			
			//store size
			if (stepWidth == 0) {
				stepWidth = s.width;
			}
			
			if (stepHeight == 0) {
				stepHeight = s.height;
			}
			
		}
		
		
		/**
		 * Create UI Group
		 * 
		 * @param	yOrigin	Number
		 */
		public function createUI(yO:Number):void {
			
			//save
			yOrigin = yO;
			
			//Make Boundaries
			drawBoundaries();
			
			//---------------Title
			//text
			titleTextField = new TextField();
			titleTextField.width = 80;
			titleTextField.autoSize = "right";
			//titleTextField.embedFonts = true;
			titleTextField.selectable = false;
			titleTextField.text = _title;
			titleTextField.setTextFormat(titleStyle);
			
			titleTextField.x = boundaries.x + boundaries.width - titleTextField.width - (margin/2);
			titleTextField.y = -4;
			this.addChild(titleTextField);
			
			//---------------Control Button
			/*
			controlButton = new ContractButton(!isContracted());
			controlButton.x = controlButton.origX = this.width;
			controlButton.y = controlButton.origY = this.height - 7;
			this.addChild(controlButton);
			
			//controlButton.addEventListener(MouseEvent.CLICK, _controlClick);
			controlButton.addEventListener(MouseEvent.CLICK, _controlClick);
			*/
			//-----------------
			
			//distribute
			distribute();
			
		}
		
		/**
		 * Create Baundary rectangle
		 * 
		 **/
		private function drawBoundaries():void {
			
			if (!isSequenced()) {
				boundaries = new RoundRect(stepWidth + (1*margin),(_stepCollection.length * stepHeight) + ((_stepCollection.length+1) * margin - margin/2),20);
			}
			boundaries.color = 0xEEEEEE;
			boundaries.lineThickness = 1;
			boundaries.lineColor = 0XCCCCCC;
			boundaries.drawShape();
			//boundaries.alpha = .2;
			boundaries.y = -10;;
			addChild(boundaries);
		}
		
		/**
		 * Distribute: Contrac or expand the group
		 * 
		 **/
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
		
		
		
		
		
		/**
		 * Control: Contrac or expand the group
		 * 
		 **/
		
		private function _controlClick(e:MouseEvent):void {
			doContract(true)
			//var infoUpdate:Object = {name: "contracter", id:id, action:!isContracted()}
			//StepController(getController()).click(infoUpdate);
		}
		
		
		/**
		 * contract or expand the group
		 **/
		
		private function doContract(value:Boolean):void {
			
			if (!isContracted()) {
				TweenMax.to(boundaries,1,{autoAlpha:0, x:boundaries.width/2, y:boundaries.height/2, scaleX:0, scaleY:0,onComplete:showStepView,onCompleteParams:[boundaries.height]});
				TweenMax.to(titleTextField,.3,{autoAlpha:0});
				TweenMax.to(controlButton,1,{x:"-10", y:boundaries.height/2 + 52});
				controlButton.changeIcon(isContracted())
				distribute(isContracted());
			} else {
				TweenMax.to(boundaries,1,{autoAlpha:.2, x:boundaries.width/2, y:-5, scaleX:1, scaleY:1});
				TweenMax.to(titleTextField,.2,{autoAlpha:1,delay:.8});
				TweenMax.to(controlButton,1,{x:controlButton.origX, y:controlButton.origY});
				controlButton.changeIcon(isContracted())
				distribute(isContracted());
				removeStepView()
			}
			
			
			
			//change info
			contracted = value;
		}
		
		
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
		
		private function removeStepView():void {
			removeChild(stepView);
			stepView = null;
		}
		
		/**
		 * UPDATE function 
		 * Distribute updates
		 * 
		 **/
		/*
		override public function update(o:Observable, infoObj:Object):void {
			switch (infoObj.action) {
				case "contract":
					doContract(infoObj.value);
					break
			}
		}
		*/
		public function get id():int {
			return _id;
		}
		
		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}

		public function isContracted():Boolean {
			return _contract;
		}

		public function set contracted(value:Boolean):void {
			_contract = value;
		}

		public function getStepCollection():Array {
			return _stepCollection;
		}

		public function get level():Number {
			return _level;
		}

		public function set level(value:Number):void {
			_level = value;
		}

		public function isSequenced():Boolean {
			return _sequenced;
		}

		public function set sequenced(value:Boolean):void {
			_sequenced = value;
		}


	}
}