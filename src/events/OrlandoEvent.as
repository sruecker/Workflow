package events{
	
	import flash.events.Event;
	
	public class OrlandoEvent extends Event {
		
		public static const KILL_BALLOON:String = "kill_balloon";
		public static const UPDATE_STEP:String = "uptade_step";
		public static const UPDATE_PIN:String = "uptade_pin";
		
		public var id:int;
		public var data:Object;
			
		public function OrlandoEvent(type:String,
								  id:int,
								  bubbles:Boolean = true,
								  cancelable:Boolean = false) {
		
			super(type, bubbles, cancelable);
			
			this.id = id;
			
			this.stopImmediatePropagation();
		}
		
		public override function clone():Event {
			return new OrlandoEvent(type, id, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("SortEvent", "type", "id", "bubbles", "cancelable", "eventPhase");
		}
		
		public function setData(value:Object):void {
			data = value;
		}
			
	}
}