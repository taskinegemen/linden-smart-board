package Events {
	import flash.events.Event;
	import flash.geom.Point;
	
	public class CropRectangleEvent extends Event {
		public static const CROP_FINISHED: String = "crop finished";
		
		public var pointStart: Point;
		public var pointEnd: Point;
		
		public function CropRectangleEvent(type: String, pointStart: Point, pointEnd: Point) {
			this.pointStart = pointStart;
			this.pointEnd = pointEnd;
			super(type);
		}
		
		public override function clone():Event {
			return new CropRectangleEvent(type, pointStart, pointEnd);
		}
	}
}