public class DE_DataStorage {
 public static String token;
	public  DE_DataStorage(){
		if(!string.isNotBlank(token)){
		 DE_Token_Creation.acquire();
		}
	}
}