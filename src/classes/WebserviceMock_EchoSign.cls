@isTest
global class WebserviceMock_EchoSign implements WebServiceMock
{
    global void doInvoke(
           Object stub,
           Object request, 
            Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
           {
               
               if(requestName.contains('delegateSigning'))
               {
                   delegateSigningapiEchosign.delegateSigningResponse_element c= (delegateSigningapiEchosign.delegateSigningResponse_element)JSON.deserialize('{"success_type_info":["success","http://dto17.api.echosign <http://dto17.api.echosign/> ",null,"0","1","false"],"success":false,"field_order_type_info":["errorCode","errorMessage","success"],"errorMessage_type_info":["errorMessage","http://dto17.api.echosign <http://dto17.api.echosign/> ",null,"0","1","true"],"errorMessage":"Not a current signer or delegate of current signer","errorCode_type_info":["errorCode","http://dto17.api.echosign <http://dto17.api.echosign/> ",null,"0","1","true"],"errorCode":"SIGNING_DELEGATION_NOT_ALLOWED","apex_schema_type_info":["http://dto17.api.echosign <http://dto17.api.echosign/> ","true","true"]},',delegateSigningapiEchosign.delegateSigningResponse_element.class);
                   response.put('response_x', c);
               }    
           }
}