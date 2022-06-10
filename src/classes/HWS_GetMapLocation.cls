/********************************************************************************
* Name : HWS_GetMapLocation
* Author : deeksha.1.gupta@nokia.com
* Description : This class is developed to call Google translate API
	to translate address
********************************************************************************/
public class HWS_GetMapLocation {
	/****************************************
	* Name : getTranslatedAddress
	* Description : returns the translated value for input address
	* Parameters: List<String> , String, String
	* Returns : String
	*****************************************/
	@AuraEnabled
	static public String getTranslatedAddress(List<String> texts,String src,String tar){
		Map<String, Object> result = new Map<String, Object>();
		String translatedText ='';
		HTTPResponse resp = null;
		String GOOGLE_TRANSLATE_API_KEY  = System.Label.Google_Translate_API_Key;
		String inputText = '';
		for (String text : texts) {
			inputText += '&q=' + text;
		}
		inputText = inputText.replace(' ', '%20');
		if (inputText != '' && (GOOGLE_TRANSLATE_API_KEY != null || GOOGLE_TRANSLATE_API_KEY != '')) {
			HttpRequest req = new HttpRequest();
			Http http = new Http();
			string url = 'https://www.googleapis.com/language/translate/v2?key='
		+ GOOGLE_TRANSLATE_API_KEY
		+ '&target='+tar+'&source='+src+'&format=text' + inputText;
			req.setMethod('GET');
			req.setEndPoint(url);
			resp = http.send(req);
			if(resp != null){
				String jsonResults = resp.getBody();
				JSONParser parser = JSON.createParser(jsonResults);
				while (parser.nextToken() != null) {
					if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) 
					&& (parser.getText() == 'translatedText')) {
						parser.nextToken();
						translatedText = parser.getText();
					}
				}				   
			}
			
		} 
		return translatedText;
	}
}