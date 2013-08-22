package services {
	import com.hurlant.crypto.symmetric.BlowFishKey;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.SHA256;
	
	public class LibraryService {
		private var password: String = "dontWorryBeHappy";
		
		private var blowJob: BlowFishKey;
		
		// amk git
		public function LibraryService(): void {
			var utf16 :ByteArray = new ByteArray();
			
			utf16.writeBoolean(false);
			utf16.endian = Endian.LITTLE_ENDIAN;
			utf16.position = 0;
			utf16.writeMultiByte(this.password, "unicode");
			
			//this.salt = SHA256.computeDigest( utf16 );
			
			//var bytes: ByteArray = new ByteArray();
			//bytes.writeMultiByte(this.salt, "unicode");
			
			//this.blowJob = new BlowFishKey( bytes );
			
			//var dataBytes: ByteArray = new ByteArray();
			
			//blowJob.decrypt(  );
			
			//this.blowJob = new BlowFishKey( bytes );
		}
		
		// library read books
		public function getBooks(): void {
			
		}
		
		// book initialization
		// return byte array of book cover
		public function getBookCover(bookId: Number): void {
			
		}
		
		// book read pages
		public function getPageThumbnails(bookId: Number): void {
			
		}
		
		public function getPage(bookId: Number, pageNo: Number, resolution: Number): void {
			
		}
		
		public function getDrawings(bookId: Number, pageNo: Number): void {
			
		}

		public function saveDrawing(bookId: Number, pageNo: Number): void {
			
		}
	}
}