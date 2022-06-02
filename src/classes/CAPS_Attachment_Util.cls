/******************************************************************
 * Class Name : CAPS_Attachment_Util
 * Created Date: 27 June 2018
 * Created By : TCS
 * Description: Utility class: to calculate signature etc. 
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*******************************************************************/
public class CAPS_Attachment_Util {
   
	/****************************************************************
	* Method Name : calculate
	* Created Date: 27 June 2018
	* Created By : TCS
	* Description: calculate signature etc.
	* Parameters: url, http method name, enduser, formatted date time
	* Return: String 
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
	*****************************************************************/
	 public String calculate(String url, String method, String userEmail, String nowFormatted){
		CH_Settings__c capsSecret = CH_Settings__c.getInstance(CAPS_ConstantHandler.CAPS_SECRET);//get encoded caps secret 
		String secret = DecodeEncodeUtility.decodeValues(capsSecret.SettingValue__c);//decode caps secret
		Blob secretBlob = Blob.valueOf(secret);
		//Build signature
		String reqpath =  CAPS_ConstantHandler.REQUEST_TARGET + method.toLowerCase() + CAPS_ConstantHandler.EMPTY_WHITESPACE + url; 
		String thisdate = CAPS_ConstantHandler.X_AMZ_DATE_SIGN + nowFormatted;
		String capsenduser = CAPS_ConstantHandler.X_END_USER_SIGN + userEmail;
		String signstring = reqpath + CAPS_ConstantHandler.NEW_LINE + thisdate + CAPS_ConstantHandler.NEW_LINE + capsenduser;
		Blob signstringBlob = Blob.valueOf(signstring);
		Blob signatureBlob = Crypto.generateMac(CAPS_ConstantHandler.HMACSHA256, signstringBlob, secretBlob);
		String signature = EncodingUtil.base64Encode(signatureBlob);
		return signature;
	}
	/*******************************************************************
	* Method Name : calculate
	* Created Date: 27 June 2018
	* Created By : TCS
	* Description: create request for signature
	* Parameters: url, url, http method name, enduser, string
	* Return: HttpRequest 
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
	********************************************************************/
	public HttpRequest createRequest( String baseURL, String suffixUrl, String method, String userEmail, String signatreKey){
		DateTime now = DateTime.now();
		string nowFormatted = now.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
		String signature = calculate(suffixUrl, method, userEmail, nowFormatted); // get signature
		HttpRequest req = new HttpRequest();
		req.setEndpoint(baseURL + suffixUrl);//set end point
		req.setMethod(method);//Get method
		//Set Header
		req.setHeader(CAPS_ConstantHandler.CONTENT_TYPE, CAPS_ConstantHandler.APPLICATION_JSON);
		req.setHeader(CAPS_ConstantHandler.X_AMZ_DATE, nowFormatted);
		req.setHeader(CAPS_ConstantHandler.X_END_USER, userEmail);
		req.setHeader(CAPS_ConstantHandler.AUTHORIZATION_STR, CAPS_ConstantHandler.SIGNATURE_KEYID1 + signatreKey + CAPS_ConstantHandler.SIGNATURE_KEYID3 
					  + CAPS_ConstantHandler.ALGORITHM_STR + CAPS_ConstantHandler.EMPTY_WHITESPACE
					  + CAPS_ConstantHandler.OTHER_HEADER_VALUE
					  + CAPS_ConstantHandler.SIGNATURE_STR + signature + CAPS_ConstantHandler.DOUBLE_QUOTE);
		return req;
	}
}