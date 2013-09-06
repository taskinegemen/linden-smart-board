package Events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ZoomClickEvent extends Event
	{
		public static const ZOOM_IN: String = "zoom in";
		public static const ZOOM_OUT: String = "zoom out";
		
		public var point: Point;
		
		public function ZoomClickEvent(type:String, point: Point)
		{
			this.point = point;
			super(type);
		}
		
		public override function clone(): Event {
			return new ZoomClickEvent(type, point);
		}
	}
}