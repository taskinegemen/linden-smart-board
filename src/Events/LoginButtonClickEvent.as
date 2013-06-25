package Events{

import flash.events.Event;
public class LoginButtonClickEvent extends Event
{
	
	public function LoginButtonClickEvent(type:String,email:String,password:String) {
		super(type);
		this.email=email;
		this.password=password;

	}
	public static const LOGIN_BUTTON_CLICK = "login button click";
	public var email;
	public var password;

	override public function clone():Event {
		return new LoginButtonClickEvent(type,email,password);
	}
}
}