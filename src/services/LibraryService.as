package services {
	import com.hurlant.crypto.symmetric.BlowFishKey;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.SHA256;
	
	public class LibraryService {
		private var password: String = "dontWorryBeHappy";
		private var salt: String = "grenade";
		
		private var blowJob: BlowFishKey;
		
		public function LibraryService(): void {
			//var utf16 :ByteArray = new ByteArray();
			
			//utf16.writeBoolean(false);
			//utf16.endian = Endian.LITTLE_ENDIAN;
			//utf16.position = 0;
			//utf16.writeMultiByte(this.password, "unicode");
			
			//this.salt = SHA256.computeDigest( utf16 );
			
			//var bytes: ByteArray = new ByteArray();
			//bytes.writeMultiByte(this.salt, "unicode");
			
			//this.blowJob = new BlowFishKey( bytes );
			
			//var dataBytes: ByteArray = new ByteArray();
			
			//blowJob.decrypt(  );
			
			//this.blowJob = new BlowFishKey( bytes );
		}
		
		public function getBooks(): void {
			
		}
		
	}
}