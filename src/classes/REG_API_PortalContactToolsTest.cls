@IsTest

private class REG_API_PortalContactToolsTest 
{
    @TestSetup
    static void testData() 
    {   
        List<Contact_Tool_Access__c > conTList = new List<Contact_Tool_Access__c >();
        List<Account> acountList=new List<Account>();
        List<contact > conList = new List<contact >();
        List<Portal_Tools_Master__c > ptmList = new List<Portal_Tools_Master__c >();
        List<Account_Tools__c> accToolsList = new List<Account_Tools__c >();
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        Account a=new account(Name='Test Account');
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        acountList.add(a);
        acountList.add(honeywellAccount );
        insert acountList;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297',MobilePhone = '(975)235-8753',Phone_1__c = '(975)235-8779');
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456');
        contact honeywellContact2 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser2@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134299');
        contact honeywellContact3 = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134300');
        contact honeywellContact4 = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134301');
        contact honeywellContact5 = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134302');
        contact honeywellContact6 = new contact(firstname='testTechPub',Contact_Status__c='Active',lastname='Tech',Email='tech@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T789654');
        contact honeywellContact7 = new contact(firstname='test123',Contact_Status__c='Active',lastname='user123',Email='testuser3@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134302');
        conList.add(honeywellContact );
        conList.add(honeywellContact1 ); 
        conList.add(honeywellContact2 );
        conList.add(honeywellContact3 );
        conList.add(honeywellContact4 );
        conList.add(honeywellContact5 );
        conList.add(honeywellContact6 );
        conList.add(honeywellContact7);
        insert conList;
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='T134299',Email_Sent_Counter__c = 0,Contact__c=honeywellContact2.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi1;
        Portal_Honeywell_Id__c   phi2 = new Portal_Honeywell_Id__c(name='T134300',Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active', Email_Sent_Counter__c = 5);
        insert phi2;
        Portal_Honeywell_Id__c   phi3 = new Portal_Honeywell_Id__c(name='T134301',Contact__c=honeywellContact4.id,primary_honeywell_id__c= true,Portal_Status__c = 'Deleted');
        insert phi3;
        Portal_Honeywell_Id__c   phi4 = new Portal_Honeywell_Id__c(name='T134302',Contact__c=honeywellContact5.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi4;
        Portal_Honeywell_Id__c   phi5 = new Portal_Honeywell_Id__c(name='T134303',Contact__c=honeywellContact5.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi5;
        Portal_Honeywell_Id__c   phi6 = new Portal_Honeywell_Id__c(name='T789654',Contact__c=honeywellContact6.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi6;
        Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'Test', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM);
        Portal_Tools_Master__c ptM1 = new Portal_Tools_Master__c(name = 'Test1', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM1);
        Portal_Tools_Master__c ptM2 = new Portal_Tools_Master__c(name = 'Test2', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM2);
        Portal_Tools_Master__c ptM3 = new Portal_Tools_Master__c(name = 'Test3', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM3);
        Portal_Tools_Master__c ptM4 = new Portal_Tools_Master__c(name = 'REG Warranty and Programs', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM4);
        Portal_Tools_Master__c ptM6 = new Portal_Tools_Master__c(name = 'Technical Publications', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM6);
        insert ptmList; 
        Account_Tools__c acT = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM.Id , Account_Name__c = honeywellAccount.Id );
        accToolsList.add(acT);
        Account_Tools__c acT1 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM1.Id , Account_Name__c = honeywellAccount.Id );
        accToolsList.add(acT1);
        Account_Tools__c acT2 = new Account_Tools__c(Portal_Tool_Master_Name__c = ptM2.Id , Account_Name__c = honeywellAccount.Id );
        accToolsList.add(acT2);
        insert accToolsList;
        Contact_Tool_Access__c caT = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM.Id, name = 'Test', Portal_Honeywell_ID__c = 'T134297', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact.Id );
        Contact_Tool_Access__c caT1 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM1.Id, name = 'Test1', Portal_Honeywell_ID__c = 'T134297', Request_Status__c = 'Pending',CRM_Contact_ID__c = honeywellContact.Id );
       Contact_Tool_Access__c caT6 = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM6.Id, name = 'Test6', Portal_Honeywell_ID__c = 'T789654', Request_Status__c = 'Approved',CRM_Contact_ID__c = honeywellContact6.Id );
       
        conTList.add(caT);
        conTList.add(caT1); 
        conTList.add(caT6);
        insert conTList;
        
        
        contact con = new contact(Lastname='Dummy');
        con.Honeywell_ID__c = '456789';
        con.accountid = a.Id;
        con.contact_status__c = 'active';
        con.alternate_email_address__c = 'test@honeywell.com';
        con.attention__c = '';
        con.Honeywell_ID__C='testHonId';
        insert con;
        Account_Email_Domains__c domain=new Account_Email_Domains__c();
        domain.Account_Email_Domain__c='internal.com';
        domain.Name='Internal';
        domain.Internal_Email_Domain__c=true;
        insert domain;
        Contact_Address__c newContactAddress=new Contact_Address__c();
        newContactAddress.contact__c=con.Id ;
        newContactAddress.address_type__c='Office' ;
        newContactAddress.address_status__c='Active';
        newContactAddress.is_primary_address__c=true ;
        newContactAddress.reporting_street_address_line_1__c='Line 1';
        newContactAddress.reporting_street_address_line_2__c='Line 2';
        newContactAddress.reporting_street_address_line_3__c='Line 3';
        newContactAddress.reporting_city_name__c='City';
        newContactAddress.reporting_address_postal_code__c='400007';
        newContactAddress.reporting_country_name__c='India';
        newContactAddress.report_country_codes__c='IN';
        
        INSERT newContactAddress;
        List<Portal_Honeywell_ID__c> listOfPortalrecs=new List<Portal_Honeywell_ID__c>();
        Portal_Honeywell_ID__c portalHONrecord0=new Portal_Honeywell_ID__c();               
        portalHONrecord0.Contact__c=con.Id;
        portalHONrecord0.Name=con.Honeywell_ID__C;
        portalHONrecord0.primary_honeywell_id__c=true;
        Portal_Honeywell_ID__c portalHONrecord=new Portal_Honeywell_ID__c();
        portalHONrecord.delete_contact_id__c=con.Id;
        listOfPortalrecs.add(portalHONrecord0);         
        listOfPortalrecs.add(portalHONrecord); 
        insert listOfPortalrecs;
    }
    
    /* static testMethod void testGetToolStatus(){

// code to cover getToolStatus method      
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;
request.requestURI = '/contacts/E23456/tools';  //Request URL
request.httpMethod = 'GET';//HTTP Request Type
// request.addParameter('honid', 'E23456');
REG_API_PortalContactTools.doGet(); 
}

static testMethod void testGetToolStatusT(){

// code to cover getToolStatus method      
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
RestContext.request = request;  
RestContext.response= response;
request.requestURI = '/contacts/T134297/tools';  //Request URL
request.httpMethod = 'GET';//HTTP Request Type
// request.addParameter('honid', 'T134297');
REG_API_PortalContactTools.doGet(); 
}*/
    static testMethod void testHidNotPresent(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/H313671/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'H313671');
        Test.startTest();
        REG_API_PortalContactTools.doGet();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
    }
    /*   static testMethod void testOtherException(){

// code to cover getToolStatus method      
RestRequest request = new RestRequest(); 
RestResponse response = new RestResponse();
request.requestUri =null;
request.httpMethod = 'GET';//HTTP Request Type
//request.addParameter('honid', 'E23456');
//RestContext.request = request;  
RestContext.response= response;

REG_API_PortalContactTools.doGet(); 
}
*/
    
    static testMethod void testStringException(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/1/@H313671/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        //request.addParameter('honid', '1/@H313671');
        REG_PortalContact_Service.GetAccountId('h3456');
        //REG_API_PortalContactTools.doGet();
        
    }
    
    static testMethod void testGetToolStatusSecnario1(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/contacts/T134297/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'T134297');
        RestContext.request = request;  
        RestContext.response= response;
        //REG_PortalContact_Service.GetAccountId('h3456');
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize(result, List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
        
    }    //E23456
    
    static testMethod void testGetToolStatusSecnario2(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/contacts/E23456/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        //request.addParameter('honid', 'E23456');
        RestContext.request = request;  
        RestContext.response= response;
        //REG_PortalContact_Service.GetAccountId('h3456');
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    } 
    
    static testMethod void testGetToolStatusSecnario3(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/contacts/Random/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'Random');
        RestContext.request = request;  
        RestContext.response= response;
        //REG_PortalContact_Service.GetAccountId('h3456');
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());        
    } 
    static testMethod void testSoqlException(){
        
        // code to cover getToolStatus method  
        List<Contact> lst=[SELECT Id FROM Contact LIMIT 2 FOR UPDATE];    
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/T134297/tools';  //Request URL
        // request.addParameter('honid', 'T134297');
        request.httpMethod = 'GET';//HTTP Request Type
        REG_API_PortalContactTools.doGet();
        
    }
    
    static testMethod void testSpecificTool(){
        
        // code to cover getToolStatus method  
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test1' limit 1];
        //system.debug('****ptM1.id'+ptM1.id);
        request.requestURI = '/contacts/T134297/tools/'+pRecord.Id;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'T134297');
        //request.addParameter('toolid', pRecord.Id);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
        
    }
    
    public static testMethod void testSpecificTool2(){
        
        // code to cover getToolStatus method  
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test2' limit 1];
        request.requestURI = '/contacts/T134297/tools/'+pRecord.Id;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'T134297');
        // request.addParameter('toolid', pRecord.Id);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
        
    }
    public static testMethod void testSpecificTool3(){
        
        // code to cover getToolStatus method  
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        request.requestURI = '/contacts/T134297/tools/'+pRecord.Id;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        //request.addParameter('honid', 'T134297');
        // request.addParameter('toolid', pRecord.Id);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
        
        
    }
    public static testMethod void testSpecificTool4(){
        
        // code to cover getToolStatus method  
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        request.requestURI = '/contacts/h313671/tools/'+pRecord.Id;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'h313671');
        //  request.addParameter('toolid', pRecord.Id);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
        
        
    }
    public static testMethod void testSpecificTool5(){
        
        // code to cover getToolStatus method  
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        request.requestURI = '/contacts/h313671/tools/a0Gm0000002gryqEAA';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', 'h313671');
        //  request.addParameter('toolid', pRecord.Id);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
        
        
    }    
    
    static testMethod void testSpecificToolNegative(){
        
        // code to cover getToolStatus method  
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/tools/';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        // request.addParameter('honid', '');
        //  request.addParameter('toolid', '');
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('error'));
        
    }
    
    private static testMethod void testGetContactDetail(){
        
        // code to cover getContactDetail method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/E23456';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        //request.addParameter('honId', 'E23456');
        REG_API_PortalContactTools.doGet(); 
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    
    
    private static testMethod void testGetAllActiveTools(){
        
        // code to cover getAllActiveTools method    
        Test.startTest();
        list<Portal_Tools_Master__c> results = [SELECT Id,Name,Lanch_URL__c,Tool_Image__c,Tool_Sort_Order__c,Tool_Authorization_Method__c,Auto_approve__c,
                                                SendAlerts_Delete_HonId__c,Admin_Email__c 
                                                FROM Portal_Tools_Master__c WHERE Tool_Active__c = true 
                                               ];  
        for(Portal_Tools_Master__c ptm:results ){
            ptm.Tool_Active__c =false;
        }
        update results;
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        REG_API_PortalToolMaster.doGet();
        Test.stopTest(); 
    }
    private static testMethod void testGetAllActiveTools1(){
        
        // code to cover getAllActiveTools method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/tools';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        REG_API_PortalToolMaster.doGet(); 
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize(result, List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    
    private static testMethod void testGetContactByEmail(){
        
        //code to cover GetContactByEmail method
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/contact-match'; //Request URI
        request.addHeader('emailid', 'testuser@itc.com');
        request.httpMethod = 'GET'; //http Request type
        REG_API_PortalContactTools.doGet();
        
    }
    
    private static testMethod void testUpdateSpecificTool(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts/T134297/tools/ptM.Id';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        
        request.requestBody=Blob.valueOf('{"contactToolAccess":{},"caseComments":"Test1","caseAddInfo":"Test2"}'); 
        
        RestContext.request = request;       
        RestContext.response= response;
        
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();    
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
    
    @isTest
    public static void testDoPost(){
        Account a=[SELECT ID FROM Account WHERE name='test_case_account' LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"AccountId": "'+a.Id+'","Honeywell_ID__c": "testClassHonId","lastName": "test",'+
                                         
                                         '"FirstName":"User","Email":"xyz@abc.com","Job_Title__c":"Engineer","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
        
    }
    @isTest
    public static void testDoPostCheckHonId(){
        Account a=[SELECT ID FROM Account LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        contact c=[select id from contact where Honeywell_ID__c='T134302' limit 1];
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name FROM Portal_Honeywell_ID__c where Name = 'T134302' and Contact__c = :c.Id];
        
        request.requestBody=Blob.valueOf('{"AccountId": "'+a.Id+'","Honeywell_ID__c": "'+portDetails[0].Name+'","lastName": "test",'+
                                         
                                         '"FirstName":"User","Email":"xyz@abc.com","Job_Title__c":"Engineer","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN"}');
        
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
        
    }
    @isTest
    public static void testDoPostWithContactId(){
        Test.startTest();
        Account a=[SELECT ID FROM Account LIMIT 1];
        Contact c=[SELECT ID FROM Contact Limit 1];
        //Portal_Honeywell_Id__c   phi = [select ID FROM Portal_Honeywell_Id__c WHERE contact__c = c.id];
        List<SAP_Contact_Sold_To__c> soldToList = new List<SAP_Contact_Sold_To__c>();
        SAP_Contact_Sold_To__c sapConSoldTo1 = new SAP_Contact_Sold_To__c();
        sapConSoldTo1.Name = 'Test sold to contact';
        sapConSoldTo1.Contact__c = c.Id;
        sapConSoldTo1.Record_Data_Owner__c = c.Id;
        sapConSoldTo1.SAP_Account_Sold_To__c = 'A120978';
        sapConSoldTo1.soldToToolAccess__c = 'ordersReturns';
        soldToList.add(sapConSoldTo1);
        insert soldToList;
        Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'REG Warranty and Programs_1', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved',Admin_Email__c = 'hemant321@gmail.com',SendAlerts_Delete_HonId__c = true);
        insert PTM;
        Contact_Tool_Access__c caT = new Contact_Tool_Access__c(Portal_Tool_Master__c= ptM.Id , MCORE_Account_Type__c = 'test',Manager_Name__c = 'test', MCORE_Purpose_of_MCORE_Access__c = 'test',name = 'REG MCORE',Portal_Honeywell_ID__c = 'T134297',  Request_Status__c = 'Approved',CRM_Contact_ID__c = c.Id);
        insert caT;
        Account_Contact__c accCon = new Account_Contact__c(Account_Name__c = a.id , Contact__c = c.id);
        insert accCon;
        
        RestRequest request = new RestRequest();
        request.requestUri ='/contacts';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"Id":"'+c.ID+'","AccountId": "'+a.Id+'","Honeywell_ID__c": "testHonId","lastName": "test",'+
                                         
                                         '"FirstName":"User","Email":"xyz@internal.com","Job_Title__c":"Engineer","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN"}');
        RestContext.request = request;       
        RestContext.response=new RestResponse();
        
        
        REG_API_PortalContactTools.doPost();
        system.assertEquals('hemant321@gmail.com', PTM.Admin_Email__c);
        Test.stopTest();
        
        
        
    }
    @isTest
    public static void testDoPostMandatoryFieldsError(){
        Account a=[SELECT ID FROM Account LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"AccountId": "'+a.Id+'","Honeywell_ID__c": "testClassHonId",'+
                                         
                                         '"FirstName":"User","Email":"xyz@abc.com","Job_Title__c":"Engineer","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
        
    }
    @isTest
    public static void testDoPostJSONError(){
        Account a=[SELECT ID FROM Account LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"AccountId": "'+a.Id+'","Honeywell_ID__c": "testClassHonId",'+
                                         
                                         '"FirstName":"User","Email":"xyz@abc.com","Job_Title__c":"Engineer","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN');
        RestContext.request = request;       
        RestContext.response= response;
        
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
        
    }
    @isTest
    public static void testDoPostWithoutAccountId(){
        Test.startTest();
        Account a=[SELECT ID FROM Account LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/contacts';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"Honeywell_ID__c": "testClassHonId","lastName": "test",'+
                                         
                                         '"FirstName":"User","Email":"xyz@abc.com","Job_Title__c":"Engineer","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
        
        
    }
    
    /////////////////////////////////////UPDATE Contact Start/////////////////////////////////////////////////////////
    
    @isTest
    public static void testContactUpdateDoPut(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts/testHonId';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"lastName": "test",'+ '"Phone_1__c":"+1 1234567890","Phone_5__c":"+1 1234567890","mobilePhone":"+1 1234567890",'+
                                         
                                         '"FirstName":"User","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Mumbai","Postal_Code__c":"400012","State_Code__c":"MH","Country_Name__c":"India","Country_Code__c":"IN"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('Successfully Updated'));
        
    }
    @isTest
    public static void testContactUpdateDoPutUS(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts/testHonId';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"lastName": "test",'+
                                         
                                         '"FirstName":"User","Address_Line_1__c":"Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Phoenix","Postal_Code__c":"400012","State_Code__c":"TX","Country_Name__c":"United States","Country_Code__c":"US"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('Successfully Updated'));
        
        
    }
    @isTest
    public static void testContactUpdateDoPutJSONError(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts/testHonId';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"lastName": "test", Address YP","Address_Line_2__c":"test Address 2","Address_Line_3__c":"test Address 3",'
                                         +'"City_Name__c":"Phoenix","Postal_Code__c":"400012","State_Code__c":"TX","Country_Name__c":"United States","Country_Code__c":"US"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
        
    }
    @isTest
    public static void testContactUpdateDoPutEmptyBodt(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts/testHonId';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{  }');
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('error'));
        
    }
    @isTest
    public static void testContactUpdateDoPutURIIncorrect(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts////';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{  }');
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('error'));
        
    }
    @isTest
    public static void testContactUpdateDoPutMandatoryError(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        Test.startTest();
        request.requestUri ='/contacts/testHonId';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody=Blob.valueOf('{"lastName": "test", Address YP","Address_Line_1__c":"test Address 2","Address_Line_3__c":"test Address 3"}');
        RestContext.request = request;       
        RestContext.response= response;
        
        REG_API_PortalContactTools.doPut();
        Test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('error'));
        
        
    }
    
    /////////////////////////////////////UPDATE Contact End/////////////////////////////////////////////////////////
    
    @isTest
    public static void testChkToolStstus(){
        Portal_Tools_Master__c pRecord = [select id from Portal_Tools_Master__c where name = 'Test3' limit 1];
        // request.requestURI = '/contacts/T134297/tools/'+pRecord.Id;  //Request URL
        REG_PortalToolAccess_Service.chkToolStatus('T134297',pRecord.Id);
    }
    
    //method to cover no hondId  
    static testMethod void testRevalidate(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/contacts//revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody = blob.valueOf(JSON.serialize(jsonObj));
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('400'));
    }
    static testMethod void testRevalidate2(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        test.startTest();
        RestContext.request = request;
        RestContext.response= response;
        request.requestURI = '/contacts/T134299/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.incrementCounter ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134299'];
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134299' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    
    static testMethod void testRevalidate3(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        test.startTest();
        RestContext.request = request;
        RestContext.response= response;
        request.requestURI = '/contacts/T134300/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134300' limit 1];
        //system.assert(c.id != '');
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134300' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    static testMethod void testRevalidate4(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        test.startTest();
        RestContext.request = request;
        RestContext.response= response;
        request.requestURI = '/contacts/T134301/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.incrementCounter ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134301' limit 1];
        //system.assert(c.id != '');
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134301' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    static testMethod void testRevalidate5(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        test.startTest();
        RestContext.request = request;
        RestContext.response= response;
        request.requestURI = '/contacts/T134302/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.incrementCounter ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134302' limit 1];
        //system.assert(c.id != '');
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134302' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    static testMethod void testRevalidate6(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        test.startTest();
        RestContext.request = request;
        RestContext.response= response;
        request.requestURI = '/contacts/jhjhjhv/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        //contact c=[select id from contact where Honeywell_ID__c='jhjhjhv' limit 1];
        //system.assert(c.id != '');
        //list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'jhjhjhv' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
    static testMethod void testRevalidate7(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        test.startTest();
        RestContext.request = request;
        RestContext.response= response;
        request.requestURI = '/contacts/T134300/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134300' limit 1];
        c.Contact_Status__c = 'Inactive';
        update c;
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134300' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
    //for portal status deleted
    static testMethod void testRevalidate8(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/contacts/T134301/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134301' limit 1];
        //system.assert(c.id != '');
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134301' and Contact__c = :c.Id];
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
        
    }
    
    static testMethod void testRevalidate9(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/contacts/T134301/revalidate';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        REG_API_PortalContactTools.revalidateWrapper jsonObj = new REG_API_PortalContactTools.revalidateWrapper();
        jsonObj.revalidate ='y';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        contact c=[select id from contact where Honeywell_ID__c='T134301' limit 1];
        
        list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c FROM Portal_Honeywell_ID__c where Name = 'T134301' and Contact__c = :c.Id];
        portDetails[0].Email_Sent_Counter__c = null;
        portDetails[0].Portal_Status__c = 'Active';
        update portDetails;
        
        REG_API_PortalContactTools.doPost();
        test.stopTest();
    }
    
    static testMethod void testupdateToolAccess(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        Test.startTest();
        Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
        request.requestUri ='/contacts/T134297/tools/'+ pRecord5.Id +'/update-status';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_PortalContactTools.toolAccessClass jsonObj = new REG_API_PortalContactTools.toolAccessClass();
        List<account> accId =[select id from account where name = 'Test Account'];
        contact c = [select id from contact limit 1]; 
        jsonObj.contactId =c.id;
        //contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        jsonObj.status='junk';
        
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
    }
    
    static testMethod void testupdateToolAccess1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        Test.startTest();
        Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
        request.requestUri ='/contacts/T134297/tools//update-status';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_PortalContactTools.toolAccessClass jsonObj = new REG_API_PortalContactTools.toolAccessClass();
        List<account> accId =[select id from account where name = 'Test Account'];
        jsonObj.contactId ='003m0000018F57a';
        //contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        jsonObj.status='Approved';
        
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
    }
    static testMethod void testupdateToolAccess3(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        Test.startTest();
        Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
        request.requestUri ='/contacts//tools/'+ pRecord5.Id +'/update-status';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_PortalContactTools.toolAccessClass jsonObj = new REG_API_PortalContactTools.toolAccessClass();
        List<account> accId =[select id from account where name = 'Test Account'];
        jsonObj.contactId ='003m0000018F57a';
        //contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        jsonObj.status='Approved';
        
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
    }
    static testMethod void testupdateToolAccess4(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        Test.startTest();
        Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
        request.requestUri ='/contacts/T134297/tools/'+ pRecord5.Id +'/update-statusssss';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_PortalContactTools.toolAccessClass jsonObj = new REG_API_PortalContactTools.toolAccessClass();
        List<account> accId =[select id from account where name = 'Test Account'];
        jsonObj.contactId ='003m0000018F57a';
        //contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        jsonObj.status='Approved';
        
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj));
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        List<REG_ToolWrapper> toolList = (List<REG_ToolWrapper>)JSON.deserialize('['+result+']', List<REG_ToolWrapper>.class);
        System.assert(!toolList.isEmpty());
    }
    static testMethod void testupdateToolAccess5(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;   
        Test.startTest();
        Portal_Tools_Master__c pRecord5 = [select id from Portal_Tools_Master__c where name = 'REG Warranty and Programs' limit 1];
        request.requestUri ='/contacts/T134297/tools/'+ pRecord5.Id +'/update-status';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_PortalContactTools.toolAccessClass jsonObj = new REG_API_PortalContactTools.toolAccessClass();
        List<account> accId =[select id from account where name = 'Test Account'];
        jsonObj.contactId ='003m0000018F57a';
        //contact con = [SELECT id, Name, firstname,Contact_Status__c, lastname,Email,accountid,Honeywell_ID__c FROM Contact where firstname = 'test' LIMIT 1];
        jsonObj.status='Approved';
        
        request.requestBody=Blob.valueOf('');
        
        REG_API_PortalContactTools.doPost();
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('error'));
        
    }
    
}