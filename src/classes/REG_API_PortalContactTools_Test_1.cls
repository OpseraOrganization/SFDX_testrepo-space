@IsTest

private class REG_API_PortalContactTools_Test_1
{

    @TestSetup
    static void testData() 
    { 
        //List<Contact_Tool_Access__c > conTList = new List<Contact_Tool_Access__c >(); 
        List<Account> acountList=new List<Account>();
        List<contact > conList = new List<contact >();
        List<Portal_Tools_Master__c > ptmList = new List<Portal_Tools_Master__c >();
        List<Account_Tools__c> accToolsList = new List<Account_Tools__c >();
        //List<case> caseList = new List<case>();
        
        /* boolean isEmbarConAdd = false;
boolean isSancConAdd = false;
boolean isSancAcc = false ;
boolean isEmbarAcc = false ;
boolean isSancCitizn =false;
boolean isEmbarCitizn = false;
boolean isGeneric = false;
*/
        
        List<Country__c > countryList = new List<Country__c >();
        Country__c countryval1 = new Country__c(name='India',SFDC_Country_Name__c='India',ISO_Country_Code__c='IN');
        Country__c countryval2 = new Country__c(name='Canada',SFDC_Country_Name__c='Canada',ISO_Country_Code__c='CA',isEmbargoed__c = true, isSanctioned__c =true);
        Country__c countryval3 = new Country__c(name='USA',SFDC_Country_Name__c='USA',ISO_Country_Code__c='US', isSanctioned__c =true);
        Country__c countryval4 = new Country__c(name='Australia',SFDC_Country_Name__c='Australia',ISO_Country_Code__c='AU');
        countryList.add(countryval1);
        countryList.add(countryval2);
        countryList.add(countryval3);
        countryList.add(countryval4);
        insert countryList;
        
        Portal_Access_Template__c temp = new Portal_Access_Template__c( Name ='Generic',Record_Class__c='None',Record_Code__c='None',Retention_Hold_Reason__c='test hold reason',Template_Description__c='test template desc');
        insert temp; 
        Portal_Access_Template__c temp1 = new Portal_Access_Template__c(Name ='Honeywell', Record_Class__c='None',Record_Code__c='None',Retention_Hold_Reason__c='test hold reason',Template_Description__c='test template desc');
        insert temp1;
        system.debug('temp==='+temp);
        
        Account a=new account(Name='Test Account', ATR_Portal_Access_Template__c = temp.id, Customer_Status__c='Active',Country__c=countryval2.id,Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell1 account');
        account honeywellAccount = new account(name='test_case_account',ATR_Portal_Access_Template__c = temp1.id,Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        account honeywellAccount1 = new account(name='Test Account1',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Country__c=countryval4.id,Report_Country_Name__c='Australia',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        account honeywellAccount2 = new account(name='test_revalidate_account',ATR_Portal_Access_Template__c = temp.id,Customer_Status__c='Active',Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany');
        account honeywellAccount3 = new account(name='Test Account3',ATR_Portal_Access_Template__c = temp1.id,Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='Australia',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        account honeywellAccount4 = new account(name='test_createContact',Customer_Status__c='Active',Country__c=countryval2.id,Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Aero Level',CBT__c='Intercompany',CBT_Team__c='Aero Level Other',Market_Name__c='Unknown',type='OEM',REPORT_ACCOUNT_NAME__c='test non-h account');
        acountList.add(a);
        acountList.add(honeywellAccount);
        acountList.add(honeywellAccount1);
        acountList.add(honeywellAccount2);
        acountList.add(honeywellAccount3);
        acountList.add(honeywellAccount4);
        insert acountList;
        contact honeywellContact = new contact(firstname='test',Contact_Status__c='Active',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297', country_code__c = 'IN',postal_code__c = '411057',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        contact honeywellContact1 = new contact(firstname='test1',Contact_Status__c='Active',lastname='user1',Email='testuser1@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23456' ,Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'));
        contact honeywellContact2 = new contact(firstname='test2',Contact_Status__c='Active',lastname='user1',Email='testuser2@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='E23457' ,Citizenship_Country__c = 'USA');
        contact honeywellContact3 = new contact(firstname='test3',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=a.id,Honeywell_ID__c='T134298', country_code__c = 'CA',postal_code__c = '411057',state_code__c = 'BC',Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Toronto',Country_Name__c = 'Canada');
        //contact honeywellContact4 = new contact(firstname='test4',Contact_Status__c='Active',lastname='user1',Email='testuser3@itc.com',accountid=a.id,Honeywell_ID__c='T134297', country_code__c = 'CA',postal_code__c = '411057',state_code__c = 'BC',Citizenship_Country__c = 'Canada',Contact_Birth_Country__c = 'Canada', Birth_City__c = 'Toronto', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Toronto',Country_Name__c = 'Canada');
        contact honeywellContact5 = new contact(firstname='test5',Contact_Status__c='Active',lastname='user1',Email='testuser5@honeywell.com',primary_email_address__c = 'testuser5@honeywell.com',accountid=honeywellAccount1.id,Honeywell_ID__c='T134290', country_code__c = 'AU',postal_code__c = '411057',Citizenship_Country__c = 'Australia',Contact_Birth_Country__c = 'Australia', Birth_City__c = 'Sydney', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Sydney');
        contact honeywellContact6 = new contact(firstname='test6',Contact_Status__c ='Active',lastname='user1',Email='testuser6@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134299', country_code__c = 'IN',postal_code__c = '411057',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        conList.add(honeywellContact );
        conList.add(honeywellContact1 );
        conList.add(honeywellContact2 );
        conList.add(honeywellContact3 );
        //conList.add(honeywellContact4 );
        conList.add(honeywellContact5 );
        //conList.add(honeywellContact6 );
        insert conList;
        
        contact honeywellContact7 = new contact(id=honeywellContact5.id,firstname='test5',Contact_Status__c='Inactive',lastname='user1',Email='testuser5@honeywell.com',primary_email_address__c = 'testuser5@honeywell.com',accountid=honeywellAccount1.id,Honeywell_ID__c='T134290', country_code__c = 'AU',postal_code__c = '411057',Citizenship_Country__c = 'Australia',Contact_Birth_Country__c = 'Australia', Birth_City__c = 'Sydney', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Sydney');
        update honeywellContact7;
        
        //Contact_Address__c cd1 = new Contact_Address__c(Reporting_Street_Address_Line_1__c='test',Report_Country_Codes__c='878',Reporting_City_Name__c='Active',Is_Primary_Address__c = true,Address_Status__c = 'Active',Contact__c=conList[5].id);
        //insert cd1;
        REG_Is_Generic__c isGen = new REG_Is_Generic__c(Name ='Is Generic', id__c = temp.id); 
        insert isGen;
        
        List<Account_Contact__c> accconList =new List<Account_Contact__c>();
        Account_Contact__c ac =new Account_Contact__c(Account_Name__c=a.Id,Contact__c=honeywellContact.Id);
        Account_Contact__c ac1 =new Account_Contact__c(Account_Name__c=a.Id,Contact__c=honeywellContact.Id);
        accconList.add(ac);
        accconList.add(ac1);
        insert accconList;
        system.debug('list data ***'+accconList);
        // List<Contact_Address__c>  cd= new List<Contact_Address__c>();
        //Contact_Address__c  caddress = new Contact_Address__c (Reporting_City_Name__c='test', Reporting_Street_Address_Line_1__c='test',Contact__c=honeywellContact.id,Report_Country_Codes__c='IN',Is_Primary_Address__c = true);
        //cd.add(caddress);
        //insert cd;
        Portal_Tools_Master__c ptM = new Portal_Tools_Master__c(name = 'Test', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM);
        Portal_Tools_Master__c ptM3 = new Portal_Tools_Master__c(name = 'Test3', Tool_Description__c = 'For Testing', Tool_Sort_Order__c = '04', Tool_Active__c =True, Tool_Authorization_Method__c = 'Auto Approved');
        ptmList.add(ptM3);          
        insert ptmList;       
        
        Portal_Honeywell_Id__c   phi = new Portal_Honeywell_Id__c(name='T134297',Contact__c=honeywellContact.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active' , Email_Sent_Counter__c = 5);
        insert phi;
        Portal_Honeywell_Id__c   phi1 = new Portal_Honeywell_Id__c(name='T134298',Email_Sent_Counter__c = 4,Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c = 'InActive');
        insert phi1;
        Portal_Honeywell_Id__c   phi2 = new Portal_Honeywell_Id__c(name='T134299',Email_Sent_Counter__c = 0,Contact__c=honeywellContact3.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi2;
        Portal_Honeywell_Id__c   phi3 = new Portal_Honeywell_Id__c(name='T134300',Email_Sent_Counter__c = 0,Contact__c=honeywellContact7.id,primary_honeywell_id__c= true,Portal_Status__c = 'Active');
        insert phi3;
        
        
    }
    //==============================getAccountMessage if  honid passed in header
    private static testMethod void testgetAccountMessage(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        request.addHeader('honid', 'T134297');
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
        /*String result = response.responseBody.toString();
        system.assert(String.isNotBlank(result));*/
        String result = response.responseBody.toString();
        list<REG_PortalContact_Service.REG_AccountMessage_Wrapper> wrapperResult = (list<REG_PortalContact_Service.REG_AccountMessage_Wrapper>)JSON.deserialize('['+result+']', list<REG_PortalContact_Service.REG_AccountMessage_Wrapper>.class);
        system.assert(!wrapperResult.isEmpty());
        
    }
    
    //==============================getAccountMessage if emailid passed in header
    private static testMethod void testgetAccountMessage1(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        request.addHeader('emailid', 'testuser@itc.com');
        map<String,String> reqHeader = request.headers;
        system.assert(!reqHeader.isEmpty());
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        system.assert(String.isNotBlank(result));
        
    }
    //==============================getAccountMessage if invalid emailid passed in header
    private static testMethod void testgetAccountMessage2(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        //request.addHeader('honid', 'test');
        request.addHeader('emailid', 'testuser@abc.com');
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        list<REG_PortalContact_Service.REG_AccountMessage_Wrapper> wrapperResult = (list<REG_PortalContact_Service.REG_AccountMessage_Wrapper>)JSON.deserialize('['+result+']', list<REG_PortalContact_Service.REG_AccountMessage_Wrapper>.class);
        system.assert(!wrapperResult.isEmpty());
        
    }
    //==============================getAccountMessage if no value passed in header
    private static testMethod void testgetAccountMessage3(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        request.addHeader('honid', 'ajay');
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
        
        
    }
    
    
    //==============================getAccountMessage if no value passed in header
    private static testMethod void testgetAccountMessage4(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request; 
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
        String result = response.responseBody.toString();
        system.assert(result.contains('400'));
        
    }
    
    //==============================getAccountMessage if inactive honid passed in header
    private static testMethod void testgetAccountMessage5(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        request.addHeader('honid', 'T134300');
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
         String result = response.responseBody.toString();
        system.assert(result.contains('400'));
        
    }
    //==============================getAccountMessage if inactive emailid passed in header
    private static testMethod void testgetAccountMessage6(){
        
        //code to cover getAccountMessage by honid
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/contacts/AccountMessage'; //Request URI
        //request.addHeader('honid', 'test5');
        request.addHeader('emailid', 'testuser5@honeywell.com');
        request.httpMethod = 'GET'; //http Request type
        system.assertEquals('GET', request.httpMethod);
        REG_API_PortalContactTools.doGet();
         String result = response.responseBody.toString();
        system.assert(result.contains('400'));
        
    }
    
    
}