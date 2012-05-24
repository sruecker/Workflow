package model {
	
	//imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.AbstractDoc;
	
	import mvc.Observable;
	
	public class DataModel extends Observable {
		
		//properties
		private var docCollections:Array;			//Collection of docs
		private var abstractDoc:AbstractDoc;		//Generic AbstractDoc Object
		
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		
		private var completeLoad:Boolean = false;
		private var totalDocs:int = 0;
		
		public function DataModel() {
			
			super();
			
			//define name
			this.name = "data";
			
			//init
			docCollections = new Array();
			LoadData(initData());
		}
		
		/**
		 * Initial list of docs.
		 * Return	Array - with the data.
		 */
		private function initData():Array {
			var data:Array = [
				{id:1,file:"resource/bathel-b.sgm_2011-12-19_checkout.sgm"},
				{id:2,file:"resource/bathel-w.sgm_2011-12-19_checkout.sgm"},
				{id:3,file:"resource/bellcl-b.sgm_2011-12-19_checkout.sgm"},
				{id:4,file:"resource/bellcl-w.sgm_2011-12-19_checkout.sgm"},
				{id:5,file:"resource/bellge-b.sgm_2011-12-19_checkout.sgm"},
				{id:6,file:"resource/bellge-w.sgm_2011-12-19_checkout.sgm"},
				{id:7,file:"resource/bellhi-b.sgm_2011-12-19_checkout.sgm"},
				{id:8,file:"resource/bellhi-w.sgm_2011-12-19_checkout.sgm"},
				{id:9,file:"resource/campdo-b.sgm_2011-12-19_checkout.sgm"},
				{id:10,file:"resource/campdo-w.sgm_2011-12-19_checkout.sgm"},
				{id:11,file:"resource/davese-b.sgm_2011-12-19_checkout.sgm"},
				{id:12,file:"resource/davese-w.sgm_2011-12-19_checkout.sgm"},
				{id:13,file:"resource/ecclch-b.sgm_2011-12-19_checkout.sgm"},
				{id:14,file:"resource/ecclch-w.sgm_2011-12-19_checkout.sgm"},
				{id:15,file:"resource/harwis-b.sgm_2011-12-19_checkout.sgm"},
				{id:16,file:"resource/harwis-w.sgm_2011-12-19_checkout.sgm"},
				{id:17,file:"resource/herblu-b.sgm_2011-12-19_checkout.sgm"},
				{id:18,file:"resource/herblu-w.sgm_2011-12-19_checkout.sgm"},
				{id:19,file:"resource/jacona-b.sgm_2011-12-19_checkout.sgm"},
				{id:20,file:"resource/jacona-w.sgm_2011-12-19_checkout.sgm"},
				{id:21,file:"resource/jenkel-b.sgm_2011-12-19_checkout.sgm"},
				{id:22,file:"resource/jenkel-w.sgm_2011-12-19_checkout.sgm"},
				{id:23,file:"resource/johnja-b.sgm_2011-12-19_checkout.sgm"},
				{id:24,file:"resource/johnja-w.sgm_2011-12-19_checkout.sgm"},
				{id:25,file:"resource/knigel-b.sgm_2011-12-19_checkout.sgm"},
				{id:26,file:"resource/knigel-w.sgm_2011-12-19_checkout.sgm"},
				{id:27,file:"resource/larkph-b.sgm_2011-12-19_checkout.sgm"},
				{id:28,file:"resource/larkph-w.sgm_2011-12-19_checkout.sgm"},
				{id:29,file:"resource/levyan-b.sgm_2011-12-19_checkout.sgm"},
				{id:30,file:"resource/levyan-w.sgm_2011-12-19_checkout.sgm"},
				{id:31,file:"resource/mayois-b.sgm_2011-12-19_checkout.sgm"},
				{id:32,file:"resource/mayois-w.sgm_2011-12-19_checkout.sgm"},
				{id:33,file:"resource/nithwi-b.sgm_2011-12-19_checkout.sgm"},
				{id:34,file:"resource/nithwi-w.sgm_2011-12-19_checkout.sgm"},
				{id:35,file:"resource/sincca-b.sgm_2011-12-19_checkout.sgm"},
				{id:36,file:"resource/sincca-w.sgm_2011-12-19_checkout.sgm"},
				{id:37,file:"resource/smedco-b.sgm_2011-12-19_checkout.sgm"},
				{id:38,file:"resource/smedco-w.sgm_2011-12-19_checkout.sgm"},
				{id:39,file:"resource/smitel-b.sgm_2011-12-19_checkout.sgm"},
				{id:40,file:"resource/smitel-w.sgm_2011-12-19_checkout.sgm"},
				{id:41,file:"resource/smitza-b.sgm_2011-12-19_checkout.sgm"},
				{id:42,file:"resource/smitza-w.sgm_2011-12-19_checkout.sgm"},
				{id:43,file:"resource/stewma-b.sgm_2011-12-19_checkout.sgm"},
				{id:44,file:"resource/stewma-w.sgm_2011-12-19_checkout.sgm"},
				{id:45,file:"resource/thurka-b.sgm_2011-12-19_checkout.sgm"},
				{id:46,file:"resource/thurka-w.sgm_2011-12-19_checkout.sgm"},
				{id:47,file:"resource/watesa-b.sgm_2011-12-19_checkout.sgm"},
				{id:48,file:"resource/watesa-w.sgm_2011-12-19_checkout.sgm"},
				{id:49,file:"resource/waugev-b.sgm_2011-12-19_checkout.sgm"},
				{id:50,file:"resource/waugev-w.sgm_2011-12-19_checkout.sgm"},
				{id:51,file:"resource/whitis-b.sgm_2011-12-19_checkout.sgm"},
				{id:52,file:"resource/whitis-w.sgm_2011-12-19_checkout.sgm"},
				{id:53,file:"resource/wilset-b.sgm_2011-12-19_checkout.sgm"},
				{id:54,file:"resource/wilset-w.sgm_2011-12-19_checkout.sgm"}];
			
			return data;
		}
	
		/**
		 * Create the orlando doc collections.
		 * Save all properties in an AbstractDoc Class
		 * Push the doc to a collection
		 * 
		 * @param	data	Array - doc data
		 */
		private function LoadData(data:Array):void {
			//length
			var length:int = data.length;
			totalDocs = length;
			
			for each(var doc:Object in data) {
				//load file
				urlRequest = new URLRequest(doc.file);
				urlLoader = new URLLoader(urlRequest);
				urlLoader.addEventListener(Event.COMPLETE, _docLoadComplete);
				
			}
			
		}
		
		/**
		 * Create the orlando doc collections.
		 * Save all properties in an AbstractDoc Class
		 * Push the doc to a collection
		 * 
		 * @param	e	event - The target is a XML file
		 */
		private function _docLoadComplete(e:Event):void {
			var doc:XMLList = new XMLList(e.target.data);
			
			abstractDoc = new AbstractDoc(docCollections.length+1);
			
			//add title, authority and source
			abstractDoc.title = doc.ORLANDOHEADER.FILEDESC.TITLESTMT.DOCTITLE;
			abstractDoc.authority = doc.ORLANDOHEADER.FILEDESC.PUBLICATIONSTMT.AUTHORITY;
			abstractDoc.source = doc.ORLANDOHEADER.FILEDESC.SOURCEDESC
			
			//add revisions to the log history
			var revisions:XMLList = doc.ORLANDOHEADER.REVISIONDESC;
			if (revisions.children().length() > 0) {
				for each(var rev:XML in revisions.children()) {
					abstractDoc.addLog(rev.DATE, rev.attribute("RESP"), rev.attribute("WORKVALUE"), rev.attribute("WORKSTATUS"))
				}
			}
			
			//push to collection
			docCollections.push(abstractDoc);
			
			testCompleteLoad()
		}
		
		private function testCompleteLoad():void {
			if (docCollections.length == totalDocs ) {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/// ------------- get and sets
		
		/**
		 * Get Pin Collections
		 * 
		 * Return	Array
		 **/
		public function getPinCollection():Array {
			return docCollections.concat();
		}
		
		
		/**
		 * Get Pin by Id
		 * 
		 * Return	AbstractDoc
		 **/
		public function getPin(id:int):AbstractDoc {
			for each(var doc:AbstractDoc in docCollections) {
				if(doc.id == id) {
					return doc;
				}
			}
			return null;
		}
		
		/**
		 * Get Pin Title
		 * 
		 * Return	String
		 **/
		public function getPinTitle(id:int):String {
			for each(var doc:AbstractDoc in docCollections) {
				if(doc.id == id) {
					return doc.title;
				}
			}
			return null;
		}
		
		/**
		 * Get Pin Authority
		 * 
		 * Return	String
		 **/
		public function getPinAuthority(id:int):String {
			for each(var doc:AbstractDoc in docCollections) {
				if(doc.id == id) {
					return doc.authority;
				}
			}
			return null;
		}
		
		/**
		 * Get Pin Source
		 * 
		 * Return	String
		 **/
		public function getPinSource(id:int):String {
			for each(var doc:AbstractDoc in docCollections) {
				if(doc.id == id) {
					return doc.source;
				}
			}
			return null;
		}
		
		/**
		 * Get Pin Step
		 * 
		 * Return	String	- Acronym
		 **/
		public function getPinStep(id:int):String {
			var doc:AbstractDoc = getPin(id);
			return doc.actualStep;
		}
		
		/**
		 * Get Pin Flag
		 * 
		 * Return	String	- ActualFlag
		 **/
		public function getPinFlag(id:int):String {
			var doc:AbstractDoc = getPin(id);
			return doc.actualFlag;
		}
		
		/**
		 * Add a log item to the pin
		 * 
		 **/
		public function addPinLog(id:int, data:Object):AbstractDoc {
			var doc:AbstractDoc = getPin(id);
			doc.addLog(data.date,data.responsible,data.flag,data.step);
			return doc;
		}
		
		/**
		 * Get a log pin log
		 * 
		 **/
		public function getPinLog(id:int):Array {
			for each(var doc:AbstractDoc in docCollections) {
				if(doc.id == id) {
					return doc.history;
				}
			}
			return null;
		}
		
		/**
		 * Add a log item to the pin
		 * 
		 **/
		public function setPinTagged(id:int, tagged:Boolean):AbstractDoc {
			var doc:AbstractDoc = getPin(id);
			doc.tagged = tagged;
			return doc;
		}
		
	}
}