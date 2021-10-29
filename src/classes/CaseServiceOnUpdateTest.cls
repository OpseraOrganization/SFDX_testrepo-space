/*
Created By : Swastika Rajkhowa
Created Date : Nov-27-2017
Usages : test class methods for CaseServiceOnUpdate methods       
*/
@isTest 
public class CaseServiceOnUpdateTest {
    static final Integer CASE_COUNT = 10;
    static final Integer CASE_COUNT_PROVIDE = 1;
    
    static final String rtIdOrders = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id; //01230000000Zen3AAC
    static final String rtIdTechIssue = RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id; //01230000000ZJvU
    static final String rtIdRepairOverhaul = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id; //01230000000Zen5AAC
    static final String rtIdDSClearingHouse = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id; //01230000000cN6e
    static final String rtIdA350FTTeschIssue = RecordTypeServices.getRecordTypeByName('A350 FT/EIS Tech Issue','Case').Id; //012a0000001ZPNjAAO
    static final String rtIdQuotes = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id; //01230000000Zen4AAC
    static final String rtIdOEMQuoteOrders = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id; //012a0000001ZLs9AAG
    static final String rtIdDSQuotesOrders = RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id; //01230000000Zemz
    static final String rtIdCSMToolbox = RecordTypeServices.getRecordTypeByName('CSM Toolbox','Case').Id; //01230000000bTK410696
    
    static final String rtIdTechPubs = RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id; //01230000000Zen7
    static final String rtIdGeneral = RecordTypeServices.getRecordTypeByName('General','Case').Id; //01230000000Zen1AAC
    static final String rtIdReturns = RecordTypeServices.getRecordTypeByName('Returns','Case').Id; //01230000000Zen6
    static final String rtIdReturnsPRO = RecordTypeServices.getRecordTypeByName('ReturnsPRO','Case').Id; //01213000001ZU8l
    static final String rtIdEngineRentals = RecordTypeServices.getRecordTypeByName('Engine Rentals','Case').Id; //01230000000Zen0AAC
    static final String rtIdinvoiceDisputes = RecordTypeServices.getRecordTypeByName('Invoice Disputes','Case').Id; //01230000000Zen2AAC
    static final String rtIdWebSupport = RecordTypeServices.getRecordTypeByName('WEB Support','Case').Id; //01230000000Zen8AAC
    static final String rtIdGDCTechIssue = RecordTypeServices.getRecordTypeByName('GDC Tech Issue','Case').Id; //01230000000bTFgAAM
    
    static final String rtIdGDCCall = RecordTypeServices.getRecordTypeByName('GDC Call','Case').Id; //01230000000bTFdAAM
    static final String rtIdGDCOperationsEmail = RecordTypeServices.getRecordTypeByName('GDC Operations Email','Case').Id; //01230000000bTFfAAM
    static final String rtIdMSPContract = RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id; //01230000000bTFiAAM
    static final String rtIdNavDBAccts = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id; //01230000000bTFjAAM
    static final String rtIdHAPPAccts = RecordTypeServices.getRecordTypeByName('HAPP MPP Contracts','Case').Id; //01230000000bTFh - HAPP MPP Contracts
    static final String rtIdGDCAccounts = RecordTypeServices.getRecordTypeByName('GDC Accounts','Case').Id; //01230000000bTFc
    
    static final String rtIdFlightTechServices = RecordTypeServices.getRecordTypeByName('Flight Technical Services','Case').Id; //012a0000001ZOoO
    static final String rtIdFSSActivation = RecordTypeServices.getRecordTypeByName('FSS Activations','Case').Id; //01213000000AXiT
    static final String rtIdFSStechIssue = RecordTypeServices.getRecordTypeByName('FSS Technical Issue','Case').Id; //01213000000AWreAAG
    static final String rtIdFSSAccounts = RecordTypeServices.getRecordTypeByName('FSS Accounts','Case').Id; //01213000000AXiJ
    static final String rtIdJXSupport = RecordTypeServices.getRecordTypeByName('JXSupport','Case').Id; //01213000001ZUF3
    static final String rtIdFSSTierISupport = RecordTypeServices.getRecordTypeByName('FSS Tier I Support','Case').Id; //012c00000005Ol5
    
    static final String rtIdOEMSpares = RecordTypeServices.getRecordTypeByName('OEM/Spares','Case').Id; //01213000001ZUAX
    static final String rtIdNewAircraftDlvry = RecordTypeServices.getRecordTypeByName('New Aircraft Delivery','Case').Id; //01213000001ZT1Z
    static final String rtIdAOG = RecordTypeServices.getRecordTypeByName('AOG','Case').Id; //01230000000ZemyAAC
    static final String rtIdWebPortalRegistration = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id; //01230000000aMbD
    static final String rtIdPilotCornerAvionics = RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id;
    static final String rtIdExchange = RecordTypeServices.getRecordTypeByName('Exchange','Case').Id; //012K0000000Ilb4IAC//FOUNDSNEHA////added for AOG/Spex Case Record Type Split

    
    
    
    static List<Case> listCaseOrder = new List<Case>();
    static List<Case> listCaseTech = new List<Case>();
    static List<Case> listCaseRepair = new List<Case>();
    static List<Case> listCaseDSClearing = new List<Case>();
    static List<Case> listCaseA350FT = new List<Case>();
    static List<Case> listCaseQuotes = new List<Case>();
    static List<Case> listCaseOEMQuote = new List<Case>();
    static List<Case> listCaseDSQuote = new List<Case>();
    static List<Case> listCaseOrderOld = new List<Case>();
    static List<Case> listCaseCSMToolbox = new List<Case>();
    static List<Case> listCaseTechIssue = new List<Case>();

    static Profile adminProfile;
    static List<Country__c> lstCountry = new List<Country__c>();
    static List<portal_tools_master__c> lstPortalToolMaster = new List<portal_tools_master__c>();
    static List<User> lstUser = new List<User>();
    static List<Account> lstnewAccount = new List<Account>();
    static List<Contact> lstContact = new List<Contact>();
    static List<Contact> lstContact1 = new List<Contact>();
    static List<Contact> lstContact2 = new List<Contact>();
    static List<Contact_Tool_Access__c> lstContactTool = new List<Contact_Tool_Access__c>();
    static List<Contact_Tool_Access__c> lstContactTool1 = new List<Contact_Tool_Access__c>();
    static List<Contact_Tool_Access__c> lstContactTool2 = new List<Contact_Tool_Access__c>();
    static List<Contact_Tool_Access__c> lstContactTool3 = new List<Contact_Tool_Access__c>();
    static List<Group> lstgrpId = new List<Group>();
    static List<Account> lstAccount = new List<Account>();
    
    @testSetup
    static void setupForAfterUpdate(){

        TriggerInactive.testTrigger = false;
        system.runAs(new User(Id = Userinfo.getUserId())){
            List<GroupMember> lstgroup = SObjectFactory.build(3,GroupMember.sObjectType);
            lstgroup[0].GroupId = CaseServiceUtility.getGroupId('EBizWebOperations','Queue');
            lstgroup[0].UserOrGroupId = Userinfo.getUserId();
                
            lstgroup[1].GroupId = CaseServiceUtility.getGroupId('GDCTech','Queue');
            lstgroup[1].UserOrGroupId = Userinfo.getUserId();
                
            lstgroup[2].GroupId = CaseServiceUtility.getGroupId('GFO','Queue');
            lstgroup[2].UserOrGroupId = Userinfo.getUserId();
            
            insert lstgroup;
        
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
        List<portal_tools_master__c> lstPortalToolMaster = SObjectFactory.create(
            CASE_COUNT_PROVIDE, portal_tools_master__c.sObjectType, new Map<Schema.SObjectField, Object>{  
            portal_tools_master__c.name => 'Test Tool1', 
            portal_tools_master__c.tool_Description__c => 'Tool description',               
            portal_tools_master__c.tool_authorization_master__c => 'HON approval',                             
            portal_tools_master__c.auto_approve__c => 'Not Allowed',        
            portal_tools_master__c.tool_active__c => true
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

        List<Account> lstAccount1 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account BGA', 
                Account.Type => 'OEM',
                Account.Country__c => lstCountry[0].Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'BGA',
                Account.PFECN__c => 'Portal',
                Account.Is_Bendix_King_Dealer__c => true,
                Account.CBT__c => 'Airbus',
                Account.CBT_Team__c => 'None',
                Account.Region_Name__c => 'Americas',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New 1',
                Account.Stop_to_Send_Surveys__c => 'test'
            }
        );
        
        List<Account> lstAccount2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account D&S', 
                Account.Type => 'OEM',
                Account.Country__c => lstCountry[0].Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.Concierge__c => True,
                Account.CBT__c => 'Airbus',
                Account.CBT_Team__c => 'None',
                Account.Region_Name__c => 'Americas',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New 2',
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
    }
     
   //Test for gtoUsabilityProject
   static testMethod void afterUpdateMethod_gtoUsabilityProject(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            //gtoUtilityProject - RT Tech Pubs
            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdTechPubs;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].HIPI_Opportunity__c = false;
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,NPS_Recommend__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseListQuery[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseListQuery[0].Id
            }
        );
        
        List<Z_Task__c> listZTask = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Z_Task__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Z_Task__c.Type__c => 'Z107 Order Information Required', 
                Z_Task__c.Status__c => 'Open',
                Z_Task__c.Long_Text__c => 'Long Text', 
                Z_Task__c.New_Long_Text__c => 'New Long Text', 
                Z_Task__c.RelatedTo__c => oldCaseListQuery[0].Id
            }
        );
        
            //gtoUtilityProject - RT Tech Pubs
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdTechPubs;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Origin = 'Email';
            newCaseList[0].Classification__c = 'EDI';    
            newCaseList[0].OwnerId = UserInfo.getUserId();  
            newCaseList[0].HIPI_Opportunity__c = true;
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,NPS_Recommend__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        S2SFRestService__c objS2SF = new S2SFRestService__c();
            objS2SF.Name = 'S2SFRestService11';
            objS2SF.Client_Id__c = '3MVG9dzpc3kWyeYadd5SFIAZYfRT0HTnAJXRkW8Hc7.5LpxdjaVJJ05iuJHTDvKITxa5EZ9Y40iSX47_r53mJ';
            objS2SF.OAuth2End_Point__c = 'https://test.salesforce.com/services/oauth2/token';
            objS2SF.Password__c = 'testHtygKefAzOUqQtJ3F5pEfjk3';
            objS2SF.Secret_Id__c = '17600332615211137021';
            objS2SF.User_Name__c = 'nandini.nanjappan@honeywell.com';
            insert objS2SF;        
        
        //Test.startTest();
  
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');        
    }
    
    //Test for caseExtensionProject
    static testMethod void afterUpdateMethod_caseExtensionProject(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);
            //caseExtensionProject - RT Web Portal Registration - existing case extension
            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdWebPortalRegistration;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.today().adddays(-1);
            
            //caseExtensionProject - RT Web Portal Registration - create case extension
            oldCaseList[1].Origin = 'Email-EMS-Norcross';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = rtIdWebPortalRegistration;
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].vn_name__c = cont.id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.today().adddays(-1);
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,NPS_Recommend__c 
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseListQuery[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseListQuery[0].Id
            }
        );
        
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdWebPortalRegistration;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Origin = 'Email';
            newCaseList[0].Subject = 'MYMAINTAINER support line';
            newCaseList[0].Classification__c = 'EDI';    
            newCaseList[0].OwnerId = UserInfo.getUserId();

            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdWebPortalRegistration;
            newCaseList[1].Type = 'Place Order';
            newCaseList[1].Status = 'Open';
            newCaseList[1].Origin = 'Email';
            newCaseList[1].Subject = 'MYMAINTAINER support line';
            newCaseList[1].Classification__c = 'EDI';    
            newCaseList[1].OwnerId = UserInfo.getUserId();
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest();

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<Case_Extension__c> caseexlst = new List<Case_Extension__c>([Select Id, Name, Case_object__c From Case_Extension__c Where Case_object__c =: caselst[0].Id]);
        system.assert(!caseexlst.isEmpty(), 'Case Extension should not be null');
    }
    
    @isTest
    static void afterUpdateMethod_caseExtensionProjectUFRPricing(){
        Test.startTest();
        try{
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id, FirstName, lastname From User Where id =: Label.DeniedPartyScreening_APIUser_ID];
        List<Case> oldCaseList; List<Case> newCaseList = new List<Case>();
        system.RunAs(usr){
            oldCaseList = SObjectFactory.build(1,Case.sObjectType);
                //caseExtensionProject - RT R&O - existing case extension - UFRPricing
                oldCaseList[0].Origin = 'Email';
                oldCaseList[0].Status = 'Open';
                oldCaseList[0].RecordTypeId = rtIdRepairOverhaul; //Label.Repair_Overhaul_RT_ID;
                oldCaseList[0].Description = 'SFDC Case for Notification';
                oldCaseList[0].Classification__c = 'R&O Issue';
                oldCaseList[0].ContactId = cont.Id;
                oldCaseList[0].AccountId = acct.Id;
                oldCaseList[0].vn_name__c = cont.id;
                oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
                oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
                
            insert oldCaseList;
            
            List<Z_Task__c> listZTask = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Z_Task__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Z_Task__c.Type__c => 'Z107 Order Information Required', 
                    Z_Task__c.Status__c => 'Open',
                    Z_Task__c.Long_Text__c => 'Long Text', 
                    Z_Task__c.New_Long_Text__c => 'New Long Text',
                    //Z_Task__c.Task_Closed__c => false, 
                    Z_Task__c.RelatedTo__c => oldCaseList[0].Id
                }
            );
            
            List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id,
                Case_Extension__c.UFR_SBU__c => 'ATR'
            }
        );
        }
        Set<Id> oldCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
        
        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].Type = 'PO Mismatch';
        newCaseList[0].Requestor_Email__c =  'gatotuka@in.ibm.com';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

        //Test.startTest();
            //try{
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
                List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<Case_Extension__c> caseexlst = new List<Case_Extension__c>([Select Id, Name, Case_object__c, Manual_Intervention_Last_Modified_Date__c From Case_Extension__c Where Case_object__c =: caselst[0].Id]);
        system.assert(!caseexlst.isEmpty(), 'Case Extension should not be null');
        }
        }catch(Exception e){}
        Test.stopTest();
        
    }
    
    static testMethod void afterUpdateMethod_caseExtensionProjectROI(){
        Test.startTest();
        try{
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        List<Case> oldCaseList; 
        User usr = [Select id, FirstName, lastname From User Where id =: Label.DeniedPartyScreening_APIUser_ID];
        List<Case> newCaseList = new List<Case>();
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        system.RunAs(usr){
            oldCaseList = SObjectFactory.build(1,Case.sObjectType);
                //caseExtensionProject - RT R&O - existing case extension - ROI
                oldCaseList[0].Origin = 'Email';
                oldCaseList[0].Status = 'Open';
                oldCaseList[0].RecordTypeId = rtIdRepairOverhaul;
                oldCaseList[0].Description = 'SFDC Case for Notification';
                oldCaseList[0].Classification__c = 'R&O Issue';
                oldCaseList[0].ContactId = cont.Id;
                oldCaseList[0].vn_name__c = cont.id;
                oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
                oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
                
            insert oldCaseList;
            
            Set<Id> oldCaseListIds = new Set<Id>();
            for(Case objId :oldCaseList){
                oldCaseListIds.add(objId.Id);
                newCaseList.add(objId);
            }
            //Query
            List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                        Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                        Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                        Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                        Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                        Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                        Description
                                                        From Case
                                                        where Id in :oldCaseListIds]);
            
            //Old Map
            for(Case objCase :oldCaseListQuery){
               oldCaseMap.put(objCase.Id,objCase); 
            }

            List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case_Extension__c.Name => oldCaseListQuery[0].CaseNumber+'_Ext', 
                    Case_Extension__c.Case_object__c => oldCaseListQuery[0].Id
                }
            );
            
            List<Z_Task__c> listZTask = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Z_Task__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Z_Task__c.Type__c => 'Z107 Order Information Required', 
                    Z_Task__c.Status__c => 'Open',
                    Z_Task__c.Long_Text__c => 'Long Text', 
                    Z_Task__c.New_Long_Text__c => 'New Long Text',
                    Z_Task__c.RelatedTo__c => oldCaseListQuery[0].Id
                }
            );
        }

        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].Requestor_Email__c =  'sumit1231.gupta@honeywell.com';
        newCaseList[0].OwnerId = UserInfo.getUserId();
        newCaseList[0].Description = 'SFDC Case for Notification';
        newCaseList[0].Classification__c = 'R&O Issue';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest(); 
                CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
                List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<Case_Extension__c> caseexlst = new List<Case_Extension__c>([Select Id, Name, Case_object__c, Manual_Intervention_Last_Modified_Date__c From Case_Extension__c Where Case_object__c =: caselst[0].Id]);
        system.assert(!caseexlst.isEmpty(), 'Case Extension should not be null');
        }
        }catch(Exception e){}
        Test.stopTest();
        
    }
    
    
   static testMethod void AOGbot_2(){    
            User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
            System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
            Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
    List<Case> Cas= SObjectFactory.build(1,Case.sObjectType);     
    cas[0].Origin = 'Email';
    cas[0].Status = 'Open';
    cas[0].Sub_Status__c = 'Order Processed';
    cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;
    cas[0].Type = 'AOG';
    cas[0].X4_Hour_AOG__c='24-hour';
    cas[0].AOG_Process_Type__c = 'Accelerated Repair';
    cas[0].Classification__c = 'CSO Spares';
    cas[0].ContactId = cont1.Id;
    cas[0].Type_of_Change__c = 'New Account';
    cas[0].Type = 'Other';
    cas[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
    cas[0].Government_Compliance_SM_M_Content__c = 'NO';
    cas[0].CreatedDate = system.Now().adddays(0);
    cas[0].OwnerId = UserInfo.getUserId();
    cas[0].subject='test subject';
    Insert cas;
    
       
    Sales_Order__c sales = new Sales_Order__c();
    sales.Sales_Order_Number__c = '123';
    sales.Case__c = cas[0].Id;
    sales.AWB__c ='222';
    sales.AWB_Sent__c = false ;
    sales.Delivery_Information__c = 'Delivered';
    sales.Delivered__c = false;
    sales.Line_Item__c = '10';
    sales.Customer_PO_RO_WO_Number__c = 'TestPO';
       
    insert sales;
    EmailMessage newEmail = new EmailMessage();
    newEmail.FromAddress='velmurugan.s@honeywell.com';
    newEmail.subject = 'Test Mail';
    newEmail.ToAddress = 'test@email.com';
    newEmail.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail.ParentId = cas[0].Id;
    newEmail.incoming = true;
    insert newEmail;
             Test.startTest();
    
    EmailMessage newEmail1 = new EmailMessage();
    newEmail1.FromAddress='velmurugan.s@honeywell.com';
    newEmail1.subject = 'Test Mail';
    newEmail1.ToAddress = 'test@email.com';
    newEmail1.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail1.ParentId = cas[0].Id;
    newEmail1.incoming = false;
    insert newEmail1;   
    
    Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :Cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber,Case_Record_Type__c, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Sub_Status__c = 'Pending Shipment';
    
    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber,Case_Record_Type__c, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.SendMailAfterSubStausChange(updatedCaseList,oldCaseMap);
    
   // system.assertequals(sales.Delivery_Information__c, 'Delivered');
   // system.assertequals(sales.Delivered__c, false);
    // system.assertequals(sales.Case__c , cas[0].id);
   } 
    Test.stopTest();
   }
