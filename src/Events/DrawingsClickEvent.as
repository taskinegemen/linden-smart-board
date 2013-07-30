package Events {
	import flash.events.Event;

	public class DrawingsClickEvent extends Event {
		
		public static const DRAWINGS_CLICK: String = "drawings click";
		public var drawingInfo: String;
		public function DrawingsClickEvent(type: String, drawingInfo: String) {
			this.drawingInfo = drawingInfo;
			super(type);
		}
		
		public override function clone(): Event {
			return new DrawingsClickEvent(type, this.drawingInfo);
		}
	}
}