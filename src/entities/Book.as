package entities {
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	
	public class Book {
		
		public var ID: Number;
		public var publisherID: Number;
		public var title: String;
		public var book: String;
		public var totalPageNumber: Number = 0;
		
		public var outlines: Array;
		public var metadatas: Array;
		public var pages: Array;
		
		public var image: String;
		
		public function Book(obj: Object = null) {
			this.outlines 			= new Array();
			this.metadatas 			= new Array();
			
			this.ID 				= obj.ID;
			this.publisherID 		= obj.publisherID;
			this.title 				= obj.title;
			this.book 				= obj.book;
			this.totalPageNumber 	= obj.totalPageNumber;
			
			this.image = "C:\\docs\\covers\\" + this.ID + ".jpg";
			
			for each(var outlineObj: Object in obj.outlines){
				var outline: Outline = new Outline(outlineObj);
				this.addOutline(outline);
			}
		}
	
		public function getFirstPage(): Page {
			if(this.pages == null){
				this.readPages();
			}
			if(this.pages.length == 0){
				return null;
			}
			this.pages[0].image = "C:\\docs\\pages\\" + this.ID.toString() + "\\" + this.pages[0].pageNo + ".jpg";
			return this.pages[0];
		}
		
		// returns pages with page-thumbnails.
		//if you want to get a page with its all items you should call getPage method, which returns a specific page.
		public function getPages(): Array {
			if(this.pages == null){
				this.readPages();
			}
			
			return this.pages;
		}
		
		public function getPage(pageNumber: Number): Page {
			if(pageNumber < 1){
				pageNumber = 1;
			}else if(pageNumber > this.totalPageNumber){
				pageNumber = this.totalPageNumber;
			}
			this.pages[pageNumber - 1].image = "C:\\docs\\pages\\" + this.ID.toString() + "\\" + pageNumber.toString() + ".jpg";
			return this.pages[pageNumber - 1];
		}
		
		// fill pages of the book
		private function readPages(): void {
			// read pages from file
			var file: File = File.documentsDirectory;
			var fileStream: FileStream = new FileStream();
			var jsonString: String;
			this.pages = new Array();			
			for(var i: Number = 1; i <= this.totalPageNumber; i++) {
				file = file.resolvePath("C:\\docs\\userbooks.json");	
				file = file.resolvePath("C:\\docs\\pages\\" + this.ID.toString() + "\\" + i.toString() + ".json");
				fileStream.open(file, FileMode.READ);
				
				jsonString = fileStream.readUTFBytes(file.size);
				
				var pageObj: Object = com.adobe.serialization.json.JSON.decode(jsonString);
				
				var page: Page = new Page(pageObj);
				
				this.addPage(page);
				
				fileStream.close();
			}
		}
		
		private function addPage(page: Page): void {
			if(this.pages == null){
				this.pages = new Array();
			}
			this.pages[this.pages.length] = page;
		}
		
		public function getPageCount(): Number {
			if(this.pages == null){
				return 0;
			}
			return this.pages.length;
		}
		
		public function getOutlinePages(outlineId: Number): Array {
			var arr: Array = new Array();
			
			// this code snippet will be changed
			var ran: Number = Math.ceil(Math.random() * 8);
			
			for(var i: Number = 0; i < ran; i++) {
				var obj: Object = new Object();
				
				obj.bookID = this.ID;
				obj.pageNo = (i + 1);
				obj.image = "C:\\docs\\pages\\" + this.ID.toString() + "\\" + (i + 1).toString() + ".jpg";
				
				arr[i] = obj;
			}
			
			// until the end of this comment
			return arr;
		}
		
		private function addOutline(outline: Outline): void {
			this.outlines[ this.outlines.length ] = outline;
		}
	}
}