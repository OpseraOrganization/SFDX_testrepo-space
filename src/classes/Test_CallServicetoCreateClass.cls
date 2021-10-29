@isTest(seealldata=true)
private class Test_CallServicetoCreateClass{
  Public static testmethod void testDoPost() {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> caseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        string rtId = caseRecordTypeInfo.get('Tech Pubs').getRecordTypeId();
        
       
        contact con=[select id,name,Primary_Email_Address__c,Phone_5__c from contact where name='NTT Offshore Test Contact' limit 1];
        /* Account acc= new Account(name = 'Test Account1',Market_name__C = 'Military');
        insert acc;
        Contact cont1 = new Contact(
            firstname = 'Testing1',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_5__c = '8392013231',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125267',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'test@nttdata.com'
        );
        insert cont1;*/
      
        Case cas= new Case(recordtypeid = rtId );
        cas.status= 'Open';
        cas.Type= 'Test lastname';
        cas.HIPI_Opportunity__c=true;
        cas.Origin='web';
        cas.contactid=con.id;
        //cas.Contact.Name='Nand test';
        cas.Classification__c='3rd Party repair';
        cas.Export_Compliance_Content_ITAR_EAR__c='No';
        cas.Government_Compliance_SM_M_Content__c='No';
       // cas.Primary_Cell_Number__c=cont1.Phone_5__c;
        cas.Description='Test';
       
        S2SFRestService__c objS2SF = new S2SFRestService__c();
        objS2SF.Name='S2SFRestService11';
        objS2SF.Client_Id__c='3MVG9dPGzpc3kWyeYadd5SFIAZYfRT0HTnAJXRkW8Hc7.5LpxdjaVJJ05iuJHTDvKITxa5EZ9Y40iSX47_r53mJ';
        objS2SF.OAuth2End_Point__c='https://test.salesforce.com/services/oauth2/token   ';
        objS2SF.Password__c='testHtygKefAzOUqQtJ3F5pEfjk3';
        objS2SF.Secret_Id__c='17600332615211287021';
        objS2SF.User_Name__c='nandini.nanjappan@honeywell.com';
        
        RESTAPIEndPoint__c restapi=new RESTAPIEndPoint__c();
        restapi.EndpointURL__c='createopty';
        restapi.Name='CreateOpportunityEndPointURL11';
  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        CallServicetoCreateClass results = new CallServicetoCreateClass();
        OAuth2 auth = new OAuth2();
        auth.id='123';
        auth.issued_at='31-12-2015';
        auth.instance_url='/testurl';
        auth.signature='test';
        auth.access_token='12345';
       /* OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class); 
        HttpRequest req1 = new HttpRequest();
        Map<string,RestAPIEndPoint__c> mapEndPointURLs = new Map<String,RestAPIEndPoint__c>();
        mapEndPointURLs = RestAPIEndPoint__c.getAll();        
        if(mapEndPointURLs.size()>0)
        {
            
            req1.setEndpoint(mapEndPointURLs.get('CreateOpportunityEndPointURL').EndPointURL__c); 
        }
       
        req1.setHeader('Content-Type','application/json;charset=UTF-8');
        //req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);        
        req1.setMethod('POST');
        HttpResponse res1 = new HttpResponse();
        Http httpCall1 = new Http();*/
        
            
        Test.startTest();
        insert restapi;  
        insert cas;
        insert objS2SF;
        Test.stopTest();
        
    
    }  
    }