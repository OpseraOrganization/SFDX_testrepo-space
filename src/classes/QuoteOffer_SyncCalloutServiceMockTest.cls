@isTest
Global class QuoteOffer_SyncCalloutServiceMockTest implements WebServiceMock {

   global void doInvoke(
		   Object stub,
		   Object request,
			Map<String, Object> response,
		   String endpoint,
		   String soapAction,
		   String requestName,
		   String responseNS,
		   String responseName,
		   String responseType) {
		SFDCOfferSyncWebService.SOAPResponse response_x = 
			new SFDCOfferSyncWebService.SOAPResponse();
			response_x.returnCode ='0';
			response_x.text='Successfully sent to EAI' ;
		 response.put('response_x', response_x);

   }

}