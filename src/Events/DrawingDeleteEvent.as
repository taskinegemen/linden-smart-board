package Events {
	import flash.events.Event;
	
	public class DrawingDeleteEvent extends Event {
		public static const DRAWING_DELETE: String = "drawing delete";
		
		public var drawingId: Number;
		public var bookId: Number;
		public var pageNo: Number;
		
		public function DrawingDeleteEvent(type: String, bookId: Number, pageNo: Number, drawingId: Number) {
			this.bookId = bookId;
			this.pageNo = pageNo;
			this.drawingId = drawingId;
			super(type);
		}
		
		public override function clone():Event {
			return new DrawingDeleteEvent(type, bookId, pageNo, drawingId);
		}
	}
}