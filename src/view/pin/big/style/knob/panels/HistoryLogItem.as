package view.pin.big.style.knob.panels {
	
	//imports
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.StatusFlag;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class HistoryLogItem extends Sprite {
		
		//****************** Proprieties ****************** ****************** ******************
		
		public static var columnProportion	:Array				
		
		protected var _id					:int;				//log ID
		protected var _date					:*;					//log date
		protected var _step					:String;			//step
		protected var _statusFlag			:*			;		//flag
		protected var _responsible			:String;			//responsible
		
		
		
		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param id_
		 * @param date_
		 * @param step_
		 * @param flag_
		 * @param responsible_
		 * 
		 */
		public function HistoryLogItem(id:int,
									   date:*,
									   step:String,
									   status:*,
									   responsible:String,
									   itemType:String = "item") {
			
			//saving
			_id = id;
			_date = date;
			_step = step;
			_statusFlag = status;
			_responsible = responsible;
			
			//style
			var textStyle:TextFormat = getStyle(itemType);
			
			//--------Column1: Date
			
			var dateTF:TextField = new TextField();
			dateTF.selectable = false;
			dateTF.width = columnProportion[0];
			dateTF.height = 16;
			
			dateTF.text = _date;
			
			if (itemType == "item") {
				var day:String = date.date.toString();
				if (day.length == 1) day = "0" + day;
				
				var month:String = (date.month + 1).toString();
				if (month.length == 1) month = "0" + month;
				
				dateTF.text = day + "." + month + "." + date.fullYear;
			}
			
			dateTF.setTextFormat(textStyle);
			this.addChild(dateTF);
			
			
			//--------Column2: Step
			
			var stepTF:TextField = new TextField();
			stepTF.selectable = false;
			stepTF.width = columnProportion[1];
			stepTF.height = 16;
			stepTF.x = dateTF.y + dateTF.width;
			
			if (itemType == "header") {
				stepTF.text = _step;
			} else {
				stepTF.text = _step.toUpperCase();	
			}
			
			stepTF.setTextFormat(textStyle);
			this.addChild(stepTF);
			
			
			//--------Column3: Flag
			if (itemType == "header") {
				var flagTF:TextField = new TextField();
				flagTF.selectable = false;
				flagTF.width = columnProportion[2];
				flagTF.height = 16;
				flagTF.x = stepTF.x + stepTF.width;
				flagTF.text = _statusFlag;
				
				flagTF.setTextFormat(textStyle);
				this.addChild(flagTF);
			
			} else {
			
				//flag
				var ball:Sprite = new Sprite();	
				var color:uint = statusFlag.color; //define color
				if (color == 0xFFFFFF) ball.graphics.lineStyle(1, 0x666666); ///put a line if it is white color
				
				//draw
				ball.graphics.beginFill(color);
				ball.graphics.drawCircle(0,0,6);
				ball.graphics.endFill();
				ball.x = stepTF.x + stepTF.width + (columnProportion[2]/2);
				ball.y = 8;
				this.addChild(ball);
			
			}
			
			//--------Column4: Responsible
			
			var respTF:TextField = new TextField();
			respTF.selectable = false;
			respTF.width = columnProportion[3];
			respTF.height = 16;
			
			if (itemType == "header") {
				respTF.x = flagTF.x + flagTF.width;
			} else {
				respTF.x = stepTF.x + stepTF.width + (columnProportion[2]);
			}
			respTF.text = _responsible;
			
			respTF.setTextFormat(textStyle);
			this.addChild(respTF);
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
		public function get date():Date {
			return _date;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get step():String {
			return _step;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get statusFlag():StatusFlag {
			return _statusFlag;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get responsible():String {
			return _responsible;
		}

		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		protected function getStyle(type:String = "item"):TextFormat {
			var style:TextFormat = new TextFormat();
			style.font = "Arial";
			style.size = 12;
			style.color = 0x333333;
			style.align = "center";
			
			if (type == "header") {
				style.bold = true;
			}
			
			return style;
		}

	}
}