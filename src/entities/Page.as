package entities
{
	import flash.filesystem.*;
	
	public class Page
	{
		public var pageNo: Number;
		public var bookID: Number;
		
		public var thumbnailImage: String;
		public var image: String;
		
		public function Page(obj: Object) {			
			this.bookID = obj.bookID;
			this.pageNo = obj.page;
			
			this.thumbnailImage = "C:\\docs\\thumbnails\\" + obj.bookID + "\\" + this.pageNo.toString() + ".jpg";
		}
		
	}
}