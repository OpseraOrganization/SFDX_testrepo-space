@RestResource(urlMapping='/bgacsm/*')
global without sharing class BGACSM_REST {
	
    @HttpGET
    global static void bgacsmGet(){
        RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.addHeader('Access-Control-Allow-Origin', '*');
        String method = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('method'));
        String type = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('type'));
        String state = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('state'));//'--None--'
        if(String.isBlank(type)){
            type = '--None--';
        }
        if(String.isBlank(state)){
            state = '--None--';
        }        
        object response;
        switch on method{
            when 'getStatevalues' {
                response = BGACSM.getStatevalues(type);
            }
            when 'getASMCountryvalues' {
                response = BGACSM.getASMCountryvalues();
            }
            when 'gethelisupport' {
                response = BGACSM.gethelisupport(type, state);
            }
            when 'getASM' {
                String strId = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('strId'));
                String strConId = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('strConId'));
                response = BGACSM.getASM(strId, strConId);
            }
            when 'getResultValue' {
                response = BGACSM.getResultValue(type, state);
            }
            when 'getResValue' {
                response = BGACSM.getResValue(type, state);
            }
            when else{
                response = '{"Error":"No Data Found"}';
            }
        }
        
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
}