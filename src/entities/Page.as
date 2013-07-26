package entities
{
	import flash.filesystem.*;
	
	public class Page
	{
		public var pageNo: Number;
		public var bookID: Number;
		public var width: Number;
		public var height: Number;
		
		public var thumbnailImage: String;
		public var image: String;
		
		public function Page(obj: Object) {			
			this.bookID = obj.bookID;
			this.pageNo = obj.page;
			this.width = obj.width;
			this.height = obj.height;
			
			this.thumbnailImage = "C:\\docs\\thumbnails\\" + obj.bookID + "\\" + this.pageNo.toString() + ".jpg";
		}
		
	}
}