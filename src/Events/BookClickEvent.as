package Events{

import entities.Book;

import flash.events.Event;

public class BookClickEvent extends Event
{
	public static const BOOK_CLICKED: String = "book click";
	public var book: Book;
	
	public function BookClickEvent(type:String, book: Book) {
		super(type);
		this.book = book;
	}
	
	override public function clone():Event {
		return new BookClickEvent(type, book);
	}
}
}