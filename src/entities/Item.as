package entities {
	import flash.utils.ByteArray;
	
	import services.MockLibraryService;

	public class Item {
		
		public static const	ITEM_VIDEO_TYPE: String = "video";
		public static const	ITEM_AUDIO_TYPE: String = "audio";
		public static const	ITEM_FLASH_TYPE: String = "flash";
		public static const	ITEM_LINK_TYPE: String = "link";
		public static const	ITEM_IMAGE_TYPE: String = "image";
		
		// json properties
		public var ID				:Number;
		public var itemID			:Number;
		public var bookID			:Number;
		public var page				:Number;
		public var type				:String;
		public var title			:String;
		public var description		:String;
		public var keyword			:String;
		public var filename			:String;
		public var courseID			:String;
		public var classID			:String;
		public var luX				:Number;
		public var luY				:Number;
		public var rlX				:Number;
		public var rlY				:Number;
		public var width			:Number;
		public var height			:Number;
		public var imageFilename	:String;
		public var imageLuX			:Number;
		public var imageLuY			:Number;
		public var imageRlX			:Number;
		public var imageRlY			:Number;
		public var imageWidth		:Number;
		public var imageHeight		:Number;
		
		public var service: MockLibraryService = new MockLibraryService();
		
		public function Item( obj: Object ) {
			this.ID 			= obj.ID;
			this.itemID			= obj.itemID;
			this.bookID			= obj.bookID;
			this.page			= obj.page;
			this.type			= obj.type;
			this.title 			= obj.title;
			this.description 	= obj.description;
			this.keyword		= obj.keyword;
			this.filename		= obj.filename;
			this.courseID		= obj.courseID;
			this.classID		= obj.classID;
			this.luX			= obj.luX;
			this.luY			= obj.luY;
			this.rlX			= obj.rlX;
			this.rlY			= obj.rlY;
			this.width			= obj.width;
			this.height			= obj.height;
			this.imageFilename	= obj.imageFilename;
			this.imageLuX		= obj.imageLuX;
			this.imageLuY		= obj.imageLuY;
			this.imageRlX		= obj.imageRlX;
			this.imageRlY		= obj.imageRlY;
			this.imageWidth		= obj.imageWidth;
			this.imageHeight	= obj.imageHeight;
		}
		
		public function getBytes(): ByteArray {
			return this.service.getItem( this.bookID, this.itemID );
		}
		
		
	}
}