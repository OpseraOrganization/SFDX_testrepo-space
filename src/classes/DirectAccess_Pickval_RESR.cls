@RestResource(urlMapping='/dropdownval/*')
global without sharing class DirectAccess_Pickval_RESR {
	@HttpGET
    global static void getPicklistVals(){
        RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.addHeader('Access-Control-Allow-Origin', '*');
        object response;
        
        String picklistType = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('droptype'));
        switch on picklistType{
            when 'makelist' {
                response = BGAMobCustomWebtocase.getMakeLists();
            }
        }
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
}