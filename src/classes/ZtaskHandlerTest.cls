@isTest
public class ZtaskHandlerTest {
    
  /*  @IsTest
    public static void TestZTaskCreation(){
        test.startTest();
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<String> setCasId= new Set<String>();
            Case cs= new Case();
            cs.Origin = 'Email-EMS-Norcross';
            cs.RecordTypeId = Label.Repair_Overhaul_RT_ID;
            cs.Classification__c = 'CSO Repair/Overhaul';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;
            cs.ORDER_CHANNEL__c='POT';
            insert cs; 
            setCasId.add(cs.Id);
            System.assert(cs != null);
            System.assertEquals('POT',cs.ORDER_CHANNEL__c);
            
            List<Z_Task__c> lstZtask = new List<Z_Task__c>();
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z115 Estimate Review Required';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Open';
            zt.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            insert zt;
            lstZtask.add(zt);
            Z_Task__c zt1 = new Z_Task__c();
            zt1.Id=zt.Id;
            zt1.Status__c = 'Closed';
            update zt1;
            
            List<Case> caList =[Select Id,AccountId,Requestor_Email__c,ORDER_CHANNEL__c,Quote_Number__c,(select id, Name,Short_Text2__c,Short_Text__c from Z_Tasks__r ) from case where id =: cs.Id and recordtypeid =: Label.Repair_Overhaul_RT_ID];
            system.assert(caList!=null);
            system.debug('caListTest:'+caList);
            //system.assert(caList[0].ORDER_CHANNEL__c=='POT');
            ZtaskHandler.automationOfZ115ForOrderChannelPot(lstZtask);
            ExternalCalloutDetails__c ext = new ExternalCalloutDetails__c();
            ext.name='ApigeeToSapStatusUpdate1';
            ext.ClientId__c='T9SbiGmd36DnK0wYZZEI01VTdYe9Qkq0123';
            ext.SecretId__c='6WJ0OjZ6NnD3NMsk1234';
            ext.AuthUrl__c='https://it.test-dev.honeywell.com/v2/oauth/accesstoken';
            ext.EndPointUrl__c='https://it.test-dev.honeywell.com/v1/priceupdate';
            insert ext;
            system.assertNotEquals(null, ext);
            
            Map<String,String> mapHeaders = new Map<String,String>(); 
            String authToken = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(ext.ClientId__c+':'+ext.SecretId__c)) ; //for Base64 conversion
            mapHeaders.put('Authorization',authToken); 
            
            
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorExternal());
            //HttpResponse res = ZtaskHandler.sendCallout('http://example.com/example/test', 'GET', mapHeaders);
            ZtaskHandler.apigeeToSapStatusUpdate(setCasId);
        }
        test.stopTest();
    }*/
    
