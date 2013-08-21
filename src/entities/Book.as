package entities {
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import services.MockLibraryService;
	
	public class Book {
		
		public var ID: Number;
		public var publisherID: Number;
		public var title: String;
		public var book: String;
		public var totalPageNumber: Number = 0;
		
		public var metadatas: Array;
		public var pages: Array;
		public var chapters: Array;
		
		public var image: ByteArray;
		
		private var service: MockLibraryService = new MockLibraryService();
		
		public function Book(obj: Object = null) {
			this.metadatas 			= new Array();
			this.chapters			= new Array();
			
			this.ID 				= obj.ID;
			this.publisherID 		= obj.publisherID;
			this.title 				= obj.title;
			this.book 				= obj.book;
			this.totalPageNumber 	= obj.totalPageNumber;
			
			this.image = this.service.getBookCover( this.ID.toString() );
			
			// ********************
			for(var i: Number = 0; i < obj.outlines.length; i++){
				
				if( obj.outlines.pages != null) continue;
				
				var n: Number = 40;
				var fuckPages: Array = new Array();
				for (var j: Number = 1; j <= n; j++) {
					fuckPages.push( j );
				}
				obj.outlines[i].pages = fuckPages;
			}
			// ********************
			
			for each(var chapterObj: Object in obj.outlines){
				var chapter: Chapter = new Chapter(chapterObj);
				this.addChapter(chapter);
			}
		}
	
		public function getFirstPage(resolution: Number): Page {
			if(this.pages == null) {
				this.readPages();
			}
			if(this.pages.length == 0){
				return null;
			}
			
			var arr: Array = this.service.getPage( this.ID, 1, resolution );
			
			var jsonString: String = arr[0].toString();
			var pageObj: Object = com.adobe.serialization.json.JSON.decode(jsonString);
			
			this.pages[ 0 ].bookID = this.ID;
			this.pages[ 0 ].width = pageObj.width;
			this.pages[ 0 ].height = pageObj.height;
			
			this.pages[ 0 ].setItems( pageObj.items );
			
			this.pages[ 0 ].image = arr[1];
			
			return this.pages[ 0 ];
		}
		
		// returns pages with page-thumbnails.
		//if you want to get a page with its all items you should call getPage method, which returns a specific page.
		public function getPages(): Array {
			if(this.pages == null){
				this.readPages();
			}
			
			return this.pages;
		}
		
		public function getPage(pageNumber: Number, resolution: Number): Page {
			if(pageNumber < 1) {
				pageNumber = 1;
			}else if(pageNumber > this.totalPageNumber){
				pageNumber = this.totalPageNumber;
			}
			
			var arr: Array = this.service.getPage( this.ID, pageNumber, resolution );
			
			var jsonString: String = arr[0].toString();
			var pageObj: Object = com.adobe.serialization.json.JSON.decode(jsonString);
			
			this.pages[ pageNumber - 1].bookID = this.ID;
			this.pages[ pageNumber - 1].width = pageObj.width;
			this.pages[ pageNumber - 1].height = pageObj.height;
			
			this.pages[ pageNumber - 1 ].setItems( pageObj.items );
			
			this.pages[ pageNumber - 1 ].image = arr[1];
			
			return this.pages[pageNumber - 1];
		}
		
		// fill pages of the book
		private function readPages(): void {
			
			for each( var pageThumbnail: Object in this.service.getThumbnails( this.ID ) ){
				var page: Page = new Page( pageThumbnail );	
				this.addPage( page );
			}
			
		}
		
		private function addPage(page: Page): void {
			if(this.pages == null){
				this.pages = new Array();
			}
			var len: Number = this.pages.length;			
			page.pageNo = len + 1;
			page.bookID = this.ID;
			this.pages[len] = page;
		}
		
		public function getPageCount(): Number {
			if(this.pages == null){
				return 0;
			}
			return this.pages.length;
		}
		
		public function getChapterPages( chapterId: Number ): Array {
			var arr: Array = new Array();
			
			var chapter: Chapter = this.getChapter( chapterId );
			
			for(var i: Number = 0; i < chapter.pages.length; i++) {
				var obj: Object = new Object();
				
				obj.bookID = this.ID;
				obj.pageNo = chapter.pages[i];
				obj.image = this.pages[ obj.pageNo - 1 ].thumbnailImage;
				
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
				var _page: Page = pageArr[i] as Page;
				
				_page.fillDrawings( arr );
			}
			
			return arr;
		}
	}
}