static testMethod void ATT_BOTS_Core_Recovery_Test1()
   {
    Test.startTest();
    User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
    System.runAs(runUser){
        TriggerInactive.testTrigger = false;

        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];

        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        Profile pf = [select id from Profile where name = 'System Administrator'];

        Country__c contry = [Select id From Country__c Where Name =: 'USA' Limit 1];
        
        List<String> ReminderDateDiffstring = new List<String>();
            List<Integer> ReminderDateDiff = new List<Integer>();
        ReminderDateDiffstring =  label.Core_Recovery_Reminder_Date_Diff.Split(';');
        for(string diff:ReminderDateDiffstring)
        {
            ReminderDateDiff.add(Integer.valueOf(diff));
        }
        
        

        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                    User.Username => 'tu3cso@test.com',
                    User.Email => 'testuser3@test.com',
                    User.Alias => 'tu3',
                    User.CommunityNickname => 'tu3cso',
                    User.TimeZoneSidKey => 'America/Los_Angeles',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.ProfileId => pf.Id,
                    User.LanguageLocaleKey => 'en_US',
                    User.SBU_User__c => 'D&S',
                    User.Country__c => 'Canada'
                    }
        );

      List<Account> lstnewAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account New', 
                Account.Type => 'Honeywell',
                Account.Country__c => contry.Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy',
                Account.Business_Focal__c => cont1.Id,
                Account.Customer_Support_Focal__c => cont1.Id
            }
        );
        
           
            
           
        List<Case> cas= SObjectFactory.build(1,Case.sObjectType);     
        cas[0].Origin = 'Email';
        cas[0].Export_Compliance_Content_ITAR_EAR__c ='No';
        cas[0].Government_Compliance_SM_M_Content__c ='No';
        cas[0].Classification__c  = 'CSO Spares';
        cas[0].Status = 'Open';
        cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Core Recovery', 'Case').Id;
        cas[0].Order_Type__c ='Exchange';
        cas[0].Type_of_Shipment_del__c = 'Domestic';
        cas[0].ContactId = cont1.Id;
        cas[0].OwnerId = UserInfo.getUserId();
        cas[0].AccountId = lstnewAccount[0].Id;
        cas[0].CurrencyIsoCode = 'USD';
        cas[0].Subject = 'Core Recovery Testing';
        cas[0].Notes__c = 'temp';
        cas[0].Shipped_On__c = system.today();
        cas[0].Due_Date__c = system.today().addDays(ReminderDateDiff[0]);
    
        Insert cas;

    EmailMessage newEmail = new EmailMessage();
    newEmail.FromAddress='velmurugan.s@honeywell.com';
    newEmail.subject = 'First Reminder Mail';
    newEmail.ToAddress = 'test@email.com';
    newEmail.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail.ParentId = cas[0].Id;
    newEmail.incoming = false;
    insert newEmail;

Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
          
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c,Type_of_Shipment_del__c, Due_Date__c,Shipped_On__c,Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,
                                                    Sub_Class__c , Notes__c 
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Due_Date__c = system.today().addDays(ReminderDateDiff[1]);    
   

    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, Shipped_On__c,Type_of_Shipment_del__c,New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,
                                                     Sub_Class__c , Notes__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.CoreRecoverySendRemainder(updatedCaseList,oldCaseMap);
 
   } 
     Test.stopTest();
   }
   
   
        static testMethod void ATT_BOTS_Core_Recovery_Test2()
   {
    Test.startTest();
    User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
    System.runAs(runUser){
        TriggerInactive.testTrigger = false;

        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];

        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        Profile pf = [select id from Profile where name = 'System Administrator'];

        Country__c contry = [Select id From Country__c Where Name =: 'USA' Limit 1];
        
        List<String> ReminderDateDiffstring = new List<String>();
            List<Integer> ReminderDateDiff = new List<Integer>();
        ReminderDateDiffstring =  label.Core_Recovery_Reminder_Date_Diff.Split(';');
        for(string diff:ReminderDateDiffstring)
        {
            ReminderDateDiff.add(Integer.valueOf(diff));
        }

        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                    User.Username => 'tu3cso@test.com',
                    User.Email => 'testuser3@test.com',
                    User.Alias => 'tu3',
                    User.CommunityNickname => 'tu3cso',
                    User.TimeZoneSidKey => 'America/Los_Angeles',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.ProfileId => pf.Id,
                    User.LanguageLocaleKey => 'en_US',
                    User.SBU_User__c => 'D&S',
                    User.Country__c => 'Canada'
                    }
        );

      List<Account> lstnewAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account New', 
                Account.Type => 'Honeywell',
                Account.Country__c => contry.Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy',
                Account.Business_Focal__c => cont1.Id,
                Account.Customer_Support_Focal__c => cont1.Id
            }
        );
        
           
            
           
        List<Case> cas= SObjectFactory.build(1,Case.sObjectType);     
        cas[0].Origin = 'Email';
        cas[0].Export_Compliance_Content_ITAR_EAR__c ='No';
        cas[0].Government_Compliance_SM_M_Content__c ='No';
        cas[0].Classification__c  = 'CSO Spares';
        cas[0].Status = 'Open';
        cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Core Recovery', 'Case').Id;
        cas[0].Order_Type__c ='Exchange';
        cas[0].Type_of_Shipment_del__c = 'Domestic';
        cas[0].ContactId = cont1.Id;
        cas[0].OwnerId = UserInfo.getUserId();
        cas[0].AccountId = lstnewAccount[0].Id;
        cas[0].CurrencyIsoCode = 'USD';
        cas[0].Subject = 'Core Recovery Testing';
        cas[0].Notes__c = 'temp';
        cas[0].Shipped_On__c = system.today();
        cas[0].Due_Date__c = system.today().addDays(ReminderDateDiff[6]);
    
        Insert cas;

    EmailMessage newEmail = new EmailMessage();
    newEmail.FromAddress='velmurugan.s@honeywell.com';
    newEmail.subject = 'Final Notice Mail';
    newEmail.ToAddress = 'test@email.com';
    newEmail.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail.ParentId = cas[0].Id;
    newEmail.incoming = false;
    insert newEmail;



    EmailMessage newEmail1 = new EmailMessage();
    newEmail1.FromAddress='velmurugan.s@honeywell.com';
    newEmail1.subject = 'Second Reminder Mail';
    newEmail1.ToAddress = 'test@email.com';
    newEmail1.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail1.ParentId = cas[0].Id;
    newEmail1.incoming = false;
    insert newEmail1;

Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
          
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c,Type_of_Shipment_del__c, Due_Date__c,Shipped_On__c,Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,
                                                    Sub_Class__c , Notes__c 
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Due_Date__c = system.today().addDays(200);    
   

    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, Shipped_On__c,Type_of_Shipment_del__c,New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,
                                                     Sub_Class__c , Notes__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.CoreRecoverySendRemainder(updatedCaseList,oldCaseMap);
 
   } 
     Test.stopTest();
   }


    static testMethod void afterUpdateMethod_caseExtensionProjectPPO(){
        Test.startTest();
        try{
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdRepairOverhaul; //Label.Repair_Overhaul_RT_ID;
            oldCaseList[0].Description = 'SFDC Case for Notification';
            oldCaseList[0].Classification__c = 'R&O Issue';
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Aircraft_Name__c,Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseListQuery[0].CaseNumber+'_Ext',
                Case_Extension__c.SAP_SalesOrder_Status__c => 'ZRA',                
                Case_Extension__c.Case_object__c => oldCaseListQuery[0].Id
            }
        );
        
        List<Z_Task__c> listZTask = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Z_Task__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Z_Task__c.Type__c => 'Z107 Order Information Required', 
                Z_Task__c.Status__c => 'Open',
                Z_Task__c.Long_Text__c => 'Long Text', 
                Z_Task__c.New_Long_Text__c => 'New Long Text',
                Z_Task__c.RelatedTo__c => oldCaseListQuery[0].Id
            }
        );
        
        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].Requestor_Email__c =  'sumit1231.gupta@honeywell.com';
        newCaseList[0].OwnerId = Label.CSO_R_O_Team;
        newCaseList[0].Description = 'SFDC Case for Notification';
        newCaseList[0].Classification__c = 'R&O Issue';
        newCaseList[0].Subject = 'Case Credit';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,Aircraft_Name__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest(); 
                CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }catch(Exception e){}
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<Case_Extension__c> caseexlst = new List<Case_Extension__c>([Select Id, Name, Case_object__c, Manual_Intervention_Last_Modified_Date__c From Case_Extension__c Where Case_object__c =: caselst[0].Id]);
        system.assert(!caseexlst.isEmpty(), 'Case Extension should not be null');
        //system.assert(caseexlst[0].Manual_Intervention_Last_Modified_Date__c != null, 'Case Extension Manual_Intervention_Last_Modified_Date__c should not be null');    
    }
    
    //Test for fleetAssetDetails
    static testMethod void afterUpdateMethod_fleetAssetDetailsForCase(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            //caseExtensionProject - RT New Aircraft Dilivery
            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].status = 'Open';
            oldCaseList[0].Type = 'Web Portal Registration';
            oldCaseList[0].ContactId = cont.id;
            oldCaseList[0].AccountId = acct.id;
            oldCaseList[0].Product_Type__c = 'Services';
            oldCaseList[0].Catalog_Product_Group__c = 'Cabin(SV)';
            oldCaseList[0].Supported_Product__c = 'OneLink';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].RecordTypeId = rtIdNewAircraftDlvry;
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].ownerid = UserInfo.getUserId();
        newCaseList[0].status = 'Closed';
        newCaseList[0].Fleet_Asset_Aircraft_Number__c = 'a1O13000003znd8EAA';
        newCaseList[0].New_Account_Name__c = acct.id;
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest();

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<Fleet_Asset_Detail__c> fleetDetails = new List<Fleet_Asset_Detail__c>([Select id, Account__c From Fleet_Asset_Detail__c]);
        //system.assert(!fleetDetails.isEmpty(), 'Fleet_Asset_Detail__c should not be null');
        //system.assert(fleetDetails[0].Account__c != null, 'Fleet_Asset_Detail__c Account__c should not be null');    
    }
    
    //Test for caseForEfforlessOrders
    /*@isTest //(seeAllData = true)
        static void afterUpdateMethod_caseForEfforlessOrders(){
        TriggerInactive.testTrigger = false;
        User usr = [Select id, Email, Name From User Where id = :CaseServiceUtilitySprint4.getEffortlessUser()];
        usr.Email = 'gatotuka@in.ibm.com';
        update usr;
        system.debug('Efort User>>'+usr);
        
        User usr1 = [Select Id, Email, Name From User Where id = :lstUser[0].Id];
        system.debug('User list>'+usr1);
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            //caseExtensionProject - RT R&O - existing case extension - UFRPricing
            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].status = 'Open';
            oldCaseList[0].Type = 'Web Portal Registration';
            oldCaseList[0].ContactId = lstContact[0].id;
            oldCaseList[0].AccountId = lstnewAccount[0].id;
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].RecordTypeId = rtIdNewAircraftDlvry;
            oldCaseList[0].OwnerId = usr1.Id;
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, OwnerId__r.Email, OwnerId__r.Name
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
        
        List<Attachment> attList1 = SObjectFactory.build(3,Attachment.sObjectType);
            attList1[0].Name = 'Attachment 1';
            attList1[0].ParentId = oldCaseListQuery[0].Id;
            attList1[0].Body = Blob.valueOf('Unit Test Attachment Body');
            attList1[0].OwnerId = usr.Id;
            attList1[1].Name = 'Attachment 2';
            attList1[1].ParentId = oldCaseListQuery[0].Id;
            attList1[1].Body = Blob.valueOf('Unit Test Attachment Body');
            attList1[1].OwnerId = usr.Id;
            attList1[2].Name = 'Attachment 3';
            attList1[2].ParentId = oldCaseListQuery[0].Id;
            attList1[2].Body = Blob.valueOf('Unit Test Attachment Body');
            attList1[2].OwnerId = usr.Id;
        insert attList1;
        
        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].OwnerId = usr.Id;
        //newCaseList[0].OwnerId__r.Email = 'gatotuka@in.ibm.com';
        newCaseList[0].Sales_Order_Number__c = '0005640490';
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, OwnerId__r.Email, OwnerId__r.Name
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

        system.runAs(usr){
        Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        Test.stopTest();
        }
    }*/
   
    static testMethod void afterUpdateMethod_contactToolAccessUpdateProject(){    
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        portal_tools_master__c ptm = [Select Id,Name From portal_tools_master__c Where Name =: 'Test Tool1' Limit 1];
        ptm.Name = 'Company Administrator';
        update ptm;
        
        List<Contact_Tool_Access__c> lstContactTool = SObjectFactory.build(1,Contact_Tool_Access__c.sObjectType);

            lstContactTool[0].CRM_Contact_ID__c = cont1.id;
            lstContactTool[0].Portal_Honeywell_ID__c = 'test1';
            lstContactTool[0].Portal_Tool_Master__c = ptm.id;
            lstContactTool[0].name = ptm.name;
            lstContactTool[0].Request_Status__c = 'Pending';
                       
            insert lstContactTool;
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].status = 'Open';
            oldCaseList[0].Type = 'Web Portal Registration';
            oldCaseList[0].ContactId = cont1.id;
            oldCaseList[0].AccountId = acct.id;
            oldCaseList[0].Tool_Name__c = 'Company Administrator';
            oldCaseList[0].Tool_Comments__c = 'Test Comments';
            oldCaseList[0].Tool_Authorization_Method__c = 'HON approval';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].Honeywell_ID__c = 'test1';
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        
        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].ownerid = CaseServiceUtility.getGroupId('CSR_Online_Ordering_Approval','Queue'); //label.CSR_Online_Ordering_Approval_Queue;
        newCaseList[0].status = 'Open';
   
        update newCaseList;
        
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest();

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_contactToolAccessUpdateProject_1(){    
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        portal_tools_master__c ptm = [Select Id,Name From portal_tools_master__c Where Name =: 'Test Tool1' Limit 1];
        ptm.Name = 'Company Administrator';
        update ptm;
        
        List<Contact_Tool_Access__c> lstContactTool = SObjectFactory.build(1,Contact_Tool_Access__c.sObjectType);

            lstContactTool[0].CRM_Contact_ID__c = cont1.id;
            lstContactTool[0].Portal_Honeywell_ID__c = 'test1';
            lstContactTool[0].Portal_Tool_Master__c = ptm.id;
            lstContactTool[0].name = ptm.name;
            lstContactTool[0].Request_Status__c = 'Pending';
                       
            insert lstContactTool;
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].status = 'Open';
            oldCaseList[0].Type = 'Web Portal Registration';
            oldCaseList[0].ContactId = cont1.id;
            oldCaseList[0].AccountId = acct.id;
            oldCaseList[0].Tool_Name__c = 'Company Administrator';
            oldCaseList[0].Tool_Comments__c = 'Test Comments';
            oldCaseList[0].Tool_Authorization_Method__c = 'HON approval';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].Honeywell_ID__c = 'test1';
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        
        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].ownerid = CaseServiceUtility.getGroupId('CSR_Online_Ordering_Approval','Queue');  //label.CSR_Online_Ordering_Approval_Queue;
        newCaseList[0].status = 'Approved';
   
        update newCaseList;
        
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest();

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_contactToolAccessUpdateProject_2(){    
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        portal_tools_master__c ptm = [Select Id,Name From portal_tools_master__c Where Name =: 'Test Tool1' Limit 1];
        ptm.Name = 'Company Administrator';
        update ptm;
        
        List<Contact_Tool_Access__c> lstContactTool = SObjectFactory.build(1,Contact_Tool_Access__c.sObjectType);

            lstContactTool[0].CRM_Contact_ID__c = cont1.id;
            lstContactTool[0].Portal_Honeywell_ID__c = 'test1';
            lstContactTool[0].Portal_Tool_Master__c = ptm.id;
            lstContactTool[0].name = ptm.name;
            lstContactTool[0].Request_Status__c = 'Pending';
                       
            insert lstContactTool;
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].status = 'Open';
            oldCaseList[0].Type = 'Web Portal Registration';
            oldCaseList[0].ContactId = cont1.id;
            oldCaseList[0].AccountId = acct.id;
            oldCaseList[0].Tool_Name__c = 'Company Administrator';
            oldCaseList[0].Tool_Comments__c = 'Test Comments';
            oldCaseList[0].Tool_Authorization_Method__c = 'HON approval';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].Honeywell_ID__c = 'test1';
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        
        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'No';
        newCaseList[0].Government_Compliance_SM_M_Content__c = 'No';
        newCaseList[0].Sales_Order_Number__c = '0005640490';
        newCaseList[0].status = 'Denied';
        newCaseList[0].Resolution__c = 'testRes';
   
        update newCaseList;
        
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //Test.startTest(); 

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_contactToolAccessUpdateProject_RnoSAPCases(){
        //Test.startTest();
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        portal_tools_master__c ptm = [Select Id,Name From portal_tools_master__c Where Name =: 'Test Tool1' Limit 1];
        
        List<Portal_Honeywell_ID__c> listpotrtalHoneywell = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Portal_Honeywell_ID__c.sObjectType, new Map<Schema.SObjectField, Object> {
            Portal_Honeywell_ID__c.Contact__c => cont.id,
            Portal_Honeywell_ID__c.Name => 'test123'
            }
        );
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            //caseExtensionProject - RT R&O - existing case extension - UFRPricing
            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].status = 'Open';
            oldCaseList[0].Type = 'Web Portal Registration';
            oldCaseList[0].ContactId = cont.id;
            oldCaseList[0].AccountId = acct.id;
            oldCaseList[0].Tool_Name__c = 'Test Tool1';
            oldCaseList[0].Tool_Comments__c = 'Test Comments';
            oldCaseList[0].Tool_Authorization_Method__c = 'HON approval';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].Honeywell_ID__c = 'test123';
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

        newCaseList[0].Id = oldCaseList[0].Id;
        newCaseList[0].ownerid = CaseServiceUtility.getGroupId('CSR_Online_Ordering_Approval','Queue'); //label.CSR_Online_Ordering_Approval_Queue;
        newCaseList[0].status='Approved';
        newCaseList[0].RnOSAPCases__c = 1;
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        
        //Test.startTest();

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<Portal_Honeywell_ID__c> phid = new List<Portal_Honeywell_ID__c>([SELECT Id, Contact__c, User_Type__c FROM Portal_Honeywell_ID__c WHERE Contact__c = :caselst[0].ContactId]);
        system.assertEquals('CSR',phid[0].User_Type__c, 'Portal_Honeywell_ID__c User_Type__c is CSR');
    }
    /*
    static testMethod void afterUpdateMethod_createSurveyURL_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){      
        TriggerInactive.testTrigger = false;     
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);
            //RT : Web Support, Orders, Quotes, Returnns, ReturnsPRO, Engine Rentals, Invoice Disputes
            oldCaseList[0].RecordTypeId = rtIdinvoiceDisputes;
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

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
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
            newCaseList[0].RecordTypeId = rtIdinvoiceDisputes;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';     
            newCaseList[0].Type = 'Support';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdOEMQuoteOrders;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Type = 'Support';
            newCaseList[1].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList0 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
         
         List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);                                           

        //Test.startTest(); 

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList0,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList3,oldCaseMap);
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    */
    static testMethod void afterUpdateMethod_createSurveyURL_7(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;      
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];

        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            //RT : OEM Quotes Orders or Repair & Overhaul
            oldCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'On Hold';
            oldCaseList[0].Sub_Status__c = 'With Production team';
            oldCaseList[0].Quote_Number__c = 'My1234';
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].OwnerId = Userinfo.getUserId();
            oldCaseList[0].Reason_for_hold__c = 'Quote Approval';
                                    
            //RT : NavDB Accts
            oldCaseList[1].RecordTypeId = rtIdNavDBAccts;
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
            
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
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
            newCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdNavDBAccts;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Sub_Status__c = 'With Production team';
            newCaseList[1].Classification__c = 'General';
            newCaseList[1].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        
        List<Case> updatedCaseList4 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList7 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
        
                                                  
        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList4,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList7,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_createSurveyURL_8(){
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
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
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
        
        List<Case> updatedCaseList8 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList9 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
        
        List<Case> updatedCaseList10 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
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

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_createSurveyURL_9(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);
            
            //RT : FSS Activations
            oldCaseList[0].RecordTypeId = rtIdFSSActivation;
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
            
            //RT : FSS Technical Issue
            oldCaseList[1].RecordTypeId = rtIdFSStechIssue;
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
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
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
            newCaseList[0].RecordTypeId = rtIdFSSActivation;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdFSStechIssue;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        
        List<Case> updatedCaseList11 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList12 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
        
        //Test.startTest();    
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList11,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList12,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_createSurveyURL_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(4,Case.sObjectType);          
            //RT : FSS Accounts
            oldCaseList[0].RecordTypeId = rtIdFSSAccounts;
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
            
            //RT : JXSupport
            oldCaseList[1].RecordTypeId = rtIdJXSupport;
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
            
            //RT : FSS Teir I Support
            oldCaseList[2].RecordTypeId = rtIdFSSTierISupport;
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
            
            //RT : Flight Technical Services
            oldCaseList[3].RecordTypeId = rtIdFlightTechServices;
            oldCaseList[3].Origin = 'Email';
            oldCaseList[3].Status = 'Open';
            oldCaseList[3].Quote_Number__c = 'My1234';
            oldCaseList[3].ContactId = cont.Id;
            oldCaseList[3].vn_name__c = cont.id;
            oldCaseList[3].AccountId = acct.Id;
            oldCaseList[3].Type_of_Change__c = 'New Account';
            oldCaseList[3].Type = 'Other';
            oldCaseList[3].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[3].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[3].OwnerId = Userinfo.getUserId();

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
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
            newCaseList[0].RecordTypeId = rtIdFSSAccounts;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdJXSupport;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Resolution__c = 'case is closed';
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdFSSTierISupport;
            newCaseList[2].OwnerId = UserInfo.getUserId();
            newCaseList[2].Status = 'Done';
            newCaseList[2].Resolution__c = 'case is closed';
            
            newCaseList[3].Id = oldCaseList[3].Id;
            newCaseList[3].RecordTypeId = rtIdFlightTechServices;
            newCaseList[3].OwnerId = UserInfo.getUserId();
            newCaseList[3].Status = 'Done';
            newCaseList[3].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList13 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList14 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
        
        List<Case> updatedCaseList15 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[2].Id]);
                                                    
        List<Case> updatedCaseList16 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c,PFECN__c,Requested_By_HON_Internal__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[3].Id]);
                                                  
        //Test.startTest();    
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList13,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList14,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList15,oldCaseMap);
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList16,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_createSurveyURL_4(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);
            
            //RT : GDC Tech Issue
            oldCaseList[0].RecordTypeId = rtIdGDCTechIssue;
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
            
            //RT : GDC Call or GDC Operations Email
            oldCaseList[1].RecordTypeId = rtIdGDCCall;
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

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
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
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('GDC Tech Issue', 'Case').Id;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdGDCCall;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query                                           
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
         
                                                  
        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList1,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void afterUpdateMethod_createSurveyURL_2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select Id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        TriggerInactive.testTrigger = false;
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);
            
            //RT : GDC Tech Issue
            oldCaseList[0].RecordTypeId = rtIdGDCTechIssue;
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
            
            //RT : GDC Call or GDC Operations Email
            oldCaseList[1].RecordTypeId = rtIdGDCCall;
            oldCaseList[1].Origin = 'Web';
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

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, PFECN__c,Requested_By_HON_Internal__c,
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
            newCaseList[0].RecordTypeId = rtIdGDCTechIssue;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Resolution__c = 'case is closed';
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdGDCCall;
            newCaseList[1].OwnerId = UserInfo.getUserId();
            newCaseList[1].Status = 'Done';
            newCaseList[1].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query                                           
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, RecordTypeId, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
         
        system.debug('Case Details'+updatedCaseList2);                                       
        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList2,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
   static testMethod void afterUpdateMethod_createSurveyURL_5(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            //RT : Web Support
            oldCaseList[0].RecordTypeId = rtIdWebSupport;
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

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
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
            newCaseList[0].RecordTypeId = rtIdWebSupport;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Type = 'MyAero web portal issue';
            newCaseList[0].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query                                            
         List<Case> updatedCaseList5 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
                                                  
        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList5,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    static testMethod void afterUpdateMethod_createSurveyURL_6(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Set<Id> lstGroupIds = new Set<Id>{CaseServiceUtility.getGroupId('EBizWebOperations','Queue'),CaseServiceUtility.getGroupId('GDCTech','Queue'),CaseServiceUtility.getGroupId('GFO','Queue')};
        List<GroupMember> listgrm = [Select Id From GroupMember Where GroupId in: lstGroupIds];
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            
            //RT : GDC Tech Issue
            oldCaseList[0].RecordTypeId = rtIdGDCTechIssue;
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
            oldCaseList[0].OwnerId = usr.Id;            

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
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
            newCaseList[0].RecordTypeId = rtIdGDCTechIssue;
            newCaseList[0].OwnerId = usr.Id;
            newCaseList[0].Status = 'Done';
            newCaseList[0].Resolution__c = 'case is closed';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query                                           
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
                                                  
        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList1,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    //###############################################################################################################################################//
    static testMethod void testMethodCaseHandlerBeforeUpdate(){
        //Prepare test data for caseService.beforeUpdateCaseReopen<start> 
        List<Case> list_newCaseToReopen = new List<Case>();
        Set<Id> setCaseIds= new Set<Id>();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        //List<Case> list_newCaseToReopen = new List<Case>();
        List<Case> list_newCaseToDone = new List<Case>();
        List<Case> list_newCaseToOthers = new List<Case>();
        Map<ID,Case> newCaseMap = new Map<ID,Case>();
        Map<ID,Case> oldCaseMap = new Map<ID,Case>();
        //Set<Id> setCaseIds= new Set<Id>(); 
        //create case records for Reopen
        List<Case> list_oldCaseToReopen= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),                
                Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Quotes', 'Case').Id,
                Case.Expected_Update__c => system.now(),
                Case.status=> 'In Process'                               
            });
             List<Case> updatedCaseOldList = new List<Case>([Select Id, Escalated__c, Due_Date__c, Hon_Plant_Code_del__c, Escalation_Level__c, Escalated_On__c, Pega_Reason_for_Hold__c, Max_Escalation_Level_Reach__c , Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id = :list_oldCaseToReopen[0].Id]);
        //create old data in map
        for(case objCase : list_oldCaseToReopen){ 
            oldCaseMap.put(objCase.Id,objCase);
        }          

        //create new data in list and map for status= Re-open
        for(case objCase : list_oldCaseToReopen){
            objCase.status= 'Re-Open';
            list_newCaseToReopen.add(objCase);            
        }  
        update list_newCaseToReopen; 
                                Test.startTest();

        List<Case> updatedCaseNewList = new List<Case>([Select Id, Case_Comments__c,Hon_Plant_Code_del__c, Escalation_Level__c, Escalated__c, Escalated_On__c, Pega_Reason_for_Hold__c, Max_Escalation_Level_Reach__c ,Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id = :list_newCaseToReopen[0].Id]);
        //create new data in list and map for Status= Done
        for(case objCase : list_oldCaseToReopen){
            objCase.status= 'Done';
            list_newCaseToDone.add(objCase);           
        }  
        update list_newCaseToReopen;

        for(case objCase : list_newCaseToReopen){ 
            newCaseMap.put(objCase.Id,objCase);
        }           
        //create new data in list and map for Status= In-Work
        for(case objCase : list_oldCaseToReopen){
            objCase.status= 'In-Work';
            list_newCaseToOthers.add(objCase);           
        }  
        update list_newCaseToOthers;    
        //Prepare test data for caseService.beforeUpdateCaseReopen <end> 
        //Test.startTest();
            CaseHandler objCaseHandler = new CaseHandler(true,1); 
            objCaseHandler.onBeforeUpdate(updatedCaseOldList,updatedCaseNewList,newCaseMap,oldCaseMap);
        }
        Test.stopTest();
        for(Case objCase: list_newCaseToReopen){
            setCaseIds.add(objCase.Id);
        }
        for (case caseStatus : [SELECT Reopen_Status_Ended__c,status,Reopen_Status_Started__c FROM case WHERE Id IN :setCaseIds]){
            if(caseStatus.status.contains('Re-Open')){   
                system.assertEquals(caseStatus.Reopen_Status_Started__c , system.now());
                system.assertEquals(caseStatus.Reopen_Status_Ended__c , null);
            }
            else if(caseStatus.status.contains('Done') && caseStatus.Reopen_Status_Started__c!=null){               
                system.assertEquals(caseStatus.Reopen_Status_Ended__c, system.now());           
            } 
        }
    }
    //########################################################################################################################################//
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: closeCaseError
    ** Description : error while closing the case if does not belong to individual owner
    */
    static testMethod void closeCaseError(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
       TriggerInactive.testTrigger = false;
        Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();                                         
       try{
       listCaseCSMToolbox = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => aeroDefaultUserId,
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdCSMToolbox,
                Case.sub_class__c => 'Order Status',
                Case.status => 'Open'
            }
        );
        List<Task> lstTask = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Task.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Task.Status => 'Open',
                Task.whatId => listCaseCSMToolbox[0].Id
            }
        );
        
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :listCaseCSMToolbox){
            oldCaseMap.put(objCase.Id,objCase);
        }
        Boolean exceptionThrown;       
        List<Case> updatedCase = new List<Case>();
        for(Case objCase :listCaseCSMToolbox){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = aeroDefaultUserId;
            objtemCase.Status = 'Denied';
            objtemCase.resolution__c = 'Case is closed';
            objtemCase.recordtypeid = rtIdCSMToolbox;
            updatedCase.add(objtemCase);
        }
        update updatedCase;

        
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCase){
            newCaseMap.put(objCase.Id,objCase);
        }

       
            CaseHandler objCaseHandler = new CaseHandler (true,1);                          
            objCaseHandler.onBeforeUpdate(listCaseCSMToolbox,updatedCase,newCaseMap,oldCaseMap);
            }catch(Exception e){}
        }
        Test.stopTest(); 
        List<Case> caselst = new List<Case>([Select Id From Case]);
        //system.assert(!caselst.isEmpty(), 'Case should not be null');
   }
   
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateComplianceCase_InsertCompliance
    ** Description : Insert compliance case - before Update
    */
   static testMethod void beforeUpdateComplianceCase_InsertCompliance(){
       Test.startTest();
       User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
       TriggerInactive.testTrigger = false;
       listCaseOrder = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(), 
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOrders, 
                Case.sub_class__c => 'Order Status',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'
            }
        );
       List<Case> lstCaseOrderOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case 
                                                    where Id =:listCaseOrder[0].Id]);

       Map<Id,Case> oldCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :lstCaseOrderOld){
            oldCaseMapOrder.put(objCase.Id,objCase);
        }
       
        List<Case> updatedCaseOrder = new List<Case>();
        for(Case objCase :lstCaseOrderOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__C = 'CSO Spares';
            updatedCaseOrder.add(objtemCase);
        }
        update updatedCaseOrder;
       
       List<Case> newUpdatedCaseOrder = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case 
                                                    where Id =:updatedCaseOrder[0].Id]); 
        
       Map<Id,Case> newCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseOrder){
            newCaseMapOrder.put(objCase.Id,objCase);
        }
        
       //Test.startTest(); 
            CaseServiceOnUpdate.beforeUpdateComplianceCase(newUpdatedCaseOrder,oldCaseMapOrder,newCaseMapOrder);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');
       
   }
    
        /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateComplianceCase_InsertCompliance
    ** Description : Insert compliance case - before Update
    */
   static testMethod void beforeUpdateComplianceCase_InsertCompliance_2(){
       Test.startTest();
       User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseOEMQuote = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOEMQuoteOrders,
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.classification__c => 'CSO OEM',
                Case.Government_Compliance_SM_M_Content__c => 'No'
            }
        );
       
       List<Case> lstCaseOEMQuoteOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case 
                                                    where Id =:listCaseOEMQuote[0].Id]);
        
        
       Map<Id,Case> oldCaseMapOEM = new Map<Id,Case>();
        for(Case objCase :lstCaseOEMQuoteOld){
            oldCaseMapOEM.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseOEM = new List<Case>();
        for(Case objCase :lstCaseOEMQuoteOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.subject = 'Government';
            objtemCase.Type = 'Order Status';
            objtemCase.Origin = 'Phone';
            objtemCase.Service_Level_Status_Flag__c = 'Normal';
            objtemCase.Status = 'Open';
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__c = 'CSO OEM';
            updatedCaseOEM.add(objtemCase);
        }
        update updatedCaseOEM;
       
       List<Case> newUpdatedCaseOEM = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c,LastModifiedDate,Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case
                                                    where Id =:updatedCaseOEM[0].Id]);
        
        Map<Id,Case> newCaseMapOEM = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseOEM){
            newCaseMapOEM.put(objCase.Id,objCase);
        }
        
       //Test.startTest(); 
            CaseServiceOnUpdate.beforeUpdateComplianceCase(newUpdatedCaseOEM,oldCaseMapOEM,newCaseMapOEM);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');
       
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateComplianceCase_InsertCompliance_1
    ** Description : Insert compliance case - before Update
    */
    static testMethod void beforeUpdateComplianceCase_InsertCompliance_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Technical Issue',
                Case.recordtypeid => rtIdTechIssue,
                Case.classification__C => 'GTO Field Service',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'

            }
        );
        
        List<Case> lstCaseTechOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case
                                                    where Id =:listCaseTech[0].Id]);
        
        Map<Id,Case> oldCaseMapTech = new Map<Id,Case>();
        for(Case objCase :lstCaseTechOld){
            oldCaseMapTech.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseTech = new List<Case>();
        for(Case objCase :lstCaseTechOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__c = 'GTO Field Service';
            updatedCaseTech.add(objtemCase);
        }
        update updatedCaseTech;
        
        List<Case> newUpdatedCaseTech = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case
                                                    where Id =:updatedCaseTech[0].Id]);
        
        Map<Id,Case> newCaseMapTech = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseTech){
            newCaseMapTech.put(objCase.Id,objCase);
        }
        
        
       //Test.startTest(); 
             CaseServiceOnUpdate.beforeUpdateComplianceCase(newUpdatedCaseTech,oldCaseMapTech,newCaseMapTech);
             
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');   
   }
    
     /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateComplianceCase_InsertCompliance_1
    ** Description : Insert compliance case - before Update
    */
    static testMethod void beforeUpdateComplianceCase_InsertCompliance_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseRepair = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdRepairOverhaul,
                Case.Classification__c => 'CSO Repair/Overhaul',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'

            }
        );
        
        List<Case> lstCaseRepairOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case 
                                                    where Id =:listCaseRepair[0].Id]);
        
        Map<Id,Case> oldCaseMapRepair = new Map<Id,Case>();
        for(Case objCase :lstCaseRepairOld){
            oldCaseMapRepair.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseRepair = new List<Case>();
        for(Case objCase :lstCaseRepairOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.classification__c = 'CSO Repair/Overhaul';
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            updatedCaseRepair.add(objtemCase);
        }
        update updatedCaseRepair;
        
        List<Case> newUpdatedCaseRepair = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c
                                                    From Case 
                                                    where Id =:updatedCaseRepair[0].Id]);
        
        Map<Id,Case> newCaseMapRepair = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseRepair){
            newCaseMapRepair.put(objCase.Id,objCase);
        }
        
       //Test.startTest(); 
             CaseServiceOnUpdate.beforeUpdateComplianceCase(newUpdatedCaseRepair,oldCaseMapRepair,newCaseMapRepair);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');   
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateComplianceCase_DeleteCompliance
    ** Description : Delete compliance case - before Update
    */
   static testMethod void beforeUpdateComplianceCase_DeleteCompliance(){
       Test.startTest();
       User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
       TriggerInactive.testTrigger = false;
       Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];

       listCaseOrder = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(), 
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOrders, 
                Case.sub_class__c => 'Order Status',
                Case.AccountId => acct.Id,
                Case.Iscompliance__c => true,
                Case.Origin => 'Phone',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'Yes',
                Case.Government_Compliance_SM_M_Content__c => 'Yes'
            }
        );
       List<Case> lstCaseOrderOld = new List<Case>([Select Id, Hon_Plant_Code_del__c, Case_Comments__c, Escalation_Level__c, Escalated__c, Escalated_On__c, Pega_Reason_for_Hold__c, Max_Escalation_Level_Reach__c , Due_Date__c,Email_Subject_Value__c , Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, Contact_Name__c, CreatedById, Service_Level_Status_Flag__c,NPS_Recommend__c 
                                                    From Case
                                                    where Id =:listCaseOrder[0].Id]);
        
        List<Compliance_Case__c> listComplianceCase = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Compliance_Case__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Compliance_Case__c.Name => lstCaseOrderOld[0].CaseNumber,
                Compliance_Case__c.OwnerId => Userinfo.getUserId()
                
            }
        );

       Map<Id,Case> oldCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :lstCaseOrderOld){
            oldCaseMapOrder.put(objCase.Id,objCase);
        }
       
        List<Case> updatedCaseOrder = new List<Case>();
        for(Case objCase :lstCaseOrderOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Government_Compliance_SM_M_Content__c = 'No';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
            objtemCase.classification__C = 'CSO Spares';
            updatedCaseOrder.add(objtemCase);
        }
        update updatedCaseOrder;
       
       List<Case> newUpdatedCaseOrder = new List<Case>([Select Id, Case_Comments__c,Hon_Plant_Code_del__c, Escalation_Level__c, Escalated__c, Escalated_On__c, Pega_Reason_for_Hold__c, Max_Escalation_Level_Reach__c ,Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c,LastModifiedDate,Contact_Name__c, CreatedById, Service_Level_Status_Flag__c,NPS_Recommend__c
                                                    From Case
                                                    where Id =:updatedCaseOrder[0].Id]); 
        
       Map<Id,Case> newCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseOrder){
            newCaseMapOrder.put(objCase.Id,objCase);
        }
        
       //Test.startTest(); 
            CaseHandler objCaseHandler = new CaseHandler (true,1);
            objCaseHandler.onBeforeUpdate(listCaseOrder,newUpdatedCaseOrder,newCaseMapOrder,oldCaseMapOrder);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(caseCompliancelst.isEmpty(), 'Compliance_Case__c should be null');
       
   }
   
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateIsOwnerChanged
    ** Description : Is Owner Changed - before Update
    */
   static testMethod void beforeUpdateIsOwnerChanged(){
       Test.startTest();
       User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
       TriggerInactive.testTrigger = false;
       Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
       User usr = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];

       listCaseOrder = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(), 
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOrders, 
                Case.sub_class__c => 'Order Status',
                Case.AccountId => acct.Id,
                Case.Iscompliance__c => false,
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'
            }
        );
       List<Case> lstCaseOrderOld = new List<Case>([Select Id, Case_Comments__c,Hon_Plant_Code_del__c, Escalation_Level__c, Escalated__c, Escalated_On__c, Pega_Reason_for_Hold__c, Max_Escalation_Level_Reach__c , Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c,NPS_Recommend__c 
                                                    From Case
                                                    where Id =:listCaseOrder[0].Id]);

       Map<Id,Case> oldCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :lstCaseOrderOld){
            oldCaseMapOrder.put(objCase.Id,objCase);
        }
       
        List<Case> updatedCaseOrder = new List<Case>();
        for(Case objCase :lstCaseOrderOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Government_Compliance_SM_M_Content__c = 'No';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
            objtemCase.classification__C = 'CSO Spares';
            objtemCase.OwnerId = usr.Id;
            updatedCaseOrder.add(objtemCase);
        }
        update updatedCaseOrder;
       
       List<Case> newUpdatedCaseOrder = new List<Case>([Select Id,Case_Comments__c,Hon_Plant_Code_del__c, Escalation_Level__c, Escalated__c, Escalated_On__c, Pega_Reason_for_Hold__c, Max_Escalation_Level_Reach__c ,Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c,LastModifiedDate,Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c,NPS_Recommend__c
                                                    From Case
                                                    where Id =:updatedCaseOrder[0].Id]); 
        
       Map<Id,Case> newCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseOrder){
            newCaseMapOrder.put(objCase.Id,objCase);
        }
        //Test.startTest(); 
            CaseHandler objCaseHandler = new CaseHandler (true,1);                     
            objCaseHandler.onBeforeUpdate(lstCaseOrderOld,newUpdatedCaseOrder,newCaseMapOrder,oldCaseMapOrder);
        }
        Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber,IsOwnerChanged__c,OwnerId From Case]);
       system.debug('Case list>>'+caselst);
       system.assert(!caselst.isEmpty(), 'Case should not be null');      
   }
   
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: beforeUpdateIsMemberCompliance
    ** Description : Is Owner Member of Compliance - before Update
    */
   static testMethod void beforeUpdateIsMemberCompliance(){
       Test.startTest();
       User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
       TriggerInactive.testTrigger = false;
       listCaseOrder = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'), //lstgrpId[0].Id,
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOrders, 
                Case.sub_class__c => 'Order Status'
            }
        );
         List<Case> newUpdatedCase = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Aircraft_Name__c,Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c,LastModifiedDate,Contact_Name__c, CreatedById, Service_Level_Status_Flag__c,NPS_Recommend__c
                                                    From Case
                                                    where Id =:listCaseOrder[0].Id]);
        Map<Id,Case> oldCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :newUpdatedCase){
            oldCaseMapOrder.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseOrder = new List<Case>();
        for(Case objCase :newUpdatedCase){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = UserInfo.getUserId();
            updatedCaseOrder.add(objtemCase);
        }
        update updatedCaseOrder;
        
        Map<Id,Case> newCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :updatedCaseOrder){
            newCaseMapOrder.put(objCase.Id,objCase);
        }
                      
            //CaseHandler objCaseHandler = new CaseHandler (true,1);                      
            //objCaseHandler.onBeforeUpdate(newUpdatedCase,updatedCaseOrder,newCaseMapOrder,oldCaseMapOrder);
        }
        Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber,IsMemberOfCompliance__c From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
   }
   
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: updateComplianceCase
    ** Description : Update Compliance case
    */
   static testMethod void updateComplianceCase(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
       TriggerInactive.testTrigger = false;
       listCaseOrder = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(), 
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOrders, 
                Case.sub_class__c => 'Order Status',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'
            }
        );
       List<Case> lstCaseOrderOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:listCaseOrder[0].Id]);
       List<Compliance_Case__c> listComplianceCaseOrder = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Compliance_Case__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Compliance_Case__c.Name => lstCaseOrderOld[0].CaseNumber,
                Compliance_Case__c.OwnerId => Userinfo.getUserId()
                
            }
        );

       Map<Id,Case> oldCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :lstCaseOrderOld){
            oldCaseMapOrder.put(objCase.Id,objCase);
        }
       
        List<Case> updatedCaseOrder = new List<Case>();
        for(Case objCase :lstCaseOrderOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__C = 'CSO Spares';
            objtemCase.OwnerId = CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'); //lstgrpId1[0].Id;
            updatedCaseOrder.add(objtemCase);
        }
        update updatedCaseOrder;
       
       List<Case> newUpdatedCaseOrder = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:updatedCaseOrder[0].Id]); 
        
       Map<Id,Case> newCaseMapOrder = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseOrder){
            newCaseMapOrder.put(objCase.Id,objCase);
        }
        
        
       //Test.startTest(); 
             CaseServiceOnUpdate.updateComplianceCase(newUpdatedCaseOrder,oldCaseMapOrder,newCaseMapOrder);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');    
   }
   
   /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: updateComplianceCase
    ** Description : Update Compliance case
    */
   static testMethod void updateComplianceCase_2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseOEMQuote = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOEMQuoteOrders,
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.classification__c => 'CSO OEM',
                Case.Government_Compliance_SM_M_Content__c => 'No'
            }
        );
       
       List<Case> lstCaseOEMQuoteOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case
                                                    where Id =:listCaseOEMQuote[0].Id]);
        
       List<Compliance_Case__c> listComplianceCaseOEM = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Compliance_Case__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Compliance_Case__c.Name => lstCaseOEMQuoteOld[0].CaseNumber,
                Compliance_Case__c.OwnerId => Userinfo.getUserId()
                
            }
        );
        
       Map<Id,Case> oldCaseMapOEM = new Map<Id,Case>();
        for(Case objCase :lstCaseOEMQuoteOld){
            oldCaseMapOEM.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseOEM = new List<Case>();
        for(Case objCase :lstCaseOEMQuoteOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.subject = 'Government';
            objtemCase.Type = 'Order Status';
            objtemCase.Origin = 'Phone';
            objtemCase.Service_Level_Status_Flag__c = 'Normal';
            objtemCase.Status = 'Open';
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__c = 'CSO OEM';
            objtemCase.OwnerId = CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'); //lstgrpId1[0].Id;
            updatedCaseOEM.add(objtemCase);
        }
        update updatedCaseOEM;
       
       List<Case> newUpdatedCaseOEM = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:updatedCaseOEM[0].Id]);
        
        Map<Id,Case> newCaseMapOEM = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseOEM){
            newCaseMapOEM.put(objCase.Id,objCase);
        }
        
       //Test.startTest(); 
              CaseServiceOnUpdate.updateComplianceCase(newUpdatedCaseOEM,oldCaseMapOEM,newCaseMapOEM);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');    
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: updateComplianceCase_1
    ** Description : Update Compliance case
    */
    static testMethod void updateComplianceCase_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Technical Issue',
                Case.recordtypeid => rtIdTechIssue,
                Case.classification__C => 'GTO Field Service',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'

            }
        );
        
        List<Case> lstCaseTechOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c,NPS_Recommend__c 
                                                    From Case
                                                    where Id =:listCaseTech[0].Id]);
        
        List<Compliance_Case__c> listComplianceCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Compliance_Case__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Compliance_Case__c.Name => lstCaseTechOld[0].CaseNumber,
                Compliance_Case__c.OwnerId => Userinfo.getUserId()
                
            }
        );
        
        Map<Id,Case> oldCaseMapTech = new Map<Id,Case>();
        for(Case objCase :lstCaseTechOld){
            oldCaseMapTech.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseTech = new List<Case>();
        for(Case objCase :lstCaseTechOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__c = 'GTO Field Service';
            objtemCase.OwnerId = CaseServiceUtility.getGroupId('ComplianceQueueGTO','Queue');//lstgrpId1[1].Id;
            updatedCaseTech.add(objtemCase);
        }
        update updatedCaseTech;
        
        List<Case> newUpdatedCaseTech = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c,NPS_Recommend__c
                                                    From Case 
                                                    where Id =:updatedCaseTech[0].Id]);
        
        Map<Id,Case> newCaseMapTech = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseTech){
            newCaseMapTech.put(objCase.Id,objCase);
        }
                
       //Test.startTest(); 
            CaseServiceOnUpdate.updateComplianceCase(newUpdatedCaseTech,oldCaseMapTech,newCaseMapTech);
            //CaseServiceOnUpdate.NPSNeutralTaskCreation(newUpdatedCaseTech,oldCaseMapTech,newCaseMapTech);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');   
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: updateComplianceCase_1
    ** Description : Update Compliance case
    */
    static testMethod void updateComplianceCase_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseRepair = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdRepairOverhaul,
                Case.Classification__c => 'CSO Repair/Overhaul',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.Government_Compliance_SM_M_Content__c => 'No'

            }
        );
        
        List<Case> lstCaseRepairOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:listCaseRepair[0].Id]);
        
        List<Compliance_Case__c> listComplianceCaseRepair = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Compliance_Case__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Compliance_Case__c.Name => lstCaseRepairOld[0].CaseNumber,
                Compliance_Case__c.OwnerId => Userinfo.getUserId()
                
            }
        );
        
        Map<Id,Case> oldCaseMapRepair = new Map<Id,Case>();
        for(Case objCase :lstCaseRepairOld){
            oldCaseMapRepair.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseRepair = new List<Case>();
        for(Case objCase :lstCaseRepairOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.classification__c = 'CSO Repair/Overhaul';
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.OwnerId = CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'); //lstgrpId1[0].Id;
            updatedCaseRepair.add(objtemCase);
        }
        update updatedCaseRepair;
        
        List<Case> newUpdatedCaseRepair = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:updatedCaseRepair[0].Id]);
        
        Map<Id,Case> newCaseMapRepair = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseRepair){
            newCaseMapRepair.put(objCase.Id,objCase);
        }
        
       //Test.startTest(); 
            CaseServiceOnUpdate.updateComplianceCase(newUpdatedCaseRepair,oldCaseMapRepair,newCaseMapRepair);
        }
       Test.stopTest();
       List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
       Set<String> strCaseNumber = new Set<String>();
       for(Case cases:caselst){
           strCaseNumber.add(cases.CaseNumber);
       }
       List<Compliance_Case__c> caseCompliancelst = new List<Compliance_Case__c>([Select Id, Name From Compliance_Case__c where Name in :strCaseNumber]);      
       System.assert(!caseCompliancelst.isEmpty(), 'Compliance_Case__c should not be null');   
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: updateOwnerAndCaseAeroIds_UserCountryVerify
    ** Description : verify Owner's Country
    */
    static testMethod void updateOwnerAndCaseAeroIds_UserCountryVerify(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
       //User usr = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
       Profile adminProfile = [select id from Profile where name = 'System Administrator'];
       User usr =(User)SObjectFactory.create(
            User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO22',
                User.Username => 'tu2cso123@test.com',
                User.Email => 'test123@test.com',
                User.Alias => 'tu21',
                User.CommunityNickname => 'tu2cso123',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => adminProfile.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );
       listCaseDSClearing = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => usr.Id,
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdDSClearingHouse,
                Case.Classification__c => 'Tech Issue'
            }
        );
        
        List<Case> caseDSClearingOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, PreviousUser_Country__c
                                                    From Case 
                                                    where Id =:listCaseDSClearing[0].Id]);
                
        Map<Id,Case> oldCaseMapDS = new Map<Id,Case>();
        for(Case objCase :caseDSClearingOld){
            oldCaseMapDS.put(objCase.Id,objCase);
        }
        List<Case> updatedCaseDS = new List<Case>();
        for(Case objCase :listCaseDSClearing){
            Case objtemCase = new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = UserInfo.getUserId();
            objtemCase.Status = 'Open';
            objtemCase.Government_Compliance_SM_M_Content__c = 'No';
            objtemCase.classification__c = 'Tech Issue';
            updatedCaseDS.add(objtemCase);
        }
        update updatedCaseDS;
        
        List<Case> newUpdatedCaseDS = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, PreviousUser_Country__c
                                                    From Case 
                                                    where Id =:updatedCaseDS[0].Id]);
        Map<Id,Case> newCaseMapDS = new Map<Id,Case>();
        for(Case objCase :newUpdatedCaseDS){
            newCaseMapDS.put(objCase.Id,objCase);
        }
        
        //Test.startTest(); 
            CaseServiceOnUpdate.updateOwnerAndCaseAeroIds(newUpdatedCaseDS,oldCaseMapDS,newCaseMapDS);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,IsMemberOfCompliance__c From Case]);
       system.assert(!caselst.isEmpty(), 'Case should not be null');
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: updateOwnerAndCaseAeroIds_UpdateTask
    ** Description : update task owner
    */
    static testMethod void updateOwnerAndCaseAeroIds_UpdateTask(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();
       
       listCaseDSClearing = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'), //lstgrpId1[0].Id,
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdDSClearingHouse,
                Case.Classification__c => 'GTO Field Service',
                Case.Government_Compliance_SM_M_Content__c => 'Yes',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No'
            }
        );
        
        List<Task> lstTask = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Task.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Task.status => 'Open',
                Task.whatId => listCaseDSClearing[0].Id,
                Task.OwnerId => aeroDefaultUserId,
                Task.Subject => 'Test Case'
            }
        );
        
        Map<Id,Case> oldCaseMapDS = new Map<Id,Case>();
        for(Case objCase :listCaseDSClearing){
            oldCaseMapDS.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseDS = new List<Case>();
        for(Case objCase :listCaseDSClearing){
            Case objtemCase = new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = UserInfo.getUserId();
            objtemCase.Government_Compliance_SM_M_Content__c = 'No';
            objtemCase.classification__c = 'GTO Tech Operations Center';
            updatedCaseDS.add(objtemCase);
        }
        update updatedCaseDS;
        
        Map<Id,Case> newCaseMapDS = new Map<Id,Case>();
        for(Case objCase :updatedCaseDS){
            newCaseMapDS.put(objCase.Id,objCase);
        }
        
        //Test.startTest(); 
            CaseServiceOnUpdate.updateOwnerAndCaseAeroIds(updatedCaseDS,oldCaseMapDS,newCaseMapDS);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,IsMemberOfCompliance__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<Id> caseTasklst = new Set<Id>();
        for(Case cases:caselst){
            caseTasklst.add(cases.Id);
        }
        List<Task> tasklst = new List<Task>([Select Id, Task_OwnerChanged__c From Task Where whatid in :caseTasklst]);
        System.assert(!tasklst.isEmpty(), 'Task should not be null');
        System.assertEquals(true, tasklst[0].Task_OwnerChanged__c, 'Task Owner should changed'); 
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: afterUpdateProvideAccess_InsertReplace
    ** Description : Insert and Replace CaseShare for Tech issue - after update
    */
    static testMethod void afterUpdateProvideAccess_InsertReplace(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
       listCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'), //lstgrpId[0].Id,
                Case.Type => 'Technical Issue',
                Case.recordtypeid => rtIdTechIssue,
                Case.Classification__c => 'CSO Spares',
                Case.Status => 'Open',
                Case.Government_Compliance_SM_M_Content__c => 'No',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No'
            }
        );
        
        List<Case> caseTechOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, PreviousUser_Country__c
                                                    From Case
                                                    where Id =:listCaseTech[0].Id]);
        
        Map<Id,Case> oldCaseMapTech = new Map<Id,Case>();
        for(Case objCase :caseTechOld){
            oldCaseMapTech.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseTech = new List<Case>();
        for(Case objCase :caseTechOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = UserInfo.getUserId();
            objtemCase.recordtypeid = rtIdTechIssue;
            objtemCase.Status = 'Open';
            objtemCase.Government_Compliance_SM_M_Content__c = 'No';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
            objtemCase.classification__c = 'GTO Field Service';
            updatedCaseTech.add(objtemCase);
        }
        update updatedCaseTech;
        
        Map<Id,Case> newCaseMapTech = new Map<Id,Case>();
        for(Case objCase :updatedCaseTech){
            newCaseMapTech.put(objCase.Id,objCase);
        }
        
        List<CaseShare> lstCaseShare = SObjectFactory.create(
            CASE_COUNT_PROVIDE, CaseShare.sObjectType, new Map<Schema.SObjectField, Object>
            {
                CaseShare.CaseId => caseTechOld[0].Id,
                CaseShare.CaseAccessLevel => 'Edit',
                CaseShare.UserOrGroupId => CaseServiceUtility.getGroupId('CSO','Regular') //Label.CSO_GRP_ID
            }
        );

        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateProvideAccess(updatedCaseTech,oldCaseMapTech,newCaseMapTech);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        List<CaseShare> casesharelst = new List<CaseShare>([Select Id,CaseId,CaseAccessLevel,RowCause,IsDeleted,UserOrGroupId From CaseShare]);      
        System.assert(!casesharelst.isEmpty(), 'CaseShare should not be null');
        for(CaseShare csobj:casesharelst){
            System.assertEquals(caselst[0].Id,csobj.caseid,'CaseShare should contain case id');
            //System.assertNotEquals(CaseServiceUtility.getGroupId('CSO','Regular'),csobj.UserOrGroupId,'CaseShare UserOrGroupId should not contain CSO Id');
            //if(CaseServiceUtility.getGroupId('Tech_Issue','Regular') == csobj.UserOrGroupId){
                //System.assertEquals(CaseServiceUtility.getGroupId('Tech_Issue','Regular'),csobj.UserOrGroupId,'CaseShare UserOrGroupId should contain Tech Issue Id');
            //}
        }
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: afterUpdateProvideAccess_Insert
    ** Description : Insert CaseShare - after update
    */
    static testMethod void afterUpdateProvideAccess_Insert(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
       listCaseRepair = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => CaseServiceUtility.getGroupId('ComplianceQueueCSO','Queue'), //lstgrpId[0].Id,
                Case.Type => 'Technical Issue',
                Case.recordtypeid => rtIdRepairOverhaul,
                Case.Classification__c => 'CSO Spares',
                Case.Status => 'Open',
                Case.Government_Compliance_SM_M_Content__c => 'No',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No'
            }
        );
        
        List<Case> caseRepairOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:listCaseRepair[0].Id]);
        
        Map<Id,Case> oldCaseMapRepair = new Map<Id,Case>();
        for(Case objCase :caseRepairOld){
            oldCaseMapRepair.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseRepair = new List<Case>();
        for(Case objCase :caseRepairOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = UserInfo.getUserId();
            objtemCase.recordtypeid = rtIdRepairOverhaul;
            objtemCase.Status = 'Open';
            objtemCase.Government_Compliance_SM_M_Content__c = 'Undetermined';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
            objtemCase.classification__c = 'CSO Repair Order';
            updatedCaseRepair.add(objtemCase);
        }
        update updatedCaseRepair;
        
        Map<Id,Case> newCaseMapRepair = new Map<Id,Case>();
        for(Case objCase :updatedCaseRepair){
            newCaseMapRepair.put(objCase.Id,objCase);
        }

        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateProvideAccess(updatedCaseRepair,oldCaseMapRepair,newCaseMapRepair);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<Id> idCaseId = new Set<Id>();
        for(Case cases:caselst){
            idCaseId.add(cases.Id);
        }
        List<CaseShare> casesharelst = new List<CaseShare>([Select Id,CaseId,UserOrGroupId From CaseShare where CaseId in: idCaseId]);      
        System.assert(!casesharelst.isEmpty(), 'CaseShare should not be null');
        for(CaseShare csobj:casesharelst){
            System.assertEquals(caselst[0].Id,csobj.caseid,'CaseShare should contain case id');
            //if(CaseServiceUtility.getGroupId('CSO','Regular') == csobj.UserOrGroupId){
              //  System.assertEquals(CaseServiceUtility.getGroupId('CSO','Regular'),csobj.UserOrGroupId,'CaseShare UserOrGroupId should contain CSO Id');
           // }
        }
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: afterUpdateProvideAccess_Delete
    ** Description : Delete CaseShare - after update
    */
    static testMethod void afterUpdateProvideAccess_Delete(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        User usr = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
       
       listCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => usr.Id,
                Case.Type => 'Technical Issue',
                Case.recordtypeid => rtIdTechIssue,
                Case.Classification__c => 'CSO Spares',
                Case.Status => 'Open',
                Case.Government_Compliance_SM_M_Content__c => 'No',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No'
            }
        );
        
        List<Case> caseTechOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case
                                                    where Id =:listCaseTech[0].Id]);
        
        Map<Id,Case> oldCaseMapTech = new Map<Id,Case>();
        for(Case objCase :caseTechOld){
            oldCaseMapTech.put(objCase.Id,objCase);
        }
        
        List<Case> updatedCaseTech = new List<Case>();
        for(Case objCase :caseTechOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.OwnerId = CaseServiceUtility.getGroupId('ComplianceQueueGTO','Queue'); //lstgrpId[1].Id;
            objtemCase.recordtypeid = rtIdTechIssue;
            objtemCase.Status = 'Open';
            objtemCase.Government_Compliance_SM_M_Content__c = 'Yes';
            objtemCase.Export_Compliance_Content_ITAR_EAR__c = 'Yes';
            objtemCase.classification__c = 'GTO Field Service';
            updatedCaseTech.add(objtemCase);
        }
        update updatedCaseTech;
        
        Map<Id,Case> newCaseMapTech = new Map<Id,Case>();
        for(Case objCase :updatedCaseTech){
            newCaseMapTech.put(objCase.Id,objCase);
        }
        
        List<CaseShare> lstCaseShare = SObjectFactory.create(
            CASE_COUNT_PROVIDE, CaseShare.sObjectType, new Map<Schema.SObjectField, Object>
            {
                CaseShare.CaseId => caseTechOld[0].Id,
                CaseShare.CaseAccessLevel => 'Edit',
                CaseShare.UserOrGroupId => CaseServiceUtility.getGroupId('CSO','Regular') //Label.CSO_GRP_ID
            }
        );
        
        List<CaseShare> lstCaseShare2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, CaseShare.sObjectType, new Map<Schema.SObjectField, Object>
            {
                CaseShare.CaseId => caseTechOld[0].Id,
                CaseShare.CaseAccessLevel => 'Edit',
                CaseShare.UserOrGroupId => CaseServiceUtility.getGroupId('Tech_Issue','Regular') //Label.TechIssue_GRP_ID
            }
        );
        //Test.startTest(); 
            CaseServiceOnUpdate.afterUpdateProvideAccess(updatedCaseTech,oldCaseMapTech,newCaseMapTech);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<Id> idCaseId = new Set<Id>();
        for(Case cases:caselst){
            idCaseId.add(cases.Id);
        }
        List<CaseShare> casesharelst = new List<CaseShare>([Select Id,CaseId,UserOrGroupId From CaseShare where CaseId in: idCaseId]);      
        System.assert(!casesharelst.isEmpty(), 'CaseShare should not be null');
        for(CaseShare csobj:casesharelst){
            System.assertEquals(caselst[0].Id,csobj.CaseId,'CaseShare should contain case id');
            //System.assertNotEquals(CaseServiceUtility.getGroupId('CSO','Regular'),csobj.UserOrGroupId,'CaseShare UserOrGroupId should not contain CSO Id');
            //System.assertNotEquals(CaseServiceUtility.getGroupId('Tech_Issue','Regular'),csobj.UserOrGroupId,'CaseShare UserOrGroupId should not contain Tech Issue Id');
        }
   }
    
    /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: caseFSENameByAccountTeamMember_Update
    ** Description : insert FSE Name - After Update
    */
    static testMethod void caseFSENameByAccountTeamMember_Update(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Profile pf = [select id from Profile where name = 'System Administrator'];
        Country__c contry = [Select id From Country__c Where Name =: 'USA' Limit 1];
        User usr = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        Account acct = [Select id From Account Where Name =: 'Test Account' Limit 1];
        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                User.Username => 'tu3cso@test.com',
                User.Email => 'testuser3@test.com',
                User.Alias => 'tu3',
                User.CommunityNickname => 'tu3cso',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => pf.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );
        
         List<Account> lstnewAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account New', 
                Account.Type => 'Honeywell',
                Account.Country__c => contry.Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy'
            }
        );
        
        List<AccountTeamMember> lstATMnew = SObjectFactory.build(3,AccountTeamMember.sObjectType);
            lstATMnew[0].AccountId = lstnewAccount[0].Id;
            lstATMnew[0].UserId = usr.Id;
            lstATMnew[0].TeamMemberRole = 'Field Service Engineer (FSE)';
            
            lstATMnew[1].AccountId = lstnewAccount[0].Id;
            lstATMnew[1].UserId = lstUser2[0].Id;
            lstATMnew[1].TeamMemberRole = 'Field Service Manager';
            
            lstATMnew[2].AccountId = lstnewAccount[0].Id;
            lstATMnew[2].UserId = UserInfo.getUserId();
            lstATMnew[2].TeamMemberRole = 'Field Service Engineer (FSE)';
            
            insert lstATMnew;
        
        listCaseOEMQuote = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOEMQuoteOrders,
                Case.Expected_Update__c => System.Now(),
                Case.AOG__c => true,
                Case.AccountId => acct.Id
            }
        );
        
        List<Case> lstCaseOEMOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case 
                                                    where Id =:listCaseOEMQuote[0].Id]);
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :lstCaseOEMOld){
           oldCaseMap.put(objCase.Id,objCase); 
        }
        List<Case> updatedCases = new List<case>();
        for(Case objCase :lstCaseOEMOld){
            Case objtemCase= new case(); 
            objtemCase.Id = objCase.Id;
            objtemCase.Expected_Update__c = System.Now()+2;
            objtemCase.accountid = lstnewAccount[0].Id;
            objtemCase.OwnerId = UserInfo.getUserId();
            updatedCases.add(objtemCase); 
        }
        update updatedCases;
        List<Case> updatedCaseNew = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, Case_Record_Type__c
                                                    From Case
                                                    where Id =:updatedCases[0].Id]);
        
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseNew){
            newCaseMap.put(objCase.Id,objCase); 
        }

            List<id> accidlist = CaseServiceOnUpdate.beforeUpdateGetAccountIds(updatedCases,oldCaseMap,newCaseMap);
            CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(updatedCases,accidlist);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id, FSE_Name_1__c, FSE_Name_2__c, FSE_Name_3__c  From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        System.assertNotEquals(null,caselst[0].FSE_Name_1__c <> Null,'Case FSE_Name_1__c should not be null');
        System.assertNotEquals(null,caselst[0].FSE_Name_2__c <> Null,'Case FSE_Name_2__c should not be null');
        System.assertNotEquals(null,caselst[0].FSE_Name_3__c <> Null,'Case FSE_Name_3__c should not be null');
    }
    
    static testMethod void sendEmailMethod_MSPContract(){
    ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
    ftpsetting.Name = 'MigratorSettings';
    insert ftpsetting; 
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;      
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Contract> contractList = SObjectFactory.build(1,Contract.sObjectType);
            contractList[0].RecordTypeID = RecordTypeServices.getRecordTypeByName('HAPP/MPP Contracts','Contract').Id;
            contractList[0].AccountId = acct.Id;
            contractList[0].Renewal_Package_Sent__c = date.newinstance(2017,11,25);
            contractList[0].Renewal_Start_date__c = System.today();
            contractList[0].Renewal_Account_Name_Dealer__c = acct.Id;
            contractList[0].Renewal_End_Date__c = date.newinstance(2022,8,17);        
            contractList[0].Renewal_Customer__c = acct.Id;
            contractList[0].Renewal_Notes__c = 'Test Note';        
            contractList[0].Renewal_Order_Receipt_Name__c = cont.Id;
            contractList[0].Renewal_Fleet_Discount__c = '10%';
            contractList[0].Status = 'Pending Activation';
            contractList[0].Type__c = 'HAPP/MPP';
            contractList[0].StartDate = date.newinstance(2017,1,7);
            contractList[0].EndDate = date.newinstance(2012,8,17);
            insert contractList;
        

        List<Attachment> attchList = SObjectFactory.build(1,Attachment.sObjectType);    
            attchList[0].Name = 'Unit Test Attachment signed.pdf';
            Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
            attchList[0].body = bodyBlob;
            attchList[0].parentId = contractList[0].Id;
            insert attchList;

        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            //RT : MSP Contracts
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id;
            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].Sub_Status__c = 'Customer Profile Sent';
            oldCaseList[0].Quote_Number__c = 'My1234';
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].OwnerId = Userinfo.getUserId();
            oldCaseList[0].subject ='MSP Customer Profile';
            oldCaseList[0].serv_Contract__c = contractList[0].Id;
                 Test.startTest();
  
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
            
            
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Sub_Status__c = 'First Follow Up';
            newCaseList[0].Status = 'Done';
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
                                                  
        //Test.startTest(); 
         /* commented for echosign package uninstall SCTASK3090378
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
         end of SCTASK3090378
        */ 
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    //#############################Before Update Helper Class Test Class#######################################################################//
        
    static testMethod void myMaintainerProject(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Plant_Code_Master__c> listPlantCode = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Plant_Code_Master__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Plant_Code_Master__c.Name => 'Test Plant code Master', 
                Plant_Code_Master__c.SAP_Plant_Code__c => 'COMDEV05',
                Plant_Code_Master__c.Plant_Name__c => 'COMDEV05'
            }
        );
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdWebPortalRegistration;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdWebPortalRegistration;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Approved';
            newCaseList[0].Origin = 'Email';
            newCaseList[0].Subject = 'MYMAINTAINER support line';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].Plant__c = listPlantCode[0].Id;          
            newCaseList[0].OwnerId = UserInfo.getUserId();
            
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    Where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

  
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');        
    
    }

    static testMethod void sendBulkEmailSBUATR(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdDSClearingHouse;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
            oldCaseList[1].Origin = 'Email-EMS-Norcross';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = rtIdCSMToolbox;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(-1);
            
            oldCaseList[2].Origin = 'Email-EMS-Norcross';
            oldCaseList[2].Status = 'Open';
            oldCaseList[2].RecordTypeId = rtIdOEMQuoteOrders;
            oldCaseList[2].AccountId = acct.Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].CreatedDate = system.Now().adddays(-1);
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdOrders;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            newCaseList[0].Origin = 'Email';
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
            //newCaseList[0].LastModifiedDate = system.Now();
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdOrders;
            newCaseList[1].Type = 'Order Status';
            newCaseList[1].Status = 'Open';
            //newCaseList[1].Do_not_send_to_portal__c = False;
            newCaseList[1].Origin = 'Email';
            //newCaseList[1].SBU__c = 'ATR';
            newCaseList[1].Classification__c = 'EDI';
            newCaseList[1].OwnerId = UserInfo.getUserId();
            //newCaseList[1].LastModifiedDate = system.Now();
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdQuotes;
            newCaseList[2].Type = 'Quotes/Availability';
            newCaseList[2].Status = 'Open';
            //newCaseList[2].Do_not_send_to_portal__c = False;
            newCaseList[2].Origin = 'Email';
            //newCaseList[2].SBU__c = 'ATR';
            newCaseList[2].Classification__c = 'EDI';
            newCaseList[2].OwnerId = UserInfo.getUserId();
            //newCaseList[2].LastModifiedDate = system.Now();
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

  
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');        
    
    }
    static testMethod void sendBulkEmailForCEC(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdDSClearingHouse;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdOrders;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Done';
            newCaseList[0].Subject = 'From Hon.com CEC order status';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            newCaseList[0].Origin = 'Email';
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId(); 
            newCaseList[0].Sales_Order_Number__c = '0005640490';
            //newCaseList[0].LastModifiedDate = system.Now();

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }
    static testMethod void aircraftConnectivityProject1(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdFSStechIssue;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdFSStechIssue;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Origin = 'Email';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].Priority = 'Severity 1';
            newCaseList[0].OwnerId = UserInfo.getUserId();
            //newCaseList[0].LastModifiedDate= system.Now();
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        /*newCaseList[0].Priority = 'Severity 2';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
        newCaseList[0].Priority = 'Severity 3';
        update newCaseList;
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);*/

  
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');        
    
    }
    static testMethod void aircraftConnectivityProject2(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdFSStechIssue;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdFSStechIssue;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Origin = 'Email';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].Priority = 'Severity 1';
            newCaseList[0].OwnerId = UserInfo.getUserId();
            //newCaseList[0].LastModifiedDate= system.Now();
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        /*List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }*/
        
        newCaseList[0].Priority = 'Severity 2';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
        /*newCaseList[0].Priority = 'Severity 3';
        update newCaseList;
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);

  
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);*/
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');        
    
    }
    
    static testMethod void aircraftConnectivityProject3(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Email-EMS-Norcross';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdFSStechIssue;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdFSStechIssue;
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Origin = 'Email';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].Priority = 'Severity 1';
            newCaseList[0].OwnerId = UserInfo.getUserId();
            //newCaseList[0].LastModifiedDate= system.Now();
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        /*List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        newCaseList[0].Priority = 'Severity 2';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);*/
                                                    
        newCaseList[0].Priority = 'Severity 3';
        update newCaseList;
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);

  
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');        
    
    }
        static testMethod void workStremProject(){  
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
            oldCaseList[1].Origin = 'Web';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = rtIdReturns;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(-1);
            
            oldCaseList[2].Origin = 'Web';
            oldCaseList[2].Status = 'Open';
            oldCaseList[2].RecordTypeId = rtIdReturnsPRO;
            oldCaseList[2].AccountId = acct.Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].CreatedDate = system.Now().adddays(-1);
            oldCaseList[2].Due_Date__c = system.today();//23Dec19:added for the VR ResturnSPRO
            oldCaseList[2].Estimated_Resolution_Date__c  = system.today();//23Dec19:added for the VR ResturnSPRO
            
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = CaseServiceUtility.getGroupID('R_O_EMEAI_Mechanical','Queue');
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdReturns;
            newCaseList[1].Type = 'Order Changes';
            newCaseList[1].Status = 'Open';
            newCaseList[1].Classification__c = 'EDI';
            newCaseList[1].OwnerId = UserInfo.getUserId();
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdReturnsPRO;
            newCaseList[2].Type = 'Order Changes';
            newCaseList[2].Status = 'Open';
            newCaseList[2].Classification__c = 'EDI';
            newCaseList[2].OwnerId = UserInfo.getUserId();
            newCaseList[2].Due_Date__c = system.today();//23Dec19:added for the VR ResturnSPRO
            newCaseList[2].Estimated_Resolution_Date__c  = system.today();//23Dec19:added for the VR ResturnSPRO
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    
    }
    
        static testMethod void workStremProject_1(){    
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdOEMQuoteOrders;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            
            oldCaseList[1].Origin = 'Web';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = rtIdDSQuotesOrders;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(-1);
            
            oldCaseList[2].Origin = 'Web';
            oldCaseList[2].Status = 'Open';
            oldCaseList[2].RecordTypeId = rtIdQuotes;
            oldCaseList[2].AccountId = acct.Id;
            oldCaseList[2].ContactId = cont.Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdOEMQuoteOrders;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdDSQuotesOrders;
            newCaseList[1].Type = 'Order Changes';
            newCaseList[1].Status = 'Open';
            newCaseList[1].Classification__c = 'EDI';
            newCaseList[1].OwnerId = UserInfo.getUserId();
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdQuotes;
            newCaseList[2].Type = 'Order Changes';
            newCaseList[2].Status = 'Open';
            newCaseList[2].Classification__c = 'EDI';
            newCaseList[2].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    
    }
    
    static testMethod void aeroDefaultQuotesProject(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        try{  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdQuotes;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            oldCaseList[0].Classification__c = 'CSO Spares';

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdQuotes;
            newCaseList[0].Emailbox_Origin__c = 'Email-DIBBS_RFQ';
            newCaseList[0].Type = 'Place Order';
            newCaseList[0].Status = 'Open';
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        system.runAs(new User(id = CaseServiceUtility.getAreoDefaultUser())){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }catch(Exception e){}
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }
    static testMethod void chinaNationalAeroProject(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(3,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdQuotes;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            oldCaseList[0].Classification__c = 'EDI';
            oldCaseList[0].OwnerId = UserInfo.getUserId();

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdQuotes;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = usr.Id;
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    static testMethod void casesOnHold(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('D&S Discount Settings','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('D&S Discount Settings','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Pending further action';
            newCaseList[0].Reason_for_hold__c = 'Engineering Review Needed';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        newCaseList[0].Status = 'Done';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,newCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    
    }
    
    static testMethod void sysAdminProfileProject(){ 
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        Profile Prf = [select id from Profile where name = 'Standard User'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        List<User> lstUser = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test std user',
                User.Username => uniqueName + '@test' + orgId + '.org',
                User.Email => 'stdUser@test.com',
                User.Alias => 'std1',
                User.CommunityNickname => 'stdUser',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => Prf.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        system.runAs(new User(id = lstUser[0].Id)){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void sysAdminProfileProject_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Workstrem__c = 'Repair and Overhaul';
            newCaseList[0].CSM_Region__c = 'Americas';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Workstrem__c = 'Repair and Overhaul';
            newCaseList[0].CSM_Region__c = 'EMEAI';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
            newCaseList[0].Workstrem__c = 'Repair and Overhaul';
            newCaseList[0].CSM_Region__c = 'Asia/Pacific Rim';
        update newCaseList;
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        system.runAs(usr){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }
    
    static testMethod void sysAdminProfileProject_2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Workstrem__c = 'OEM';
            newCaseList[0].CSM_Region__c = 'Americas';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Workstrem__c = 'OEM';
            newCaseList[0].CSM_Region__c = 'EMEAI';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
            newCaseList[0].Workstrem__c = 'OEM';
            newCaseList[0].CSM_Region__c = 'Asia/Pacific Rim';
        update newCaseList;
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        system.runAs(usr){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }
    
    static testMethod void sysAdminProfileProject_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Workstrem__c = 'Spares';
            newCaseList[0].CSM_Region__c = 'Americas';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Workstrem__c = 'Spares';
            newCaseList[0].CSM_Region__c = 'EMEAI';
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
            newCaseList[0].Workstrem__c = 'Spares';
            newCaseList[0].CSM_Region__c = 'Asia/Pacific Rim';
        update newCaseList;
        
        /*List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);*/
        
        system.runAs(usr){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }
    
    static testMethod void sysAdminProfileProject_4(){
         Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        Profile Prf = [select id from Profile where name = 'Standard User'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        List<User> lstUser = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test std user',
                //User.Username => 'stdUser@test.com',
                User.Username => uniqueName + '@test' + orgId + '.org',
                User.Email => 'stdUser@test.com',
                User.Alias => 'std1',
                User.CommunityNickname => 'stdUser',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => Prf.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Workstrem__c = 'OEM';
            newCaseList[0].CSM_Region__c = 'Americas';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = CaseServiceUtility.getGroupID('OEM_Team','Queue');
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Workstrem__c = 'OEM';
            newCaseList[0].CSM_Region__c = 'Americas';
        update newCaseList;
        
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        system.runAs(new User(id = lstUser[0].Id)){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,newCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    
    static testMethod void closeCaseErrorGDC(){     
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        system.runAs(usr){
            List<GroupMember> lstgroup = SObjectFactory.build(1,GroupMember.sObjectType);
                lstgroup[0].GroupId = CaseServiceUtility.getGroupId('WIS','Regular');
                lstgroup[0].UserOrGroupId = usr.Id;
            insert lstgroup;
        }
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdGDCTechIssue;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdGDCTechIssue;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Reject';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'Datalink';
            newCaseList[0].OwnerId = usr.Id;
            //newCaseList[0].LastModifiedDate = system.Now();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        system.runAs(usr){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    static testMethod void sbuUpdateForAOG(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdAOG;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdAOG;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void sbuUpdateForExchange(){    //added for AOG/Spex Case Record Type Split
    
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdExchange;//FOUNDSNEHA
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdExchange;//FOUNDSNEHA
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void closeCaseOwnerBasedOnStatus(){        
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Emailbox_Origin__c = 'Email-R&O MechComponents';
            newCaseList[0].Status = 'Cancelled';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    /*static testMethod void caseErrorOnHistory(){
        Test.startTest();
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Platform__c> lstPlatform = SObjectFactory.build(1,Platform__c.sObjectType);
        lstPlatform[0].Name = 'Test Platform';
        lstPlatform[0].Platform_Type__c = 'Airplane';
        lstPlatform[0].Model__c = 'Test Model';
        lstPlatform[0].Make__c = 'Test Make';
        lstPlatform[0].Managing_SBU__c = 'ATR';
        insert lstPlatform; 
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdTechIssue;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<CaseHistory> lstCaseHistory = SObjectFactory.create(
            CASE_COUNT_PROVIDE, CaseHistory.sObjectType, new Map<Schema.SObjectField, Object>
            {
                CaseHistory.caseid => 'Status',
                CaseHistory.CaseId => oldCaseList[0].Id
            }
        );
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdTechIssue;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Done';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'Technical Issue';
            newCaseList[0].Aircraft_Type__c = lstPlatform[0].Id;
            newCaseList[0].OwnerId = usr.Id;
            //newCaseList[0].LastModifiedDate = system.Now();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }*/
    
    static testMethod void updateOnBehalfEndUserStatus_a(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Engineering Hold';
            newCaseList[0].Reason_for_hold__c = 'Engineering Review Needed';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Status = 'Closed';
        update newCaseList;
        
        /*List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
                                                    
            newCaseList[0].Status = 'Re-open';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap1 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap1.put(objCase.Id,objCase); 
        }
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Status = 'Closed';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap2 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList2){
           newCaseMap2.put(objCase.Id,objCase); 
        }
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap3 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList3){
           newCaseMap3.put(objCase.Id,objCase); 
        }*/

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,newCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,newCaseMap1);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,newCaseMap2);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    static testMethod void updateOnBehalfEndUserStatus_b(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Engineering Hold';
            newCaseList[0].Reason_for_hold__c = 'Engineering Review Needed';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        newCaseList[0].Status = 'Closed';
        update newCaseList;
        
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
                                                    
           /* newCaseList[0].Status = 'Re-open';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap1 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap1.put(objCase.Id,objCase); 
        }
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Status = 'Closed';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap2 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList2){
           newCaseMap2.put(objCase.Id,objCase); 
        }
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap3 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList3){
           newCaseMap3.put(objCase.Id,objCase); 
          }*/

            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,newCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,newCaseMap1);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,newCaseMap2);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    static testMethod void updateOnBehalfEndUserStatus_c(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Engineering Hold';
            newCaseList[0].Reason_for_hold__c = 'Engineering Review Needed';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        newCaseList[0].Status = 'Closed';
        update newCaseList;
        
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
                                                    
                                                    
            newCaseList[0].Status = 'Re-open';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap1 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap1.put(objCase.Id,objCase); 
        }
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Status = 'Closed';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap2 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList2){
           newCaseMap2.put(objCase.Id,objCase); 
        }
        
        /*List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap3 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList3){
           newCaseMap3.put(objCase.Id,objCase); 
          }*/

            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,newCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,newCaseMap1);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,newCaseMap2);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    static testMethod void updateOnBehalfEndUserStatus_d(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Engineering Hold';
            newCaseList[0].Reason_for_hold__c = 'Engineering Review Needed';
            newCaseList[0].Classification__c = 'EDI';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        newCaseList[0].Status = 'Closed';
        update newCaseList;
        
        /*List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);*/
                                                    
                                                    
            newCaseList[0].Status = 'Re-open';
        update newCaseList;
        //New Map
        /*Map<Id,Case> newCaseMap1 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap1.put(objCase.Id,objCase); 
        }*/
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Status = 'Closed';
        update newCaseList;
        //New Map
        Map<Id,Case> newCaseMap2 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList2){
           newCaseMap2.put(objCase.Id,objCase); 
        }
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap3 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList3){
           newCaseMap3.put(objCase.Id,objCase); 
          }

            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,newCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,newCaseMap1);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,newCaseMap2);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    static testMethod void updateOnBehalfEndUserStatus_1(){ 
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('EMS orders','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('EMS orders','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].OwnerId = CaseServiceUtility.getGroupID('Norcross_CSR_Team','Queue');
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap); 
        }           
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void updateOnBehalfEndUserStatus_2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('EMS orders','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].Origin = 'Email-EMS-Norcross';
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('EMS orders','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].OwnerId = CaseServiceUtility.getAreoDefaultUser();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }           
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void updateOnBehalfEndUserStatus_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id, Contact_Function__c from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        cont.Contact_Function__c = 'Airline';
        update cont;
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdGDCCall;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].ContactId = cont.Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].OwnerId = UserInfo.getUserId();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }           
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void updateOnBehalfEndUserStatus_4(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].Sub_Status__c = 'Rented';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Engine Rentals','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].Origin = 'Email-EMS-Norcross';
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Engine Rentals','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'In Repair';
            newCaseList[0].Reason_for_hold__c = 'Customer Requested Paperwork';
            newCaseList[0].Shipment_Sub_Status_Selected__c = system.Now();
            newCaseList[0].OwnerId = CaseServiceUtility.getAreoDefaultUser();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Status = 'Open';
            newCaseList[0].Sub_Status__c = 'DSO';
            newCaseList[0].Removal_Sub_Status_Selected__c = system.Now();
        update newCaseList;
        
        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap1 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList1){
           newCaseMap1.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Other';
            newCaseList[0].Reason_for_hold__c = 'Customer Requested Paperwork';
            newCaseList[0].DSO_Sub_Status_Selected__c = system.Now();
        update newCaseList;
        
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap2 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList2){
           newCaseMap2.put(objCase.Id,objCase); 
        }
        
            newCaseList[0].Status = 'Done';
            newCaseList[0].Sub_Status__c = '';
            newCaseList[0].Others_Sub_Status_Selected__c = system.Now();
        update newCaseList;
        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap3 = new Map<Id,Case>();
        for(Case objCase :updatedCaseList3){
           newCaseMap3.put(objCase.Id,objCase); 
        }
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,newCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,newCaseMap1);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,newCaseMap2);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void caseValueUpdate(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        try{
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
            
            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id;
            oldCaseList[0].OwnerId = CaseServiceUtility.getGroupID('D_S_Clearing_House','Queue');

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
            
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].OwnerId = CaseServiceUtility.getGroupID('DSPRQuotesTeam','Queue');
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        } catch(Exception e){}
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void caseValueUpdate_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdOrders;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        String userInId = CaseServiceUtility.getGroupID('R_O_Vendome_Order_Entry','Queue');
        List<Case_Matrix__c> lstCaseMatrix = SObjectFactory.build(1,Case_Matrix__c.sObjectType);

            lstCaseMatrix[0].repair_location__c = 'Vendome';
            lstCaseMatrix[0].Case__c = oldCaseList[0].Id;
            lstCaseMatrix[0].Classification__c = 'EDI';
            lstCaseMatrix[0].RecordTypeId__c = rtIdOrders;
            lstCaseMatrix[0].Type__c = 'Order Changes';
            lstCaseMatrix[0].OwnerId__c = userInId;

        insert lstCaseMatrix;
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdOrders;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Open';
            newCaseList[0].OwnerId = CaseServiceUtility.getGroupID('R_O_Vendome_Order_Entry','Queue');

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void autoCloseActivity(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdQuotes;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Task> lstTask = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Task.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Task.Status => 'Open',
                Task.whatId => oldCaseList[0].Id
            }
        );
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdQuotes;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Discard';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'CSO D&S Internal';
            newCaseList[0].OwnerId = usr.Id;
            //newCaseList[0].LastModifiedDate = system.Now();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    static testMethod void caseValueUpdateBaseOnOwner(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        List<R_O_Case_Reassignment_Queue__c> custSettingData = SObjectFactory.build(6,R_O_Case_Reassignment_Queue__c.sObjectType);
            custSettingData[0].Name = 'ATR OEM Airbus_Queue';
            custSettingData[0].Classification__c = '';
            custSettingData[0].Detail_Class__c = '';
            custSettingData[0].QueueId__c = '00Ga0000002svi9EAA';
            custSettingData[0].RecordTypeid__c = '';
            custSettingData[0].Repair_Location__c = '';
            custSettingData[0].Sub_Class__c = '';
            custSettingData[0].Type__c = '';
            
            custSettingData[1].Name = 'ATR OEM Boeing_Queue';
            custSettingData[1].Classification__c = '';
            custSettingData[1].Detail_Class__c = '';
            custSettingData[1].QueueId__c = '00Ga0000002sviEEAQ';
            custSettingData[1].RecordTypeid__c = '';
            custSettingData[1].Repair_Location__c = '';
            custSettingData[1].Sub_Class__c = '';
            custSettingData[1].Type__c = '';
            
            custSettingData[2].Name = 'ATR OEM Components_Queue';
            custSettingData[2].Classification__c = '';
            custSettingData[2].Detail_Class__c = '';
            custSettingData[2].QueueId__c = '00Ga0000002svi4EAA';
            custSettingData[2].RecordTypeid__c = '';
            custSettingData[2].Repair_Location__c = '';
            custSettingData[2].Sub_Class__c = '';
            custSettingData[2].Type__c = '';
            
            custSettingData[3].Name = 'CSO BGA OEM Team_Queue';
            custSettingData[3].Classification__c = 'CSO OEM – BGA';
            custSettingData[3].Detail_Class__c = '';
            custSettingData[3].QueueId__c = '';
            custSettingData[3].RecordTypeid__c = '012a0000001ZLs9AAG';
            custSettingData[3].Repair_Location__c = '';
            custSettingData[3].Sub_Class__c = '';
            custSettingData[3].Type__c = '';
            
            custSettingData[4].Name = 'R&O Quotes Team Escalation_Queue';
            custSettingData[4].Classification__c = 'R&O Quote';
            custSettingData[4].Detail_Class__c = '01230000000Zen5AAC';
            custSettingData[4].QueueId__c = '00Ga0000002smlOEAQ';
            custSettingData[4].RecordTypeid__c = '';
            custSettingData[4].Repair_Location__c = '';
            custSettingData[4].Sub_Class__c = 'Quotes COE - Escalation';
            custSettingData[4].Type__c = 'Quotes Escalation';
            
            custSettingData[5].Name = 'Secan Spares_Queue';
            custSettingData[5].Classification__c = 'CSO Repair/Overhaul';
            custSettingData[5].Detail_Class__c = '';
            custSettingData[5].QueueId__c = '00Ga0000002t0MDEAY';
            custSettingData[5].RecordTypeid__c = '012a0000001ZSXg';
            custSettingData[5].Repair_Location__c = 'Gennevilliers';
            custSettingData[5].Sub_Class__c = 'Secan';
            custSettingData[5].Type__c = 'Place Order';
            
        insert custSettingData;
        
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(6,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            oldCaseList[0].RnOSAPCases__c = 123456;
            
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(-1);
            oldCaseList[1].OwnerId = UserInfo.getUserId();
            oldCaseList[1].RnOSAPCases__c = 213456;
            
            oldCaseList[2].Origin = 'Email';
            oldCaseList[2].Status = 'Open';
            oldCaseList[2].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[2].AccountId = acct.Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].CreatedDate = system.Now().adddays(-1);
            oldCaseList[2].OwnerId = UserInfo.getUserId();
            oldCaseList[2].RnOSAPCases__c = 324561;
            
            oldCaseList[3].Origin = 'Email';
            oldCaseList[3].Status = 'Open';
            oldCaseList[3].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[3].AccountId = acct.Id;
            oldCaseList[3].Type_of_Change__c = 'New Account';
            oldCaseList[3].Type = 'Other';
            oldCaseList[3].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[3].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[3].CreatedDate = system.Now().adddays(-1);
            oldCaseList[3].OwnerId = UserInfo.getUserId();
            oldCaseList[3].RnOSAPCases__c = 45321;
            
            oldCaseList[4].Origin = 'Email';
            oldCaseList[4].Status = 'Open';
            oldCaseList[4].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[4].AccountId = acct.Id;
            oldCaseList[4].Type_of_Change__c = 'New Account';
            oldCaseList[4].Type = 'Other';
            oldCaseList[4].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[4].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[4].CreatedDate = system.Now().adddays(-1);
            oldCaseList[4].OwnerId = UserInfo.getUserId();
            oldCaseList[4].RnOSAPCases__c = 673452;
            
            oldCaseList[5].Origin = 'Email';
            oldCaseList[5].Status = 'Open';
            oldCaseList[5].RecordTypeId = rtIdRepairOverhaul;
            oldCaseList[5].AccountId = acct.Id;
            oldCaseList[5].Type_of_Change__c = 'New Account';
            oldCaseList[5].Type = 'Other';
            oldCaseList[5].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[5].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[5].CreatedDate = system.Now().adddays(-1);
            oldCaseList[5].OwnerId = UserInfo.getUserId();
            oldCaseList[5].RnOSAPCases__c = 86467;

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[0].Status = 'Open';
            newCaseList[0].RnOSAPCases__c = 123456;
            newCaseList[0].OwnerId = CaseServiceUtility.getGroupID('Secan_Spares','Queue');
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[1].Status = 'Open';
            newCaseList[1].RnOSAPCases__c = 213456;
            newCaseList[1].OwnerId = CaseServiceUtility.getGroupID('ATR_OEM_Components','Queue');
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[2].Status = 'Open';
            newCaseList[2].RnOSAPCases__c = 324561;
            newCaseList[2].OwnerId = CaseServiceUtility.getGroupID('ATR_OEM_Boeing','Queue');
            
            newCaseList[3].Id = oldCaseList[3].Id;
            newCaseList[3].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[3].Status = 'Open';
            newCaseList[3].RnOSAPCases__c = 45321;
            newCaseList[3].OwnerId = CaseServiceUtility.getGroupID('ATR_OEM_Airbus','Queue');
            
            newCaseList[4].Id = oldCaseList[4].Id;
            newCaseList[4].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[4].Status = 'Open';
            newCaseList[4].RnOSAPCases__c = 673452;
            newCaseList[4].OwnerId = CaseServiceUtility.getGroupID('CSO_BGA_OEM_Team','Queue');
            
            newCaseList[5].Id = oldCaseList[5].Id;
            newCaseList[5].RecordTypeId = rtIdRepairOverhaul;
            newCaseList[5].Status = 'Open';
            newCaseList[5].Priority = 'Low';
            newCaseList[5].RnOSAPCases__c = 86467;
            newCaseList[5].OwnerId = CaseServiceUtility.getGroupID('R_O_Quotes_Team_Escalation','Queue');

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }
    
    static testMethod void portalAutoclose(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdQuotes;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            oldCaseList[0].OwnerId = CaseServiceUtility.getGroupID('Portal_Quotes','Queue');

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        List<Case_Line_Item__c> listCaseLineItem = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Line_Item__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Line_Item__c.Case_Number__c => oldCaseList[0].Id,
                Case_Line_Item__c.RecordTypeId => RecordTypeServices.getRecordTypeByName('Quotes','Case_Line_Item__c').Id,
                Case_Line_Item__c.Comment__c => 'Price dont required',
                Case_Line_Item__c.Price__c => 65000.00
            }
        );
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdQuotes;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'Re-Open';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'CSO D&S Internal';
            newCaseList[0].OwnerId = usr.Id;
            //newCaseList[0].LastModifiedDate = system.Now();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    static testMethod void errorHWInternalActions(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        User usr = [Select id from User where Username =: 'tu2cso@test.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);

            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = rtIdDSQuotesOrders;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(-1);
            oldCaseList[0].Classification__c = 'CSO D&S Internal';
            oldCaseList[0].OwnerId = UserInfo.getUserId();

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => oldCaseList[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => oldCaseList[0].Id
            }
        );
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdDSQuotesOrders;
            newCaseList[0].Type = 'Order Changes';
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Engineering Hold';
            newCaseList[0].Reason_for_hold__c = 'Engineering Review Needed';
            //newCaseList[0].Do_not_send_to_portal__c = False;
            //newCaseList[0].SBU__c = 'ATR';
            newCaseList[0].Classification__c = 'CSO D&S Internal';
            newCaseList[0].OwnerId = usr.Id;
            //newCaseList[0].LastModifiedDate = system.Now();
        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void casePreventCreation(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(6,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();


        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].SuppliedEmail = 'test@triumphgroup.com';
            newCaseList[0].Emailbox_Origin__c = 'Email-Order Status';
            newCaseList[0].ownerid = CaseServiceUtility.getAreoDefaultUser();
            //newCaseList[0].PreventCloseonupdate__c = 0;

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void casePreventCreation_1(){
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(6,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            oldCaseList[0].Classification__c = 'CSO Spares';


        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
        Test.startTest();

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-Order Changes';
            // newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].Ownerid = CaseServiceUtility.getGroupID('BFE_Fastlane','Queue');
            newCaseList[0].Subject = 'BFE orders';

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    /*static testMethod void casePreventCreation_2(){
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(6,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            oldCaseList[0].Classification__c = 'CSO Spares';


        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-Bournemouth Repairs';
            // newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].Ownerid = CaseServiceUtility.getGroupID('CSOROTeam','Queue');
            newCaseList[0].Subject = 'BFE orders';

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Emailbox_Origin__c = 'Email-Yeovil Repairs';
        update newCaseList;

        List<Case> updatedCaseList1 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Emailbox_Origin__c = 'Email-Raunheim';
        update newCaseList;
 
        List<Case> updatedCaseList2 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Emailbox_Origin__c = 'Email-Edinburgh';
        update newCaseList;
        Test.startTest();        
        List<Case> updatedCaseList3 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, 
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Emailbox_Origin__c = 'Email-Garden Grove';
        update newCaseList;

        List<Case> updatedCaseList4 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, 
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
        
            newCaseList[0].Emailbox_Origin__c = 'Email-AVSAT Orders';
        update newCaseList;
        
        List<Case> updatedCaseList5 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
            
            newCaseList[0].Emailbox_Origin__c = 'Email-AeroBizSupport';
            newCaseList[0].Subject = 'NORMAL - BFE orders';
        update newCaseList;
        
        List<Case> updatedCaseList6 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id =: newCaseList[0].Id]);
            
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList1,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList2,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList3,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList4,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList5,oldCaseMap);
            //CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList6,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    */
    static testMethod void casePreventCreation_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Account acct1 = [Select Id From Account Where Name =: 'Test Account D&S' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(4,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(0);
            oldCaseList[1].OwnerId = UserInfo.getUserId();
            
            oldCaseList[2].Origin = 'Email';
            oldCaseList[2].Status = 'Open';
            oldCaseList[2].RecordTypeId = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
            oldCaseList[2].AccountId = acct1.Id;
            oldCaseList[2].ContactId = cont.Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].CreatedDate = system.Now().adddays(0);
            oldCaseList[2].OwnerId = UserInfo.getUserId();
            
            oldCaseList[3].Origin = 'Email';
            oldCaseList[3].Status = 'Open';
            oldCaseList[3].RecordTypeId = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
            oldCaseList[3].AccountId = acct.Id;
            oldCaseList[3].ContactId = cont.Id;
            oldCaseList[3].Type_of_Change__c = 'New Account';
            oldCaseList[3].Type = 'Other';
            oldCaseList[3].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[3].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[3].CreatedDate = system.Now().adddays(0);
            oldCaseList[3].OwnerId = UserInfo.getUserId();

        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, 
                                                    PFECN__c, Account_Concierge__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-CSO BGA Spares';
           // newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;
            newCaseList[1].Status = 'Open';
            newCaseList[1].Emailbox_Origin__c = 'Email-NavDB';
            // newCaseList[1].PreventCloseonupdate__c = 0;
            newCaseList[1].of_Open_Activity__c = 0;
            newCaseList[1].Subject = 'OneNav Orders';
            newCaseList[1].OwnerId = CaseServiceUtility.getAreoDefaultUser();
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
            newCaseList[2].Status = 'Open';
            newCaseList[2].Emailbox_Origin__c = 'Email-olatheservicecenter';
           // newCaseList[2].PreventCloseonupdate__c = 0;
            newCaseList[2].of_Open_Activity__c = 0;
            newCaseList[2].OwnerId = CaseServiceUtility.getAreoDefaultUser();
            
            newCaseList[3].Id = oldCaseList[3].Id;
            newCaseList[3].RecordTypeId = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
            newCaseList[3].Status = 'Open';
            newCaseList[3].Emailbox_Origin__c = 'Email-olatheservicecenter';
            //newCaseList[3].PreventCloseonupdate__c = 0;
            newCaseList[3].of_Open_Activity__c = 0;
            newCaseList[3].OwnerId = CaseServiceUtility.getAreoDefaultUser();

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
            
        
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void casePreventCreation_4(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Account acct1 = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            oldCaseList[1].AccountId = acct1.Id;
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(0);
            oldCaseList[1].OwnerId = UserInfo.getUserId();
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-CSO BGA Spares';
            // newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].OwnerId = CaseServiceUtility.getAreoDefaultUser();
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            newCaseList[1].Status = 'Open';
            newCaseList[1].Emailbox_Origin__c = 'Email-Order Status';
            // newCaseList[1].PreventCloseonupdate__c = 0;
            newCaseList[1].of_Open_Activity__c = 0;
            newCaseList[1].OwnerId = CaseServiceUtility.getAreoDefaultUser();

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
            
        system.runAs(new User(id = CaseServiceUtility.getAreoDefaultUser())){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    static testMethod void casePreventCreation_5(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].Origin = 'Email';
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-Quotes';
            //newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].SuppliedEmail = 'test@linmarr.com';
            newCaseList[0].OwnerId = CaseServiceUtility.getAreoDefaultUser();

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
            
        system.runAs(new User(id = CaseServiceUtility.getAreoDefaultUser())){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
   
   /* static testMethod void casePreventCreation_6(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Account acct1 = [Select Id From Account Where Name =: 'Test Account BGA' Limit 1];
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            oldCaseList[1].AccountId = acct1.Id;
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(0);
            oldCaseList[1].OwnerId = UserInfo.getUserId();
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-Quotes';
            // newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].OwnerId = CaseServiceUtility.getAreoDefaultUser();
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].Origin = 'Email';
            newCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            newCaseList[1].Status = 'Open';
            newCaseList[1].Emailbox_Origin__c = 'Email-CSO BGA Spares';
           //  newCaseList[1].PreventCloseonupdate__c = 0;
            newCaseList[1].of_Open_Activity__c = 0;
            newCaseList[1].SuppliedEmail = 'test@linmarr.com';
            newCaseList[1].OwnerId = CaseServiceUtility.getAreoDefaultUser();

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
            
        system.runAs(new User(id = CaseServiceUtility.getAreoDefaultUser())){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
    }*/
    
    static testMethod void casePreventCreation_7(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;       
        Account acct = [Select Id,Orders_Next_Wave__c, Orders_Next_Wave_Check_Time__c, CreatedDate 
                        From Account Where Name =: 'Test Account'];
        acct.Do_Not_Send_to_Portal__c = true;
        acct.Orders_Next_Wave__c = true;
        acct.Orders_Next_Wave_Check_Time__c = system.Now().adddays(-35);
        update acct;

        Contact cont = [Select id,AccountId,Primary_Email_Address__c from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        cont.AccountId = acct.Id;
        update cont;
        
        List<Case> oldCaseList = SObjectFactory.build(2,Case.sObjectType);

            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].CreatedDate = system.Now().adddays(0);
            oldCaseList[0].OwnerId = UserInfo.getUserId();
            
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'Open';
            oldCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            oldCaseList[1].AccountId = acct.Id;
            oldCaseList[1].ContactId = cont.Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].CreatedDate = system.Now().adddays(0);
            oldCaseList[1].OwnerId = UserInfo.getUserId();
            
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].Origin = 'Email';
            newCaseList[0].AccountId = acct.Id;
            newCaseList[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            newCaseList[0].Status = 'Open';
            newCaseList[0].Emailbox_Origin__c = 'Email-Quotes';
           // newCaseList[0].PreventCloseonupdate__c = 0;
            newCaseList[0].of_Open_Activity__c = 0;
            newCaseList[0].OwnerId = CaseServiceUtility.getAreoDefaultUser();
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].Origin = 'Email';
            newCaseList[1].AccountId = acct.Id;
            newCaseList[1].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            newCaseList[1].Status = 'Open';
            newCaseList[1].Emailbox_Origin__c = 'Email-Orders';
           // newCaseList[1].PreventCloseonupdate__c = 0;
            newCaseList[1].of_Open_Activity__c = 0;
            newCaseList[1].OwnerId = CaseServiceUtility.getAreoDefaultUser();

        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c
                                                    From Case
                                                    where Id in : newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
            
        system.runAs(new User(id = CaseServiceUtility.getAreoDefaultUser())){
            CaseServiceOnUpdate.beforeUpdateMethod(updatedCaseList,oldCaseMap);
        }
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');

    }
    
    
    //############
    static testMethod void UserCountryVerify2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
       User usr = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
       
       listCaseDSClearing = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => usr.Id,
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdDSClearingHouse,
                Case.Classification__c => 'Tech Issue',
                Case.Government_Compliance_SM_M_Content__c => 'Yes'
            }
        );       
        List<Case> caseDSClearingOld = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c, 
                                                    Case_Record_Type__c, PreviousUser_Country__c
                                                    From Case 
                                                    where Id =:listCaseDSClearing[0].Id]);                
        Map<Id,Case> oldCaseMapDS = new Map<Id,Case>();
        for(Case objCase :caseDSClearingOld){
            oldCaseMapDS.put(objCase.Id,objCase);
        }
        Map<Id,Case> newCaseMapDS = new Map<Id,Case>();
        for(Case objCase :caseDSClearingOld){
            objCase.OwnerId = UserInfo.getUserId();
            newCaseMapDS.put(objCase.Id,objCase);
        }
        CaseServiceOnUpdate.updateOwnerAndCaseAeroIds(listCaseDSClearing ,oldCaseMapDS,newCaseMapDS);
        }
        Test.stopTest();       
    }
    
 static testMethod void SendMailAfterSubStausChange(){
        User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;  
        Contact cont = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        List<Case> oldCaseList = SObjectFactory.build(1,Case.sObjectType);
        
        
        Sales_Order__c sales = new Sales_Order__c();
        Product2 prod = new Product2();
        EmailMessage em = new EmailMessage();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id MailTemplate = '00X3C000000m96a';
        string parentid = null;
        string contactid = null;
        Boolean IsUpdated=false; 
        Boolean Ischange = false;

            
        oldCaseList[0].Status = 'Open';
        oldCaseList[0].Sub_Status__c = 'Order Processed';
        oldCaseList[0].RecordTypeId = '01230000000ZemyAAC';
        oldCaseList[0].recordtypeid = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;

        oldCaseList[0].subject= 'test subject';
        insert oldCaseList;
        
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }

        
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, Shipment_Sub_Status_Selected__c,
                                                    Account_Concierge__c,LastModifiedById
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }

            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = '01230000000ZemyAAC';
            newCaseList[0].Status = 'Open';
            newCaseList[0].Sub_Status__c = 'Delivered';
           // newCaseList[0].LastModifiedById = oldCaseList[0].LastModifiedById;
            newCaseList[0].recordtypeid = RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id;
            
            
         Test.startTest();
           
            sales.Sales_Order_Number__c = '123';
            sales.Case__c = oldCaseList[0].Id;
            sales.AWB__c ='222';
            sales.AWB_Sent__c = false ;
            sales.Line_Item__c = '10';
            sales.Customer_PO_RO_WO_Number__c = 'TestPO';
           
            sales.Delivery_Information__c = 'Delivered';
            sales.Delivered__c = false;
            
            insert sales;
            
            em.ToAddress ='test@honeywell.com';
            em.FromAddress = 'vel@honeywell.com';
            em.CcAddress = 'hello@honeywell.com';
            em.MessageDate = Date.newInstance(2016, 12, 9);
            em.ParentId = oldCaseList[0].Id;
            em.subject='test subject';
            insert em;
            
        
            
            
           

        
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
            }
