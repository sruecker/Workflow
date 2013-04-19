package model {
	
	//imports
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import events.OrlandoEvent;
	
	import mvc.Observable;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DataModel extends Observable {
		
		//****************** Proprieties ****************** ****************** ******************
		
		protected var docCollections			:Array;						//Collection of docs
		
		protected var completeLoad				:Boolean = false;
		protected var totalDocs					:int = 0;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		public function DataModel() {
			
			super();
			
			//define name
			this.name = "data";
			
			//init
			docCollections = new Array();
			LoadData(initData());
		}
		
		
		//****************** PRIVATE INITIAL DATA ****************** ****************** ******************
		
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
				{id:54,file:"resource/wilset-w.sgm_2011-12-19_checkout.sgm"}
			];
			
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
				var urlLoader:URLLoader = new URLLoader(new URLRequest(doc.file));
				urlLoader.addEventListener(Event.COMPLETE, _docLoadComplete);
			}
			
		}
		
		
		//****************** PROCESS DATA ****************** ****************** ******************
		
		/**
		 * Create Orlando doc collections.
		 * Save all properties in an Document Model Class
		 * Push doc to doc collection
		 * 
		 * @param	e	event - The target is a XML file
		 */
		private function _docLoadComplete(e:Event):void {
			var doc:XMLList = new XMLList(e.target.data);
			
			var documentModel:DocumentModel = new DocumentModel(docCollections.length+1);
			
			//add title, authority and source
			documentModel.title = doc.ORLANDOHEADER.FILEDESC.TITLESTMT.DOCTITLE;
			documentModel.authority = doc.ORLANDOHEADER.FILEDESC.PUBLICATIONSTMT.AUTHORITY;
			documentModel.source = doc.ORLANDOHEADER.FILEDESC.SOURCEDESC
			
			//add revisions to the log history
			var revisions:XMLList = doc.ORLANDOHEADER.REVISIONDESC;
			if (revisions.children().length() > 0) {
				for each(var rev:XML in revisions.children()) {
					documentModel.addLog(rev.attribute("WORKVALUE"), rev.attribute("WORKSTATUS"), rev.attribute("RESP"),rev.ITEM, rev.DATE)
				}
			}
			
			//push to collection
			docCollections.push(documentModel);
			
			testCompleteLoad()
		}
		
		/**
		 * 
		 * 
		 */
		private function testCompleteLoad():void {
			if (docCollections.length == totalDocs ) {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		//****************** PUBLIC METHODS - GETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * Get Document Collections
		 * 
		 * Return	Array
		 **/
		public function getDocumentCollection():Array {
			return docCollections.concat();
		}
		
		/**
		 * 
		 * Get Document by Id
		 * 
		 * Return	AbstractDoc
		 **/
		public function getDocument(id:int):DocumentModel {
			for each(var doc:DocumentModel in docCollections) {
				if(doc.id == id) {
					return doc;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * Get Document Title
		 * 
		 * Return	String
		 **/
		public function getDocumentTitle(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.title;
			return null;
		}
		
		/**
		 * 
		 * Get Document Authority
		 * 
		 * Return	String
		 **/
		public function getDocumentAuthority(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.authority;
			return null;
		}
		
		/**
		 * Get Document Source
		 * 
		 * Return	String
		 **/
		public function getDocumentSource(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.source;
			return null;
		}
		
		/**
		 * 
		 * Get Document current Step
		 * 
		 * Return	String
		 **/
		public function getDocumentCurrentStep(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentStep;
			return null;
		}
		
		/**
		 * 
		 * Get Document Current Flag
		 * 
		 * Return	StatusFlag	- currentFlag
		 **/
		public function getDocumentCurrentFlag(id:int):StatusFlag {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentStatus;
			return null;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getDocumentCurrentResponsible(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentResponsible;
			return null;
		}
		
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getDocumentCurrentNote(id:int):String {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.currentNote;
			return null;
		}
		
		/**
		 * 
		 * Get a Document log history
		 * @param id
		 * @return 
		 * 
		 */
		public function getDocumentLogHistory(id:int):Array {
			var doc:DocumentModel = getDocument(id);
			if (doc) return doc.history;
			return null;
		}
		
		
		//****************** PUBLIC METHODS - ACTIONS ****************** ****************** ******************
		
		/**
		 * Add a log item to the pin
		 * 
		 **/
		public function updateDocument(id:int, newFlag:String = "", newStep:String = ""):void {
			
			var doc:DocumentModel = getDocument(id);
			
			//flag
			var flag:String;
			if (newFlag == "") {
				flag = "Start";
			} else {
				flag = newFlag;
			}
			
			//step
			var step:String;
			if (newStep == "") {
				step = getDocumentCurrentStep(id);
			} else {
				step = newStep;
			}
			
			//get new responsable
			var responsible:String = "WFM";
			
			//addLog
			doc.addLog(flag, step, responsible);
			
			//dispatch Event
			var data:Object = {};
			data.document = doc;
			
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.UPDATE_PIN, data));
			
		}
		
		/**
		 * 
		 * @param id
		 * @param tagged
		 * @return 
		 * 
		 */
		public function setDocumentTagged(id:int, tagged:Boolean):DocumentModel {
			var doc:DocumentModel = getDocument(id);
			doc.tagged = tagged;
			return doc;
			
			//dispatch Event
			var data:Object = {};
			data.pinId = id;
			
			this.dispatchEvent(new OrlandoEvent(OrlandoEvent.UPDATE_PIN, data));
		}
		
	}
}