package entities {
	public class Outline {
		
		public var ID: Number;
		public var bookID: Number;
		public var page: Number;
		public var depth: Number;
		public var title: String;
		public var pages: Array;
		
		public function Outline(obj: Object) {
			this.pages = new Array();
			
			this.ID 		= obj.ID;
			this.bookID 	= obj.bookID;
			this.page 		= obj.page;
			this.depth 		= obj.depth;
			this.title 		= obj.title;
			
			this.pages = obj.pages;
		}
		
		public function containsPage( pageNo: Number ): Boolean {
			return true;
		}
		
	}
}