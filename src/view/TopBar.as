package view {
	
	//imports
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import settings.Settings;
	import view.menu.TopMenu;
	
	public class TopBar extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var titleTF					:TextField;
		protected var menu						:TopMenu;
		protected var style						:TextFormat;
		
		private var h:Number;
		private var bg:Shape;
		
		//****************** Constructor ****************** ****************** ******************
		
		public function TopBar(c:IController) {			
			super(c);
			
			style = new TextFormat();
			style.font = "Arial";
			style.bold = true;
			style.color = 0XFFFFFF;
			
			if (Settings.platformTarget == "mobile") {
				h = 60;
				style.size = 42;
			} else {
				h = 30;
				style.size = 21;
			}
		}
		
		public function init():void {
			
			//1.background
			bg = new Shape();
			bg.graphics.beginFill(0x111111,.7);
			bg.graphics.drawRect(0,0,stage.stageWidth,h);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//this.blendMode = "multiply";
			
			//1.2 Shadow
			//var shadowLine:ShadowLine = new ShadowLine(stage.stageWidth);
			//shadowLine.y = bg.height;
			//this.addChild(shadowLine);
			
			//2.City Name
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.autoSize = "center";
			titleTF.text = "Orlando Workflow";
			titleTF.setTextFormat(style);
			titleTF.x = (this.width/2) - (titleTF.width/2);
			titleTF.y = 2;
			
			this.addChild(titleTF);
			
			//3.menu
			var options:Array = [
				{title:"list"}
			];
				
			menu = new TopMenu(this.getController(),options);
			menu.x = 5;
			menu.y = 2;
			menu.init();
			this.addChild(menu);
			
		}
		
		private function killChild(value:DisplayObject):void {
			this.removeChild(value);
			
		}
	}
}