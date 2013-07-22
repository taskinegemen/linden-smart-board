package Basic
{

	import Events.GetBookResultEvent;
	import Events.GetLibraryResultEvent;
	import Events.GetPageResultEvent;
	import Events.GetThumbnailsResultEvent;
	import Events.LoginResultEvent;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;

	public class Api extends EventDispatcher
	{
		
		public static var api:Api;
		
		public var domain = "http://api.linden.pro/";
		public var library;
		public var token:String;
		public var email:String;
		public var password:String;
		
//		public function Api(email:String,password:String) 
//		{
//			this.email = email;
//			this.password = password;
//		}
		
		public function Api() {
	
		}
		
		public static function getInstance(){
			return Api.api;
		}
		
		public function getLibrary(){
			//var urlLoader:URLLoader = new URLLoader();
			//var urlString:String = domain+"book?token="+this.token;
			//var urlRequest:URLRequest = new URLRequest(urlString);
			//urlRequest.method = URLRequestMethod.GET;
			//urlLoader.addEventListener(Event.COMPLETE,getLibraryResult);
			//urlLoader.load(urlRequest);		
			
			// read books;

		}
		
		public function getLibraryResult(ev:Event){
			var result:Object = com.adobe.serialization.json.JSON.decode(ev.target.data);
			var books:Array = new Array();
			if(result.status == true){
				books = result.books;
			}
			var eve:GetLibraryResultEvent = new GetLibraryResultEvent(GetLibraryResultEvent.GET_LIBRARY_SUCCESS,books);
			dispatchEvent(eve);
		}
		
		public function getPage(book:String,page:Number,resolution:Number){
			var urlLoader:URLLoader = new URLLoader();
			//http://api.linden.pro/book-page/5/2?width=1200&add_book_page_items=1&add_book_page_words=1&token=asf
			var urlString:String = domain+"book-page/"+book+"/"+page+"?width=1920&add_book_page_items=1&add_book_page_words=0&token="+this.token;
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.GET;
			urlLoader.addEventListener(Event.COMPLETE,getPageResult);
			urlLoader.load(urlRequest); 
		}
		
		public function getPageResult(ev:Event){
			var res:Object = com.adobe.serialization.json.JSON.decode(ev.target.data);
			if(res.hasOwnProperty("success") && res.success == true){
				dispatchEvent(new GetPageResultEvent(GetPageResultEvent.GET_PAGE_SUCCESS,res.page,res["page-image-url"],res.items));
			}
		}
		
		public function getToken(){
			var urlLoader:URLLoader = new URLLoader();
			var urlString:String = domain+"user-login?email="+this.email+"&password="+this.password;
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.GET;
			urlLoader.addEventListener(Event.COMPLETE,getTokenResult);
			urlLoader.load(urlRequest); 
		}
		
		public function getTokenResult(e:Event){
			var data:Object = com.adobe.serialization.json.JSON.decode(e.target.data);
			if(data.hasOwnProperty("token")){
				this.token = data.token;
				var ev:LoginResultEvent = new LoginResultEvent(LoginResultEvent.LOGIN_SUCCESS,this.email,this.password);
				dispatchEvent(ev);
			}else{
				var ev:LoginResultEvent = new LoginResultEvent(LoginResultEvent.LOGIN_FAIL,this.email,this.password);
				dispatchEvent(ev);				
			}
		}
		
		public function getBook(book:String){
			var urlLoader:URLLoader = new URLLoader();
			//http://api.linden.pro/book-page/5/2?width=1200&add_book_page_items=1&add_book_page_words=1&token=asf
			var urlString:String = domain+"book/"+book+"?token="+this.token;
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.GET;
			urlLoader.addEventListener(Event.COMPLETE,getBookResult);
			urlLoader.load(urlRequest); 
		}
		
		public function getBookResult(ev:Event){
			var res:Object = com.adobe.serialization.json.JSON.decode(ev.target.data);
			if(res.hasOwnProperty("isActive") && res.isActive == 1){
				dispatchEvent(new GetBookResultEvent(GetBookResultEvent.GET_BOOK_SUCCESS,res.ID,res.outlines));
			}
		}
		
		public var currentBook:String;
		
		public function getThumbnailsOfBook(book:String){
			//http://api.linden.pro/book-thumbnail/1&token=asf
			this.currentBook = book;
			var urlLoader:URLLoader = new URLLoader();
			var urlString:String = domain+"book-thumbnail/"+book+"?token="+this.token;
			var urlRequest:URLRequest = new URLRequest(urlString);
			urlRequest.method = URLRequestMethod.GET;
			urlLoader.dataFormat=URLLoaderDataFormat.BINARY
			urlLoader.addEventListener(Event.COMPLETE,getBookThumnbnailsResult);
			urlLoader.load(urlRequest); 
		}
		
		import flash.utils.IDataInput;
		import nochump.util.zip.*;
		
		public function getBookThumnbnailsResult(ev:Event){
			var zipFile:ZipFile = new ZipFile(ev.target.data as IDataInput);
			
			var thumbnails:Array = new Array();
			for(var i:int = 0; i <zipFile.entries.length; i++) {
				var entry:ZipEntry = zipFile.entries[i];
				trace(entry.name);
				var data:ByteArray = zipFile.getInput(entry);
				var file:File=File.applicationStorageDirectory.resolvePath(this.currentBook+"/thumb_"+i+".png");
				var pathFile:String = file.nativePath;
				var fileStream:FileStream = new FileStream();
				thumbnails.push(pathFile);
				fileStream.open(file, FileMode.WRITE);  
				fileStream.writeBytes(data);  
				fileStream.close(); 
			}
			dispatchEvent(new GetThumbnailsResultEvent(GetThumbnailsResultEvent.GET_THUMBNAILS_SUCCESS,this.currentBook,thumbnails));
		}
		
		public function getItemUrl(itemId:String){
			//http://api.linden.pro/item/1?token=2de582978c9417fd459228126a4936156ce8f15a-135b55c6ad38b675c0704dba3598dc80-5940609b9b35ad1db5db
			//http://api.linden.pro//item/2?token=eb8dc7929f42b06e655b3ecf2f88abdd7c5e5d82-fadcbfa4a0a27b48718c91482dd049f6-a2e7afcc06e94f0eede4
			return domain+"item/"+itemId+"?token="+this.token;
		}
		
	}
}