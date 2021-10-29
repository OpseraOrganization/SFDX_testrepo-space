@isTest
public class AEROSfToSAPCalloutTest {
    @isTest static  void testPostCallout() {    
        AeroCaseDataToSap Acd = new AeroCaseDataToSap();
        Acd.CaseOwner = 'test';
        Acd.Estimated_Resolution_Date = system.today();
        acd.status ='test';
        acd.Notes='test';
        acd.FSCMId='12340987';
        acd.CaseID ='12345678';
        Map<String,Object> MapOfCaseWrap = new Map<String,Object>();
        MapOfCaseWrap.put('CaseResult',acd);
        String json1 = JSON.serializePretty(MapOfCaseWrap);
        AEROSfToSAPCallout.PostDataToSAP(json1);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AeroSFtoSAPgetcalloutResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        AEROSfToSAPCallout.Wrap wr = new AEROSfToSAPCallout.Wrap();
        wr.refresh_token_expires_in ='1';
        wr.api_product_list = '0';
        wr.developer_email = 'abc@test.com';
        wr.token_type = '1';
        wr.issued_at ='0';
        wr.organization_name ='abc';
        wr.client_id = 'abc';
        wr.status = 'new';
        wr.refresh_count ='1';
        wr.application_name = 'abc';
        wr.scope ='1';
        wr.expires_in ='0';
        
   }
}