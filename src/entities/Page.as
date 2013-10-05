package entities {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Decoder;
	
	import spark.components.Image;
	
	import services.MockLibraryService;
	
	public class Page{
		public var pageNo: Number;
		public var bookID: Number;
		public var width: Number;
		public var height: Number;
		
		public var thumbnailImage: ByteArray;
		public var image: ByteArray;
		
		public var items: Array = new Array();
		
		public static const _640: Number = 640;
		public static const _1280: Number = 1280;
		public static const _1920: Number = 1920;
		
		public var service: MockLibraryService = new MockLibraryService();
		
		private var gonulGozu: GonulGozu = new GonulGozu();
		
		public function Page(thumbnail: Object) {
			this.thumbnailImage = thumbnail as ByteArray;
		}
		
		public function saveDrawing(bitmapData: BitmapData): Boolean {
			var encoder: PNGEncoder = new PNGEncoder();
			return this.service.saveDrawing( this.bookID, this.pageNo, encoder.encode(bitmapData) );
		}
		
		public function updateDrawing(bitmapData: BitmapData, no: String): Boolean {
			var encoder: PNGEncoder = new PNGEncoder();
			return this.service.updateDrawing( this.bookID, this.pageNo, int(no), encoder.encode(bitmapData) );
		}

		// this function can delete any drawing belongs to any page in which specified by bookId
		public function deleteDrawing( bookId: Number, pageNo: Number, drawingId: Number ): Boolean {
			return this.service.deleteDrawing( bookId, pageNo, drawingId );
		}
		
		public function getDrawings(): Array {
			var arr: Array = new Array();
			
			try {
				for each( var drawing: Object in this.service.getDrawings( this.bookID, this.pageNo )) {
					var obj: Object = new Object();
					obj.image = drawing.bytes;
					obj.id = "drawing_" + pageNo.toString() + "_" + drawing.id.toString();
					
					arr.push(obj);
				}
			} catch(e: Error) {
				
			}
			finally {
				return arr;	
			}
		}
		
		private var loader: Loader = new Loader();
		private var bitmapData: BitmapData;
		public function getDrawing(no: Number, width: Number, height: Number): void {
			var bytes: ByteArray = this.service.getDrawing( this.bookID, this.pageNo, no);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.bytesLoaded);
			loader.loadBytes(bytes);
		}
		
		private function bytesLoaded(e: Event): void {
			var bytes: * = loader.content;
			
			this.bitmapData = new BitmapData(bytes.width, bytes.height, true, 0);
			var matrix: Matrix = new Matrix();
			this.bitmapData.draw(bytes, matrix, null, null, null, true);
			
			FlexGlobals.topLevelApplication.dispatchEvent(new Event("bitmap read"));
		}
		
		public function getDrawingBitmap(): BitmapData {
			return this.bitmapData;
		}
		
		public function fillDrawings(arr: Array): void {
			
			try
			{
				for each( var drawing: Object in this.service.getDrawings( this.bookID, this.pageNo )) {
					var obj: Object = new Object();
					
					obj.id = "drawing_" + pageNo.toString() + "_" + drawing.id.toString();
					obj.image = drawing.bytes;
					
					arr.push( obj );
				}
			}catch(e: Error) {
				
			}

		}
		
		public function setItems( items: Array ): void {
			for each( var item: Object in items ){
				this.items.push( new Item( item ) );
			}
		}
	}
}