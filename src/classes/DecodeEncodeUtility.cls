/***********************************************************************
 * Class Name : DecodeEncodeUtility
 * Created Date: 02 July 2018
 * Created By : TCS 
 ***********************************************************************/
public class DecodeEncodeUtility{
	/********************************************************************
	*Method Name: decodeValues
	* Created Date: 02 July 2018
	* Created By : TCS 
	*Parameter: String - encoded string
	*Description: Decode encoded string based on base64
	*********************************************************************/
	public static String decodeValues(String inputValue) {
		Blob decodedblob = EncodingUtil.base64Decode(inputValue);
		String decodedValue = decodedblob.toString();
		return decodedValue;
	}
	/********************************************************************
	*Method Name: encodeValues
	* Created Date: 02 July 2018
	* Created By : TCS 
	*Parameter: String - decoded string
	*Description: Encode string based on base64
	*********************************************************************/
	public static String encodeValues(String inputValue) {
		Blob encodedblob = Blob.valueOf(inputValue);
		String encodedvalue = EncodingUtil.base64Encode(encodedblob);
		return encodedvalue;
	}   
}