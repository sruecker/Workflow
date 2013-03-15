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
	
	import view.OrlandoView;
	
	[SWF(width="1150", height="650", backgroundColor="#ffffff", frameRate="30")]
	public class Workflow extends Sprite {
		
		//properties
		private var structureModel:StructureModel;			//Model of Orlando Project's Workflow	
		private var dataModel:DataModel;					//Model of Orlando Project's Data
		private var workflowController:WorkflowController	//Controller of the Orlando Project's view
		private var orlandoView:OrlandoView;				//View of Orlando Project's View
		
		private var background:Sprite 
		private var url:URLRequest;
		private var loader:Loader;
		
		private var logo:Sprite;
		
		public function Workflow() {
			
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
			logo = new Sprite();
			url = new URLRequest("images/logo.png");
			
			var loaderLogo:Loader = new Loader();
			loaderLogo.contentLoaderInfo.addEventListener(Event.COMPLETE, loadLogo)
			loaderLogo.load(url);
			logo.addChild(loaderLogo);
			logo.blendMode = "multiply";
			logo.alpha = .9;
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
		
		protected function loadLogo(event:Event):void {
			var img:Bitmap = event.currentTarget.content;
			img.x = -img.width/2;
			img.y = -img.height/2;
			
			logo.x = 195;
			logo.y = 70;
			
			TweenMax.from(logo,3,{alpha:0, x:-img.width/2, rotation:-400, delay:1, ease: Back.easeOut});
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