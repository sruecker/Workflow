package view.menu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 * ButtonBar Class.
	 * 
	 * This class represents the buttons used in TopBar and Footer. 
	 * @author lucaju
	 * 
	 */
	public class ButtonBar extends Sprite {
		
		//****************** Proprieties ****************** ****************** ****************** 

		protected var icon				:Sprite;					//Icon container
		protected var _iconFile			:String;					//Icon bitmap file
		
		protected var _label			:String;					//Label
		
		protected var loader			:Loader;					//Loader Container
		
		protected var _toggle			:Boolean = false;			//Toggle. Defult: false
		
		
		//****************** Contructor ****************** ****************** ******************
		
		/**
		 * Button Bar Contructor.
		 * <p>Prepare button. Set the style, and textfield and bg containers.</p> 
		 * 
		 */
		public function ButtonBar() {
			this.buttonMode = true;
		}

		//****************** Initiate ****************** ****************** ******************
		
		/**
		 * init. Render Item on the screen.
		 * <p>Load icon image.</p>
		 * <p>Set Label.</p>
		 *  
		 * @param title: String
		 * 
		 */
		public function init(title:String):void {
	
			_label = title;
			
			//Pull icon
			if (_iconFile != "") {
				icon = new Sprite();
				this.addChild(icon);
				
				loader = new Loader();
				loader.mouseEnabled = false;
				
				loader.load(new URLRequest(_iconFile));
				
				icon.addChild(loader);
				
			}
			
		}
		
		
		//****************** GETTERS ****************** ****************** ******************
		
		/**
		 * label. Return label.
		 * @return: String
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * Toggle. Return whether the item is ON (true) or OFF (false).
		 * @return:Boolean 
		 * 
		 */
		public function get toggle():Boolean {
			return _toggle;
		}
		
		//****************** SETTERS ****************** ****************** ******************
		
		/**
		 * iconFile. Set icon bitmap file
		 * @param value
		 * 
		 */
		public function set iconFile(value:String):void {
			if (_iconFile == null) {
				_iconFile = value;
			}
		}
		
		
		/**
		 * Toggle. Set the item ON (true) or OFF (false).
		 * @param value
		 * 
		 */
		public function set toggle(value:Boolean):void {
			_toggle = value;
			
			if (!_toggle) {
				TweenMax.to(icon,.3,{alpha:1});
				
			} else {
				TweenMax.to(icon,.3,{alpha:.5})
			}
			
		}

	}
}