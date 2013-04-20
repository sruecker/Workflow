package {
	
	//import
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import controller.WorkflowController;
	
	import model.DataModel;
	import model.StructureModel;
	
	import view.WorkflowView;
	
	[SWF(width="1260", height="700", backgroundColor="#ffffff", frameRate="60")]
	public class Workflow extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var structureModel			:StructureModel;			//Structure
		protected var dataModel					:DataModel;					//Documents Data
		protected var workflowController		:WorkflowController			//Controller
		protected var workflowView				:WorkflowView;				//Main View;
		
		protected var settings					:Settings;					//Settings
		
		

		
		//****************** Constructor ****************** ****************** ******************
		
		public function Workflow() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//settings
			settings = new Settings();
			
			//background
			var background:Sprite = new Sprite();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage)
			loader.load(new URLRequest("images/new_background4.jpg"));
			background.addChild(loader)
			background.alpha = .3;
			addChild(background);
			
			
			
			//Start models
			structureModel = new StructureModel();
			
			dataModel = new DataModel();
			dataModel.addEventListener(Event.COMPLETE, _loadWorkFlow);
			
			//Start controler
			workflowController = new WorkflowController([structureModel,dataModel]);
			
			//Starting View
			workflowView = new WorkflowView(workflowController);
			addChild(workflowView);
			workflowController.setView(workflowView);
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function loadImage(event:Event):void {
			event.target.content.width = stage.stageWidth;
			event.target.content.height = stage.stageHeight;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function _loadWorkFlow(e:Event):void {
			workflowView.init();
		}
	}
}