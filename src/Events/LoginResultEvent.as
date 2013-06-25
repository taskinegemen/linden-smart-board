package Events{
	
	import flash.events.Event;
	public class LoginResultEvent extends Event
	{
		
		public function LoginResultEvent(type:String,email:String,password:String) {
			super(type);
			this.email=email;
			this.password=password;
			
		}
		public static const LOGIN_SUCCESS = "success";
		public static const LOGIN_FAIL = "fail";
		public var email;
		public var password;
		
		override public function clone():Event {
			return new LoginResultEvent(type,email,password);
		}
	}
}