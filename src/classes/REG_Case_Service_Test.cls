@isTest
public class REG_Case_Service_Test {
    
    @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecordsForCase();        
    } 
    
   /* @TestSetup
    static void testData() 
    { 
        List<contact > conList = new List<contact >();
        List<case > caseList = new List<case >();
        List<SitecoreCaseType__c > customsettingList = new List<SitecoreCaseType__c >();
        List<Supported_Products__c > spList = new List<Supported_Products__c >();
        List<Platform__c > pfList = new List<Platform__c >();
         List<Service_Request__c > srList = new List<Service_Request__c >();
        
        SitecoreCaseType__c sc = new SitecoreCaseType__c(Name='WebsiteIssues/Registrationtoolaccess',Subject__c='MyAerospace Request Copy of Invoice');
        SitecoreCaseType__c sc1 = new SitecoreCaseType__c(Name='test',Case_Type__c='Services-AOG',Case_Record_Type__c='01230000000Zen1AAC',Origin__c='web',Subject__c='MyAerospace Request Copy of Invoice1');
        SitecoreCaseType__c sc3 = new SitecoreCaseType__c(Name='test1',Case_Type__c='Orders',Origin__c='web',Subject__c='MyAerospace Sending Payment');
        SitecoreCaseType__c sc2 = new SitecoreCaseType__c(Name='Global Customer Committee SR',Case_Record_Type__c='01230000000Zen1AAC',Subject__c=label.MyAerospace_Warranty_Credit_Request );
        SitecoreCaseType__c sc4 = new SitecoreCaseType__c(Name='WebsiteIssues/Registrationtoolaccess1',Case_Type__c='Global Customer Committee',Case_Record_Type__c='01230000000Zen1AAC',Subject__c=label.MyAerospace_Warranty_Credit_Request);
        customsettingList.add(sc);
        customsettingList.add(sc1);
        customsettingList.add(sc2);
        customsettingList.add(sc3);
        customsettingList.add(sc4);
        insert customsettingList;
        
        Supported_Products__c sp = new Supported_Products__c(Name='Tst',Product_Type__c='Yes',Status__c ='Active');
        spList.add(sp);
        insert spList;
        Platform__c pf = new Platform__c(Name='Tst',Make__c='Yes',Model__c='Active');
        pfList.add(pf);
        insert pfList;
        
        //service request
         Service_Request__c sr = new Service_Request__c(EmailId__c='amit.kate2@honeywell.com',Subject__c='test',Problem_Description__c='description');
        srList.add(sr);
        insert srList;
        
        Account a=new account(Name='Test Account',  Customer_Status__c='Active',Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell1 account');
        insert a;
        contact honeywellContact = new contact(firstname='test',accountid=a.Id,Contact_Status__c='Active',lastname='user1',Primary_Email_Address__c='testuser@itc.com',Email='testuser@itc.com',Honeywell_ID__c='T134297', country_code__c = 'IN',Postal_Code__c='10010',Job_Title__c ='ABC',state_code__c = 'MA',Citizenship_Country__c = 'India',Contact_Birth_Country__c = 'India', Birth_City__c = 'Pune', Permanent_Resident_Expiration_Date__c = date.valueof('2019-09-01'),Address_Line_1__c = 'wakad',Address_Line_2__c = 'dutt mandir', City_Name__c = 'Pune');
        contact honeywellContact1=new contact(LastName='test',email='test@test.com',Primary_Email_Address__c='test@test.com',Phone_1__c='1234567890',Address_Line_1__c='test',Address_Line_2__c='test',City_Name__c='test',State_Code__c='12',Country_Name__c='test',Postal_Code__c='565',accountid=a.id,Honeywell_ID__c='T134297');
         contact honeywellContact2=new contact(LastName='test2',email='test2@test.com',Primary_Email_Address__c='test2@test.com',Phone_1__c='1234567890',Address_Line_1__c='test',Address_Line_2__c='test',City_Name__c='test',State_Code__c='12',Country_Name__c='test',Postal_Code__c='565',accountid=a.id,Honeywell_ID__c='T1342982');
        conList.add(honeywellContact);        
        conList.add(honeywellContact1);        
        conList.add(honeywellContact2);        
        insert conList;
        case cas = new case(Honeywell_ID__c = 'T134297',Address_Line_1__c='',Address_Line_2__c='',City_Name__c='',State_Code__c='',Country_Name__c='',Postal_Code__c='',accountid=a.id, contactId =honeywellContact.id, subject = 'MyAerospace Request Copy of Invoice' );  
        caseList.add(cas);
        insert caseList;
    }
    */
    //Get Method
    static testMethod void testgetCasePickListVlaues(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/portal-case/picklist/GovernmentComplianceContent';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        Test.startTest();
        REG_API_Case.doGet();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
        //List<CaseData> puList = (List<CaseData>)JSON.deserialize(result, List<CaseData>.class);
        //System.assert(!puList.isEmpty());
    }
    static testMethod void testgetCasePickListVlauesCatchBlk(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/portal-case/picklist/producttype';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        Test.startTest();
        REG_API_Case.doGet();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testgetCasePickListVlaues1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/portal-case/GovernmentComplianceContent';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        Test.startTest();
        REG_API_Case.doGet();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }   
    
    //Post method
    static testMethod void testcheckcreatecase7(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        request.requestBody=Blob.valueOf(JSON.serialize('[]'));
        Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testcheckcreatecase(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        request.requestBody=Blob.valueOf(JSON.serialize('jsonObj1'));
        Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
    }
    static testMethod void testcheckcreatecase1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case/test';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1));
        Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
        //String result = response.responseBody.toString();
        //System.assert(result.contains('success'));
    }
    static testMethod void testcheckcreatecasejsonexceptionPost(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json'); 
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        request.requestBody=Blob.valueOf('{"formName":"WebsiteIssues/Registrationtoolaccess","caseAddInfo":"Test2"}');        
        REG_API_Case.doPost();
        Test.stopTest();
    }
    static testMethod void testcheckcreatecaseInvalidFormName(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        jsonObj1.FormName='EmailAddressUpdate123';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1));         
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
        static testMethod void testcheckcreatecaseOustsidePurchaseFormName(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        jsonObj1.FormName='OutSidePurchaseRequest';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1));         
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    
    static testMethod void testcheckcreatecaseserviceapareorderType(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test1' Limit 1];
        jsonObj1.FormName= 'test1';
        jsonObj1.DESCRIPTION='Other';
        jsonObj1.OrderType = 'Spares';
        //jsonObj1.Subject == 'MyAerospace Sending Payment';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        
        REG_API_Case.doPost();
        Test.stopTest();
    }
    static testMethod void testcheckcreatecaseserviceAoGFormName(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test1' Limit 1];
        jsonObj1.FormName= 'test1';
        List<contact> con = [select id from contact where email=:'test@test.com'];
        jsonObj1.ContactId=con[0].id;
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        //update cas;
        system.assert(cas[0].type=='Orders');        
        List<Supported_Products__c> sp=[SELECT Name,Product_Type__c FROM Supported_Products__c Limit 1];
        jsonObj1.ProductType= sp[0].Name;
        List<Platform__c > pf=[SELECT id,Name,Make__c,Model__c FROM Platform__c Limit 1];
        jsonObj1.AircraftMake= pf[0].Name;
        jsonObj1.AircraftModel= pf[0].Name;
        jsonObj1.DESCRIPTION='Other';
        jsonObj1.OrderType = 'Services';
        jsonObj1.LaborTime='11.02'; 
        jsonObj1.LaborRate='1';
        jsonObj1.LaborCharges='1';
        jsonObj1.AmountofMaterialClaim='1';
        jsonObj1.AmountofFreightClaim='1';
        jsonObj1.AmountofTotalClaim='1';
        jsonObj1.Subject= 'MyAerospace Request Copy of Invoice';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        //Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testcheckcreatecaseserviceAoGFormName1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test' Limit 1];
        jsonObj1.FormName= 'test';
        jsonObj1.TYPE=c.Case_Type__c;
        jsonObj1.OrderType = 'Services1';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
       // Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testcheckcreatecasesFormNameBlnk(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        jsonObj1.FormName= '';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
    }
    
    static testMethod void testcheckcreatecaseserviceAoGFormName4(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test' Limit 1];
        jsonObj1.FormName= 'test';
        List<contact> con = [select id from contact where email=:'test@test.com'];
        jsonObj1.ContactId=con[0].id;
        //system.assert(jsonObj2.ContactId != null);
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;
        system.assert(cas[0].type=='Orders');        
        List<Supported_Products__c> sp=[SELECT Name,Product_Type__c FROM Supported_Products__c Limit 1];
        jsonObj1.ProductType= sp[0].Name;
        List<Platform__c > pf=[SELECT id,Name,Make__c,Model__c FROM Platform__c Limit 1];
        jsonObj1.AircraftMake= pf[0].Name;
        jsonObj1.AircraftModel= pf[0].Name;
        
        jsonObj1.DESCRIPTION='Type of Product: Electrical';
        jsonObj1.OrderType = 'Services';
        // jsonObj1.DateofFailure='19/05/2019';
        jsonObj1.LaborTime='11.02'; 
        jsonObj1.LaborRate='1';
        jsonObj1.LaborCharges='1';
        jsonObj1.AmountofMaterialClaim='1';
        jsonObj1.AmountofFreightClaim='1';
        jsonObj1.AmountofTotalClaim='1';
        jsonObj1.Subject= 'MyAerospace Request Copy of Invoice';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        //Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testcheckcreatecaseserviceAoGFormName8(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test' Limit 1];
        jsonObj1.FormName= 'test';
        List<contact> con = [select id from contact where email=:'test@test.com'];
        jsonObj1.ContactId=con[0].id;
        //system.assert(jsonObj2.ContactId != null);
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;
        system.assert(cas[0].type=='Orders');        
        List<Supported_Products__c> sp=[SELECT Name,Product_Type__c FROM Supported_Products__c Limit 1];
        jsonObj1.ProductType= sp[0].Name;
        List<Platform__c > pf=[SELECT id,Name,Make__c,Model__c FROM Platform__c where Make__c='Yes' and Model__c='Active' Limit 1];
        jsonObj1.AircraftMake= pf[0].Name;
        jsonObj1.AircraftModel= pf[0].Name;
        
        jsonObj1.DESCRIPTION='Type of Product: Mechanical';
        jsonObj1.OrderType = 'Services';
        jsonObj1.DateofFailure='2019-04-30';
        jsonObj1.LaborTime='11.02'; 
        jsonObj1.LaborRate='1';
        jsonObj1.LaborCharges='1';
        jsonObj1.AmountofMaterialClaim='1';
        jsonObj1.AmountofFreightClaim='1';
        jsonObj1.AmountofTotalClaim='1';
        jsonObj1.Subject= 'MyAerospace Request Copy of Invoice';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        //Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testcheckcreatecaseBKking(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test' Limit 1];
        jsonObj1.FormName= 'test';
        List<contact> con = [select id from contact where email=:'test@test.com'];
        jsonObj1.ContactId=con[0].id;
        //system.assert(jsonObj2.ContactId != null);
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;
        system.assert(cas[0].type=='Orders');        
        List<Supported_Products__c> sp=[SELECT Name,Product_Type__c FROM Supported_Products__c Limit 1];
        jsonObj1.ProductType= sp[0].Name;
        List<Platform__c > pf=[SELECT id,Name,Make__c,Model__c FROM Platform__c Limit 1];
        jsonObj1.AircraftMake= pf[0].Name;
        jsonObj1.AircraftModel= pf[0].Name;
        
        jsonObj1.DESCRIPTION='Type of Product: Bendix King';
        jsonObj1.OrderType = 'Services';
        jsonObj1.DateofFailure='2019-04-30';
        jsonObj1.LaborTime='11.02'; 
        jsonObj1.LaborRate='1';
        jsonObj1.LaborCharges='1';
        jsonObj1.AmountofMaterialClaim='1';
        jsonObj1.AmountofFreightClaim='1';
        jsonObj1.AmountofTotalClaim='1';
        jsonObj1.Subject= 'MyAerospace Request Copy of Invoice';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        //Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    static testMethod void testcheckcreatecaseserviceAoGFormName7(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'test' Limit 1];
        jsonObj1.FormName= 'test';
        List<contact> con = [select id from contact where email=:'test@test.com'];
        //jsonObj1.ContactId=con[0].id;
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;
        system.assert(cas[0].type=='Orders');        
        List<Supported_Products__c> sp=[SELECT Name,Product_Type__c FROM Supported_Products__c Limit 1];
        jsonObj1.ProductType= sp[0].Name;
        List<Platform__c > pf=[SELECT id,Name,Make__c,Model__c FROM Platform__c Limit 1];
        jsonObj1.AircraftMake= pf[0].Name;
        jsonObj1.AircraftModel= pf[0].Name;
        jsonObj1.DESCRIPTION='Type of Product: Not Listed';
        jsonObj1.OrderType = 'Services';
        jsonObj1.LaborTime='11.02'; 
        jsonObj1.LaborRate='1';
        jsonObj1.DateofFailure='2019-04-30';
        jsonObj1.LaborCharges='1';
        jsonObj1.AmountofMaterialClaim='1';
        jsonObj1.AmountofFreightClaim='1';
        jsonObj1.AmountofTotalClaim='1';
        jsonObj1.Subject= 'MyAerospace Request Copy of Invoice';        
        List<REG_API_Case.PARTPRODUCTDETAILS> part = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        List<REG_API_Case.Attachmentlist> attachList  = new List<REG_API_Case.Attachmentlist>();
        REG_API_Case.Attachmentlist Attachments = new REG_API_Case.Attachmentlist();
        Attachments.AttFileName = 'SomeFile.txt';
        Attachments.AttContentType = 'text/plain';
        Attachments.AttBody = 'dGVzdA==';
        attachList.add(Attachments);
        jsonObj1.Attachments = attachList;
        
         List<REG_API_Case.PARTPRODUCTDETAILS> partList  = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        REG_API_Case.PARTPRODUCTDETAILS PARTPRODUCT = new REG_API_Case.PARTPRODUCTDETAILS();
        PARTPRODUCT.PartNumber = '12AB';
        PARTPRODUCT.ProductNumber = '12AB';
        PARTPRODUCT.CageCode = '12AB';
        PARTPRODUCT.Quantity = '2';
        PARTPRODUCT.DateNeeded = '2019-04-30';
        PARTPRODUCT.NetPrice = '100';
        partList.add(PARTPRODUCT);
        jsonObj1.PARTPRODUCT = partList;
        
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    } 
    //insert case
    static testMethod void testcheckcreatecaseserviceInsertCase(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        Test.startTest();
        List<contact> con = [select id from contact where email=:'test@test.com'];
        account accId=new account(name='testAcc123');
        insert accId;
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'Global Customer Committee SR' Limit 1];         
        // RecordType theRecordType = [SELECT Id,Name  FROM RecordType where Name = 'General' and SobjectType = 'case' Limit 1];
        jsonObj1.FormName= c.Name;
        jsonObj1.ContactId=con[0].id;
        jsonObj1.AccountId=accId.Id;
        jsonObj1.OrderType = 'Services12';
        jsonObj1.DESCRIPTION='Process/Services Affected';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        cas[0].Subject = 'MyAerospace Sending Payment';
        update cas;
        //List<Service_Request__c> srq = [select id,Case_Number__c from Service_Request__c limit 1];
        //srq[0].Case_Number__c = cas[0].id;
        //update srq;
        List<REG_API_Case.Attachmentlist> attachList  = new List<REG_API_Case.Attachmentlist>();
        REG_API_Case.Attachmentlist Attachments = new REG_API_Case.Attachmentlist();
        Attachments.AttFileName = 'SomeFile.txt';
        Attachments.AttContentType = 'text/plain';
        Attachments.AttBody = 'dGVzdA==';
        attachList.add(Attachments);
        jsonObj1.Attachments = attachList;
        
        List<REG_API_Case.PARTPRODUCTDETAILS> partList  = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        REG_API_Case.PARTPRODUCTDETAILS PARTPRODUCT = new REG_API_Case.PARTPRODUCTDETAILS();
        PARTPRODUCT.PartNumber = '12AB';
        PARTPRODUCT.ProductNumber = '12AB';
        PARTPRODUCT.CageCode = '12AB';
        PARTPRODUCT.Quantity = '2';
        PARTPRODUCT.DateNeeded = '2019-04-30';
        PARTPRODUCT.NetPrice = '100';
        partList.add(PARTPRODUCT);
        jsonObj1.PARTPRODUCT = partList;
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1));
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    
    static testMethod void testcheckcreatecaseserviceInsertCaseServiceRequestChng(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        Test.startTest();
        List<contact> con = [select id from contact where email=:'test@test.com'];
        account accId=new account(name='testAcc123');
        insert accId;
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'Global Customer Committee SR' Limit 1];         
        // RecordType theRecordType = [SELECT Id,Name  FROM RecordType where Name = 'General' and SobjectType = 'case' Limit 1];
        jsonObj1.FormName= c.Name;
        jsonObj1.ContactId=con[0].id;
        jsonObj1.AccountId=accId.Id;
        jsonObj1.OrderType = 'Services12';
        jsonObj1.DESCRIPTION='Proposed Solution / Criteria to close:123';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;
        system.assert(cas[0].type=='Orders'); 
        List<REG_API_Case.Attachmentlist> attachList  = new List<REG_API_Case.Attachmentlist>();
        REG_API_Case.Attachmentlist Attachments = new REG_API_Case.Attachmentlist();
        Attachments.AttFileName = 'SomeFile.txt';
        Attachments.AttContentType = 'text/plain';
        Attachments.AttBody = 'dGVzdA==';
        attachList.add(Attachments);
        jsonObj1.Attachments = attachList;
        
        List<REG_API_Case.PARTPRODUCTDETAILS> partList  = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        REG_API_Case.PARTPRODUCTDETAILS PARTPRODUCT = new REG_API_Case.PARTPRODUCTDETAILS();
        PARTPRODUCT.PartNumber = '12AB';
        PARTPRODUCT.ProductNumber = '12AB';
        PARTPRODUCT.CageCode = '12AB';
        PARTPRODUCT.Quantity = '2';
        PARTPRODUCT.DateNeeded = '2019-04-30';
        PARTPRODUCT.NetPrice = '100';
        partList.add(PARTPRODUCT);
        jsonObj1.PARTPRODUCT = partList;
        
        List<Service_Request__c> servrqst=[select EmailId__c,Subject__c,Problem_Description__c from Service_Request__c limit 1];
        servrqst[0].Case_Number__c=cas[0].id;
        //jsonObj1.Case_Number__c = servrqst[0].Id;
        
       // jsonObj1.Case_Number__c=cas[0].id;
        //jsonObj1.PARTPRODUCT[]= '{"PARTPRODUCT":[{"PartNumber":"12AB","ProductNumber":"12AB","CageCode":"12AB","Quantity":"10","DateNeeded":"2019-04-30","NetPrice":"100"},{"PartNumber":"123","ProductNumber":"123","CageCode":"123","Quantity":"20","DateNeeded":"2019-04-30","NetPrice":"200"}]}';
        //system.assert(cas[0].type=='Orders'); 
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1));
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
   static testMethod void testcheckcreatecaseserviceAoGFormName77(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
       Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'WebsiteIssues/Registrationtoolaccess1' Limit 1];
        jsonObj1.FormName= 'WebsiteIssues/Registrationtoolaccess1';
        List<contact> con = [select id from contact where email=:'test2@test.com'];
        con[0].Contact_Status__c='InActive';
        update con;
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;
        jsonObj1.Subject= 'MyAerospace Technical Issue (Product Specific)'; 
        jsonObj1.AOG= false; 
        jsonObj1.CustomerType= 'customer type'; 
        jsonObj1.PartStatus= 'Part Status'; 
        jsonObj1.IsTheAircraftSupportedWithARental= 'Part Status'; 
        jsonObj1.CopyOf8130Tag_ifAvailable= 'Part Status'; 
        jsonObj1.ILSChecked= 'Part Status'; 
        jsonObj1.OtherServiceCentersChecked= 'Part Status'; 
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        //Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    
    static testMethod void testcheckcreatecaseserviceAoGFormName78(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'WebsiteIssues/Registrationtoolaccess1' Limit 1];
        jsonObj1.FormName= 'WebsiteIssues/Registrationtoolaccess1';
        List<contact> con = [select id from contact where email=:'test2@test.com'];       
        //jsonObj1.ContactId=con[0].id;
        con[0].Contact_Status__c='Inactive';
        update con;
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].ContactId= con[0].id;
        cas[0].type = 'Orders';
        update cas;        
        jsonObj1.Subject= 'MyAerospace Sending Payment';         
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        //Test.startTest();
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);
    }
    
     static testMethod void testcheckcreatecaseserviceAoGFormName79(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'WebsiteIssues/Registrationtoolaccess1' Limit 1];
		jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].type = 'Orders';
        update cas;
        system.assertEquals(1,cas.size());
        List<contact> con = [select id from contact where email=:'test2@test.com']; 
        List<account> a = [select id from account limit 1]; 
        Case caseObj = new Case(ContactId = con[0].id,AccountId = a[0].id,Status = 'Working',Origin = 'Phone');
		insert caseObj; 
		caseObj = [select id, casenumber from case where id = : caseObj.id];
		System.debug('case number' + caseObj.casenumber); 

        jsonObj1.FormName='WebsiteIssues/Registrationtoolaccess1';
        jsonObj1.Subject= label.MyAerospace_Warranty_Credit_Request;   
        jsonObj1.DESCRIPTION='Proposed Solution / Criteria to\n close:123';
         List<REG_API_Case.PARTPRODUCTDETAILS> part = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        List<REG_API_Case.Attachmentlist> attachList  = new List<REG_API_Case.Attachmentlist>();
        REG_API_Case.Attachmentlist Attachments = new REG_API_Case.Attachmentlist();
        Attachments.AttFileName = 'SomeFile.txt';
        Attachments.AttContentType = 'text/plain';
        Attachments.AttBody = 'dGVzdA==';
        attachList.add(Attachments);
        jsonObj1.Attachments = attachList;
        
         List<REG_API_Case.PARTPRODUCTDETAILS> partList  = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        REG_API_Case.PARTPRODUCTDETAILS PARTPRODUCT = new REG_API_Case.PARTPRODUCTDETAILS();
        PARTPRODUCT.PartNumber = '12AB';
        PARTPRODUCT.ProductNumber = '12AB';
        PARTPRODUCT.CageCode = '12AB';
        PARTPRODUCT.Quantity = '2';
        PARTPRODUCT.DateNeeded = '2019-04-30';
        PARTPRODUCT.NetPrice = '100';
        partList.add(PARTPRODUCT);
        jsonObj1.PARTPRODUCT = partList;
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        REG_API_Case.doPost();
        Test.stopTest();
    }
    
    static testMethod void testcheckcreatecaseserviceAoGFormName80(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'WebsiteIssues/Registrationtoolaccess1' Limit 1];
		jsonObj1.EmailAddress= 'amits.kate@tcs.com';
        List<case> cas=[select id,ContactId,type from case limit 1];
        cas[0].type = 'Orders';
        update cas;
        system.assertEquals(1,cas.size());
        List<contact> con = [select id,email from contact where email=:'test2@test.com']; 
        List<account> a = [select id from account limit 1]; 
        Case caseObj = new Case(ContactId = con[0].id,AccountId = a[0].id,Status = 'Working',Origin = 'Phone');
		insert caseObj; 
		caseObj = [select id, casenumber from case where id = : caseObj.id];
		System.debug('case number' + caseObj.casenumber); 

        jsonObj1.FormName='WebsiteIssues/Registrationtoolaccess1';
        jsonObj1.Subject= 'MyAerospace Technical Issue (Product Specific)';  
        jsonObj1.ccEmailAddress='test2@test.com';
        system.assertEquals(jsonObj1.ccEmailAddress, con[0].email);
        List<REG_API_Case.PARTPRODUCTDETAILS> part = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        List<REG_API_Case.Attachmentlist> attachList  = new List<REG_API_Case.Attachmentlist>();
        REG_API_Case.Attachmentlist Attachments = new REG_API_Case.Attachmentlist();
        Attachments.AttFileName = 'SomeFile.txt';
        Attachments.AttContentType = 'text/plain';
        Attachments.AttBody = 'dGVzdA==';
        attachList.add(Attachments);
        jsonObj1.Attachments = attachList;
        
         List<REG_API_Case.PARTPRODUCTDETAILS> partList  = new List<REG_API_Case.PARTPRODUCTDETAILS>();
        REG_API_Case.PARTPRODUCTDETAILS PARTPRODUCT = new REG_API_Case.PARTPRODUCTDETAILS();
        PARTPRODUCT.PartNumber = '12AB';
        PARTPRODUCT.ProductNumber = '12AB';
        PARTPRODUCT.CageCode = '12AB';
        PARTPRODUCT.Quantity = '2';
        PARTPRODUCT.DateNeeded = '2019-04-30';
        PARTPRODUCT.NetPrice = '100';
        partList.add(PARTPRODUCT);
        jsonObj1.PARTPRODUCT = partList;
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        REG_API_Case.doPost();
        Test.stopTest();
    }   
    
    static testMethod void testcheckcreatecaseOustsidePurchaseFormName1(){
        /*RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        jsonObj1.FormName='OutSidePurchaseRequest';
        jsonObj1.Subject='CP Authorization Part Number Needed';
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1));         
        REG_API_Case.doPost();
        Test.stopTest();
         String result = response.responseBody.toString();      
        System.assert(result!=Null);*/
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response; 
        request.requestUri ='/portal-case';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        Test.startTest();
        REG_API_Case.CaseData jsonObj1 = new  REG_API_Case.CaseData();
        SitecoreCaseType__c c=[SELECT Name,Case_Type__c FROM SitecoreCaseType__c where Name=:'OutSidePurchaseRequest' Limit 1];
        jsonObj1.FormName='OutSidePurchaseRequest';
        List<contact> con = [select id from contact where email=:'test2@test.com']; 
        List<account> a = [select id from account where name=:'STANDARD AERO INC' limit 1]; 
        
        Case caseObj = new Case(ContactId = con[0].id,AccountId = a[0].id,Status = 'Working',Origin = 'Phone',Subject='CP Authorization Part Number Needed');
		insert caseObj; 
		caseObj = [select id, casenumber,subject,Account_Name__c from case where id = : caseObj.id];
		System.debug('case number' + caseObj.id); 
        System.debug('case subject' + caseObj.subject); 
        System.debug('case Account_Name__c' + caseObj.Account_Name__c); 
        //jsonObj1.Subject= 'CP Authorization Part Number Needed'; 
        jsonObj1.EmailAddress= 'amits.kate@tcs.com';  
        jsonObj1.ContactId= con[0].id;  
        request.requestBody=Blob.valueOf(JSON.serialize(jsonObj1)); 
        REG_API_Case.doPost();
        Test.stopTest();
    }
         
}