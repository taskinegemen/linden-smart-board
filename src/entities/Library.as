package entities
{	
	import com.adobe.serialization.json.*;
	
	import entities.Book;
	
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	
	import services.LibraryService;
	import services.MockLibraryService;

	public class Library
	{
		private var bookCount: Number = 0;
		private var books: Array = null;
		
		private var service: MockLibraryService;
		private var libraryService: LibraryService;
		
		public function Library() {
			// this.service = new LibraryService();
			// this.service = new MockLibraryService();
			this.libraryService = new LibraryService();
		}
		
		public function readBooks(): void {
			var fileStream: FileStream = new FileStream();
			
			// not read before
			if(this.books == null) {
				// read books;
				this.books = new Array();
				var i: Number = 0;
				
				for each( var bookBytes: ByteArray in this.libraryService.getBooks()){
					var metajson: String = bookBytes.toString();
					
					var bookObj: Object = com.adobe.serialization.json.JSON.decode(metajson);
					
					var book: Book = new Book(bookObj);
					
					this.books[i] = book;
					i++;
				}
			}
		}
		
		public function getBooks(): Array {
			if(this.books == null){
				this.readBooks();
			}
			
			return this.books;
		}
		
		public function getBookCount(): Number {
			if(this.books == null) return 0;
			return this.books.length;
		}
	}
}