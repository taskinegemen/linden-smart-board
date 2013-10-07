package components {

	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import mx.core.UIComponent;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="locationChanging", type="flash.events.LocationChangeEvent")]
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]

	public class StageWebViewUIComponent extends UIComponent{

		public var yOffset:int = 80;

		protected var myStage:Stage;
		private var _url:String;
		private var _text:String;

		private var _stageWebView:StageWebView;

		public var startX: Number = 0;
		public var startY: Number = 0;
		
		public var _width: Number = 800;
		public var _height: Number = 600;
		
		public function get stageWebView():StageWebView{
			return _stageWebView;
		}

		public function StageWebViewUIComponent(){
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		public function set url(url:String):void{
			_url = url;

			if(_stageWebView){
				_stageWebView.loadURL(url);
			}
		}

		public function set text(text:String):void{
			_text = text;

			if(_stageWebView){
				_stageWebView.loadString(text);
			}
		}

		public function hide():void{
			_stageWebView.stage = null;
		}

		public function show():void{
			_stageWebView.stage = myStage;
		}

		public function dispose():void{
			hide();
			_stageWebView.dispose();
		}

		protected function addedToStageHandler(event:Event):void{
			myStage = event.currentTarget.document.stage;
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			_stageWebView = new StageWebView();
			_stageWebView.stage = myStage;
			_stageWebView.viewPort = new Rectangle(0, yOffset, myStage.width, myStage.fullScreenHeight - yOffset);
			_stageWebView.addEventListener(Event.COMPLETE, completeHandler);
			_stageWebView.addEventListener(ErrorEvent.ERROR, errorHandler);
			_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, locationChangingHandler);
			_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, locationChangeHandler);
			if(_url){
				_stageWebView.loadURL(_url);
			}else if(_text){
				_stageWebView.loadString(_text);
			}
			
			var localPoint: Point = new Point(0, 0);
			var globalPoint: Point = localToGlobal(localPoint);
			_stageWebView.viewPort = new Rectangle( this.startX, this.startY, this._width, this._height);
		}

		protected function completeHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}

		protected function locationChangingHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}

		protected function locationChangeHandler(event:Event):void{
			dispatchEvent(event.clone());
		}

		protected function errorHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}


	}
}