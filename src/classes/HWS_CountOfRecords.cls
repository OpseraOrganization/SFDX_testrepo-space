/****************************************
* Class Name : HWS_TokenGenerate
* Created Date: 12 December 2018
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 
* Description : HWS Count the No of Records Based on token and query  
*****************************************/
public class HWS_CountOfRecords {
	Integer count;
	/****************************************
* Name : getCountofRecords
* Description : gets the count of records retrieved for each callout to an external object
* Parameters: URL string
* Returns : Count Integer
*****************************************/
	public Integer getCountofRecords(String query, String token){
		String queryString;
		if(query.contains('?')){
			queryString=query+'&$count=true&$top=1'; 
		}else{
			queryString=query+'?&$count=true&$top=1'; 
		}
		try
		{
			if(token!=null){
				HttpRequest request = new HttpRequest();
				request.setMethod('GET');									
				request.setEndpoint(queryString);
				request.setHeader('Authorization', 'Bearer '+token);
				request.setHeader('Content-Type','application/json');
				request.setTimeout(20000);
				Http http1 = new Http();
				HttpResponse response1 = http1.send(request);
				String responseStr = response1.getBody();
				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL) {
							if(text=='@odata.count'){
								count = jsonparser.getIntegerValue();
								System.debug('count is'+count);
							}
						}
					}
				}
				return count;
			}else{ 
				return 0; 
			}
		}catch(Exception ex){
			if(ex.getMessage() == 'Read timed out'){
				System.debug('Attempting to read again with token: '+token);
				count = getCountofRecords(query,token);
				return count;				
			}else{
				return 0;  
			} 
		}		
	}
}