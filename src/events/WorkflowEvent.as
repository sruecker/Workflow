package events{
	
	//imports
	import flash.events.Event;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class WorkflowEvent extends Event {
		
		//****************** Properties ****************** ******************  ******************
		
		public static const KILL_BALLOON			:String = "kill_balloon";
		public static const UPDATE_STEP				:String = "uptade_step";
		public static const UPDATE_PIN				:String = "uptade_pin";
		public static const ACTIVATE_PIN			:String = "activate_pin";
		
		public static const SELECT					:String = "select";
		public static const DRAG_PIN				:String = "drag_pin";
		
		public var phase							:String;
		public var data								:Object;
			
		
		//****************** Constructor ****************** ******************  ******************
		
		/**
		 * 
		 * @param type
		 * @param data
		 * @param phase
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function WorkflowEvent(type:String,
								  data:Object = null,
								  phase:String = "",
								  bubbles:Boolean = true,
								  cancelable:Boolean = false) {
		
			super(type, bubbles, cancelable);
			this.phase = phase;
			this.data = data;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function clone():Event {
			return new WorkflowEvent(type, data, phase, bubbles, cancelable);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function toString():String {
			return formatToString("OrlandoEvent", "type", "data", "phase", "bubbles", "cancelable", "eventPhase");
		}
		
			
	}
}