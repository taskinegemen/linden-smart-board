package services {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.PNGEncoder;
	
	
	public class LibraryService {

		private var decryption: DecryptionService;
		private static const LibraryPath: String = "C:\\books\\";
		
		public function LibraryService(): void {
			decryption = new DecryptionService();
			/*
			var jsonAndImg: Vector.<ByteArray>;
			jsonAndImg = decryption.decryptPage(1,1,1);
			decryption.byteArrayToFile(jsonAndImg[0],"C:/c_ouz/lindenFiles/decryptedJson.json");
			decryption.byteArrayToImage(jsonAndImg[1],"C:/c_ouz/lindenFiles/decryptedImg.jpg");
			
						
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
			
			decryption.byteArrayToFile(decryption.decryptMeta(1),"C:/c_ouz/lindenFiles/decryptedMeta.json");
			decryption.byteArrayToImage(decryption.decryptCover(1),"C:/c_ouz/lindenFiles/decryptedCover.jpg");
			
			var listTemp: Array = decryption.decryptThumbs(1);
			for (var i:Number = 1; i <= listTemp.length; i++)
			{
				decryption.byteArrayToImage(listTemp[i - 1],"C:/c_ouz/lindenFiles/decThumbs/thm" + i + ".jpg");
			}
			*/
		}
		
		// library read books
		public function getBooks(): Array {
			return decryption.decryptBookMetas();
		}
		
		// book initialization
		// return byte array of book cover
		public function getBookCover(bookId: Number): ByteArray {
			return decryption.decryptCover(bookId);
		}
		
		// book read pages
		public function getThumbnails( bookId: Number ): Array {
			return decryption.decryptThumbs(bookId);
		}
		
		public function getPage( bookId: Number, pageNo: Number, resolution: Number ): Array {
			return decryption.decryptPage(bookId, resolution, pageNo);
		}
		
		
		

	}
}