List<Case> updatedCaseList = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,LastModifiedById
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
           
        }
        
        //Test.startTest();

            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList,oldCaseMap);
              
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case]);
    }
        
      static testMethod void afterUpdateMethod_createSurveyURL_81(){
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
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
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
        
        List<Case> updatedCaseList8 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, PFECN__c,Requested_By_HON_Internal__c,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
        
        List<Case> updatedCaseList9 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                    From Case
                                                    where Id = :newCaseList[1].Id]);
        
        List<Case> updatedCaseList10 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, PFECN__c,Requested_By_HON_Internal__c,
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
        AfterUpdateHelperClass.getGroupMembers(GroupMemberid,runUser.id);
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }   
      static testMethod void RmaIscHold(){    
            Test.startTest();
            User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
            System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
            Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
    List<Case> cas= SObjectFactory.build(1,Case.sObjectType);     
    cas[0].Origin = 'Email';
    cas[0].Status = 'On Hold';
    cas[0].Sub_Status__c = 'Integrated Supply Chain Hold';
    cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id;
    cas[0].Type = 'Returns';
    cas[0].X4_Hour_AOG__c='24-hour';
    cas[0].AOG_Process_Type__c = 'Accelerated Repair';
    cas[0].Classification__c = 'CSO Spares';
    cas[0].ContactId = cont1.Id;
    cas[0].Type_of_Change__c = 'New Account';
    cas[0].Type = 'Other';
    cas[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
    cas[0].Government_Compliance_SM_M_Content__c = 'NO';
    cas[0].Due_Date__c = system.today();
    cas[0].OwnerId = UserInfo.getUserId();
    
    Insert cas;
    
    EmailMessage newEmail = new EmailMessage();
    newEmail.FromAddress='velmurugan.s@honeywell.com';
    newEmail.subject = 'Test Mail';
    newEmail.ToAddress = 'test@email.com';
    newEmail.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail.ParentId = cas[0].Id;
    newEmail.incoming = true;
    insert newEmail;
    
    EmailMessage newEmail1 = new EmailMessage();
    newEmail1.FromAddress='velmurugan.s@honeywell.com';
    newEmail1.subject = 'Test Please Induct Test ';
    newEmail1.TextBody =  ' This is a test mail ';
    newEmail1.ToAddress = 'test@email.com';
    newEmail1.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail1.ParentId = cas[0].Id;
    newEmail1.incoming = false;

    insert newEmail1;
    
    Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :Cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Sub_Status__c = 'Integrated Supply Chain Hold';

    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.SendOutBoundOnISCHoldUpdate(updatedCaseList,oldCaseMap);
    
   // system.assertequals(sales.Delivery_Information__c, 'Delivered');
   // system.assertequals(sales.Delivered__c, false);
    // system.assertequals(sales.Case__c , cas[0].id);
   } 
    Test.stopTest();
   }  


   static testMethod void RmaIscHold2(){    
            Test.startTest();
            User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
            System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
            Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
    List<Case> cas= SObjectFactory.build(1,Case.sObjectType);     
    cas[0].Origin = 'Email';
    cas[0].Status = 'On Hold';
    cas[0].Sub_Status__c = 'Integrated Supply Chain Hold';
    cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id;
    cas[0].Type = 'Returns';
    cas[0].X4_Hour_AOG__c='24-hour';
    cas[0].AOG_Process_Type__c = 'Accelerated Repair';
    cas[0].Classification__c = 'CSO Spares';
    cas[0].ContactId = cont1.Id;
    cas[0].Type_of_Change__c = 'New Account';
    cas[0].Type = 'Other';
    cas[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
    cas[0].Government_Compliance_SM_M_Content__c = 'NO';
    cas[0].Due_Date__c = system.today();
    cas[0].OwnerId = UserInfo.getUserId();
    
    Insert cas;
    
    EmailMessage newEmail = new EmailMessage();
    newEmail.FromAddress='velmurugan.s@honeywell.com';
    newEmail.subject = 'Test Mail';
    newEmail.ToAddress = 'test@email.com';
    newEmail.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail.ParentId = cas[0].Id;
    newEmail.incoming = true;
    insert newEmail;
    
    EmailMessage newEmail1 = new EmailMessage();
    newEmail1.FromAddress='velmurugan.s@honeywell.com';
    newEmail1.subject = 'Test Please Induct Test ';
    newEmail1.TextBody =  ' This is a test mail ';
    newEmail1.ToAddress = 'test@email.com';
    newEmail1.CcAddress = 'test1@email.com;vel1@honeywell.com';
    newEmail1.ParentId = cas[0].Id;
    newEmail1.incoming = false;

    insert newEmail1;
    
    Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :Cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
    List<Case> oldCaseListQuery = new List<Case>([Select Id,Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Due_Date__c,Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Sub_Status__c = 'RMA Rejected';

    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.SendOutBoundOnISCHoldUpdate(updatedCaseList,oldCaseMap);
    
   // system.assertequals(sales.Delivery_Information__c, 'Delivered');
   // system.assertequals(sales.Delivered__c, false);
    // system.assertequals(sales.Case__c , cas[0].id);
   } 
    Test.stopTest();
   }
  static testMethod void CustomerHold(){
  ENZ__MigratorSettings__c ftpsetting = new ENZ__MigratorSettings__c();
ftpsetting.Name = 'MigratorSettings';
insert ftpsetting;    
    Test.startTest();
    User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
    System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        Profile pf = [select id from Profile where name = 'System Administrator'];
        Country__c contry = [Select id From Country__c Where Name =: 'USA' Limit 1];
        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                    User.Username => 'tu3cso@test.com',
                    User.Email => 'testuser3@test.com',
                    User.Alias => 'tu3',
                    User.CommunityNickname => 'tu3cso',
                    User.TimeZoneSidKey => 'America/Los_Angeles',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.ProfileId => pf.Id,
                    User.LanguageLocaleKey => 'en_US',
                    User.SBU_User__c => 'D&S',
                    User.Country__c => 'Canada'
                    }
        );

    List<Account> lstnewAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account New CustomerHold', 
                Account.Type => 'Honeywell',
                Account.Country__c => contry.Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy CustomerHold 1'
            }
        );
        
        List<AccountTeamMember> lstATMnew = SObjectFactory.build(3,AccountTeamMember.sObjectType);
            lstATMnew[0].AccountId = lstnewAccount[0].Id;
            lstATMnew[0].UserId =  lstUser2[0].Id;
            lstATMnew[0].TeamMemberRole = 'Customer Support Manager (CSM)';
            
            lstATMnew[1].AccountId = lstnewAccount[0].Id;
            lstATMnew[1].UserId = lstUser2[0].Id;
            lstATMnew[1].TeamMemberRole = 'Customer Business Manager (CBM)';
            
            lstATMnew[2].AccountId = lstnewAccount[0].Id;
            lstATMnew[2].UserId = UserInfo.getUserId();
            lstATMnew[2].TeamMemberRole = 'Customer Business Director';
            
            insert lstATMnew;           
            
            
    List<Case> cas = new List<Case>();    
    Case case1 = new case();
    case1.Origin = 'Email';
    case1.Status = 'On Hold';
    case1.Sub_Status__c = 'Customer Hold';
    case1.RecordTypeId = RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id;
    case1.Type = 'Returns';
    case1.X4_Hour_AOG__c='24-hour';
    case1.AOG_Process_Type__c = 'Accelerated Repair';
    case1.Classification__c = 'CSO Spares';
    case1.ContactId = cont1.Id;
    case1.Type_of_Change__c = 'New Account';
    case1.Type = 'Other';
    case1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
    case1.Government_Compliance_SM_M_Content__c = 'NO';
    case1.Due_Date__c = system.today().addDays(4);
    case1.OwnerId = UserInfo.getUserId();
    case1.AccountId = lstnewAccount[0].Id;
    cas.add(case1);
    
    Case case2 = new case();
    case2.Origin = 'Email';
    case2.Status = 'On Hold';
    case2.Sub_Status__c = 'Customer Hold';
    case2.RecordTypeId = RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id;
    case2.Type = 'Returns';
    case2.X4_Hour_AOG__c='24-hour';
    case2.AOG_Process_Type__c = 'Accelerated Repair';
    case2.Classification__c = 'CSO Spares';
    case2.ContactId = cont1.Id;
    case2.Type_of_Change__c = 'New Account';
    case2.Type = 'Other';
    case2.Export_Compliance_Content_ITAR_EAR__c = 'NO';
    case2.Government_Compliance_SM_M_Content__c = 'NO';
    case2.Due_Date__c = system.today().addDays(8);
    case2.OwnerId = UserInfo.getUserId();
    case2.AccountId = lstnewAccount[0].Id;
    cas.add(case2);
    
    Case case3 = new case();
    case3.Origin = 'Email';
    case3.Status = 'On Hold';
    case3.Sub_Status__c = 'Customer Hold';
    case3.RecordTypeId = RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id;
    case3.Type = 'Returns';
    case3.X4_Hour_AOG__c='24-hour';
    case3.AOG_Process_Type__c = 'Accelerated Repair';
    case3.Classification__c = 'CSO Spares';
    case3.ContactId = cont1.Id;
    case3.Type_of_Change__c = 'New Account';
    case3.Type = 'Other';
    case3.Export_Compliance_Content_ITAR_EAR__c = 'NO';
    case3.Government_Compliance_SM_M_Content__c = 'NO';
    case3.Due_Date__c = system.today().addDays(12);
    case3.OwnerId = UserInfo.getUserId();
    case3.AccountId = lstnewAccount[0].Id;
    cas.add(case3);
    
    Case case4 = new case();
    case4.Origin = 'Email';
    case4.Status = 'On Hold';
    case4.Sub_Status__c = 'Customer Hold';
    case4.RecordTypeId = RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id;
    case4.Type = 'Returns';
    case4.X4_Hour_AOG__c='24-hour';
    case4.AOG_Process_Type__c = 'Accelerated Repair';
    case4.Classification__c = 'CSO Spares';
    case4.ContactId = cont1.Id;
    case4.Type_of_Change__c = 'New Account';
    case4.Type = 'Other';
    case4.Export_Compliance_Content_ITAR_EAR__c = 'NO';
    case4.Government_Compliance_SM_M_Content__c = 'NO';
    case4.Due_Date__c = system.today().addDays(20);
    case4.OwnerId = UserInfo.getUserId();
    case4.AccountId = lstnewAccount[0].Id;
    cas.add(case4);
    
    Insert cas;
    
    Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = cas[0].Id;
        attachment.Name = 'Return_7898.pdf';
        attachment.Body = b;
        
        insert(attachment);
        
       
    
       List<Case_Extension__c> listCaseExtension = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => cas[0].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => cas[0].Id,
                 Case_Extension__c.RMA_Created_date__c => system.today()
            }
        );
        
         List<Case_Extension__c> listCaseExtension1 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => cas[1].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => cas[1].Id,
                 Case_Extension__c.RMA_Created_date__c => system.today()
            }
        );
         List<Case_Extension__c> listCaseExtension2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => cas[2].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => cas[2].Id,
                 Case_Extension__c.RMA_Created_date__c => system.today()
            }
        );
         List<Case_Extension__c> listCaseExtension3 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case_Extension__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case_Extension__c.Name => cas[3].CaseNumber+'_Ext', 
                Case_Extension__c.Case_object__c => cas[3].Id,
                 Case_Extension__c.RMA_Created_date__c => system.today()
            }
        );
       
    Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
          
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Due_Date__c,Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Sub_Status__c = 'Customer Hold';
    
    newCaseList[1].Id = cas[1].Id;
    newCaseList[1].Sub_Status__c = 'Customer Hold';
    
    newCaseList[2].Id = cas[2].Id;
    newCaseList[2].Sub_Status__c = 'Customer Hold';
    
    newCaseList[3].Id = cas[3].Id;
    newCaseList[3].Sub_Status__c = 'Customer Hold';

    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.SendReminderEmailOnCustomerHold(updatedCaseList,oldCaseMap);
    
   // system.assertequals(sales.Delivery_Information__c, 'Delivered');
   // system.assertequals(sales.Delivered__c, false);
    // system.assertequals(sales.Case__c , cas[0].id);
   } 
     Test.stopTest();
   } 
   
    static testMethod void CustomerHoldOnAttachment(){    
    Test.startTest();
    try{
    User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
    System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        Profile pf = [select id from Profile where name = 'System Administrator'];
        Country__c contry = [Select id From Country__c Where Name =: 'USA' Limit 1];
        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                    User.Username => 'tu3cso@test.com',
                    User.Email => 'testuser3@test.com',
                    User.Alias => 'tu3',
                    User.CommunityNickname => 'tu3cso',
                    User.TimeZoneSidKey => 'America/Los_Angeles',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.ProfileId => pf.Id,
                    User.LanguageLocaleKey => 'en_US',
                    User.SBU_User__c => 'D&S',
                    User.Country__c => 'Canada'
                    }
        );

    List<Account> lstnewAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account New', 
                Account.Type => 'Honeywell',
                Account.Country__c => contry.Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy'
            }
        );
        
            
    List<Case> cas= SObjectFactory.build(4,Case.sObjectType);     
    cas[0].Origin = 'Email';
    cas[0].Classification__c  = 'CSO Spares';
    cas[0].Status = 'Open';
    cas[0].Sub_Status__c = null;
    cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
    cas[0].Type = 'Order Status';
    cas[0].X4_Hour_AOG__c='24-hour';
    cas[0].ContactId = cont1.Id;
    cas[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
    cas[0].Government_Compliance_SM_M_Content__c = 'NO';
    cas[0].OwnerId = UserInfo.getUserId();
    cas[0].AccountId = lstnewAccount[0].Id;
    cas[0].Sub_Class__c = 'BFE/SFE Buyer/Seller Furnished';
    cas[0].Subject = 'IBAS Report';
    //cas[0].Due_Date__c = system.today().addDays(-4);

    Insert cas;

        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId =  cas[0].Id;
        attachment.Name = 'IBAS Waterfall BOT';
        attachment.Body = b;
        insert(attachment);
    

    Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
          
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Due_Date__c,Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,Sub_Class__c 
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Status= 'Open';
    
    
    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,Sub_Class__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        //CaseServiceOnUpdate.SendAttachmentOrders(updatedCaseList,oldCaseMap);
    
   // system.assertequals(sales.Delivery_Information__c, 'Delivered');
   // system.assertequals(sales.Delivered__c, false);
    // system.assertequals(sales.Case__c , cas[0].id);
    } }
        catch(Exception e){}
     Test.stopTest();
   } 
    static testMethod void CustomerHoldOnOrders(){    
    Test.startTest();
    User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
    System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
        Contact cont1 = [Select id from Contact where Email =: 'test0@in.ibm.com'  Limit 1];
        Profile pf = [select id from Profile where name = 'System Administrator'];
        Country__c contry = [Select id From Country__c Where Name =: 'USA' Limit 1];
        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                    User.Username => 'tu3cso@test.com',
                    User.Email => 'testuser3@test.com',
                    User.Alias => 'tu3',
                    User.CommunityNickname => 'tu3cso',
                    User.TimeZoneSidKey => 'America/Los_Angeles',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.ProfileId => pf.Id,
                    User.LanguageLocaleKey => 'en_US',
                    User.SBU_User__c => 'D&S',
                    User.Country__c => 'Canada'
                    }
        );

    List<Account> lstnewAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account New', 
                Account.Type => 'Honeywell',
                Account.Country__c => contry.Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy'
            }
        );
        
        List<AccountTeamMember> lstATMnew = SObjectFactory.build(1,AccountTeamMember.sObjectType);
            lstATMnew[0].AccountId = lstnewAccount[0].Id;
            lstATMnew[0].UserId =  lstUser2[0].Id;
            lstATMnew[0].TeamMemberRole = 'Customer Support Manager (CSM)';
                      
            insert lstATMnew;           
            
            
    List<Case> cas= SObjectFactory.build(1,Case.sObjectType);     
    cas[0].Origin = 'Email';
    cas[0].Classification__c  = 'CSO Spares';
    cas[0].Status = 'On Hold';
    cas[0].Sub_Status__c = 'Customer Hold';
    cas[0].RecordTypeId = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
    cas[0].Type = 'Order Status';
    cas[0].X4_Hour_AOG__c='24-hour';
    cas[0].ContactId = cont1.Id;
    cas[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
    cas[0].Government_Compliance_SM_M_Content__c = 'NO';
    cas[0].OwnerId = UserInfo.getUserId();
    cas[0].AccountId = lstnewAccount[0].Id;
    cas[0].Sub_Class__c = 'BFE/SFE Buyer/Seller Furnished';
    cas[0].Subject = 'IBAS Report';
    cas[0].Notes__c = 'temp';
    cas[0].Due_Date__c = system.today().addDays(-4);
   
    Insert cas;
    
    
      
        
       
       
    Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :cas){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        
          
    List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Due_Date__c,Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,
                                                    Sub_Class__c , Notes__c 
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
    
    newCaseList[0].Id = cas[0].Id;
    newCaseList[0].Due_Date__c = system.today().addDays(4);    
   

    update newCaseList;
    
    Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :cas){
            newCaseListIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type,
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c,Due_Date__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c,LastModifiedById,NPS_Recommend__c,AWB_Number__c,
                                                     Sub_Class__c , Notes__c
                                                    From Case
                                                    where Id in :newCaseListIds]);
        
        //New Map
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        for(Case objCase :updatedCaseList){
           newCaseMap.put(objCase.Id,objCase); 
        }
        
        CaseServiceOnUpdate.SendReminderEmailOnCustomerHoldOrders(updatedCaseList,oldCaseMap);
    
   // system.assertequals(sales.Delivery_Information__c, 'Delivered');
   // system.assertequals(sales.Delivered__c, false);
    // system.assertequals(sales.Case__c , cas[0].id);
   } 
     Test.stopTest();
   } 
    static testMethod void afterUpdateMethod_createSurveyURL_for_p2c(){
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
            oldCaseList[0].RecordTypeId = rtIdQuotes;
            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].Quote_Number__c = 'My1234';
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Order Status';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].OwnerId = Userinfo.getUserId();
            
          
          
            
        insert oldCaseList;
        List<Case_Line_Item__c> listCaseLineItem = new List<Case_Line_Item__c>();
       
                Case_Line_Item__c cli1 = new Case_Line_Item__c();
                cli1.Case_Number__c = oldCaseList[0].Id;
                cli1.RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case_Line_Item__c').Id;
                cli1.Price_Status__c = '';
            
        insert cli1;
         
                
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,Requested_By_HON_Internal__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
            
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdQuotes;
            newCaseList[0].OwnerId = UserInfo.getUserId();
            newCaseList[0].Status = 'Done';
            newCaseList[0].Sub_Status__c = 'With Production team';
            newCaseList[0].Resolution__c = 'case is closed';
          
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        
        List<Case> updatedCaseList8 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,Requested_By_HON_Internal__c,PFECN__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
       
        
        
        //Test.startTest();    
            CaseServiceOnUpdate.afterUpdateMethod(updatedCaseList8,oldCaseMap);
            
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
    
    static testMethod void OwnerassignmentsforCsoCAses(){
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
            oldCaseList[0].RecordTypeId = rtIdOrders;
            oldCaseList[0].Origin = 'Web';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].Quote_Number__c = 'My1234';
            oldCaseList[0].ContactId = cont.Id;
            oldCaseList[0].vn_name__c = cont.id;
            oldCaseList[0].AccountId = acct.Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Order Status';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].OwnerId =label.Orders_Team_Id;
            
          
          
            
        insert oldCaseList;
        List<Case_Line_Item__c> listCaseLineItem = new List<Case_Line_Item__c>();
       
                Case_Line_Item__c cli1 = new Case_Line_Item__c();
                cli1.Case_Number__c = oldCaseList[0].Id;
                cli1.RecordTypeId = RecordTypeServices.getRecordTypeByName('Quotes','Case_Line_Item__c').Id;
                cli1.Price_Status__c = '';
            
        insert cli1;
         
                
        Set<Id> oldCaseListIds = new Set<Id>();
        List<Case> newCaseList = new List<Case>();  
        for(Case objId :oldCaseList){
            oldCaseListIds.add(objId.Id);
            newCaseList.add(objId);
        }
        //Query
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,Requested_By_HON_Internal__c
                                                    From Case
                                                    where Id in :oldCaseListIds]);
        
        //Old Map
        Map<Id,Case> oldCaseMap = new Map<Id,Case>();
        for(Case objCase :oldCaseListQuery){
           oldCaseMap.put(objCase.Id,objCase); 
        }
            
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdOrders;
            newCaseList[0].OwnerId = label.Orders_Team_Id;
            newCaseList[0].Status = 'Done';
            newCaseList[0].Sub_Status__c = 'With Production team';
            newCaseList[0].Resolution__c = 'case is closed';
          
            
        update newCaseList;
        
        Set<Id> newCaseListIds = new Set<Id>();
        for(Case objId :oldCaseList){
            newCaseListIds.add(objId.Id);
        }
        //Query
        
        List<Case> updatedCaseList8 = new List<Case>([Select Id, Due_Date__c, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,Requested_By_HON_Internal__c,PFECN__c
                                                    From Case
                                                    where Id = :newCaseList[0].Id]);
       
        
        
        //Test.startTest();    
            CaseServiceOnUpdate.ownerAssignmentForCSOCasesBeforeUpdateMethod(updatedCaseList8,oldCaseMap);
            
        }

        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        
    }
}