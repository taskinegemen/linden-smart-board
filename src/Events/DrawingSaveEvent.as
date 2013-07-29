package Events {
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mx.graphics.*;
	
	public class DrawingSaveEvent extends Event {
		public static const DRAWING_SAVE: String = "drawing save";
		
		public var bitmapData: BitmapData;
		
		public function DrawingSaveEvent(type: String, bitmapData: BitmapData) {
			this.bitmapData = bitmapData;
			super(type);
		}
		
		public override function clone():Event {
			return new DrawingSaveEvent(type, bitmapData);
		}
	}
}