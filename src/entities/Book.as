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
		
		public var metadatas: Array;
		public var pages: Array;
		public var chapters: Array;
		
		public var image: String;
		
		public function Book(obj: Object = null) {
			this.metadatas 			= new Array();
			this.chapters			= new Array();
			
			this.ID 				= obj.ID;
			this.publisherID 		= obj.publisherID;
			this.title 				= obj.title;
			this.book 				= obj.book;
			this.totalPageNumber 	= obj.totalPageNumber;
			
			this.image = "C:\\docs\\covers\\" + this.ID + ".jpg";
			
			for each(var chapterObj: Object in obj.chapters){
				var chapter: Chapter = new Chapter(chapterObj);
				this.addChapter(chapter);
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
				file = file.resolvePath("C:\\docs\\pages\\" + this.ID.toString() + "\\" + i.toString() + ".json");
				fileStream.open(file, FileMode.READ);
				
				jsonString = fileStream.readUTFBytes(file.size);
				
				var pageObj: Object = com.adobe.serialization.json.JSON.decode(jsonString);
				pageObj.bookID = this.ID;
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
		
		public function getChapterPages(chapterId: Number): Array {
			var arr: Array = new Array();
			
			var chapter: Chapter = this.getChapter( chapterId );
			
			for(var i: Number = 0; i < chapter.pages.length; i++) {
				var obj: Object = new Object();
				
				obj.bookID = this.ID;
				obj.pageNo = chapter.pages[i];
				obj.image = "C:\\docs\\pages\\" + this.ID.toString() + "\\" + obj.pageNo.toString() + ".jpg";
				
				arr[i] = obj;
			}
			
			return arr;
		}
		
		private function getChapter( chapterId: Number ): Chapter {
			for(var i: Number = 0; i < this.chapters.length; i++) {
				if( this.chapters[i].ID == chapterId ){
					return this.chapters[i];
				}
			}
			return null;
		}
		
		private function addChapter(chapter: Chapter): void {
			this.chapters[ this.chapters.length ] = chapter;
		}
		
		public function getChapterDrawings( id: Number ): Array {
			var arr: Array = new Array();
			var chapter: Chapter;
			var pageArr: Array = new Array();
			var i: Number = 0;
			for(i = 0; i < this.chapters.length; i++) {
				if( (this.chapters[i] as Chapter).ID == id ){
					chapter = this.chapters[i] as Chapter;
				}
			}
			
			if(chapter == null) {
				pageArr = this.getPages();
			}else{
				for(i = 0; i < this.getPages().length; i++ ){
					var page_: Page = this.pages[i] as Page;
					
					if( chapter.containsPage( page_.pageNo ) ){
						pageArr.push( page_ );
					}
					
				}
			}
			
			for(i = 0; i < pageArr.length; i++ ){
				( pageArr[i] as Page ).fillDrawings( arr );
			}
			
			return arr;
		}
	}
}