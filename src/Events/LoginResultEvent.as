package Events{
	
	import flash.events.Event;
	public class LoginResultEvent extends Event
	{
		
		public function LoginResultEvent(type:String,email:String,password:String) {
			super(type);
			this.email=email;
			this.password=password;
			
		}
		public static const LOGIN_SUCCESS: String = "success";
		public static const LOGIN_FAIL: String = "fail";
		public var email: String;
		public var password: String;
		
		override public function clone():Event {
			return new LoginResultEvent(type,email,password);
		}
	}
}