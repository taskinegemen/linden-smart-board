package Events {
	import flash.events.Event;
	
	public class UploadingComplete extends Event {
		public static const COMPLETE: String = "uploading complete";
		public static const IOERROR: String = "uploading ioError";
		
		public var success: Boolean;
		
		public function UploadingComplete(type:String, success: Boolean) {
			this.success = success;
			super( type );
		}
		
		public override function clone():Event {
			return new UploadingComplete(type, success);
		}
	}
}