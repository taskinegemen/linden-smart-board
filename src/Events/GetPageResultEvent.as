package Events{
	
	import flash.events.Event;
	public class GetPageResultEvent extends Event
	{
		
		public function GetPageResultEvent(type:String,page:String,pageUrl:String, items:Array) {
			super(type);

			this.page = page;
			this.pageUrl = pageUrl;
			this.items = items;
			
		}
		public static const GET_PAGE_SUCCESS = "get_page_success";
		public var book;
		public var page;
		public var pageUrl;
		public var items;
		override public function clone():Event {
			return new GetPageResultEvent(type, page, pageUrl, items);
		}
	}
}