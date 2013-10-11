package services {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.PNGEncoder;
	
	public class MockLibraryService {
		private static const LibraryPath: String = "C:\\books\\";
		
		public function MockLibraryService() {
			
		}
		
		public function getBooks(): Array {
			var root: 		File 		= File.documentsDirectory;
			var fileStream: FileStream 	= new FileStream();
			var books: 		Array		= new Array();
			
			// read book ids
			root = root.resolvePath(MockLibraryService.LibraryPath);
			
			for each( var bookDir: File in root.getDirectoryListing()){
				var book: ByteArray = this.getBookMeta( bookDir.name );
				books.push( book );
			}
			
			return books;
		}
		
		public function getThumbnails( bookId: Number ): Array {
			var thumbnailsDir: File = File.documentsDirectory;
			var fileStream: FileStream = new FileStream();
			
			thumbnailsDir = thumbnailsDir.resolvePath( MockLibraryService.LibraryPath + bookId + "\\thumbnails");
			
			var directoryFiles: Array = thumbnailsDir.getDirectoryListing();
			var arr: Array = new Array(directoryFiles.length);
			
			for each( var thumbnail: File in directoryFiles ){
				var thumbnailBytes: ByteArray = new ByteArray();
				fileStream.open( thumbnail, FileMode.READ );
				fileStream.readBytes( thumbnailBytes );				
				fileStream.close();
				
				var pageNo: Number = thumbnail.name.split('.')[0];
				
				arr[ int(pageNo) ] = thumbnailBytes;
			}
			
			return arr;
		}
		
		public function getBookCover(bookId: Number): ByteArray {
			var bytes: ByteArray = new ByteArray();
			var bookDir: File = File.documentsDirectory;
			var fileStream: FileStream = new FileStream();
			
			bookDir = bookDir.resolvePath(MockLibraryService.LibraryPath + bookId.toString() + "\\cover\\1.jpg");
			
			fileStream.open(bookDir, FileMode.READ);
			
			fileStream.readBytes( bytes );
			
			fileStream.close();
			
			return bytes;
		}
		
		public function getPage( bookId: Number, pageNo: Number, resolution: Number ): Array {
			var arr: Array = new Array(2);
			
			var file: File = File.documentsDirectory;
			var fileStream: FileStream = new FileStream();
			
			// page json
			file = file.resolvePath( 
				MockLibraryService.LibraryPath + 
				bookId.toString() + 
				"\\" + 
				resolution.toString() + 
				"\\" + pageNo.toString() + ".json");
			fileStream.open(file, FileMode.READ);
			
			var bytes: ByteArray = new ByteArray();
			fileStream.readBytes( bytes );
			fileStream.close();
			
			arr[0] = bytes;
			
			// page image
			file = file.resolvePath( 
				MockLibraryService.LibraryPath + 
				bookId.toString() + 
				"\\" + 
				resolution.toString() + 
				"\\" + pageNo.toString() + ".jpg");
			
			var imageBytes: ByteArray = new ByteArray();
			fileStream.open( file, FileMode.READ );
			fileStream.readBytes( imageBytes );
			fileStream.close();
			
			arr[1] = imageBytes;
			
			return arr;
		}
		
		public function getItem( bookId: Number, itemId: Number): ByteArray {
			var bytes: ByteArray = new ByteArray();
			
			var item: File = File.documentsDirectory;
			var fileStream: FileStream = new FileStream();
			
			item = item.resolvePath( MockLibraryService.LibraryPath + bookId.toString() + "\\" + "item-" + itemId.toString());
			
			fileStream.open( item, FileMode.READ );
			
			fileStream.readBytes( bytes );
			
			fileStream.close();
			
			return bytes;
		}
		
		public function getDrawings( bookId: Number, pageNo: Number ): Array {
			var path: String = File.applicationDirectory.nativePath;
			var dir: File = new File();
			
			dir = dir.resolvePath(path + "\\books\\" + bookId.toString() + "\\drawings\\"  + pageNo.toString());
			
			var fileStream: FileStream = new FileStream();
			
			if( !dir.exists ) throw Error("Drawing yok");
			
			var arr: Array = new Array( );
			for each( var file: File in dir.getDirectoryListing() ) {
				var bytes: ByteArray = new ByteArray();
				
				fileStream.open(file, FileMode.READ);
				fileStream.readBytes( bytes );
				fileStream.close();
				
				var obj: Object = new Object();
				obj.bytes = bytes;
				obj.id = file.name.split('.')[0];
				
				arr.push( obj );
			}
			
			return arr;
		}
		
		// ***
		public function getDrawing( bookId: Number, pageNo: Number, drawingNo: Number): ByteArray {
			var bytes: ByteArray = new ByteArray();
			var path: String = File.applicationDirectory.nativePath;
			var fileStream: FileStream = new FileStream();
			var file: File = new File();
			
			file = file.resolvePath( path + "\\books\\" + bookId.toString() + "\\drawings\\" + pageNo.toString() + "\\" + drawingNo.toString() + ".png");
			fileStream.open( file, FileMode.READ );
			fileStream.readBytes( bytes );
			fileStream.close();
			
			return bytes;
		}
		
		// ***
		public function saveDrawing( bookId: Number, pageNo: Number, bytes: ByteArray ): Boolean {
			var name: String = this.getNextDrawingName(bookId, pageNo);
			var result: Boolean = true;
			
			try
			{
				var path: String = File.applicationDirectory.nativePath;
				var file: File = new File();
				var fileStream: FileStream = new FileStream();
				
				file = file.resolvePath( path + "\\books\\" + bookId.toString() + "\\drawings\\" + pageNo.toString() + "\\" + name + ".png" );
				fileStream.open(file, FileMode.WRITE);
				bytes.position = 0;
				fileStream.writeBytes(bytes, 0, bytes.length);
				fileStream.close();
				
			}
			catch(error: Error){
				result = false;
			}finally{
				return result;
			}
		}
		
		// ***
		public function updateDrawing( bookId: Number, pageNo: Number, drawingNo:Number ,bytes: ByteArray ): Boolean {
			var res: Boolean = true;
			try{
				var path: String = File.applicationDirectory.nativePath;
				var file: File = new File();
				var fileStream: FileStream = new FileStream();
				
				file = file.resolvePath( path + "\\books\\" + bookId.toString() + "\\drawings\\" + pageNo.toString() + "\\" + drawingNo.toString() + ".png");
				
				fileStream.open( file, FileMode.WRITE );
				bytes.position = 0;
				fileStream.writeBytes( bytes, 0, bytes.length );
				fileStream.close();
				
			}catch(e: Error){
				res = false;
			}finally{
				return res;
			}
		}
		
		public function deleteDrawing( bookId: Number, pageNo: Number, drawingNo: Number ): Boolean  {
			var res: Boolean = true;
			try {
				var path: String = File.applicationDirectory.nativePath;
				var file: File = new File();
				var fileStream: FileStream = new FileStream();
				
				file = file.resolvePath( path + "\\books\\" + bookId.toString() + "\\drawings\\" + pageNo.toString() + "\\" + drawingNo.toString() + ".png");
				file.deleteFile();
				
			}catch(	e: Error ){
				res = false;
			}finally {
				return res;
			}
			return false;
		}
		
		private function getNextDrawingName( bookId: Number, pageNo: Number ): String {
			var name: String = (1).toString();
			try{
				var path: String = File.applicationDirectory.nativePath;
				var dir: File = new File();
				
				dir = dir.resolvePath(path + "\\books\\" + bookId.toString() + "\\drawings\\" + pageNo.toString());
				
				var len: Number = dir.getDirectoryListing().length;
				if( len ) {
					
					var lastFile: File = dir.getDirectoryListing()[len -1 ];
					var lastFileName: Number = lastFile.name.split('.')[0];
					
					name = (int(lastFileName) + 1).toString();
				} else {
					name = "1";
				}
				
			}catch(e: Error){
				var file: File = new File();
				file = file.resolvePath( path + "\\books\\" + bookId.toString() );
				file.createDirectory();
				
				dir.createDirectory();
			}finally{
				return name;	
			}
		}
		
		private function getBookMeta(bookId: String): ByteArray {
			var bytes: ByteArray = new ByteArray();
			var bookDir: File = File.documentsDirectory;
			var fileStream: FileStream = new FileStream();
			
			bookDir = bookDir.resolvePath(MockLibraryService.LibraryPath + bookId + "\\meta.json");
			fileStream.open( bookDir, FileMode.READ );
			fileStream.readBytes( bytes );
			fileStream.close();
			return bytes;
		}
		
	}
}