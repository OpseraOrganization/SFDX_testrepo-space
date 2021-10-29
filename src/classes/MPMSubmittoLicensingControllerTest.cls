@isTest(SeeAllData = true)
Public Class MPMSubmittoLicensingControllerTest{
   Public static testmethod void MPMSubmittoLicensing(){
   User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Schema.DescribeSObjectResult OppSchema = Schema.SObjectType.Opportunity;
            Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = OppSchema.getRecordTypeInfosByName();
            string rtId = oppRecordTypeInfo.get('M&PM SIM Licensing').getRecordTypeId();
            Account acc= new account();
            acc.name = 'NTT Offshore Test Account121';
            acc.Report_Address_Line_1__c = '12 Hajecka Us A Hlinku 25/30';
            acc.Report_Address_Line_2__c = '2 Hajecka Us A Hlinku 25/30';
            acc.Report_Address_Line_3__c = '11 Hajecka Us A Hlinku 25/30';
            acc.Report_City_Name__c = 'Brno';
            acc.Report_State_Code__c = '600021';
            acc.Report_Postal_Code__c = '618 00';
            acc.Report_Country_Name__c = 'czech republic';
            acc.CBT__c = 'BGA Aftermarket';
            acc.CBT_Team__c  = 'EMEAI BGA';
            acc.REPORT_ACCOUNT_NAME__c='NTT Offshore Test Account';
            insert acc;
            opportunity opp= new opportunity(recordtypeid = rtId );
            opp.Name= 'testopty';
            opp.Licensor__c= 'HII';
            opp.Licensee__c= 'Testaccount';
            opp.Contract_Type__c= 'SIM Military';
            opp.Attorney_SBG__c= 'AER';
            opp.CloseDate= Date.newInstance(2016, 2, 1);  
            opp.Country__c= 'India';
            opp.Region1__c= 'EMEAI';
            opp.stagename= 'Phase 2: Detailed Negotiation';
            opp.Submit_to_Licensing__c=false;
            opp.AccountId = acc.Id;
            opp.Request_Contract_Number__c=true;
            opp.Contract_Term_In_Years__c = 43;
            opp.Value_in_Q1_K_Text__c = '5241';
            opp.Value_in_Q2_K_Text__c = '5241';
            opp.Value_in_Q3_K_Text__c = '5241';
            opp.Value_in_Q4_K_Text__c = '5241';
            opp.Year_2__c = 7;
            opp.Year_3__c = 3;
            opp.Year_4__c=4;
            opp.Year_5__c=5;
            opp.Comments__c='test comments';
            opp.HIPI_Accounts__c='AGUSTA S.P.A.';
            opp.CBT_HIPI__c='Airbus';
            opp.CBT_Team_HIPI__c='Airbus Companies';
            opp.HIPI_CONTRACT_NUMBER__c='123';
            opp.contract_sub_type__c='Data';
            opp.Deal_Status__c='Green [90%]';
            opp.Business_Contact__c='Test';
            opp.Contract_Title__c='TEST';
           
            S2SFRestService__c objS2SF = new S2SFRestService__c();
            objS2SF.Name='S2SFRestService11';
            objS2SF.Client_Id__c='3MVG9dzpc3kWyeYadd5SFIAZYfRT0HTnAJXRkW8Hc7.5LpxdjaVJJ05iuJHTDvKITxa5EZ9Y40iSX47_r53mJ';
            objS2SF.OAuth2End_Point__c='https://test.salesforce.com/services/oauth2/token   ';
            objS2SF.Password__c='testHtygKefAzOUqQtJ3F5pEfjk3';
            objS2SF.Secret_Id__c='17600332615211137021';
            objS2SF.User_Name__c='nandini.nanjappan@honeywell.com';         
            /*RESTAPIEndPoint__c restapi=new RESTAPIEndPoint__c();
            restapi.EndpointURL__c='createopty1';
            restapi.Name='CreateOpportunityEndPointURL1';
            insert restapi;  */           
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
            CallServicetoCreateClass1 results = new CallServicetoCreateClass1();
            OAuth2 auth = new OAuth2();
            auth.id='121';
            auth.issued_at='11-12-2015';
            auth.instance_url='/testurl';
            auth.signature='test';
            auth.access_token='12987';
          
            Test.startTest();        
            insert opp; 
                  
            insert objS2SF;
            
             PageReference pgr = page.MPMSubmittoLicensing;
             pgr.getParameters().put('id',opp.id);
             pgr.getParameters().put('RecordType',rtId);
             Test.SetCurrentPage(pgr);
             System.currentPageReference().getparameters().put('id',opp.id);      
             ApexPages.StandardController sc = new ApexPages.standardController(opp);
             MPMSubmittoLicensingController  MPM = new MPMSubmittoLicensingController (sc);  
             MPM.oppUpdate();
             opp.Submit_to_Licensing__c=true;
             update opp;  
             Test.stopTest();       
        }
   
       
        
       
}
}