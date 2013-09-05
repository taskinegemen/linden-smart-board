package entities {
	import Events.UploadingComplete;
	
	import Views.DrawingView;
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.controls.ProgressBar;
	import mx.core.UIComponent;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Encoder;
	
	public class GonulGozu extends EventDispatcher{
		
		private var request: URLRequest;
		private var requestHeader: URLRequestHeader;
		private var loader: HTTPURLLoader;
		private var urlLoader: URLLoader;
		private var variables: URLVariables;
		
		private static const API_URL: String = "http://api.linden.pro";
		
		private var email: String = "kurtulus@linden-tech.com";
		private var password: String = "123456";
		
		private var bookID: String;
		private var pageNo: String;
		private var bitmapData: BitmapData;
		
		public var container: DrawingView;
		
		private var token: String;
		
		
		
		public function GonulGozu() {
			
		}
		
		public function sendImage( bookId: Number, pageNo: Number, image: BitmapData ): void {
			this.bookID = bookId.toString();
			this.pageNo = pageNo.toString();
			this.bitmapData = image;
			
			this.loader = new HTTPURLLoader();
			
			this.loader.addEventListener("complete", onComplete);
			this.loader.addEventListener("ioError", onIOError);
			
			this.request = new URLRequest();
			this.request.url = GonulGozu.API_URL + "/user-login?email="+this.email+"&password="+this.password;
			this.request.method = URLRequestMethod.GET;
			
			this.loader.load( this.request );
		}
		
		private function onIOError(e: Event): void {
			this.dispatchEvent(new UploadingComplete(UploadingComplete.IOERROR, false));
		}
		
		private function onComplete(e: Event): void {
			var res: Boolean = true;
			var result: Object;
			try {
				var headers: Object = HTTPURLLoader(e.target).header;
				var str: String = "";
				//for(var p:String in headers) {
				//	trace( headers[p] );
				//}
				
				str = HTTPURLLoader(e.target).data;
				result = com.adobe.serialization.json.JSON.decode( str );
				
				this.token = result.token;
				
			} catch(e: Error) {
				res = false;
			} finally {
				if( res ) {
					this._sendImage( );
				} else {
					this.dispatchEvent(new UploadingComplete(UploadingComplete.COMPLETE, false));
				}
			}
		}
		
		private function _sendImage(): void {
			this.urlLoader = new URLLoader();
			
			this.urlLoader.addEventListener("complete", onPostComplete);
			
			var variables: URLVariables = new URLVariables();
			var pngEncoder: PNGEncoder = new PNGEncoder();
			var base64: Base64Encoder = new Base64Encoder();
			
			
			var bytes: ByteArray = pngEncoder.encode( bitmapData );
			
			base64.encodeBytes(bytes);
			
			var str: String = base64.toString();
			
			variables.file = str
			//variables.bookID = this.bookID;
			//variables.page = pageNo;
			//variables.token = this.token;
			//variables.page = this.pageNo;
			//variables.file = str;
			//trace( variables );
			var request: URLRequest = new URLRequest();
			var header: URLRequestHeader = new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			request.requestHeaders.push(header);
		
			
			request.data = variables.toString();
			request.idleTimeout = 60 * 1000;
			request.url = //GonulGozu.API_URL + "/book-imagenote";
				GonulGozu.API_URL + "/book-imagenote?token=" + this.token+"&bookID="+this.bookID+"&page="+pageNo;
			request.method = URLRequestMethod.POST;
			this.urlLoader.load( request );
		}
		
		private function onProgress(e: ProgressEvent): void {
			
		}
		
		private function onPostComplete(e: Event): void {
			var res: Boolean = true;
			var result: Object;
			try {
				var str:String = "";
				
				str = URLLoader(e.target).data;
				result = com.adobe.serialization.json.JSON.decode( str );
				
			} catch(e: Error) {
				res = false;
			} finally {
				if( res ) {
					this.processResult( result );
				} else {
					this.dispatchEvent(new UploadingComplete(UploadingComplete.COMPLETE, false));
				}
			}
		}
		
		private function processResult( result: Object ): void {
			if( result.status ) {
				//trace( com.adobe.serialization.json.JSON.encode(result) );
				this.dispatchEvent(new UploadingComplete(UploadingComplete.COMPLETE, true));
			} else {
				this.dispatchEvent(new UploadingComplete(UploadingComplete.COMPLETE, false));
			}
		}
		
	}
}

