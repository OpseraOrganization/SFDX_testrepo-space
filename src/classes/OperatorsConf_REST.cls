@RestResource(urlMapping='/operatorconference/*')
global without sharing class OperatorsConf_REST {
	
    @HttpGET
    global static void getConferences(){
        RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.addHeader('Access-Control-Allow-Origin', '*');
        object response;
        DirectAccess_operatorconference dAccConf = new DirectAccess_operatorconference();
        response = dAccConf.Summaries;
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
}