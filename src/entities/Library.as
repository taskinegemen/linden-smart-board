package entities
{	
	import entities.Book;
	
	import flash.filesystem.*;
	
	public class Library
	{
		private var bookCount: Number = 0;
		private var books: Array = null;
		
		public function Library() {
			
		}
		
		public function readBooks(): void {
			// not read before
			if(this.books == null) {
				// read books;
				this.books = new Array();
				
				
				var file:File = File.documentsDirectory;
				file = file.resolvePath("C:\\docs\\thumbnails\\1\\1.jpg");
				
				this.books[0] = new Book();
				this.books[1] = new Book();
			}
		}
		
		
		
		public function getBooks(): Array {
			if(this.books == null){
				this.readBooks();
			}
			
			return this.books;
		}
		
		public function getBookCount(): Number {
			return this.bookCount;
		}
	}
}