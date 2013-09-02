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
		private var password: String = "kestimAkittimDamarlarimdakiKanimdaAkanOKirliSiyahYalanlari";
		private var encryptedBooksPath: String = "/books";
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
			var file:File = File.applicationDirectory;
			var path: String = file.nativePath;
			var filestream:FileStream = new FileStream();
			file = file.resolvePath(path + encryptedBooksPath + "/encryptedBook." + bookID + ".dat");
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
			var file:File = File.applicationDirectory;
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
			var numberOfBooks: Number = 0;
			var metas: Array = new Array();
			var file:File = File.applicationDirectory;
			var path: String = file.nativePath;
			file = file.resolvePath( path + encryptedBooksPath);
			var files: Array = file.getDirectoryListing();
			
			var arr: Array = new Array();
			
			for each (var f:File in files) 
			{
				if(!f.isDirectory && f.type == ".dat" && f.name.search("Book") != -1){
					arr[numberOfBooks] = f.name.split('.')[1];
					numberOfBooks++;
				}
			}
			
			
			for(var i: int = 0; i < numberOfBooks; i++)
			{
				metas.push(decryptMeta(int(arr[i])));
			}
			//metas.push(decryptMeta(1));
			//metas.push(decryptMeta(2));
			//metas.push(decryptMeta(64));
			return metas;
		}
		
		public function decryptPage(reqBook: Number, reqRes: Number, reqPage: Number) : Array
		{
			var bookIndex: int;
			var sizeOfMeta: int;
			var pageNumber: int;
			var startOfPages: int;
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
			
			switch(reqRes)
			{
				case 640: 	{reqRes = 1; break;}
				case 1280: 	{reqRes = 2; break;}
				case 1920: 	{reqRes = 3; break;}
				default: 	{reqRes = 1; break;}
			}
			
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
			
			intBytes.clear();
			intBytes.writeBytes(theBook, theBook.length - sizeOfMeta / 2 - 8, 4);
			intBytes.position = 0;
			startOfPages = intBytes.readInt();
			
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
			
			sizeOfRequestedPage = pages[indexOfRequestedPage].size;
			pages.sort(sortFunc);

			bookIndex = startOfPages;
			
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
			var startOfMeta: int;
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
			
			intBytes.clear();
			intBytes.writeBytes(theBook, theBook.length - sizeOfMeta / 2 - 16, 4);
			intBytes.position = 0;
			startOfMeta = intBytes.readInt();
			
			bookIndex = startOfMeta;
			
			encryptedMetaBytes.writeBytes(theBook, bookIndex, (sizeOfMeta + 1) / 2);
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
			var sizeOfMeta: int;
			var startOfCover: int;
			var theBook: ByteArray;
			var intBytes: ByteArray;
			var encryptedCoverBytes: ByteArray;
			
			bookIndex = 0;
			theBook = this.getBookBytes(reqBook);
			intBytes = new ByteArray();
			encryptedCoverBytes = new ByteArray();
			
			intBytes.endian = Endian.LITTLE_ENDIAN;
			intBytes.writeBytes(theBook, bookIndex, 4);
			intBytes.position = 0;
			sizeOfMeta = intBytes.readInt();
			
			intBytes.clear();
			intBytes.writeBytes(theBook, theBook.length - sizeOfMeta / 2 - 12, 4);
			intBytes.position = 0;
			startOfCover = intBytes.readInt();
			
			bookIndex = startOfCover;
			
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
			var startOfThumbs: int;
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
			retThumbs = new Array();
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
			
			intBytes.clear();
			intBytes.writeBytes(theBook, theBook.length - sizeOfMeta / 2 - 4, 4);
			intBytes.position = 0;
			startOfThumbs = intBytes.readInt();
			
			bookIndex = startOfThumbs;
			
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
		
		public function decryptItem( bookId: Number, itemId: Number): ByteArray
		{
			var theItem: ByteArray = new ByteArray();
			var intBytes: ByteArray = new ByteArray();
			var numberOfItems: int;
			var itemPlace: int = -1;
			var jumpSize: int = 0;
			var sizeOfItem: int = -1;
			
			var file:File = File.applicationDirectory;
			var path: String = file.nativePath;
			var fs:FileStream = new FileStream();
			file = file.resolvePath( path + encryptedBooksPath + "/encryptedItems." + bookId + ".dat");
			fs.open(file, FileMode.READ);
			
			intBytes.endian = Endian.LITTLE_ENDIAN;
			fs.readBytes(intBytes, 0, 4);
			intBytes.position = 0;
			numberOfItems = intBytes.readInt();
			
			for (var i:int = 0; i < numberOfItems; i++)
			{
				intBytes.clear();
				fs.readBytes(intBytes, 0, 4);
				intBytes.position = 0;
				if (intBytes.readInt() == itemId) 
				{
					itemPlace = i;
					break;
				}
			}
			fs.position = 4 + numberOfItems * 4;
			
			for (var j: int = 0; j < numberOfItems; j++)
			{
				if (j == itemPlace)
				{
					intBytes.clear();
					fs.readBytes(intBytes, 0, 4);
					intBytes.position = 0;
					sizeOfItem = intBytes.readInt();
					break;
				}
				intBytes.clear();
				fs.readBytes(intBytes, 0, 4);
				intBytes.position = 0;
				jumpSize += intBytes.readInt() + 22;
			}
			fs.position = 4 + numberOfItems * 8 + jumpSize + 11;
			
			fs.readBytes(theItem, 0, sizeOfItem / 2);
			fs.position += 11;
			fs.readBytes(theItem, sizeOfItem / 2, (sizeOfItem + 1) / 2);
			
			return theItem;
		}
	}
}