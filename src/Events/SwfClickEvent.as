package Events{

import Views.SwfView;

import flash.events.Event;

public class SwfClickEvent extends Event
{
	
	public function SwfClickEvent(type:String,swf:SwfView) {
		super(type);
		this.swf = swf;


	}
	public static const SWF_CLICKED = "swf click";
	public var swf;


	override public function clone():Event {
		return new SwfClickEvent(type,swf);
	}
}
}