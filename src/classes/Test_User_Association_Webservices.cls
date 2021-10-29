@isTest
private class Test_User_Association_Webservices 
{
    static testMethod void testGetRecord(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/services/apexrest/AerospaceAircraftandProgramServices?honeywellid=gdjdksj&requestType=aircraft';
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{}'); 
        RestContext.request = request;       
        //RestContext.response=new RestResponse();
        RestContext.response= response;
       /* request.addParameter('honeywellid', 'jhffjhfj'); // validate for no data for given honeywell Id
        request.addParameter('requestType', 'aircraft');*/
       
        Test.startTest();
         UserAssociationWebserviceController.getRecord();
        Test.stopTest();    
        
    }
    
    private static testMethod void testWebServices() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        insert phi1;
        
         Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',Account_Name__c= honeywellContact.accountid,External_Account_ID__c='0000000000-01',Site_Code__c='123',XREF_Type__c='SAP_SOLD_TO');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram;
        
        
        
         // code to cover getRecord method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        
        request.addParameter('honeywellid', ''); // validate for blank honeywell id 
        request.addParameter('requestType', 'aircraft');  
         UserAssociationWebserviceController.getRecord();
        
        
        
        request.addParameter('requestType', 'serviceprogram'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('honeywellid', 'E23456');       //validate for wrong honeywell id 
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord(); 
        Contact c = [Select Contact_Status__c  from Contact where id=: honeywellContact.id];
        c.Contact_Status__c ='Inactive';        
        update c;
        request.addParameter('honeywellid', 'T134297');    // validate for inactive contact
        
        
        UserAssociationWebserviceController.getRecord();
        request.addParameter('requestType', 'aircraft'); 
       UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'serviceprogram'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice'); 
        UserAssociationWebserviceController.getRecord();        
        honeywellContact.Contact_Status__c ='active';
        update honeywellContact;        
        
        request.addParameter('requestType', '');        // validate for blank request type
        //RestContext.request = request;               
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraft');    //validate for wrong request type
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord();
        request.addParameter('requestType', 'serviceprogram');    //validate for wrong request type
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord();
        
        //request.addParameter('requestType', 'aircraftandservice');         
       // UserAssociationWebserviceController.getRecord();
        
        
        request.addParameter('requestType', 'aircraft12'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', ''); 
        UserAssociationWebserviceController.getRecord();
        
        
       
        
        
    }
    
    private static testMethod void testWebServices1() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        insert phi1;
        
         
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
         RestContext.request = request1;  
        RestContext.response = response1;  
        
        
        request1.addParameter('requestType', 'aircraft');    
        UserAssociationWebserviceController.getRecord();
        
       Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',Account_Name__c= honeywellContact.accountid,External_Account_ID__c='0000000000-01',Site_Code__c='123',XREF_Type__c='SAP_SOLD_TO');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
          
        request1.addParameter('requestType', 'aircraft');
        UserAssociationWebserviceController.getRecord();
         request1.addParameter('honeywellid', 'T134297');
        request1.addParameter('requestType', 'aircraftandservice');
        UserAssociationWebserviceController.getRecord();
        request1.addParameter('externalId', 'true');
                 
        UserAssociationWebserviceController.getRecord();
        request1.addParameter('requestType', 'serviceprogram');
        UserAssociationWebserviceController.getRecord();
        
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram;
        UserAssociationWebserviceController.getRecord();
       
        
        
    }
    
  
    private static testMethod void testWebServices2() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id);
        insert phi1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        //User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        //insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
         
        RestContext.request = request1;  
        RestContext.response= response1;  
        //UserAssociationWebserviceController.doPost();    //validate for empty request body
           
        JsonMsg = '{"honeywellID":"E134297"}';            // validate for wrong honeywell id
        request1.requestBody = Blob.valueof(JsonMsg);        
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297"}';        //validate for inactive user
        request1.requestBody = Blob.valueof(JsonMsg);
        honeywellContact.Contact_Status__c ='Inactive';        
        update honeywellContact;
        UserAssociationWebserviceController.doPost(); 
               
        honeywellContact.Contact_Status__c ='active';
        update honeywellContact;                    
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"test","role":"No Access","requestTypeIdList":[]}'; //validate for requesttype other than aircraft and serviceprogram
        request1.requestBody = Blob.valueof(JsonMsg);
        
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"No Access","requestTypeIdList":["'+serviceProgram.Id+'"]}'; //validate for wrong Fleet asset aircraft id
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        
        
        
    }
    
    
    
    private static testMethod void testWebServices6() 
    {
        
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id);
        insert phi;
        
       // Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id);
        //insert phi1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
         test.startTest();
        RestContext.request = request1;  
        RestContext.response= response1;  
        UserAssociationWebserviceController.doPost();    //validate for empty request body
          
          JsonMsg = '{"honeywellID":"T134297","requestType":"allaircraft","role":"Full Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost(); 
        
        //code to cover service program
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":["'+serviceProgram.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"No Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';  //validate for wrong serviceprogram id
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        test.stopTest();
        
        
       
        
    }
    private static testMethod void testWebServices3() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id);
        insert phi1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
         
        RestContext.request = request1;  
        RestContext.response= response1;  
       // UserAssociationWebserviceController.doPost();    //validate for empty request body
           
        
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"No Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';  //validate for wrong serviceprogram id
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
       
        
       
        
    }
    private static testMethod void testWebServices7() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
       // Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id);
       // insert phi;
       // Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id);
       // insert phi1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
         
        RestContext.request = request1;  
        RestContext.response= response1;  
        //UserAssociationWebserviceController.doPost();    //validate for empty request body
           
        
        
       
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":[]}'; //validate for empty Fleet Asset aircraft list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
         
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
       
        
    }
    private static testMethod void testWebServices4() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        //Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id);
        //insert phi;
        //Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id);
        //insert phi1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
         
        RestContext.request = request1;  
        RestContext.response= response1;  
        UserAssociationWebserviceController.doPost();    //validate for empty request body
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":[]}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":["'+serviceProgram.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
    }
    
    
     private static testMethod void testWebServices5() 
    {
         Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
        Test.startTest(); 
        RestContext.request = request1;  
        RestContext.response= response1;  
        UserAssociationWebserviceController.doPost();    //validate for empty request body
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":[]}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":["'+serviceProgram.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        Test.stopTest(); 
       UserAssociationWebserviceController obj =  new UserAssociationWebserviceController();
       UserAssociationWebserviceController.userRecords  obj1 = new UserAssociationWebserviceController.userRecords();
    }
    
     private static testMethod void testWebServices8() 
    {
         Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
        Test.startTest(); 
        RestContext.request = request1;  
        RestContext.response= response1;  
        UserAssociationWebserviceController.doPost();    //validate for empty request body
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":[]}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"aircraft","role":"Full Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
       
        Test.stopTest(); 
       UserAssociationWebserviceController obj =  new UserAssociationWebserviceController();
       UserAssociationWebserviceController.userRecords  obj1 = new UserAssociationWebserviceController.userRecords();
    }
    
     private static testMethod void testWebServices10() 
    {
         Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
        Test.startTest(); 
        RestContext.request = request1;  
        RestContext.response= response1;  
        UserAssociationWebserviceController.doPost();    //validate for empty request body
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":[]}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"allaircraft","role":"Full Access","requestTypeIdList":["'+fleetAsset.Id+'"]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":['+userAircraft.Id+']}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":[]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();   
        
        JsonMsg = '{"honeywellID":"T134290","requestType":"aircraft","role":"Full Access","requestTypeIdList":[]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost(); 
        
        request1.requestBody = Blob.valueof('null');
        UserAssociationWebserviceController.doPost(); 
        
        JsonMsg = '{"honeywellID":"T134290","requestType":"aircraft","hasRestriction":"test","requestTypeIdList":[12ff]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost(); 
       
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"","requestTypeIdList":[]}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        Test.stopTest(); 
       UserAssociationWebserviceController obj =  new UserAssociationWebserviceController();
       UserAssociationWebserviceController.userRecords  obj1 = new UserAssociationWebserviceController.userRecords();
    }

	private static testMethod void testWebServices11(){
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        insert phi1;
        
         Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',Account_Name__c= honeywellContact.accountid,External_Account_ID__c='0000000000-01',Site_Code__c='123',XREF_Type__c='SAP_SOLD_TO');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram;
        
        
         // code to cover getRecord method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/services/apexrest/AerospaceUserAssociationServices1';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        
        request.addParameter('honeywellid', ''); // validate for blank honeywell id 
        request.addParameter('requestType', 'aircraft');     
               
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'serviceprogram'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('honeywellid', 'E23456');       //validate for wrong honeywell id 
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord(); 
        Contact c = [Select Contact_Status__c  from Contact where id=: honeywellContact.id];
        c.Contact_Status__c ='Inactive';        
        update c;
        request.addParameter('honeywellid', '');    // validate for inactive contact
        
        
        UserAssociationWebserviceController.getRecord();
        request.addParameter('requestType', 'aircraft'); 
       UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'serviceprogram'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice'); 
        UserAssociationWebserviceController.getRecord();        
        honeywellContact.Contact_Status__c ='inactive';
        update honeywellContact;        
        
        request.addParameter('requestType', '');        // validate for blank request type
        //RestContext.request = request;               
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraft123');    //validate for wrong request type
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord();
        request.addParameter('requestType', 'serviceprogram123');    //validate for wrong request type
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', '');         
        UserAssociationWebserviceController.getRecord();
        
        
        
    }    
     private static testMethod void errorBlock(){
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        insert phi1;
        
         Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',Account_Name__c= honeywellContact.accountid,External_Account_ID__c='0000000000-01',Site_Code__c='123',XREF_Type__c='SAP_SOLD_TO');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram;
        
        
         // code to cover getRecord method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/services/apexrest/AerospaceUserAssociationServices1';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        
        request.addParameter('honeywellid', ''); // validate for blank honeywell id 
        request.addParameter('requestType', 'aircraft');     
               
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'serviceprogram'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('honeywellid', 'E23456');       //validate for wrong honeywell id 
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord(); 
        Contact c = [Select Contact_Status__c  from Contact where id=: honeywellContact.id];
        c.Contact_Status__c ='Inactive';        
        update c;
        request.addParameter('honeywellid', '');    // validate for inactive contact
        
        
        UserAssociationWebserviceController.getRecord();
        request.addParameter('requestType', 'aircraft'); 
       UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'serviceprogram'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice'); 
        UserAssociationWebserviceController.getRecord();        
        honeywellContact.Contact_Status__c ='inactive';
        update honeywellContact;        
        
        request.addParameter('requestType', '');        // validate for blank request type
        //RestContext.request = request;               
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraft123');    //validate for wrong request type
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord();
        request.addParameter('requestType', 'serviceprogram123');    //validate for wrong request type
        //RestContext.request = request;        
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', '');         
        UserAssociationWebserviceController.getRecord();
        
        
        
    }
  /*  private static testMethod void errorBlockPostMethod(){
         test.startTest(); 
       Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id);
        insert phi1;
        Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',External_Account_ID__c='0000047309-01',Site_Code__c='123');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
        insert fleetAsset;
          
        
        Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
        Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
        List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
        fleetxRefList.add(fleetxref1);
        fleetxRefList.add(fleetxref2);
        insert fleetxRefList;
        
        User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram; 
         //code to cover doPost method
        String JsonMsg = '{}';
        RestRequest request1 = new RestRequest(); 
        RestResponse response1 = new RestResponse();
        request1.requestURI = '/services/apexrest/AerospaceUserAssociationServices';  //Request URL
        request1.httpMethod = 'POST';//HTTP Request Type
        request1.requestBody = Blob.valueof(JsonMsg);
         
        RestContext.request = request1;  
        RestContext.response= response1;  
        UserAssociationWebserviceController.doPost();    //validate for empty request body
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":[]}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
       JsonMsg = '{"honeywellID":"T134297","requestType":"specificaircraft","role":"Full Access","requestTypeIdList":['+userAircraft.Id+']}';        //validate for empty service program list
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();
        
        JsonMsg = '{"honeywellID":"T134297","requestType":"serviceprogram","role":"Full Access","requestTypeIdList":[]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost();   
        
        JsonMsg = '{"honeywellID":"T134290","requestType":"aircraft","role":"Full Access","requestTypeIdList":[]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost(); 
        
        request1.requestBody = Blob.valueof('null');
        UserAssociationWebserviceController.doPost(); 
        
        JsonMsg = '{"honeywellID":"T134290","requestType":"aircraft","hasRestriction":"test","requestTypeIdList":[12ff]}';
        request1.requestBody = Blob.valueof(JsonMsg);
        UserAssociationWebserviceController.doPost(); 
         test.stopTest();
    }
    */
    private static testMethod void errorBlock2(){
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        insert honeywellContact1;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='E23456',Contact__c=honeywellContact1.id,primary_honeywell_id__c= true);
        insert phi1;
        
         Account_Cross_Ref__c accCrossRef = new Account_Cross_Ref__c(Name='TestAccountCrossRef',Account_Name__c= honeywellContact.accountid,External_Account_ID__c='0000000000-01',Site_Code__c='123',XREF_Type__c='SAP_SOLD_TO');
        insert accCrossRef;
   
         Platform__c pltForm = new Platform__c(Name='Embraer Phenom 300');
        insert pltForm;
        
       // Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=pltForm.id);
       // insert fleetAsset;
          
        
       // Fleet_Asset_Aircraft_XRef__c fleetxref1 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='SIMS',Serial_Number__c='1234',Fleet_Asset_Detail__c=fleetAsset.Id);
       // Fleet_Asset_Aircraft_XRef__c fleetxref2 = new Fleet_Asset_Aircraft_XRef__c(External_Source_Nm__c='BMS',Serial_Number__c='12344',Fleet_Asset_Detail__c=fleetAsset.Id);
        
      //  List<Fleet_Asset_Aircraft_XRef__c> fleetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
      //  fleetxRefList.add(fleetxref1);
      //  fleetxRefList.add(fleetxref2);
      //  insert fleetxRefList;
        
        //User_Aircraft_Association__c userAircraft = new User_Aircraft_Association__c(Fleet_Asset_Aircraft_Name__c=fleetAsset.Id,User__c=honeywellContact.Id);
        //insert userAircraft;     
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        Restricted_Service_Program__c restrictedProgram = new Restricted_Service_Program__c(Master_Service_Program_Name__c=serviceProgram.Id,User__c=honeywellContact.Id);
        insert restrictedProgram;
        
        
         // code to cover getRecord method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/services/apexrest/AerospaceUserAssociationServices1';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        
        
        request.addParameter('honeywellid', 'E23456');       //validate for wrong honeywell id 
 
        UserAssociationWebserviceController.getRecord(); 
        Contact c = [Select Contact_Status__c  from Contact where id=: honeywellContact.id];
        c.Contact_Status__c ='Inactive';        
        update c;
        
        // List<Portal_Honeywell_Id__c>  portalHWContactLst = [select contact__r.Contact_Status__c,contact__r.accountid, contact__r.Access__c, contact__r.All_Aircrafts__c, contact__r.Assigned_Aircrafts__c,contact__r.Has_Restriction__c, contact__r.firstname,contact__r.lastname 
        // from portal_honeywell_id__c 
        // Where contact__r.contact_status__c = 'Active' and primary_honeywell_id__c = true and name  =:honeywellNo] ;
        /*Portal_Honeywell_Id__c p = [Select Contact_Status__c  from Portal_Honeywell_Id__c where contact__r.contact_status__c = 'Active' and primary_honeywell_id__c = true and name=: honeywellContact.id];
        p.contact__r.Contact_Status__c ='Inactive';        
        update p;
        request.addParameter('honeywellid', p.Id);    // validate for inactive contact  
        request.addParameter('requestType', 'aircraft'); 
        UserAssociationWebserviceController.getRecord();*/
        
        request.addParameter('requestType', 'aircraft12'); 
        UserAssociationWebserviceController.getRecord();
        
        request.addParameter('requestType', ''); 
        UserAssociationWebserviceController.getRecord();
       
    }
}