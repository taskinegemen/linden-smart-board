package entities {
	public class Chapter {
		
		public var ID: Number;
		public var title: String;
		public var description: String;
		
		public var pages: Array;
		
		public function Chapter(obj: Object) {
			
			this.ID 			= obj.ID;
			this.description 	= obj.description;
			this.title 			= obj.title;
			
			this.pages 			= obj.pages;
		}
		
		public function containsPage( pageNo: Number ): Boolean {
			return true;
		}
		
	}
}