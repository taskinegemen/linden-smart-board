package Events{

import flash.events.Event;
public class PagePaletteClickEvent extends Event
{
	
	public function PagePaletteClickEvent(type:String) {
		super(type);



	}
	public static const LEFT_CLICKED = "left click";
	public static const OUTLINE_CLICKED = "mid click";
	public static const RIGHT_CLICKED = "right click";



	override public function clone():Event {
		return new PagePaletteClickEvent(type);
	}
}
}