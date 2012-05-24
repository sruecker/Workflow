package {
	
	//import
	import controller.WorkflowController;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import model.DataModel;
	import model.StructureModel;
	
	import util.LoadFile;
	
	import view.OrlandoView;
	
	//[SWF(width="1150", height="650", backgroundColor="#ffffff", frameRate="30")]
	
	public class Main extends Sprite {
		
		//properties
		private var structureModel:StructureModel;			//Model of Orlando Project's Workflow	
		private var dataModel:DataModel;					//Model of Orlando Project's Data
		private var workflowController:WorkflowController	//Controller of the Orlando Project's view
		private var orlandoView:OrlandoView;				//View of Orlando Project's View
		
		private var background:Sprite 
		private var url:URLRequest;
		private var loader:Loader;
		
		public function Main() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//background
			background = new Sprite();
			url = new URLRequest("images/new_background4.jpg");
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage)
			loader.load(url);
			background.addChild(loader)
			background.alpha = .3;
			addChild(background);
			
			//logo
			var logo:Sprite = new LoadFile("images/new_logo.png");
			logo.x = 20;
			logo.y = 20;
			logo.blendMode = "multiply";
			logo.alpha = .5;
			logo.cacheAsBitmap = true;
			this.addChild(logo);
			
			//Starting models
			structureModel = new StructureModel();
			dataModel = new DataModel();
			
			dataModel.addEventListener(Event.COMPLETE, _loadWorkFlow);
			
			//starting controler
			workflowController = new WorkflowController([structureModel,dataModel]);
			
			//Starting View
			orlandoView = new OrlandoView(workflowController);
			addChild(orlandoView);
			
			
		}
		
		private function loadImage(e:Event):void {
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
		}
		
		private function _loadWorkFlow(e:Event):void {
			orlandoView.init();
			
		}
	}
}