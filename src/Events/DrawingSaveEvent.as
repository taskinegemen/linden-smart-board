package Events {
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class DrawingSaveEvent extends Event {
		public static const DRAWING_SAVE: String = "drawing save";
		public static const DRAWING_UPDATE: String ="drawing update";
		public static const DRAWING_SHARE: String = "drawing share";
		public static const DRAWING_DELETE: String = "drawing delete";
		
		public var bitmapData: BitmapData;
		public var savedBefore: Boolean;
		
		public function DrawingSaveEvent(type: String, bitmapData: BitmapData, savedBefore: Boolean) {
			this.bitmapData = bitmapData;
			this.savedBefore = savedBefore;
			super(type);
		}
		
		public override function clone():Event {
			return new DrawingSaveEvent(type, bitmapData, savedBefore);
		}
	}
}