package view.pin.big.style.knob.panels {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.filters.BitmapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import controller.WorkflowController;
	
	import events.WorkflowEvent;
	
	import mvc.IController;
	
	import view.pin.big.AbstractPanel;

	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class InfoPanel extends AbstractPanel {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var collectionTF					:TextField;				//Collection
		protected var stepTF						:TextField;				//Step
		protected var statusTF						:TextField;				//status
		protected var responsibleTF					:TextField;				//responsible
		protected var notesTF						:TextField;				//Notes
		
		protected var titleStyle					:TextFormat;
		protected var labelStyle					:TextFormat;
		protected var valueStyle					:TextFormat;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param c
		 * @param id
		 * 
		 */
		public function InfoPanel(c:IController) {
			super(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		override public function init(id:int = 0):void {
			
			pinId = id;
				
			loadStyles();
			
			//Built Layout
			
			panelShape = new Shape();
			var posY:Number = margin + 6;
			
			//1. Authority
			var collection:String = WorkflowController(this.getController()).getPinAuthority(pinId);
				
			collectionTF = createTF();
			collectionTF.wordWrap = true;
			collectionTF.multiline = true;
			collectionTF.text = "Collection: "+ collection;
			collectionTF.setTextFormat(labelStyle,0,10);
			collectionTF.setTextFormat(valueStyle,10,collectionTF.length);
			
			collectionTF.x = margin;
			collectionTF.y = posY;
			collectionTF.width = hMax - margin;
			
			this.addChild(collectionTF);
			
			posY += collectionTF.height + 4;
			
			//2. Step
			var stepAcronym:String = WorkflowController(this.getController()).getPinCurrentStep(pinId);
			var stepTitle:String = WorkflowController(this.getController()).getStepTitleByAcronym(stepAcronym);
			
			stepTF = createTF();
			stepTF.wordWrap = true;
			stepTF.multiline = true;
			stepTF.text = "Stage: "+ stepTitle + " (" +stepAcronym.toUpperCase() + ")";
			stepTF.setTextFormat(labelStyle,0,7);
			stepTF.setTextFormat(valueStyle,7,stepTF.length);
			
			stepTF.x = margin;
			stepTF.y = posY;
			stepTF.width = hMax - margin;
			
			this.addChild(stepTF);
			
			posY += stepTF.height + 4;
			
			//3. status
			var statusInfo:String = WorkflowController(this.getController()).getPinCurrentFlag(pinId).name;
			
			statusTF = createTF();
			statusTF.wordWrap = true;
			statusTF.multiline = true;
			statusTF.text = "Status: "+ statusInfo;
			statusTF.setTextFormat(labelStyle,0,7);
			statusTF.setTextFormat(valueStyle,7,statusTF.length);
			
			statusTF.x = margin;
			statusTF.y = posY;
			statusTF.width = hMax - margin;
			
			this.addChild(statusTF);
			
			posY += statusTF.height + 4;
			
			//4. responsible
			var responsible:String = WorkflowController(this.getController()).getPinCurrentResponsible(pinId);
			
			responsibleTF = createTF();
			responsibleTF.wordWrap = true;
			responsibleTF.multiline = true;
			responsibleTF.text = "Responsible: "+ responsible;
			responsibleTF.setTextFormat(labelStyle,0,12);
			responsibleTF.setTextFormat(valueStyle,12,responsibleTF.length);
			
			responsibleTF.x = margin;
			responsibleTF.y = posY;
			responsibleTF.width = hMax - margin;
			
			this.addChild(responsibleTF);
			
			posY += responsibleTF.height + 4;
			
			//5. Note
			var note:String = WorkflowController(this.getController()).getPinCurrentNote(pinId);
			
			if (note) {
				notesTF = createTF();
				notesTF.wordWrap = true;
				notesTF.multiline = true;
				notesTF.text = "Notes: "+ note;
				notesTF.setTextFormat(labelStyle,0,6);
				notesTF.setTextFormat(valueStyle,6,notesTF.length);
				
				notesTF.x = margin;
				notesTF.y = posY;
				notesTF.width = hMax - margin;
				
				this.addChild(notesTF);
			}
			
			//listener
			this.getController().getModel("data").addEventListener(WorkflowEvent.UPDATE_PIN, updatePanel);
			
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function loadStyles():void {
			
			//title
			titleStyle = new TextFormat();
			titleStyle.font = "Arial";
			titleStyle.size = 14;
			titleStyle.leading = 1.5;
			titleStyle.color = 0x333333;
			titleStyle.bold = true;
			//titleStyle.align = "center";
			
			//Label
			labelStyle = new TextFormat();
			labelStyle.font = "Arial";
			labelStyle.size = 12;
			labelStyle.color = 0x333333;
			
			//Value
			valueStyle = new TextFormat();
			valueStyle.font = "Arial";
			valueStyle.size = 12;
			valueStyle.color = 0x333333;
			valueStyle.bold = true;
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		override public function updatePanel(event:WorkflowEvent):void {
			
			//status
			var statusInfo:String = WorkflowController(this.getController()).getPinCurrentFlag(pinId).name;
			statusTF.text = "Status: "+ statusInfo;
			statusTF.setTextFormat(labelStyle,0,7);
			statusTF.setTextFormat(valueStyle,7,statusTF.length);
			
			//responsible
			var responsibleInfo:String = WorkflowController(this.getController()).getPinCurrentResponsible(pinId);
			responsibleTF.text = "Responsible: "+ responsibleInfo;
			responsibleTF.setTextFormat(labelStyle,0,12);
			responsibleTF.setTextFormat(valueStyle,12,responsibleTF.length)
			
			//note
			var note:String = WorkflowController(this.getController()).getPinCurrentNote(pinId);
			var currentHeight:Number;
			var heightDiff:Number = this.height;
			
			if (note) {
				
				if (!notesTF) {
					notesTF = createTF();
					notesTF.wordWrap = true;
					notesTF.multiline = true;
					
					notesTF.x = margin;
					notesTF.y = responsibleTF.y + responsibleTF.height;
					notesTF.width = hMax - margin;
				}
				
				notesTF.text = "Responsible: "+ responsibleInfo;
				notesTF.setTextFormat(labelStyle,0,6);
				notesTF.setTextFormat(valueStyle,6,notesTF.length);
				
				currentHeight = this.height + (2*margin);
					
				
			} else {
				if (notesTF) {
					this.removeChild(notesTF);
					notesTF = null;
					currentHeight = responsibleTF.y + responsibleTF.height + (2*margin);
				}
			}
			
			heightDiff = heightDiff - currentHeight;
			
			//animation
			TweenMax.to(panelShape,.5,{height:currentHeight});
			if (heightDiff) TweenMax.to(this,.5,{y:this.y + heightDiff});
			
		}
		
	}
}