    @isTest
    public static void TestZTaskCreation1(){
       
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;
            cs.ORDER_CHANNEL__c='POT';
            insert cs; 
            setCasId.add(cs.Id);
            System.assert('POT' == cs.ORDER_CHANNEL__c);
            List<Z_Task__c> lstZtask = new List<Z_Task__c>();
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z115 Estimate Review Required';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt.Status__c = 'Open';
            zt.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            lstZtask.add(zt);
            insert lstZtask;
            
           // ZtaskHandler.automationOfZ115ForOrderChannelPot(lstZtask);
             test.startTest();
            Case cs1= new Case();
            cs1.Origin = 'SAP Interface';
            cs1.RecordTypeId = RecordtypeId;
            cs1.Classification__c = 'R&O Issue';
            cs1.ContactId = con.Id;
            cs1.Type_of_Change__c = 'New Account';
            cs1.Type = 'Other';
            cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs1.Government_Compliance_SM_M_Content__c = 'NO';  
            cs1.OwnerId=label.aero_default_user_id;
            cs1.ORDER_CHANNEL__c='RWB';
            cs1.Requestor_Email__c='nagarajan.s@nttdata.com';
            insert cs1; 
            setCasId.add(cs1.Id);
            System.assert('RWB' == cs1.ORDER_CHANNEL__c);
            ContentVersion conVer = new ContentVersion();
            Blob tstbody = EncodingUtil.base64Decode('dGVzdA==');
            conVer.PathOnClient = 'Test_ZCAF_test.txt'; // file name with extension
            conVer.Title = 'Test_ZCAF_test.txt'; // file name to display. Usually specify the extension here also
            conVer.VersionData = tstbody;
            insert conVer;
            ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
            ContentDocumentlink objCDL = new ContentDocumentlink();
            objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
            objCDL.linkedentityId = cs1.Id;
            insert objCDL;
            
            List<Z_Task__c> lstZtask1 = new List<Z_Task__c>();
            Z_Task__c zt2 = new Z_Task__c();
            zt2.Type__c='Z115 Estimate Review Required';
            zt2.SAP_ZTask_Number__c = 'Test123';
            zt2.Name = 'Tasktest1';
            zt2.RelatedTo__c = cs1.id;
            zt2.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt2.Comments__c = 'Test Ztask';
            zt2.Long_Text__c = 'Test122';
            zt2.Event_Type__c = '';
            zt2.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt2.Other_Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt2.Status__c = 'Open';
            zt2.Long_Text_Summary__c='test111test111test111test11st111test111test111test111test111test111test111';
            insert zt2;
            //lstZtask1.add(zt2);
            Z_Task__c zt1 = new Z_Task__c();
            zt1.Type__c='Z135 Escalation to CSR';
            zt1.SAP_ZTask_Number__c = 'Test123';
            zt1.Name = 'Tasktest1';
            zt1.RelatedTo__c = cs1.id;
            zt1.Short_Text__c = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
            zt1.Comments__c = 'Test Ztask';
            zt1.Long_Text__c = 'Test122';
            zt1.Event_Type__c = '';
            zt1.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt1.Other_Short_Text__c = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
            zt1.Status__c = 'Open';
            zt1.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            //lstZtask1.add(zt1);
            insert zt1;   
            //System.assertEquals(2,lstZtask1.size());
            test.stopTest();
        }
        
    }
   
    @isTest(SeeAllData = true)
    public static void testInterface1() {
        test.startTest();
        Set<String> setCasId= new Set<String>();
        setCasId.add('0223531398');
        setCasId.add('0223531397');        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorExternal());
        ZtaskHandler.apigeeToSapStatusUpdate(setCasId);        
        test.stopTest(); 
        
    }
    /*testmethod static void testInterface2() {
        test.startTest();
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            
            Customer_Specific_Work_Instruction__c cswi = new Customer_Specific_Work_Instruction__c();
            cswi.Account__c=acctest.Id;
            cswi.Record_Data_Owner__c=con.Id;
            insert cswi;
            
            CSWI_Emails_List__c csel = new CSWI_Emails_List__c();
            csel.Emails__c='nagarajan.s@nttdata.com';
            csel.Customer_Specific_Work_Instruction__c=cswi.Id;
            insert csel;
            Case cs1= new Case();
            cs1.Origin = 'Email-EMS-Norcross';
            cs1.RecordTypeId = Label.Repair_Overhaul_RT_ID;
            cs1.Classification__c = 'CSO Repair/Overhaul';
            cs1.ContactId = con.Id;
            cs1.AccountId=acctest.Id;
            cs1.Type_of_Change__c = 'New Account';
            cs1.Type = 'Other';
            cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs1.Government_Compliance_SM_M_Content__c = 'NO';  
            cs1.OwnerId=label.aero_default_user_id;
            cs1.ORDER_CHANNEL__c='POT';
            cs1.Requestor_Email__c='nagarajan.s@nttdata.com';
            insert cs1; 
            System.assert('POT' == cs1.ORDER_CHANNEL__c); 
            ContentVersion conVer = new ContentVersion();
            Blob tstbody = EncodingUtil.base64Decode('dGVzdA==');
            conVer.PathOnClient = 'Test_ZCAF_test.txt'; // file name with extension
            conVer.Title = 'Test_ZCAF_test.txt'; // file name to display. Usually specify the extension here also
            conVer.VersionData = tstbody;
            insert conVer;
            ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
            ContentDocumentlink objCDL = new ContentDocumentlink();
            objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
            objCDL.linkedentityId = cs1.Id;
            insert objCDL;
            
            Z_Task__c zt1 = new Z_Task__c();
            zt1.Type__c='Z135 Escalation to CSR';
            zt1.SAP_ZTask_Number__c = 'Test123';
            zt1.Name = 'Tasktest1';
            zt1.RelatedTo__c = cs1.id;
            zt1.Short_Text__c = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
            zt1.Comments__c = 'Test Ztask';
            zt1.Long_Text__c = 'Test122';
            zt1.Event_Type__c = '';
            zt1.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt1.Other_Short_Text__c = 'Test text';
            zt1.Status__c = 'Open';
            zt1.Long_Text_Summary__c='test111test111test111tesest111test111';
            
            insert zt1;   
        }
        test.stopTest(); 
    }*/
    
    @isTest
    public static void testInterface3(){
       
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            
            test.startTest();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
            Case cs1= new Case();
            cs1.Origin = 'SAP Interface';
            cs1.RecordTypeId = RecordtypeId;
            cs1.Classification__c = 'R&O Issue';
            cs1.ContactId = con.Id;
            cs1.Type_of_Change__c = 'New Account';
            cs1.Type = 'Other';
            cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs1.Government_Compliance_SM_M_Content__c = 'NO';  
            cs1.OwnerId=label.aero_default_user_id;
            cs1.ORDER_CHANNEL__c='CON';
            cs1.Requestor_Email__c='nagarajan.s@nttdata.com';
            insert cs1; 
            System.assert('CON' == cs1.ORDER_CHANNEL__c);
            ContentVersion conVer = new ContentVersion();
            Blob tstbody = EncodingUtil.base64Decode('dGVzdA==');
            conVer.PathOnClient = 'Test_ZCAF_test.txt'; // file name with extension
            conVer.Title = 'Test_ZCAF_test.txt'; // file name to display. Usually specify the extension here also
            conVer.VersionData = tstbody;
            insert conVer;
            ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
            ContentDocumentlink objCDL = new ContentDocumentlink();
            objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
            objCDL.linkedentityId = cs1.Id;
            insert objCDL;
            
            Z_Task__c zt2 = new Z_Task__c();
            zt2.Type__c='Z115 Estimate Review Required';
            zt2.SAP_ZTask_Number__c = 'Test123';
            zt2.Name = 'Tasktest1';
            zt2.RelatedTo__c = cs1.id;
            zt2.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt2.Comments__c = 'Test Ztask';
            zt2.Long_Text__c = 'Test122';
            zt2.Event_Type__c = '';
            zt2.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt2.Other_Short_Text__c = 'Test text';
            zt2.Status__c = 'Open';
            zt2.Long_Text_Summary__c='test111test111test111test11st111test111test111test111test111test111test111';
            insert zt2;
               
            test.stopTest();
        }
        
    }
    
    @isTest
    public static void TestZTaskCreation2(){
       
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;
            cs.ORDER_CHANNEL__c='CON';
            insert cs; 
            setCasId.add(cs.Id);
            System.assert('CON' == cs.ORDER_CHANNEL__c);
            List<Z_Task__c> lstZtask = new List<Z_Task__c>();
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z115 Estimate Review Required';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Open';
            zt.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            lstZtask.add(zt);
            insert lstZtask;
            
           // ZtaskHandler.automationOfZ115ForOrderChannelPot(lstZtask);
             test.startTest();
            Case cs1= new Case();
            cs1.Origin = 'SAP Interface';
            cs1.RecordTypeId = RecordtypeId;
            cs1.Classification__c = 'R&O Issue';
            cs1.ContactId = con.Id;
            cs1.Type_of_Change__c = 'New Account';
            cs1.Type = 'Other';
            cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs1.Government_Compliance_SM_M_Content__c = 'NO';  
            cs1.OwnerId=label.aero_default_user_id;
            cs1.ORDER_CHANNEL__c='POT';
            cs1.Requestor_Email__c='nagarajan.s@nttdata.com';
            insert cs1; 
            setCasId.add(cs1.Id);
            System.assert('POT' == cs1.ORDER_CHANNEL__c);
            ContentVersion conVer = new ContentVersion();
            Blob tstbody = EncodingUtil.base64Decode('dGVzdA==');
            conVer.PathOnClient = 'Test_ZCAF_test.txt'; // file name with extension
            conVer.Title = 'Test_ZCAF_test.txt'; // file name to display. Usually specify the extension here also
            conVer.VersionData = tstbody;
            insert conVer;
            ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
            ContentDocumentlink objCDL = new ContentDocumentlink();
            objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
            objCDL.linkedentityId = cs1.Id;
            insert objCDL;
            
            List<Z_Task__c> lstZtask2 = new List<Z_Task__c>();
            Z_Task__c zt2 = new Z_Task__c();
            zt2.Type__c='Z115 Estimate Review Required';
            zt2.SAP_ZTask_Number__c = 'Test123';
            zt2.Name = 'Tasktest1';
            zt2.RelatedTo__c = cs1.id;
            zt2.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt2.Comments__c = 'Test Ztask';
            zt2.Long_Text__c = 'Test122';
            zt2.Event_Type__c = '';
            zt2.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt2.Other_Short_Text__c = 'Test text';
            zt2.Status__c = 'Open';
            zt2.Long_Text_Summary__c='test111test111test111test11st111test111test111test111test111test111test111';
            lstZtask2.add(zt2);
            
            Z_Task__c zt1 = new Z_Task__c();
            zt1.Type__c='Z135 Escalation to CSR';
            zt1.SAP_ZTask_Number__c = 'Test123';
            zt1.Name = 'Tasktest1';
            zt1.RelatedTo__c = cs1.id;
            zt1.Short_Text__c = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
            zt1.Comments__c = 'Test Ztask';
            zt1.Long_Text__c = 'Test122';
            zt1.Event_Type__c = '';
            zt1.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt1.Other_Short_Text__c = 'Test text';
            zt1.Status__c = 'Open';
            zt1.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            lstZtask2.add(zt1);
            insert lstZtask2;  
            System.assertEquals(2,lstZtask2.size());
            
            test.stopTest();
        }
        
    }
    
    @isTest
    public static void TestZTaskCreation3(){
       
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Case cs= new Case();
            cs.Origin = 'Email-EMS-Norcross';
            cs.RecordTypeId = Label.Repair_Overhaul_RT_ID;
            cs.Classification__c = 'CSO Repair/Overhaul';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;
            cs.ORDER_CHANNEL__c='CON';
            insert cs; 
            setCasId.add(cs.Id);
            System.assert('CON' == cs.ORDER_CHANNEL__c);
            List<Z_Task__c> lstZtask = new List<Z_Task__c>();
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z115 Estimate Review Required';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = '';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Open';
            zt.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            lstZtask.add(zt);
            insert lstZtask;
        }
        
    }
    
    @isTest
    public static void TestZTaskCreation4(){
       
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            
            test.startTest();
            Case cs1= new Case();
            cs1.Origin = 'Email-EMS-Norcross';
            cs1.RecordTypeId = Label.Repair_Overhaul_RT_ID;
            cs1.Classification__c = 'CSO Repair/Overhaul';
            cs1.ContactId = con.Id;
            cs1.Type_of_Change__c = 'New Account';
            cs1.Type = 'Other';
            cs1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs1.Government_Compliance_SM_M_Content__c = 'NO';  
            cs1.OwnerId=label.aero_default_user_id;
            cs1.ORDER_CHANNEL__c='CON';
            cs1.Requestor_Email__c='nagarajan.s@nttdata.com';
            insert cs1; 
            System.assert('CON' == cs1.ORDER_CHANNEL__c);
            ContentVersion conVer = new ContentVersion();
            Blob tstbody = EncodingUtil.base64Decode('dGVzdA==');
            conVer.PathOnClient = 'Test_ZSRP_test.txt'; // file name with extension
            conVer.Title = 'Test_ZSRP_test.txt'; // file name to display. Usually specify the extension here also
            conVer.VersionData = tstbody;
            insert conVer;
            ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
            ContentDocumentlink objCDL = new ContentDocumentlink();
            objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
            objCDL.linkedentityId = cs1.Id;
            insert objCDL;
            List<Z_Task__c> zTaskList = new List<Z_Task__c>();
            Z_Task__c zt2 = new Z_Task__c();
            zt2.Type__c='Z115 Estimate Review Required';
            zt2.SAP_ZTask_Number__c = 'Test123';
            zt2.Name = 'Tasktest1';
            zt2.RelatedTo__c = cs1.id;
            zt2.Short_Text__c = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
            zt2.Comments__c = 'Test Ztask';
            zt2.Long_Text__c = 'Test122';
            zt2.Event_Type__c = '';
            zt2.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt2.Other_Short_Text__c = 'Test text';
            zt2.Status__c = 'Open';
            zt2.Long_Text_Summary__c='test111test111test111test11st111test111test111test111test111test111test111';
            zTaskList.add(zt2);
            insert zTaskList;
            System.assertEquals(1,zTaskList.size());
            ZtaskHandler.automationOfZ115ForOrderChannelRwbAndCon(zTaskList);
            ZtaskHandler.automationOfZ135ForOrderChannelRwbAndCon(zTaskList);
            test.stopTest();
        }
        
    }
    
}