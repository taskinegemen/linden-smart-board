package entities {
	public class Outline {
		public var ID: Number;
		public var title: String;
		public var description: String;
		
		public var pages: Array;
		
		public function Outline(obj: Object) {
			this.ID = obj.ID;
			this.description = obj.description;
			this.title = obj.title;
			
			this.pages = [1, 2, 3];
		}
		
		public function containsPage( pageNo: Number): Boolean {
			return true;
		}
	}
}