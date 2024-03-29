package Events{
	
	import flash.events.Event;
	public class GetBookResultEvent extends Event
	{
		
		public function GetBookResultEvent(type:String,book:String,chapters:Array) {
			super(type);
			this.book = book;
			this.chapters = chapters;
		}
		public static const GET_BOOK_SUCCESS: String = "get_book_success";
		public var book: String;
		public var chapters: Array;
		override public function clone():Event {
			return new GetBookResultEvent(type, book,chapters);
		}			
	}
}