package entities {
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	
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
			return null;
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
	}
}