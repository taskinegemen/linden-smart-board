package Events{

import flash.display.BitmapData;
import flash.events.Event;

public class ChangeViewToBitmapEvent extends Event
{
	
	public function ChangeViewToBitmapEvent(type:String,bmp:BitmapData) {
		super(type);
		this.bitmapData = bmp;
	}
	public static const IMAGE_CROPPED = "IMAGE_cropped";
	public var bitmapData:BitmapData;


	override public function clone():Event {
		return new ChangeViewToBitmapEvent(type,bitmapData);
	}
}
}