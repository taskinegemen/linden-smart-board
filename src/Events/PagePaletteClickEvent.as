package Events{

import flash.events.Event;
public class PagePaletteClickEvent extends Event
{
	
	public function PagePaletteClickEvent(type:String) {
		super(type);
	}
	public static const LEFT_CLICKED: String = "left click";
	public static const OUTLINE_CLICKED: String = "mid click";
	public static const RIGHT_CLICKED: String = "right click";
	override public function clone():Event {
		return new PagePaletteClickEvent(type);
	}
}
}