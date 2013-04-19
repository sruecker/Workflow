package view.pin.panels {
	
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
		protected var _id					:int;				//log ID
		protected var _date					:Date;				//log date
		protected var _step					:String;			//step
		protected var _statusFlag			:StatusFlag;		//flag
		protected var _responsible			:String;			//responsible
		
		protected var textTF				:TextField;
		protected var style					:TextFormat;
		
		
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
									   date:Date,
									   step:String,
									   status:StatusFlag,
									   responsible:String) {
			
			_id = id;
			_date = date;
			_step = step;
			_statusFlag = status;
			_responsible = responsible;
			
			style = new TextFormat("Arial",10,0x333333);
			
			//date
			textTF = getTextField();
			
			var day:String = date.date.toString();
			if (day.length == 1) day = "0" + day;
			
			var month:String = (date.month + 1).toString();
			if (month.length == 1) month = "0" + month;
			
			textTF.text = day + "." + month + "." + date.fullYear;
			this.addChild(textTF);
			
			//step
			textTF = getTextField();
			textTF.text = step.toUpperCase();
			textTF.x = 70;
			this.addChild(textTF);
			
			//flag
			var ball:Sprite = new Sprite();	
			var color:uint = statusFlag.color; //define color
			if (color == 0xFFFFFF) ball.graphics.lineStyle(1, 0x666666); ///put a line if it is white color
			
			//draw
			ball.graphics.beginFill(color);
			ball.graphics.drawCircle(6,8,6);
			ball.graphics.endFill();
			
			ball.x = 110;
			this.addChild(ball);
			
			//Responsible
			textTF = getTextField();
			textTF.text = responsible;
			textTF.x = 140;
			this.addChild(textTF);
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
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getTextField():TextField {
			textTF = new TextField();
			textTF.selectable = false;
			textTF.autoSize = "left";
			textTF.defaultTextFormat = style;
			
			return textTF;
		}

	}
}