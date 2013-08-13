package entities
{	
	import com.adobe.serialization.json.*;
	
	import entities.Book;
	
	import flash.filesystem.*;
	
	import services.LibraryService;

	
	public class Library
	{
		private var bookCount: Number = 0;
		private var books: Array = null;
		
		private var service: LibraryService;
		
		public function Library() {
			this.service = new LibraryService();
		}
		
		public function readBooks(): void {
			
			this.service.getBooks();
			
			// not read before
			if(this.books == null) {
				// read books;
				this.books = new Array();
				
				var file:File = File.documentsDirectory;
				file = file.resolvePath("C:\\docs\\userbooks.json");				
				
				var fileStream: FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				
				var jsonString: String = fileStream.readUTFBytes(file.size);
				
				var obj: Object = com.adobe.serialization.json.JSON.decode(jsonString);
				fileStream.close();
				
				if( obj.hasOwnProperty("books") ){
					//this.books = obj.books;
					
					var i: Number = 0;
					for(var repeat: Number = 0; repeat < 20; repeat++) {
					// **********************
					for each(var objBook: Object in obj.books){
						
						file = file.resolvePath("C:\\docs\\books\\" + objBook.bookID + ".json");
						fileStream.open(file, FileMode.READ);
						jsonString = fileStream.readUTFBytes(file.size);
												
						var bookObj: Object = com.adobe.serialization.json.JSON.decode(jsonString);						
						
						var book: Book = new Book(bookObj);
						
						fileStream.close();
						
						this.books[i] = book;
						i++;
					}
					//	**************************
					}
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