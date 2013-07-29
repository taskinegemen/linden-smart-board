package entities {
	import flash.display.BitmapData;
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.PNGEncoder;
	
	public class Page {
		public var pageNo: Number;
		public var bookID: Number;
		public var width: Number;
		public var height: Number;
		
		public var thumbnailImage: String;
		public var image: String;
		
		public function Page(obj: Object) {	
			
			this.bookID = obj.bookID;
			this.pageNo = obj.page;
			this.width = obj.width;
			this.height = obj.height;
			
			this.thumbnailImage = "C:\\docs\\thumbnails\\" + obj.bookID + "\\" + this.pageNo.toString() + ".jpg";
		}
		
		public function saveDrawing(bitmapData: BitmapData): Boolean {
			var file: File = File.documentsDirectory;
			var name: String = this.getNextName();
			
			var encoder: PNGEncoder = new PNGEncoder();
			var bytes: ByteArray = encoder.encode(bitmapData);
			try
			{
				file = file.resolvePath("C:\\docs\\drawings\\" + this.bookID.toString() + "\\" + this.pageNo.toString() + "\\" + name + ".png");
				
				var fileStream: FileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				bytes.position = 0;
				fileStream.writeBytes(bytes, 0, bytes.length);
				
				return true;
			}
			catch(error: Error){
				
			}
			finally {
				fileStream.close();
			}
			return false;
		}
		
		private function getNextName(): String {
			var dir: File = File.documentsDirectory;
			dir = dir.resolvePath("C:\\docs\\drawings\\" + this.bookID.toString() + "\\" + this.pageNo.toString());
			var files: Array = dir.getDirectoryListing();
			
			if( !files.length ){
				return "1";
			}else {
				var file: File = files[ files.length - 1 ] as File;
				var name_: String = file.name.split('.')[0];
				var intName: Number = int(name_);
				return (intName + 1).toString();
			}
		}
		
		public function getDrawings(): Array {
			var arr: Array = new Array();
			
			var dir: File = File.documentsDirectory.resolvePath("C:\\docs\\drawings\\" + this.bookID.toString() + "\\" + this.pageNo.toString());
			for each( var file: File in dir.getDirectoryListing()) {
				var obj: Object = new Object();
				
				obj.id = "drawing_" + this.pageNo.toString() + "_" + file.name.split('.')[0];
				obj.source = "C:\\docs\\drawings\\" + this.bookID.toString() + "\\" + this.pageNo.toString() + "\\" + file.name;
				
				arr.push( obj );
			}
			
			return arr;
		}
		
		public function fillDrawings(arr: Array): void {
			var dir: File = File.documentsDirectory.resolvePath("C:\\docs\\drawings\\" + this.bookID.toString() + "\\" + this.pageNo.toString());
			for each( var file: File in dir.getDirectoryListing()) {
				var obj: Object = new Object();
				
				obj.id = "drawing_" + this.pageNo.toString() + "_" + file.name.split('.')[0];
				obj.source = "C:\\docs\\drawings\\" + this.bookID.toString() + "\\" + this.pageNo.toString() + "\\" + file.name;
				
				arr.push( obj );
			}
			
		}
	}
}