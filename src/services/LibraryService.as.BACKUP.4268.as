package services {
<<<<<<< HEAD
=======
	import com.hurlant.crypto.symmetric.BlowFishKey;
	import com.hurlant.util.Hex;
	
	
>>>>>>> origin/master
	import flash.utils.ByteArray;
	
	public class LibraryService {
<<<<<<< HEAD

=======
		private var password: String = "dontWorryBeHappy";
		private var blowJob: BlowFishKey;
		
>>>>>>> origin/master
		public function LibraryService(): void {
			var decrypt:DecryptionService = new DecryptionService();
			var jsonAndImg: Vector.<ByteArray>;
			jsonAndImg = decrypt.decryptPage(1,1,1);
			decrypt.byteArrayToFile(jsonAndImg[0],"C:/c_ouz/lindenFiles/decryptedJson.json");
			decrypt.byteArrayToImage(jsonAndImg[1],"C:/c_ouz/lindenFiles/decryptedImg.jpg");
			
			/*			
			for(var m:Number = 1; m < 4; m++)
			{
				for(var n:Number = 1; n < 185; n++ )
				{
					//trace("res:"+m+" page:"+n);
					jsonAndImg = decrypt.decryptPage(1,m,n);
					decrypt.byteArrayToFile(jsonAndImg[0],"C:/c_ouz/lindenFiles/decPages/res"+m+"page"+n+".json");
					decrypt.byteArrayToImage(jsonAndImg[1],"C:/c_ouz/lindenFiles/decPages/res" + m + "page" + n + ".jpg");
				}
			}
			*/
			
			decrypt.byteArrayToFile(decrypt.decryptMeta(1),"C:/c_ouz/lindenFiles/decryptedMeta.json");
			decrypt.byteArrayToImage(decrypt.decryptCover(1),"C:/c_ouz/lindenFiles/decryptedCover.jpg");
			
			var listTemp: Array = decrypt.decryptThumbs(1);
			for (var i:Number = 1; i <= listTemp.length; i++)
			{
				decrypt.byteArrayToImage(listTemp[i - 1],"C:/c_ouz/lindenFiles/decThumbs/thm" + i + ".jpg");
			}
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