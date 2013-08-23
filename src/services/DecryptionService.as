package services
{
	import com.adobe.images.JPGEncoder;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.BlowFishKey;
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.crypto.symmetric.NullPad;
	import com.hurlant.util.Hex;
	
	import entities.PageImage;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.controls.Image;
	import mx.utils.SHA256;
	
	
	public class DecryptionService
	{
		private var password: String = "dontWorryBeHappy";
		private var booksPath: String = "C:/encryptedBooks/";
		private var theSalt: ByteArray;
		private var blowFish: BlowFishKey;
		
		
		public function DecryptionService()
		{
			this.createTheSalt();
			this.blowFish = new BlowFishKey( theSalt );
		}
		
		private function getBookBytes(bookID: Number) : ByteArray
		{
			var theBookBytes: ByteArray = new ByteArray();
			var file:File = File.documentsDirectory;
			var filestream:FileStream = new FileStream();
			file = file.resolvePath(booksPath + "encryptedBook" + bookID + ".dat");
			filestream.open(file, FileMode.READ);
			filestream.readBytes(theBookBytes);
			return theBookBytes;
		}
		
		private function createTheSalt() : void
		{
			theSalt = new ByteArray();
			var passwordBytes :ByteArray = new ByteArray();
			passwordBytes.writeBoolean(false);
			passwordBytes.endian = Endian.LITTLE_ENDIAN;
			passwordBytes.position = 0;
			passwordBytes.writeMultiByte(this.password, "unicode");
			var saltString:String = SHA256.computeDigest( passwordBytes );
			theSalt = Hex.toArray(saltString);
		}
		
		private function decryptByteArray(barray: ByteArray) : ByteArray
		{	
			var dummy: ByteArray = new ByteArray();
			var cbcmode:CBCMode = new CBCMode(this.blowFish);
			cbcmode.encrypt(dummy); // dummy encrypt
			cbcmode.IV = cbcmode.IV; 
			cbcmode.decrypt(barray);
			
			var retBytes: ByteArray = new ByteArray();
			retBytes.writeBytes(barray, 8);
			//barray =retBytes;
			return retBytes;
		}
		
		public function byteArrayToFile(barray: ByteArray, destinationPath: String) : void
		{
			//remove dummy bytes, null bytes
			//var newbytes: ByteArray = new ByteArray();
			//var i: Number;
			//for(i = barray.length - 1; barray[i] == 0; i--){}
			//newbytes.writeBytes(barray, 10, i-9);
			//newbytes.writeBytes(barray, 8);
			
			//write into file
			var file:File = File.documentsDirectory;
			var filestream:FileStream = new FileStream();
			file = file.resolvePath(destinationPath);
			filestream.open(file, FileMode.WRITE);
			filestream.writeBytes(barray);
		}
		
		public function byteArrayToImage(barray: ByteArray, destinationPath: String) : void
		{
			//remove dummy bytes
			//var newbytes: ByteArray = new ByteArray();
			//newbytes.writeBytes(barray, 8);
			
			var file:File = File.documentsDirectory;
			var filestream:FileStream = new FileStream();
			file = file.resolvePath(destinationPath);
			filestream.open(file, FileMode.WRITE);
			filestream.writeBytes(barray);
		}
		
		public function decryptBookMetas() :Array
		{
			var metas: Array = new Array();
			var file:File = File.documentsDirectory;
			file = file.resolvePath(booksPath);
			var files: Array = file.getDirectoryListing();
			for(var i: int = 0; i < files.length; i++)
			{
				metas.push(decryptMeta(i+1));
			}
			return metas;
		}
		
		public function decryptPage(reqBook: Number, reqRes: Number, reqPage: Number) : Array
		{
			var bookIndex: int;
			var sizeOfMeta: int;
			var pageNumber: int;
			var indexOfRequestedPage: int;
			var sizeOfRequestedPage: int;
			var theBook: ByteArray;
			var pages: Array;
			var jsonAndImage: Array;
			var encryptedImgBytes: ByteArray;
			var encryptedJsonBytes: ByteArray;
			var intBytes: ByteArray;
			
			bookIndex = 0;
			theBook = this.getBookBytes(reqBook);
			pages = new Array();
			jsonAndImage = new Array();
			encryptedImgBytes = new ByteArray();
			encryptedJsonBytes = new ByteArray();
			intBytes = new ByteArray();
			
			var sortFunc : Function = function (x: PageImage, y: PageImage):Number{
				if(x.size < y.size)
					return -1;
				else
					return 1;
		   	}
			
			intBytes.endian = Endian.LITTLE_ENDIAN;
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			sizeOfMeta = intBytes.readInt();
			bookIndex += 4;

			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			pageNumber = intBytes.readInt();
			bookIndex += 4;
			
			indexOfRequestedPage = (reqPage - 1) * 3 + reqRes-1;
			
			for(var i: Number = 0; i < pageNumber * 3; i++)
			{
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4)
				intBytes.position = 0;
				bookIndex += 4;
				pages.push(new PageImage(i, intBytes.readInt()));
				
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4);
				intBytes.position = 0;
				bookIndex += 4;
				
				if(i == indexOfRequestedPage)
				{
					encryptedJsonBytes.writeBytes(theBook, bookIndex, intBytes.readInt());
					jsonAndImage.push(decryptByteArray(encryptedJsonBytes));
				}
				intBytes.position = 0;
				bookIndex += intBytes.readInt();
			}
			
			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			bookIndex += 4 + intBytes.readInt();
			
			bookIndex += (sizeOfMeta + 1) / 2;
			sizeOfRequestedPage = pages[indexOfRequestedPage].size;
			pages.sort(sortFunc);

			var finished: int = 0;
			var finishedAndPlacedBeforeReqPage: int = 0;
			var temp: int;
			encryptedImgBytes.clear();
			for(var currByte: int = 0; currByte < sizeOfRequestedPage; currByte++)
			{
				for(var j: Number = 0; j < pages.length && pages[j].size <= currByte; j++)
				{
					finished++;
					if(pages[j].index < indexOfRequestedPage)
						finishedAndPlacedBeforeReqPage++;
					pages.splice(j,1);
					j--;
				}
				
				temp = bookIndex;
				bookIndex += indexOfRequestedPage - finishedAndPlacedBeforeReqPage;
				encryptedImgBytes.writeBytes(theBook, bookIndex, 1);
				bookIndex = temp;
				bookIndex += 3 * pageNumber - finished;
			}
			
			jsonAndImage.push(decryptByteArray(encryptedImgBytes));
			
			return jsonAndImage;
			
		}
		public function decryptMeta(reqBook: Number) : ByteArray
		{
			var bookIndex: int;
			var sizeOfMeta: int;
			var pageNumber: int;
			var theBook: ByteArray;
			var intBytes: ByteArray;
			var encryptedMetaBytes: ByteArray;
			var reversedMetaBytes: ByteArray;
			
			bookIndex = 0;
			theBook = this.getBookBytes(reqBook);
			intBytes = new ByteArray();
			encryptedMetaBytes = new ByteArray();
			reversedMetaBytes = new ByteArray();
			
			intBytes.endian = Endian.LITTLE_ENDIAN;
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			sizeOfMeta = intBytes.readInt();
			bookIndex += 4;
			
			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			pageNumber = intBytes.readInt();
			bookIndex += 4;
		
			for(var i: Number = 0; i < pageNumber * 3; i++)
			{
				bookIndex += 4;
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4);
				intBytes.position = 0;
				bookIndex += intBytes.readInt();
				bookIndex += 4;
			}
			
			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			bookIndex += 4 + intBytes.readInt();
			encryptedMetaBytes.writeBytes(theBook, bookIndex, (sizeOfMeta + 1) / 2);
			bookIndex += (sizeOfMeta + 1) / 2;
			encryptedMetaBytes.writeBytes(theBook, theBook.length - sizeOfMeta / 2, sizeOfMeta / 2);
			
			for(var j: Number = encryptedMetaBytes.length - 1; j >=0; j--)
			{
				reversedMetaBytes.writeByte(encryptedMetaBytes[j]);
			}
			
			return decryptByteArray(reversedMetaBytes);
		}
		
		public function decryptCover(reqBook: Number) : ByteArray
		{
			var bookIndex: int;
			var pageNumber: int;
			var theBook: ByteArray;
			var intBytes: ByteArray;
			var encryptedCoverBytes: ByteArray;
			
			bookIndex = 0;
			theBook = this.getBookBytes(reqBook);
			intBytes = new ByteArray();
			encryptedCoverBytes = new ByteArray();
			
			bookIndex += 4;
			intBytes.endian = Endian.LITTLE_ENDIAN;
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			pageNumber = intBytes.readInt();
			bookIndex += 4;
			
			for(var i:Number = 0; i < pageNumber * 3; i++)
			{
				bookIndex += 4;
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4);
				intBytes.position = 0;
				bookIndex += intBytes.readInt() + 4;
			}
			
			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			bookIndex += 4;
			encryptedCoverBytes.writeBytes(theBook, bookIndex, intBytes.readInt());
			return decryptByteArray(encryptedCoverBytes);
		}
		
		public function decryptThumbs(reqBook: Number) : Array
		{
			var bookIndex: int;
			var sizeOfMeta: int;
			var pageNumber: int;
			var totalPageSize: int;
			var theBook: ByteArray;
			var pages: Array;
			var thumbs: Array;
			var retThumbs: Array;
			var encryptedImgBytes: ByteArray;
			var intBytes: ByteArray;
			
			bookIndex = 0;
			totalPageSize = 0;
			theBook = this.getBookBytes(reqBook);
			pages = new Array();
			thumbs = new Array();
			encryptedImgBytes = new ByteArray();
			intBytes = new ByteArray();
			
			intBytes.endian = Endian.LITTLE_ENDIAN;
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			sizeOfMeta = intBytes.readInt();
			bookIndex += 4;
			
			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			pageNumber = intBytes.readInt();
			bookIndex += 4;
			
			for(var i: Number = 0; i < pageNumber*3; i++)
			{
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4);
				intBytes.position = 0;
				totalPageSize += intBytes.readInt();
				bookIndex += 4;
				
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4);
				intBytes.position = 0;
				bookIndex += intBytes.readInt();
				bookIndex += 4;
			}
			
			intBytes.clear();
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			bookIndex += 4 + intBytes.readInt();
			bookIndex += (sizeOfMeta + 1) / 2;
			bookIndex += totalPageSize;
			
			for (var v: Number = 0; v < pageNumber; v++)
			{
				thumbs.push(new ByteArray());
			}
			var maxThumbSize: int = 0;
			var tmp:int = 0;
			
			for (var j:Number = 0; j < pageNumber; j++)
			{
				intBytes.clear();
				intBytes.writeBytes(theBook, bookIndex, 4);
				intBytes.position = 0;
				bookIndex += 4;
				tmp = intBytes.readInt();
				pages.push(new PageImage(j, tmp));
				if (tmp > maxThumbSize)
					maxThumbSize = tmp;
				
			}

			for (var currByte:int = 0; currByte < maxThumbSize; currByte++)
			{
				for (var k:Number = 0; k < pages.length; k++)
				{
					if (pages[k].size > currByte)
					{
						thumbs[pages[k].index].writeBytes(theBook, bookIndex, 1);
						bookIndex++;
					}
				}
			}
			
			for (var r:Number = 0; r < thumbs.length; r++)
			{
				//trace(r);
				retThumbs.push(decryptByteArray(thumbs[r]));
			}
			
			return retThumbs
		}
	}
}