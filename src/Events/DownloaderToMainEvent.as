package Events
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	
	public class DownloaderToMainEvent extends Event {
		
		public var downloaderToMain: MessageChannel;
		
		public function DownloaderToMainEvent(type:String, downloaderToMain: MessageChannel , bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
			this.downloaderToMain = downloaderToMain;
		}
		
		override public function clone():Event {
			return new DownloaderToMainEvent(type, downloaderToMain);
		}
	}
}