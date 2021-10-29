//@isTest(seealldata=true)

@isTest 
public class AfterUpdateHelperclass_Test {

static final Integer CASE_COUNT_PROVIDE = 1;    
 @testSetup
 
  static void setupForAfterUpdate(){
        Test.startTest();
  Profile adminProfile = [select id from Profile where name = 'System Administrator'];
        List<Country__c> lstCountry = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Country__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Country__c.OwnerId => UserInfo.getUserId(),
                Country__c.Name => 'USA',
                Country__c.SFDC_Country_Name__c => 'USA'
                }
             );
    List<User> lstUser = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO2',
                User.Username => 'tu2cso@test.com',
                User.Email => 'testuser2@test.com',
                User.Alias => 'tu2',
                User.CommunityNickname => 'tu2cso',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => adminProfile.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );
    
      List<Account> lstAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account', 
                Account.Type => 'OEM',
                Account.Country__c => lstCountry[0].Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'ATR',
                Account.CBT__c => 'Airbus',
                Account.CBT_Team__c => 'None',
                Account.Region_Name__c => 'Americas',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New',
                Account.Stop_to_Send_Surveys__c => 'test'
            }
        );  
        
    
        List<Contact> lstContact = SObjectFactory.build(1,Contact.sObjectType);

               lstContact[0].LastName = 'Test';
               lstContact[0].FirstName = 'Contact';
               lstContact[0].AccountId = lstAccount[0].Id;
               lstContact[0].Primary_Email_Address__c = 'gatotuka@in.ibm.com';
               //lstContact[0].Last_Survey_Date__c = Date.parse('12/16/15');
               lstContact[0].Last_Survey_Date__c = system.Today()-90;
               lstContact[0].Email = 'test0@in.ibm.com';
               lstContact[0].Survey_Opt_Out__c = false;
               lstContact[0].NPS_Survey__c = 'No';
               
               insert lstContact;

        Test.stopTest();
                       
  }    
 /*
    static testmethod void testmethod1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
             
        test.startTest();       
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email-EMS-Norcross';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.Case_AOG_RecordType;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        //cseLow1.OwnerId=label.aero_default_user_id;
        insert cseLow1; 
        
        cseLow1.RecordTypeId=Label.Orders_Rec_ID;
        cseLow1.Type='Place Order';
        cseLow1.Status='Open';
        cseLow1.Origin='Email';
        cseLow1.Classification__c = 'EDI';    
        cseLow1.OwnerId=UserInfo.getUserId();  
        cselow1.Sales_Order_Number__c = '123';
        update cseLow1;

        
        test.stopTest();    

        
    } 
 
 static testmethod void testmethod2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.TechnicalIssue_RecordTypeID;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        //cseLow1.OwnerId=label.aero_default_user_id;
        insert cseLow1; 
             
        test.startTest();
        cseLow1.Status='On Hold';
        cseLow1.Sub_Status__c = 'Waiting for TCT';
        update cseLow1;
        
        cseLow1.Sub_Status__c = 'Waiting for Customer Feedback';
        update cseLow1;
        
        cseLow1.Sub_Status__c = 'Waiting for EPS';
        update cseLow1;
        test.stopTest();    

        
    } 
    
     static testmethod void testmethod3(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.TechnicalIssue_RecordTypeID;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        //cseLow1.OwnerId=label.aero_default_user_id;
        insert cseLow1; 
             
        test.startTest();
        cseLow1.Status='On Hold';
        cseLow1.Sub_Status__c =  'Waiting for Engineering';
        update cseLow1;
        
        cseLow1.Sub_Status__c = 'Waiting for EPS/Engineering';
        update cseLow1;
        
        cseLow1.Sub_Status__c = 'Waiting for Honeywell Internal';
        update cseLow1;
        test.stopTest();    

        
    } 
    
      
     static testmethod void testmethod4(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit14.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        Case cseLow1 = new Case();
        user u = [select id from user where id=:Label.DeniedPartyScreening_APIUser_ID];
        system.runas(u){
        
        cseLow1.Origin = 'Email';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.Repair_Overhaul_RT_ID;
        cseLow1.Description = 'SFDC Case for Notification';
        //cseLow1.Requestor_Email__c =  'sumit13.gupta@honeywell.com';
        cseLow1.Classification__c = 'R&O Issue';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        //cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'PO Mismatch';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        //cseLow1.OwnerId=label.aero_default_user_id;
        insert cseLow1;
        Z_Task__c zt = new Z_Task__c();
        zt.Type__c = 'Z107 Order Information Required';
        zt.Status__c = 'Open';
        zt.Long_Text__c = 'test';
        zt.New_Long_Text__c='test2';
        //zt.Task_Closed__c = false; 
        zt.RelatedTo__c = cseLow1.id;
        insert zt;
         }
        
        test.startTest();
        
        cseLow1.Requestor_Email__c =  'sumit15.gupta@honeywell.com';
        update cseLow1;
        
        test.stopTest();    

        
    } 
    
    static testmethod void testmethod5(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.QuotesRecordID;
        cseLow1.Quote_Number__c = 'My1234';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow1.OwnerId= userinfo.getuserid();
        insert cseLow1; 
             Case_Line_Item__c cli = new Case_Line_Item__c();
             //cli.Lineitemstatus__c = true;
             cli.price__c = 10;
             cli.Case_Number__c = cselow1.id;
             insert cli;
        test.startTest();
        cseLow1.OwnerId= userinfo.getuserid();
        cseLow1.Status='Done';
        update cseLow1;
        test.stopTest();    

        
    }
    
static testMethod void updateContactToolAccess(){
portal_tools_master__c newtool = new portal_tools_master__c();     
        newtool.name = 'Test Tool1';    
        newtool.tool_Description__c = 'Tool description';                
        newtool.tool_authorization_master__c = 'HON approval';                              
        newtool.auto_approve__c = 'Not Allowed';         
        newtool.tool_active__c = true;           
        insert newtool; 
        
        
        account newAcct = new account();
        newAcct.name = 'test account code coverage2';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='ATR';
        insert newAcct;
        Contact cont=new Contact();
        cont.LastName='Test Contatct Name';
        cont.accountid=newAcct.id;
        cont.Primary_Email_Address__c='test@test.com';
        cont.Email='test@test.com';
        insert cont;
        Contact_Tool_Access__c conToolAccess=new Contact_Tool_Access__c();
        conToolAccess.CRM_Contact_ID__c=cont.id;
        conToolAccess.Portal_Honeywell_ID__c ='test123';
        conToolAccess.Portal_Tool_Master__c=newtool.id;
        conToolAccess.name=newtool.name;
        conToolAccess.Request_Status__c='Pending';
        insert conToolAccess;
        
        //Id rcrdtypeid=[select id from recordtype where name='General' and SobjectType='Case' limit 1].Id;
        //system.debug('Record Type Id is:'+rcrdtypeid);
        
        Case newCase=new Case();
        newCase.Origin='Web';
        newCase.status='Open';
        newCase.Type='Web Portal Registration';
        newCase.contactid=cont.id;
        newCase.accountid=newAcct.id;
        newCase.Tool_Name__c='Test Tool1';
        newCase.Tool_Comments__c='Test Comments';
        newCase.Tool_Authorization_Method__c='HON approval';
        newCase.Product_Type__c='Services';
        newCase.Catalog_Product_Group__c='Cabin(SV)';
        newCase.Supported_Product__c='OneLink';
        newCase.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        newCase.Government_Compliance_SM_M_Content__c = 'NO';
        newCase.Honeywell_ID__c ='test123';
        //newCase.recordtypeid=rcrdtypeid;
        insert newCase;
        
        
        
Test.startTest();
        newCase.ownerid=label.CSR_Online_Ordering_Approval_Queue;
        newCase.status='Approved';
        update newCase;
        newCase.Product_Type__c='Services';
        newCase.Catalog_Product_Group__c='Cabin(SV)';
        newCase.Supported_Product__c='OneLink';
        newCase.Export_Compliance_Content_ITAR_EAR__c='No';
        newCase.Government_Compliance_SM_M_Content__c='No';
        newCase.status='Denied';
        newCase.Resolution__c='testRes';
        //newCase.recordtypeid=rcrdtypeid;
        update newCase;
        
        
Test.stopTest();
}

 static testmethod void testmethod6(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = label.GDC_Tech_Issue;
        cseLow1.Quote_Number__c = 'My1234';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow1.OwnerId=label.aero_default_user_id;
        insert cseLow1; 
        
        Case cseLow2 = new Case();
        cseLow2.Origin = 'Email';
        cseLow2.Status = 'Open';
        cseLow2.RecordTypeId = label.GDC_Call;
        cseLow2.Quote_Number__c = 'My1234';
        cseLow2.ContactId = con.Id;
        cseLow2.vn_name__c=con.id;
        cseLow2.Type_of_Change__c = 'New Account';
        cseLow2.Type = 'Other';
        cseLow2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow2.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow2.OwnerId= userinfo.getuserid();
        insert cseLow2; 
             
        
             
         
        test.startTest();
        cseLow1.Status='Done';
        update cseLow1;
        cseLow1.OwnerId= userinfo.getuserid();
        cseLow2.Status='Done';
        update cseLow2;
         
        test.stopTest();   
    }
    
     static testmethod void testmethod7(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        
       
        Case cseLow3 = new Case();
        cseLow3.Origin = 'Web';
        cseLow3.Status = 'Open';
        cseLow3.RecordTypeId = label.Web_Support_Rec_Type_ID;
        cseLow3.Quote_Number__c = 'My1234';
        cseLow3.ContactId = con.Id;
        cseLow3.vn_name__c=con.id;
        cseLow3.Type_of_Change__c = 'New Account';
        cseLow3.Type = 'MyAero web portal issue';
        cseLow3.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow3.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow3.OwnerId=label.aero_default_user_id;
        insert cseLow3; 
        
        Case cseLow4 = new Case();
        cseLow4.Origin = 'Web';
        cseLow4.Status = 'Open';
        cseLow4.RecordTypeId = Label.New_Aircraft_Delivery_RT_ID;
        cseLow4.Quote_Number__c = 'My1234';
        cseLow4.ContactId = con.Id;
        cseLow4.vn_name__c=con.id;
        cseLow4.Type_of_Change__c = 'New Account';
        cseLow4.Type = 'MyAero web portal issue';
        cseLow4.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow4.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow4.OwnerId=label.aero_default_user_id;
        cseLow4.Fleet_Asset_Aircraft_Number__c = 'faan1234';
        insert cseLow4;
             
         
        test.startTest();
        cseLow3.Status='Done';
        update cseLow3;
        
        cseLow4.Status='Closed';
        update cseLow4;
        test.stopTest();   

        
    }
    
     static testmethod void testmethod8(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        user u = [select id from user where username like 'effortlessorders@honeywell.com%' limit 1];
        /*Case cseLow1 = new Case();
        cseLow1.Origin = 'Email-Orders';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.Orders_Rec_ID;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Sales_Order_Number__c = 'test123';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        //cseLow1.OwnerId=u.id;
        insert cseLow1; 
             Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=cseLow1.id;
            insert attach;
            
             Attachment attach1=new Attachment();     
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=cseLow1.id;
            insert attach1;
            
             Attachment attach2=new Attachment();     
            attach2.Name='Unit Test Attachment';
            Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
            attach2.body=bodyBlob;
            attach2.parentId=cseLow1.id;
            insert attach2;*/
      /*  test.startTest();
        //map<id, case> lc =new Map<ID, case>([select id,Sales_Order_Number__c from case where Sales_Order_Number__c!=null limit 200]);
        attachment att =[select id, parentid from attachment where parentid in (select id from case where Sales_Order_Number__c!=null) limit 1];
        //system.runas(u){
        case cseLow1 = new case(id=att.parentid);
        cseLow1.Sales_Order_Number__c = null;
        update cseLow1;
        
        test.stopTest();    
        //}
        
    }
    
    /*
    static testmethod void testmethod9(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
             
              
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email-Orders';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.Orders_Rec_ID;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow1.OwnerId=label.aero_default_user_id;
        cseLow1.createddate=system.today().adddays(-1);
        cselow1.Reason_for_hold__c = 'test1';
        insert cseLow1; 
        
          test.startTest(); 
        cseLow1.OwnerId=UserInfo.getUserId();
        cseLow1.Status = 'Done'; //added
        update cseLow1;

        
        test.stopTest();    

        
    } */
    
    /*
       static testmethod void testmethod10(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
             
              
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.OEM_Spares;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        cseLow1.OwnerId=Label.CSO_OEM_Spares;
        cseLow1.Requestor_Email__c='123@honeywell.com';
        cseLow1.subject='123test';
        insert cseLow1; 
        
          test.startTest();
          cseLow1.subject='1234test'; 
          cseLow1.Requestor_Email__c='1234@honeywell.com';
        cseLow1.OwnerId=Label.CSO_OEM_Spares;
        update cseLow1;

        
        test.stopTest();    

        
    } */
    
    static testMethod void afterUpdateMethod_createSurveyURL_81(){
        String rtIdHAPPAccts = RecordTypeServices.getRecordTypeByName('HAPP MPP Contracts','Case').Id; //01230000000bTFh - HAPP MPP Contracts
        String rtIdGDCAccounts = RecordTypeServices.getRecordTypeByName('GDC Accounts','Case').Id; //01230000000bTFc
        String rtIdTechPubs = RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id; //01230000000Zen7
        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);
            //RT : HAPP MPP Contracts
            oldCaseList[0].RecordTypeId = rtIdHAPPAccts;
            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].Quote_Number__c = 'My1234';
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].OwnerId = Userinfo.getUserId();
            
            //RT : GDC Accounts
            oldCaseList[1].RecordTypeId = rtIdGDCAccounts;
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].Quote_Number__c = 'My1234';
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].vn_name__c = cont.id;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].OwnerId = Userinfo.getUserId();
            
            //RT : Tech Pubs
            oldCaseList[2].RecordTypeId = rtIdTechPubs;
            oldCaseList[2].Origin = 'Email';
            oldCaseList[2].Status = 'Open';
            oldCaseList[2].Quote_Number__c = 'My1234';
            oldCaseList[2].ContactId = cont.Id;
            oldCaseList[2].vn_name__c = cont.id;
            oldCaseList[2].AccountId = acct.Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].OwnerId = Userinfo.getUserId();

            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,Requested_By_HON_Internal__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
            
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdHAPPAccts;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Sub_Status__c = 'With Production team';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdGDCAccounts;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Resolution__c = 'case is closed';
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdTechPubs;
            newCaseList[2].OwnerId = UserInfo.getUserId();
            newCaseList[2].Status = 'Done';
            newCaseList[2].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        
        List<Case> updatedCaseList8 = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId,Requested_By_HON_Internal__c, Iscompliance__c,PFECN__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList9 = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId,Requested_By_HON_Internal__c, Iscompliance__c,PFECN__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
        
        List<Case> updatedCaseList10 = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c,Requested_By_HON_Internal__c, OwnerId, Iscompliance__c,PFECN__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[2].Id]);
        
        
        //Test.startTest();    
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList8,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList9,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList10,oldCaseMap);
        }
        
        
        List <GroupMember> GroupMemberlist = new List <GroupMember>();
        List <Id> GroupMemberid = new List <Id>();
        
        AfterUpdateHelperClass.getGroupIds(GroupMemberlist,runUser.id); //newly added

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }   
    
}