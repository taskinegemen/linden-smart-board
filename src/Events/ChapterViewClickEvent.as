package Events{

import flash.events.Event;
public class ChapterViewClickEvent extends Event
{
	
	public function ChapterViewClickEvent(type:String,page:Number) {
		super(type);
		this.page = page;
			
		

	}
	public static const CHAPTER_CLICKED: String = "chapter_click";
	
	public var page: Number;


	override public function clone():Event {
		return new ChapterViewClickEvent(type,page);
	}
}
}