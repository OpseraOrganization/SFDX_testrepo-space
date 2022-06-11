/*****************************************************************
@description:  Calls external webservice i.e iPass/SOO to check the Warranty status  
Requested values 
- MaterialCode 
- SerialNumber
- Customer Number
- Source System
Response values
-WarrantyCheck Status
History									
DATE		 AUTHOR	 Change
11/13/2018   Nikita Jain	Created
*****************************************************************/
Public without sharing Class HWS_SendWarrantyCheckRequesttoSOO {
	/*****************************************************************
@description:  This method will callout to external service to iPASS/SOO
@param: - MaterialCode,SerialNumber,Customer Number,Source System
@return: Warranty Status recieved from SOO.
Throws [Exceptions]: [optional]				
History						
DATE	 AUTHOR	 Change
11/11/2018	 Shiv Maila	  Created
12/17/2018	 Vinod Ch		 Updated
*****************************************************************/
	Public String sendToSOO(HWS_CheckWarranty_SVC.FlowInput objInput,boolean flowRequest,HWS_CheckWarranty_SVC.ChildDetails childDetailsrequest)
	{ 
		String exceptionMessage;
		try{
			HTTPRequest feedRequest = new HTTPRequest();
			String createSRJSON = '';
			feedRequest.setHeader('Content-Type','application/json');
			feedRequest.setEndpoint('callout:IPAAS_WARRANTY_CHECK');
			feedRequest.setTimeout(60000);
			HWS_CreateWarrantyCheckRequest objSR = new HWS_CreateWarrantyCheckRequest();
			if(flowRequest){
				
				createSRJSON = objSR.createSRRequest(objInput);
				
			}else{
				createSRJSON = objSR.createSRequest(childDetailsrequest);
				
			}
			feedRequest.setMethod('POST');
			feedRequest.setbody(createSRJSON);
			
			HTTP http = new HTTP();
			
			HTTPResponse feedResponse = http.send(feedRequest);
			
	if(feedResponse.getStatusCode()==200){
	warrantyCheck w = (warrantyCheck)JSon.deserialize(feedResponse.getBody(),warrantyCheck.class);
	return w.WarrantyStatus == 'Undefined' ? 'Unknown':w.WarrantyStatus;
			}else{
	
	return null;
			}
		}catch(Exception Ex){
			if(flowRequest){exceptionMessage='Facing issues in the response. please try again later'; 
			}
			else{exceptionMessage = 'Failed to determine Warranty';
			}
			return exceptionMessage;			
		}
	}
	//Wrapper class to process Json response
	Public Class warrantyCheck{
		Public string SerialNumber{get;set;}
		Public String MaterialCode{get;set;}
		Public String WarrantyStatus{get;set;}
	}
}