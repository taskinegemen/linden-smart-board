package Events{

import flash.events.Event;
public class BookClickEvent extends Event
{
	
	public function BookClickEvent(type:String,bookId:String) {
		super(type);
		this.bookId=bookId;


	}
	public static const BOOK_CLICKED = "book click";
	public var bookId;


	override public function clone():Event {
		return new BookClickEvent(type,bookId);
	}
}
}