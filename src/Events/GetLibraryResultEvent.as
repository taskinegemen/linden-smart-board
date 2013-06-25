package Events{
	
	import flash.events.Event;
	public class GetLibraryResultEvent extends Event
	{
		
		public function GetLibraryResultEvent(type:String,books:Array) {
			super(type);
			this.books = books;
			
		}
		public static const GET_LIBRARY_SUCCESS = "get_success";
		public var books;
		
		override public function clone():Event {
			return new GetLibraryResultEvent(type, books);
		}
	}
}