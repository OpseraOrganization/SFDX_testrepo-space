public class EinsteinDiscoveryPredictions {
	@future(callout=true)
	public static void makeDailyPrediction(String predictionLabel){
		
		String predictionDefinitionId = getPredictionId(predictionLabel);
		if(predictionDefinitionId == null) return;
		
		String restApi = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v53.0/smartdatadiscovery/predict-jobs';
		String restAPIBody = '{"predictionDefinition":{ "id":"' + predictionDefinitionId + '" },"label":"Daily L2W Score","useTerminalStateFilter" : true}';
		
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setMethod('POST');
		httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
		httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
		httpRequest.setHeader('Accept', 'application/json');
		httpRequest.setEndpoint(restApi);
		httpRequest.setBody(restAPIBody);
		
		try {  
			Http http = new Http();   
			HttpResponse httpResponse = http.send(httpRequest);
			if (httpResponse.getStatusCode() == 201) {
				string response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) );  
				System.debug('REST API Response : ' + response );
			} else {  
				System.debug('httpResponse: ' + httpResponse.getBody());
				throw new CalloutException(httpResponse.getBody());
			}	 
		} catch( System.Exception e) {
			System.debug(LoggingLevel.ERROR, 'ERROR: '+ e);
			throw e;
		}
	}
	
	public static String getPredictionId(String predictionLabel){
		String predictionId = null;
		String restApi = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v53.0/smartdatadiscovery/predictiondefinitions';
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setMethod('GET');
		httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
		httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
		httpRequest.setHeader('Accept', 'application/json');
		httpRequest.setEndpoint(restApi);
		Http http = new Http();   
		HttpResponse httpResponse = http.send(httpRequest);
		if (httpResponse.getStatusCode() == 200) {
			Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
			List<Object> results = (List<Object>) json.get('predictionDefinitions');
			for(Object result : results){
				Map<String, Object> details = (Map<String, Object>) result;
				String label = (String) details.get('label');
				if(label == predictionLabel){
					predictionId = (String) details.get('id');
					break;
				}
			}
			System.debug(predictionId);
		} 
		return predictionId;
	}
}