package entities {
	public class Chapter {
		
		public var ID: Number;
		public var title: String;
		public var page: Number;
		public var depth: Number;
		public var bookID: Number;
		
		public var pages: Array;
		
		public function Chapter(obj: Object) {
			
			this.ID 			= obj.ID;
			this.title 			= obj.title;
			this.page 			= obj.page;
			this.depth			= obj.depth;
			this.bookID			= obj.bookID;
			
			this.pages 			= obj.pages;
		}
		
		public function containsPage( pageNo: Number ): Boolean {
			var matches: Array = this.pages.filter(function (no: *, index: int, array: Array): Boolean {
				return no == pageNo;
			});
			return matches.length ? true : false;
		}
		
		
	}
}