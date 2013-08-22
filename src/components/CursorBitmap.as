package components {
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	
	import mx.core.BitmapAsset;
	
	public class CursorBitmap extends BitmapAsset {
		public static var bitmapData: BitmapData;
		
		public function CursorBitmap() {
			super(CursorBitmap.bitmapData);
		}
	}
}