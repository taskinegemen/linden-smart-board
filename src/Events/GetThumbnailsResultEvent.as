package Events{
	
	import flash.events.Event;
	public class GetThumbnailsResultEvent extends Event
	{
		
		public function GetThumbnailsResultEvent(type:String,book:String,thumbnails:Array) {
			super(type);

			this.book = book;
			this.thumbnails = thumbnails;
			
		}
		public static const GET_THUMBNAILS_SUCCESS: String = "get_thumb_success";
		public var book: String;
		public var thumbnails: Array;
		override public function clone():Event {
			return new GetThumbnailsResultEvent(type, book, thumbnails);
		}
	}
}