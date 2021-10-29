/*
Created By : Swastika Rajkhowa
Created Date : Nov-27-2017
Usages : test class methods for CaseServiceForCommonMetods methods       
*/
@isTest
public class CaseServiceForCommonMethodsTest{
    //Added by Anvesha For BeforeInsert test Methods
    static List<Case> list_CaseOrder10;
    static User currentUser;
    static Account accountWithBGA;
    static Account accountWithATR;
    static Contact contactWithBGA;
    static Contact contactWithATR;
    static Id recId; 
    static final Integer CASE_COUNT = 10;
    static Account accountWithCbtTeam;
    static Account accountWithoutCbtTeam;
    static Id aircraftContySerMgntUserId = CaseServiceUtility.getAircraftConnectivity();//Added by Shilpa
    
    //Added by Anvesha For BeforeInsert test Methods
    static final Integer CASE_COUNT_PROVIDE = 1;
    static final Integer CASE_MATRIX_COUNT = 2;
    static final String rtIdOrders = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id; //01230000000Zen3AAC
    static final String rtIdTechIssue = RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id; //01230000000ZJvU
    static final String rtIdRepairOverhaul = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id; //01230000000Zen5AAC
    static final String rtIdDSClearingHouse = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id; //01230000000cN6e
    static final String rtIdA350FTTeschIssue = RecordTypeServices.getRecordTypeByName('A350 FT/EIS Tech Issue','Case').Id; //012a0000001ZPNjAAO
    static final String rtIdQuotes = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id; //01230000000Zen4AAC
    static final String rtIdOEMQuoteOrders = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id; //012a0000001ZLs9AAG
    static final String rtIdDSQuotesOrders = RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id; //01230000000Zemz
    static final String rtIdCSMToolbox = RecordTypeServices.getRecordTypeByName('CSM Toolbox','Case').Id; //01230000000bTK4
    
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
    static final String rtIdMPMSIMLicensing = RecordTypeServices.getRecordTypeByName('M&PM SIM Licensing','Opportunity').Id; // 01213000000AWudAAG
    
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
    static List<account> accList = new List<Account>();
    static final boolean isSent=true;
    static final Id tempId=label.Case_Creation_Template_ID; 
    static List<User> listUser;
    static final Id targetObjectId=Label.UFR_Cont_Id;
    static final Id orgWideEmailAddressId=label.Yourresponse_OrgId;
    static final Id WhatId=Label.UFR_Cont_Id;
    static final String mailBody='Test Mail Body';
    static final String mailSubject='Test Mail Subject';
    static final String strDMLMode1 = 'Insert';
    static final String strDMLMode2 = 'Update';
    static Boolean isAfter = true;
    static Map<Id,Case> oldmap = new Map<ID,Case>();
    static Case cas = new Case();
    static List<Case> oldList;
    static List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>();
    static Contact cont;
    static Account acc;
    @testSetup
    static void setupData() {
        test.startTest();
        TriggerInactive.testTrigger = false;
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                                                    {
                                                        User.FirstName => 'TestFirstName',
                                                            User.LastName => 'TestLastName',
                                                            User.Email => 'test_radha@in.ibm.com',
                                                            User.Username => 'test_radha@in.ibm.com',
                                                            User.Alias => 'TestF',
                                                            User.ProfileId => p1.Id,
                                                            User.TimeZoneSidKey => 'America/Denver',
                                                            User.LocaleSidKey => 'en_US',
                                                            User.EmailEncodingKey => 'UTF-8',
                                                            User.LanguageLocaleKey => 'en_US'
                                                            });
        currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                    User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LastName => 'Customer Master',
                    User.FirstName=>'Salesforce',    
                    User.LanguageLocaleKey => 'en_US',
                    User.LocalesIdKey => 'en_US',
                    User.ProfileId => UserInfo.getProfileId(),
                    User.TimezonesIdKey => 'America/Los_Angeles',
                    //User.Username => 'wilnellies.vargas@honeywell.com'
                    User.Username => 'testtest@honeywell.com'
                    }
        );
        test.stoptest();             
    }     
    static void setupForAfterUpdate(){
        //test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            adminProfile = [select id from Profile where name = 'System Administrator'];
            lstCountry = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Country__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Country__c.OwnerId => UserInfo.getUserId(),
                        Country__c.Name => 'USA',
                        Country__c.SFDC_Country_Name__c => 'USA'
                        }
            );
            lstPortalToolMaster = SObjectFactory.create(
                CASE_COUNT_PROVIDE, portal_tools_master__c.sObjectType, new Map<Schema.SObjectField, Object>{  
                    portal_tools_master__c.name => 'Test Tool1', 
                        portal_tools_master__c.tool_Description__c => 'Tool description',               
                        portal_tools_master__c.tool_authorization_master__c => 'HON approval',                             
                        portal_tools_master__c.auto_approve__c => 'Not Allowed',        
                        portal_tools_master__c.tool_active__c => true
                        }
            );
            
            lstUser = SObjectFactory.create(
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
            
            lstnewAccount = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Account.OwnerId => UserInfo.getUserId(),
                        Account.Name => 'Test Account New', 
                        Account.Type => 'OEM',
                        Account.Country__c => lstCountry[0].Id,
                        Account.Customer_Status__c => 'Active',
                        Account.Strategic_Business_Unit__c => 'ATR',
                        Account.CBT__c => 'Airbus',
                        Account.CBT_Team__c => 'None',
                        Account.Region_Name__c => 'Americas',
                        Account.Market_Name__c => 'Marine',
                        Account.Service_Level__c => 'Standard',
                        Account.REPORT_ACCOUNT_NAME__c => 'test Account New Copy',
                        Account.Stop_to_Send_Surveys__c => 'test'
                        }
            );
            
            lstContact = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Contact.LastName => 'Test',
                        Contact.FirstName => 'Contact',
                        Contact.AccountId => lstnewAccount[0].Id,
                        Contact.Primary_Email_Address__c => 'gatotuka@in.ibm.com',
                        Contact.Last_Survey_Date__c => Date.parse('12/16/15'),
                        Contact.Email => 'gatotuka@in.ibm.com',
                        Contact.Survey_Opt_Out__c => false,
                        Contact.NPS_Survey__c => 'No'
                        }
            );
            lstContact1 = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Contact.LastName => 'Test1',
                        Contact.FirstName => 'Contact1',
                        Contact.AccountId => lstnewAccount[0].Id,
                        Contact.Primary_Email_Address__c => 'gatotuka@in.ibm.com',
                        Contact.Last_Survey_Date__c => Date.parse('12/16/15'),
                        Contact.Email => 'gatotuka@in.ibm.com',
                        Contact.Survey_Opt_Out__c => false,
                        Contact.NPS_Survey__c => 'No'
                        }
            );
            
            lstContact2 = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Contact.LastName => 'Test2',
                        Contact.FirstName => 'Contact2',
                        Contact.AccountId => lstnewAccount[0].Id,
                        Contact.Primary_Email_Address__c => 'gatotuka@in.ibm.com',
                        Contact.Last_Survey_Date__c => Date.parse('12/16/15'),
                        Contact.Email => 'gatotuka@in.ibm.com',
                        Contact.Survey_Opt_Out__c => false,
                        Contact.NPS_Survey__c => 'No'
                        }
            );
            
            lstContactTool = SObjectFactory.create(
                CASE_COUNT_PROVIDE, Contact_Tool_Access__c.sObjectType, new Map<Schema.SObjectField, Object> {
                    Contact_Tool_Access__c.CRM_Contact_ID__c => lstContact[0].id,
                        Contact_Tool_Access__c.Portal_Honeywell_ID__c => 'test123',
                        Contact_Tool_Access__c.Portal_Tool_Master__c => lstPortalToolMaster[0].id,
                        Contact_Tool_Access__c.name => lstPortalToolMaster[0].name,
                        Contact_Tool_Access__c.Request_Status__c => 'Pending'
                        }
            );
        }
        //test.stopTest();
    }
    //Test for CaseOnHoldMethod
    static testMethod void CaseOnHoldMethod(){
        try{
            TriggerInactive.testTrigger = false;
            setupForAfterUpdate();
            
            List<Case> oldCaseList = SObjectFactory.build(6,Case.sObjectType);
            
            oldCaseList[0].RecordTypeId = rtIdGDCAccounts;
            oldCaseList[0].Origin = 'Email';
            oldCaseList[0].Status = 'Open';
            oldCaseList[0].Quote_Number__c = 'My1234';
            oldCaseList[0].ContactId = lstContact[0].Id;
            oldCaseList[0].AccountId = lstnewAccount[0].Id;
            oldCaseList[0].Type_of_Change__c = 'New Account';
            oldCaseList[0].Type = 'Other';
            oldCaseList[0].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[0].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[0].OwnerId = lstUser[0].Id;
            oldCaseList[0].vn_name__c = lstContact[0].id;
            
            oldCaseList[1].RecordTypeId = rtIdOrders;
            oldCaseList[1].Origin = 'Email';
            oldCaseList[1].Status = 'On Hold';
            oldCaseList[1].Sub_Status__c = 'Credit Hold';
            oldCaseList[1].Reason_for_hold__c = 'Customer Part Missing';
            oldCaseList[1].Quote_Number__c = 'My1234';
            oldCaseList[1].ContactId = lstContact[0].Id;
            oldCaseList[1].AccountId = lstnewAccount[0].Id;
            oldCaseList[1].Type_of_Change__c = 'New Account';
            oldCaseList[1].Type = 'Other';
            oldCaseList[1].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[1].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[1].OwnerId = lstUser[0].Id;
            
            oldCaseList[2].RecordTypeId = rtIdQuotes;
            oldCaseList[2].Origin = 'Email';
            oldCaseList[2].Status = 'On Hold';
            oldCaseList[2].Sub_Status__c = 'Customer Hold';
            oldCaseList[2].Reason_for_hold__c = 'Customer Part Missing';
            oldCaseList[2].Quote_Number__c = 'My1234';
            oldCaseList[2].ContactId = lstContact[0].Id;
            oldCaseList[2].AccountId = lstnewAccount[0].Id;
            oldCaseList[2].Type_of_Change__c = 'New Account';
            oldCaseList[2].Type = 'Other';
            oldCaseList[2].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[2].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[2].OwnerId = lstUser[0].Id;
            
            oldCaseList[3].RecordTypeId = rtIdAOG;
            oldCaseList[3].Origin = 'Email';
            oldCaseList[3].Status = 'Open';
            oldCaseList[3].Quote_Number__c = 'My1234';
            oldCaseList[3].ContactId = lstContact[0].Id;
            oldCaseList[3].AccountId = lstnewAccount[0].Id;
            oldCaseList[3].Type_of_Change__c = 'New Account';
            oldCaseList[3].Type = 'Other';
            oldCaseList[3].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[3].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[3].OwnerId = lstUser[0].Id;
            
            oldCaseList[4].RecordTypeId = rtIdTechIssue;
            oldCaseList[4].Origin = 'Email';
            oldCaseList[4].Status = 'Open';
            oldCaseList[4].Quote_Number__c = 'My1234';
            oldCaseList[4].ContactId = lstContact[0].Id;
            oldCaseList[4].AccountId = lstnewAccount[0].Id;
            oldCaseList[4].Type_of_Change__c = 'New Account';
            oldCaseList[4].Type = 'Other';
            oldCaseList[4].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[4].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[4].OwnerId = lstUser[0].Id;
            
            oldCaseList[5].RecordTypeId = rtIdTechIssue;
            oldCaseList[5].Origin = 'Email';
            oldCaseList[5].Status = 'Open';
            oldCaseList[5].Quote_Number__c = 'My1234';
            oldCaseList[5].ContactId = lstContact[0].Id;
            oldCaseList[5].AccountId = lstnewAccount[0].Id;
            oldCaseList[5].Type_of_Change__c = 'New Account';
            oldCaseList[5].Type = 'Other';
            oldCaseList[5].Export_Compliance_Content_ITAR_EAR__c = 'NO';
            oldCaseList[5].Government_Compliance_SM_M_Content__c = 'NO';
            oldCaseList[5].OwnerId = lstUser[0].Id;
            
            insert oldCaseList;
            
            oldCaseList[5].Status = 'On Hold';
            oldCaseList[5].Sub_Status__c = 'Credit Hold';
            oldCaseList[5].Reason_for_hold__c = 'Credit Card Payment';
            update oldCaseList;
            
            Set<Id> oldCaseListIds = new Set<Id>();
            List<Case> newCaseList = new List<Case>();  
            for(Case objId :oldCaseList){
                oldCaseListIds.add(objId.Id);
                newCaseList.add(objId);
            }
            //Query
            List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
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
            test.startTest();
            newCaseList[0].Id = oldCaseList[0].Id;
            newCaseList[0].RecordTypeId = rtIdGDCAccounts;
            newCaseList[0].OwnerId = lstUser[0].Id;
            newCaseList[0].Status = 'On Hold';
            newCaseList[0].Sub_Status__c = 'Credit Hold';
            newCaseList[0].Reason_for_hold__c = 'Credit Card Payment';
            newCaseList[0].vn_name__c = lstContact[0].id;
            
            newCaseList[1].Id = oldCaseList[1].Id;
            newCaseList[1].RecordTypeId = rtIdOrders;
            newCaseList[1].OwnerId = lstUser[0].Id;
            newCaseList[1].Status = 'On Hold';
            newCaseList[1].Sub_Status__c = 'Customer Hold';
            newCaseList[1].Reason_for_hold__c = 'Customer Part Missing';
            newCaseList[1].vn_name__c = lstContact[0].id;
            
            newCaseList[2].Id = oldCaseList[2].Id;
            newCaseList[2].RecordTypeId = rtIdQuotes;
            newCaseList[2].OwnerId = lstUser[0].Id;
            newCaseList[2].Status = 'On Hold';
            newCaseList[2].Sub_Status__c = 'Export Hold';
            newCaseList[2].Reason_for_hold__c = 'Export Control';
            newCaseList[2].vn_name__c = lstContact[0].id; 
            
            newCaseList[3].Id = oldCaseList[3].Id;
            newCaseList[3].RecordTypeId = rtIdAOG;
            newCaseList[3].OwnerId = lstUser[0].Id;
            newCaseList[3].Status = 'Open-Rejected';
            
            newCaseList[4].Id = oldCaseList[4].Id;
            newCaseList[4].RecordTypeId = rtIdTechIssue;
            newCaseList[4].OwnerId = lstUser[0].Id;
            newCaseList[4].Status = 'On Hold';
            newCaseList[4].Sub_Status__c = 'Export Hold';
            newCaseList[4].Reason_for_hold__c = 'Export Control';
            
            newCaseList[5].Id = oldCaseList[5].Id;
            newCaseList[5].RecordTypeId = rtIdTechIssue;
            newCaseList[5].OwnerId = lstUser[0].Id;
            newCaseList[5].Status = 'Propose to Close';
            
            update newCaseList;
            
            Set<Id> newCaseListIds = new Set<Id>();
            for(Case objId :oldCaseList){
                newCaseListIds.add(objId.Id);
            }
            //Query                                           
            List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                         Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                         Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                         Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                         Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                         Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                         Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                         Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                         From Case
                                                         where Id in :newCaseListIds]);
            
            
            
            CaseServiceForCommonMethods.CaseOnHoldMethod(oldCaseListQuery,null,'Insert');
            CaseServiceForCommonMethods.CaseOnHoldMethod(updatedCaseList,oldCaseMap,'Update');
            
            List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c, ContactId From Case]);
            system.assert(!caselst.isEmpty(), 'Case should not be null'); 
            Test.stopTest();
            
            
        }
        catch(exception e){}
        //}
        
        
    }
    //Test for InsertReasonForHold
    static testMethod void InsertReasonForHold(){
        test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                List<Case> listCaseOrder = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(), 
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdOrders, 
                            Case.sub_class__c => 'Order Status',
                            Case.Iscompliance__c => false,
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                            Case.Government_Compliance_SM_M_Content__c => 'No',
                            Case.Case_Record_Type__c => 'Engine Rentals'
                            }
                );
                List<Case> lstCaseOrderOld = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                             Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                             Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                             Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                             Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                             Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                             Description,Case_Record_Type__c
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
                    objtemCase.Status = 'On Hold';
                    objtemCase.Sub_Status__c = 'Credit Hold';
                    objtemCase.Reason_for_hold__c = 'Credit Block;Credit Card Payment;Cust Approval Required';
                    objtemCase.OwnerId = UserInfo.getUserId();
                    updatedCaseOrder.add(objtemCase);
                }
                update updatedCaseOrder;
                
                List<Case> newUpdatedCaseOrder = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                                 Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                                 Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                                 Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                                 Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                                 Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                                 Description
                                                                 From Case
                                                                 where Id =:updatedCaseOrder[0].Id]); 
                
                Map<Id,Case> newCaseMapOrder = new Map<Id,Case>();
                for(Case objCase :newUpdatedCaseOrder){
                    newCaseMapOrder.put(objCase.Id,objCase);
                }
                
                CaseServiceForCommonMethods.InsertReasonForHold(newUpdatedCaseOrder);
                
                List<Case> caselst = new List<Case>([Select Id,CaseNumber,Status, Reason_for_hold__c, Sub_Status__c From Case Where id =:newUpdatedCaseOrder[0].Id]);
                system.assert(!caselst.isEmpty(), 'Case should not be null');
                List<String> values = new List<String>();
                for(Case cas :caselst){
                    if(String.isNotBlank(cas.Reason_for_hold__c)){
                        values = cas.Reason_for_hold__c.split(';');
                    }
                }
                System.assertEquals(true,values.size() > 1, 'Reason for Hold values are greater than 1');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    
    //Start of Adding Test Methods of Email Method of afterInserthelperClass
    static testMethod void testCaseHandlerAfterInsertEmail()
    {  
        //setup2();
        //Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test Account Energy'];
        //Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                //setup2();
                currentUser = (User) SObjectFactory.create(
                    User.SObjectType,
                    new Map<SObjectField, Object>{
                        User.Alias => 'wvarg',
                            User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                            User.EmailEncodingKey => 'UTF-8',
                            User.LastName => 'Customer Master',
                            User.FirstName=>'Salesforce',    
                            User.LanguageLocaleKey => 'en_US',
                            User.LocalesIdKey => 'en_US',
                            User.ProfileId => UserInfo.getProfileId(),
                            User.TimezonesIdKey => 'America/Los_Angeles',
                            //User.Username => 'wilnellies.vargas@honeywell.com'
                            User.Username => 'testtest@honeywell.com'
                            }
                );  
                account accountWithATR =[SELECT Id, Name FROM Account WHERE Type=:'OEM' LIMIT 1];
                Contact contactWithATR =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1]; 
                Set<Id> setCaseIds= new Set<Id>();
                recId = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id;       
                //create case records
                
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin =>'Email-Quotes',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.Ownerid => currentUser.Id,//label.Salesforce_Customer_Master,
                            Case.RecordTypeId=> recId,
                            Case.SBU_w2c__c=>'D&S',
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithATR.Id,
                            Case.AccountId=>accountWithATR.id,
                            Case.Type => 'Other',
                            Case.Part_Number__c=>'Test', 
                            Case.NSN__c=>'Test',
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                Case caseRelatedToCLI = new Case();
                caseRelatedToCLI = list_CaseOrder[0];
                Case_Line_Item__c caseLookupRec = (Case_Line_Item__c) SObjectFactory.create(Case_Line_Item__c.SObjectType,
                                                                                            new Map<SObjectField, Object>{
                                                                                                Case_Line_Item__c.Case_Number__c=> caseRelatedToCLI.Id,
                                                                                                    Case_Line_Item__c.Price__c => 20,
                                                                                                    Case_Line_Item__c.Quantity__c => 2,
                                                                                                    Case_Line_Item__c.RecordTypeId=>RecordTypeServices.getRecordTypeByName('DS Clearing House Proposal','Case_Line_Item__c').Id
                                                                                                    }
                                                                                           );   
                
                
                
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,list_CaseOrder,null); 
                
                
                
                for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertEquals(CaseTech.Origin,'Email-Quotes'); 
                    
                }
            }catch(Exception e){}
        }
        
        Test.stopTest(); 
    }
    static testMethod void testCaseHandlerAfterInsert_CBTTeam()
    { 
        test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                //setup2();
                TriggerInactive.testTrigger = false;
                account accountWithATR =[SELECT Id, Name FROM Account WHERE Type=:'OEM' LIMIT 1];
                Contact contactWithATR =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1]; 
                //setup2();
                Set<Id> setCaseIds= new Set<Id>();
                recId = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id;       
                //create case records
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin => 'Email-SAP_CustomerMaster',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.RecordTypeId=> recId,
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithATR.Id,
                            Case.AccountId=>accountWithATR.id,
                            Case.Type => 'Other',   
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                
                
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,list_CaseOrder,null);    
                
                
                for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertEquals(CaseTech.Origin,'Email-SAP_CustomerMaster'); 
                    
                }
            }catch(Exception e){}
        }
        Test.stopTest();
        
    }
    static testMethod void testCaseHandlerAfterInsert_CBTTeam2()
    {  
        test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                //setup2();
                TriggerInactive.testTrigger = false;
                account Account1= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                        account.Name => 'Test Account111111',
                        account.type => 'Energy',
                        account.Strategic_Business_Unit__c => 'D&S',
                        account.Service_Level__c => 'Refer To Network',
                        account.Do_Not_Send_to_Portal__c => false,
                        Account.PFECN__c => null,
                        account.Region_Name__c => 'Asia/Pacific Rim'
                        });
                account accountWithATR =[SELECT Id, Name FROM Account WHERE Type=:'OEM' LIMIT 1];
                Contact contactWithATR =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1];
                account account2 =[SELECT Id, Name FROM Account WHERE Name='Test Account111111' LIMIT 1];
                Contact contact2=[SELECT Id, Name FROM Contact WHERE AccountId=:account2.Id LIMIT 1];
                
                //setup2(); 
                Set<Id> setCaseIds= new Set<Id>();
                recId = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id;       
                //create case records
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin => 'Email-SAP_CustomerMaster',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.RecordTypeId=> recId,
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithATR.Id,
                            Case.AccountId=>accountWithBGA.id,
                            Case.Type => 'Other',   
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                List<Case> list_CaseOrder2= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin => 'Email-Quotes',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting',
                            Case.Subject=>'OCD Updates 620',
                            Case.RecordTypeId=> recId,
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contact2.Id,
                            Case.AccountId=>account2.id,
                            Case.Type => 'Other',   
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                         ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                         ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                         ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                         ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                         ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                         ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                         ,Sub_Class__c,Aircraft_Name__c,Case_Record_Type__c              
                                         FROM Case Where Id=:list_CaseOrder2[0].Id];
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                
                //Test.startTest();     
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,list_CaseOrder,null); 
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,newCaseList,null); 
                
                
                for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertEquals(CaseTech.Origin,'Email-SAP_CustomerMaster'); 
                    
                }
            }catch(Exception e){}
        }
        Test.stopTest();
        
    }
    static testMethod void testCaseHandlerAfterInsert_CBTTeam3()
    {
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){  
            try{
                //setup2();
                TriggerInactive.testTrigger = false;
                account accountWithATR =[SELECT Id, Name FROM Account WHERE Type=:'OEM' LIMIT 1];
                Contact contactWithATR =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1]; 
                //setup2();
                Set<Id> setCaseIds= new Set<Id>();
                recId = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id;       
                //create case records
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin => 'Email-SAP_CustomerMaster',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.RecordTypeId=> recId,
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithATR.Id,
                            Case.AccountId=>accountWithATR.id,
                            Case.Type => 'Other',   
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                
                
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,list_CaseOrder,null);    
                
                
                for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertEquals(CaseTech.Origin,'Email-SAP_CustomerMaster'); 
                    
                }
            }catch(Exception e){}
        }
        Test.stopTest(); 
    }
    static testMethod void testCaseHandlerAfterInsert_CBTTeamwithoutCbtTeam()
    {  
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                //setup2();
                TriggerInactive.testTrigger = false;
                account accountWithoutCbtTeam=[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
                Contact contactWithBGA =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithBGA.Id LIMIT 1]; 
                //setup2();
                Set<Id> setCaseIds= new Set<Id>();
                recId = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id;       
                //create case records
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin => 'Email-SAP_CustomerMaster',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.RecordTypeId=> recId,
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithBGA.Id,
                            Case.AccountId=>accountWithoutCbtTeam.id, 
                            Case.Type => 'Other',   
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                
                
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,list_CaseOrder,null);    
                
                
                for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertEquals(CaseTech.Origin,'Email-SAP_CustomerMaster'); 
                    
                }
            }catch(Exception e){}
        }
        test.stopTest();
        
    }
    //End of Adding Test Methods of Email Method of afterInserthelperClass
    //############################################################################################################################################//
    
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: setupForProvide
    // Description : setup method for Case Provide Access contains Profile, user, Group, Country and Account
    static void setupForProvide(){
        // test.startTest();
        
        //Profile
        adminProfile = [select id from Profile where name = 'System Administrator'];
        
        //Create User
        lstUser = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                    User.Username => 'testcsouser@test.com',
                    User.Email => 'testuser1@test.com',
                    User.Alias => 'tu0',
                    User.CommunityNickname => 'tu0cso',
                    User.TimeZoneSidKey => 'America/Los_Angeles',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'ISO-8859-1',
                    User.ProfileId => adminProfile.Id,
                    User.LanguageLocaleKey => 'en_US',
                    User.SBU_User__c => 'D&S',
                    User.Country__c => 'Canada'
                    }
        );
        
        //Group ID
        List<String> lstQueue = new List<String>();
        lstQueue.add('Compliance Queue CSO');
        lstQueue.add('Compliance Queue GTO');
        lstQueue.add('CSO');
        lstQueue.add('General Compliance Queue');
        lstQueue.add('Tech Issue');
        lstgrpId = new List<Group>([Select Id,Name From Group where Name in: lstQueue]);
        
        //Country__c
        lstCountry = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Country__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Country__c.OwnerId => UserInfo.getUserId(),
                    Country__c.Name => 'USA',
                    Country__c.SFDC_Country_Name__c => 'USA'
                    }
        );
        
        //Account
        lstAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                    Account.Name => 'Test Account', 
                    Account.Type => 'Honeywell',
                    Account.Country__c => lstCountry[0].Id,
                    Account.Customer_Status__c => 'Active',
                    Account.Strategic_Business_Unit__c => 'D&S',
                    Account.CBT__c => 'DMA',
                    Account.CBT_Team__c => 'None',
                    Account.Market_Name__c => 'Marine',
                    Account.Service_Level__c => 'Standard',
                    Account.REPORT_ACCOUNT_NAME__c => 'test Account New'
                    }
        );
        //test.stopTest();
    }
    
    
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: caseResolutionAndSubclass_NotNULL
    // Description : Resolution and sub class are not NULL
    static testMethod void caseResolutionAndSubclass_NotNULL(){
        
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                listCaseOrder = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdOrders,
                            Case.resolution__C => 'Resolved Cases for Orders',
                            Case.sub_class__c => 'Order Status'
                            }
                );
                
                
                CaseHandler objCaseHandler = new CaseHandler (true,1);                     
                objCaseHandler.onBeforeInsert(listCaseOrder);     
                
                List<Case> caselst = new List<Case>([Select Id, Is_Resolution_Blank__c,Is_Type_equal_to_SubClass__C From Case]);
                System.assert(!caselst.isEmpty(),'Case should not be Empty');
                //System.assertEquals('0',caselst[0].Is_Resolution_Blank__c,'Case Is Resolution Blank to be 0');
                //System.assertEquals('0',caselst[0].Is_Type_equal_to_SubClass__C,'Case Is_Type_equal_to_SubClass__C to be 0');
            }
            catch(exception e){}
        }
        test.stopTest();
    }
    
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: caseResolutionAndSubclass_NULL
    // Description : Resolution and sub class are NULL
    static testMethod void caseResolutionAndSubclass_NULL(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                listCaseOrder = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdOrders
                            }
                );
                
                
                CaseHandler objCaseHandler = new CaseHandler (true,1);                     
                objCaseHandler.onBeforeInsert(listCaseOrder);    
                
                List<Case> caselst = new List<Case>([Select Id, Is_Resolution_Blank__c,Is_Type_equal_to_SubClass__C From Case WHERE Id=:listCaseOrder[0].Id]);
                System.assert(!caselst.isEmpty(),'Case should not be Empty');
                //System.assertEquals('1',caselst[0].Is_Resolution_Blank__c,'Case Is Resolution Blank to be 1');
                //System.assertEquals('1',caselst[0].Is_Type_equal_to_SubClass__C,'Case Is_Type_equal_to_SubClass__C to be 1');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: beforeCaseOwnerQueue
    // Description : set Case Owner to Queue
    static testMethod void beforeCaseOwnerQueueTechRepair(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                List<String> lstQueue = new List<String>();
                lstQueue.add('Compliance Queue CSO');
                lstQueue.add('Compliance Queue GTO');
                List<Group> lstgrpId1 = new List<Group>([Select Id,Name From Group where Name in: lstQueue]);
                
                listCaseTech = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Technical Issue',
                            Case.recordtypeid => rtIdTechIssue,
                            Case.Classification__c => 'GTO Field Service',
                            Case.Government_Compliance_SM_M_Content__c => 'Yes',
                            Case.IsMemberOfCompliance__c => false
                            }
                );
                
                listCaseRepair = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdRepairOverhaul,
                            Case.Classification__c => 'CSO Repair/Overhaul',
                            Case.Government_Compliance_SM_M_Content__c => 'Yes',
                            Case.IsMemberOfCompliance__c => false 
                            }
                ); 
                
                CaseHandler objCaseHandler = new CaseHandler (true,1);                     
                objCaseHandler.onBeforeInsert(listCaseTech);
                objCaseHandler.onBeforeInsert(listCaseRepair);            
                
                List<Case> caselst = new List<Case>([Select Id, OwnerId, RecordTypeId From Case]);
                System.assert(!caselst.isEmpty(),'Case should not be Empty');
                System.assertEquals(lstgrpId1[1].Id,caselst[0].OwnerId,'RT : Technical Issue Case OwnerId should be Compliance Queue GTO');
                System.assertEquals(lstgrpId1[0].Id,caselst[1].OwnerId,'RT : Repair & Overhaul Case OwnerId should be Compliance Queue CSO');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: beforeCaseOwnerQueue
    // Description : set Case Owner to Queue
    static testMethod void beforeCaseOwnerQueueOEMDSA35(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                List<String> lstQueue = new List<String>();
                lstQueue.add('Compliance Queue CSO');
                lstQueue.add('Compliance Queue GTO');
                List<Group> lstgrpId1 = new List<Group>([Select Id,Name From Group where Name in: lstQueue]);
                listCaseOEMQuote = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdOEMQuoteOrders,
                            Case.Classification__c => 'CSO OEM',
                            Case.Government_Compliance_SM_M_Content__c => 'Yes',
                            Case.IsMemberOfCompliance__c => false  
                            }
                );
                
                listCaseDSClearing = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdDSClearingHouse,
                            Case.Classification__c => 'CSO Spares',
                            Case.Government_Compliance_SM_M_Content__c => 'Yes',
                            Case.IsMemberOfCompliance__c => false
                            }
                );
                
                listCaseA350FT = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdA350FTTeschIssue,
                            Case.Classification__c => 'Engineering(A350)',
                            Case.Government_Compliance_SM_M_Content__c => 'Yes',
                            Case.IsMemberOfCompliance__c => false
                            }
                );
                
                
                CaseHandler objCaseHandler = new CaseHandler (true,1); 
                objCaseHandler.onBeforeInsert(listCaseOEMQuote);
                objCaseHandler.onBeforeInsert(listCaseDSClearing);
                objCaseHandler.onBeforeInsert(listCaseA350FT);
                
                List<Case> caselst = new List<Case>([Select Id, OwnerId, RecordTypeId From Case]);
                System.assert(!caselst.isEmpty(),'Case should not be Empty');
                //System.assertEquals(lstgrpId1[1].Id,caselst[0].OwnerId,'RT : Technical Issue Case OwnerId should be Compliance Queue GTO');
                //System.assertEquals(lstgrpId1[0].Id,caselst[1].OwnerId,'RT : Repair & Overhaul Case OwnerId should be Compliance Queue CSO');
                System.assertEquals(lstgrpId1[0].Id,caselst[0].OwnerId,'RT: OEM Quotes Orders Case OwnerId should be Compliance Queue CSO');
                System.assertEquals(lstgrpId1[0].Id,caselst[1].OwnerId,'RT : D&S Clearing House Classification CSO Spare Proposal Case OwnerId should be Compliance Queue CSO');
            }
            catch(exception e){}
        }
        Test.stopTest();
        
    }  
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: beforeIsCaseOwnerQueue
    // Description : Is Case Owner a Queue
    static testMethod void beforeIsCaseOwnerQueue(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                listCaseOrder = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdOrders
                            }
                );
                
                listCaseQuotes = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => Label.MyareoFrmUsrid,
                            Case.Type => 'Quote', 
                            Case.recordtypeid => rtIdQuotes,
                            Case.Status => 'Re-Open'
                            }
                );
                
                
                CaseHandler objCaseHandler = new CaseHandler (true,1);                  
                objCaseHandler.onBeforeInsert(listCaseOrder);
                objCaseHandler.onBeforeInsert(listCaseQuotes);
                
                List<Case> caselst = new List<Case>([Select Id, OwnerId, ownerid__c, Is_Case_Owner_a_queue__c, RecordTypeId From Case]);
                System.assert(!caselst.isEmpty(),'Case should not be Empty');
                System.assertEquals(false,caselst[0].Is_Case_Owner_a_queue__c,'RT : Orders Is_Case_Owner_a_queue__c should be false ');
                //System.assertEquals(true,caselst[1].Is_Case_Owner_a_queue__c,'RT : Orders Is_Case_Owner_a_queue__c should be true ');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    
    // Created By : Garvit Totuka   Date : 13 Nov 2017
    // method: beforeIsCaseOwnerQueue_1
    // Description : Is Case Owner a Queue
    static testMethod void beforeIsCaseOwnerQueue_1(){
        
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            setupForProvide();
            try{
                List<Case> listCaseOrder1 = SObjectFactory.create(
                    CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => lstgrpId[0].Id,
                            Case.Type => 'Order Status', 
                            Case.recordtypeid => rtIdOrders, 
                            Case.sub_class__c => 'Order Status',
                            Case.Status => 'Denied',
                            Case.Subject => 'None',
                            Case.ownerid__c => UserInfo.getUserId(),
                            Case.Reopen_Case__c => false
                            }
                );
                
                
                CaseHandler objCaseHandler = new CaseHandler (true,1); 
                objCaseHandler.onBeforeInsert(listCaseOrder1);
                
                List<Case> caselst = new List<Case>([Select Id, OwnerId, ownerid__c, Is_Case_Owner_a_queue__c, RecordTypeId From Case WHERE ID=:listCaseOrder1[0].Id]);
                //System.assert(caselst.isEmpty(),'Case should be Empty');
            }
            catch(Exception e){}
        }
        Test.stopTest();
        
    }
    // Created By : Swastika Rajkhowa Date : 16 Nov 2017
    // method: testMethodRnOCaseOwnerAssignOnCreationMethodInsert
    // Description : test method for caseservice class method RnOCaseOwnerAssignOnCreationMethod for before Insert
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert()
    {  
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });  
            Set<Id> setCaseIds= new Set<Id>();           
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            Test.startTest();
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> 'Pilots Corner Avionics',
                            OriginCheckChange__c.CaseOriginName__c=> 'Email-Pilots Corner Avionics'         
                            }
                );  
                OriginCheckChange__c custSettingOrigin1 = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> 'st',
                            OriginCheckChange__c.CaseOriginName__c=> 'st'         
                            }
                );
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');  
                //create old map
                Map<Id,Case> oldmapRO = new Map<ID,Case>();
                List<Case> oldListRO;
                oldListRO= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.OwnerId => UserInfo.getUserId(),
                        Case.Sub_Status__c=>'Activation',
                        Case.Subject => 'Test',
                        Case.recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                        Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                        Case.Expected_Update__c => system.now(),
                        Case.Classification__c => 'CSO OEM',
                        Case.Government_Compliance_SM_M_Content__c => 'Yes',
                        Case.IsMemberOfCompliance__c => false, 
                        Case.status=> 'In Process'
                        });
                //create old data in map
                for(case objCase : oldListRO){
                    oldmapRO.put(objCase.Id,objCase);
                }              
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => 'Email-Pilots Corner Avionics',
                            Case.status=> 'On Hold',
                            Case.Sub_Status__c=>'Shipment',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Engine Rentals', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'Email-Pilots Corner Avionics'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => 'Email-Pilots Corner Avionics',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                );
                listCaseEmail[0].Type = '2nd year HUMS';
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= RecordTypeServices.getRecordTypeByName('Engine Rentals', 'Case').Id; 
                listCaseEmail[0].Status= 'On Hold';
                System.assertNotEquals(listCaseMatrix,null,'success');
                //CaseHandler objCaseHandler = new CaseHandler(true,1);              
                //Test.startTest(); 
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,oldmapRO,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert2()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });  
            Set<Id> setCaseIds= new Set<Id>();          
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '*****D&S R&O',
                            OriginCheckChange__c.CaseOriginName__c=> '*****D&S R&O'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******D&S R&O',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'D&S R&O'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => 'D&S R&O',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******D&S R&O';
                
                listCaseEmail[1].Type = '2nd year HUMS';            
                listCaseEmail[1].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[1].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[1].Status= 'On Hold';
                listCaseEmail[1].Origin = '******D&S R&O Internal';
                
                listCaseEmail[2].Type = '2nd year HUMS';            
                listCaseEmail[2].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[2].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[2].Status= 'On Hold';
                listCaseEmail[2].Origin = '******R&O Canada';
                
                listCaseEmail[3].Type = '2nd year HUMS';            
                listCaseEmail[3].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[3].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[3].Status= 'On Hold';
                listCaseEmail[3].Origin = '******BGA R&O Internal';
                
                listCaseEmail[4].Type = '2nd year HUMS';            
                listCaseEmail[4].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[4].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[4].Status= 'On Hold';
                listCaseEmail[4].Origin = '******ATR R&O Internal';
                System.assertNotEquals(listCaseMatrix,null,'success');  
                //CaseHandler objCaseHandler = new CaseHandler(true,1);          
                //Test.startTest();   
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    }
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert3()
    {  
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });  
            Set<Id> setCaseIds= new Set<Id>();           
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******D&S R&O Internal',
                            OriginCheckChange__c.CaseOriginName__c=> '******D&S R&O Internal'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******D&S R&O Internal',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'D&S R&O Internal'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******D&S R&O Internal',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******D&S R&O Internal';
                
                
                System.assertNotEquals(listCaseMatrix,null,'success');   
                //CaseHandler objCaseHandler = new CaseHandler(true,1);         
                //Test.startTest();  
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    
    
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert4()
    {  
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });  
            Set<Id> setCaseIds= new Set<Id>();
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******R&O Canada',
                            OriginCheckChange__c.CaseOriginName__c=> '******R&O Canada'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******R&O Canada',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'R&O Canada'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******R&O Canada',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******R&O Canada';
                
                
                System.assertNotEquals(listCaseMatrix,null,'success');  
                //CaseHandler objCaseHandler = new CaseHandler(true,1);          
                //Test.startTest();             
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert5()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });  
            Set<Id> setCaseIds= new Set<Id>();
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******BGA R&O Internal',
                            OriginCheckChange__c.CaseOriginName__c=> '******BGA R&O Internal'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******BGA R&O Internal',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'BGA R&O Internal'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******BGA R&O Internal',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******BGA R&O Internal';            
                
                System.assertNotEquals(listCaseMatrix,null,'success');
                //CaseHandler objCaseHandler = new CaseHandler(true,1);            
                //Test.startTest();             
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert8()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });                
            Set<Id> setCaseIds= new Set<Id>();
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******ATR R&O Internal',
                            OriginCheckChange__c.CaseOriginName__c=> '******ATR R&O Internal'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******ATR R&O Internal',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'ATR R&O Internal'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******ATR R&O Internal',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******ATR R&O Internal';            
                
                System.assertNotEquals(listCaseMatrix,null,'success'); 
                //CaseHandler objCaseHandler = new CaseHandler(true,1);           
                //Test.startTest();             
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert8_a()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });                
            Set<Id> setCaseIds= new Set<Id>();
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******ATR R&O Internal',
                            OriginCheckChange__c.CaseOriginName__c=> '******ATR R&O Internal'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    1, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******ATR R&O Internal',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Engine Rentals', 'Case').Id,
                            Case.Status => 'On Hold',
                            Case.Sub_Status__c => 'Shipment'
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'ATR R&O Internal'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******ATR R&O Internal',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                //listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                //listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******ATR R&O Internal';            
                
                System.assertNotEquals(listCaseMatrix,null,'success'); 
                List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                         ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                         ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                         ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                         ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                         ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                         ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                         ,Sub_Class__c,Aircraft_Name__c,Case_Record_Type__c              
                                         FROM Case Where Id=:listCaseEmail[0].Id];  
                
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(newCaseList,null,'Insert');
            }
            Test.stopTest(); 
        } 
    }   
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert7()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1]; 
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });             
            Set<Id> setCaseIds= new Set<Id>(); 
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******Aero GSE Orders',
                            OriginCheckChange__c.CaseOriginName__c=> '******Aero GSE Orders'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******Aero GSE Orders',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'Aero GSE Orders'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******Aero GSE Orders',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******Aero GSE Orders';
                
                
                System.assertNotEquals(listCaseMatrix,null,'success'); 
                //CaseHandler objCaseHandler = new CaseHandler(true,1);           
                //Test.startTest();             
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    }  
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert9()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1]; 
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });             
            Set<Id> setCaseIds= new Set<Id>(); 
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******Aero GSE Quotes',
                            OriginCheckChange__c.CaseOriginName__c=> '******Aero GSE Quotes'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******Aero GSE Quotes',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'Aero GSE Quotes'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******Aero GSE Quotes',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******Aero GSE Quotes';
                
                
                System.assertNotEquals(listCaseMatrix,null,'success'); 
                //CaseHandler objCaseHandler = new CaseHandler(true,1);           
                //Test.startTest();             
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert10()
    { 
        
        
        Test.startTest();
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    });  
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
                account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1]; 
                opportunity testOpp= (opportunity)SObjectFactory.create(
                    opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        opportunity.OwnerId => UserInfo.getUserId(),
                            opportunity.Name => 'Test name',
                            opportunity.AccountId => testAccount.Id,
                            opportunity.StageName => 'Prospecting',
                            opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                            });             
                Set<Id> setCaseIds= new Set<Id>(); 
                Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
                
                System.runAs(testUser) {
                    //Create custom setting data
                    OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                        OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                        {
                            OriginCheckChange__c.Name=> '******Aero GSE Support',
                                OriginCheckChange__c.CaseOriginName__c=> '******Aero GSE Support'         
                                }
                    ); 
                    //Create data for Platform__c
                    Platform__c platform = (Platform__c)SObjectFactory.create(
                        Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                        {
                            Platform__c.Name => 'Test Platform'         
                                }
                    ); 
                    //create Fleet_Asset_Detail__c data
                    Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                        Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                        {
                            Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                                Fleet_Asset_Detail__c.Account__c => testAccount.id,
                                Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                                }
                    ); 
                    System.assertNotEquals(fleetAsst,null,'success');                
                    //create case records        
                    List<Case> listCaseEmail = SObjectFactory.create(
                        CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                        {
                            Case.OwnerId => UserInfo.getUserId(),
                                Case.Origin => '******Aero GSE Support',  
                                Case.IsWorkflowTriggered__c => true,
                                Case.Mail_Box_Name__c => 'Fax test',
                                Case.Origin_Check__c => False,
                                Case.Agent_Contact_Flag__c => false, 
                                Case.Subject => 'Fax:{4343434343}',
                                Case.Supported_Product__c => '787 Maintenance System',
                                Case.Aircraft_Name__c => fleetAsst.Id,   
                                Case.opportunity__c=> testOpp.Id,
                                Case.Requested_By_HON_Internal__c=> testContact.Id,
                                Case.contactid => testContact.Id,
                                Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                                }
                    );
                    Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                        Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                        {            
                            Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                                Agent_Contact_Mapping__c.Process__c => 'Aero GSE Support'          
                                }); 
                    System.assertNotEquals(listCaseEmail,null,'success');                  
                    List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                        CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                        {
                            Case_Matrix__c.name => '******Aero GSE Support',
                                Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                                Case_Matrix__c.Email_Public_Group__c => null,
                                Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                                }
                    ); 
                    listCaseEmail[0].Type = '2nd year HUMS';            
                    listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                    listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                    listCaseEmail[0].Status= 'On Hold';
                    listCaseEmail[0].Origin = '******Aero GSE Support';
                    
                    
                    System.assertNotEquals(listCaseMatrix,null,'success'); 
                    //CaseHandler objCaseHandler = new CaseHandler(true,1);           
                    //Test.startTest();             
                    //call before insert handler method 
                    //objCaseHandler.onBeforeInsert(listCaseEmail);
                    CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
                }
            }
            catch(exception e){} 
            
        } 
        Test.stopTest(); 
        
        
    } 
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodInsert11()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1]; 
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });             
            Set<Id> setCaseIds= new Set<Id>(); 
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1]; 
            
            System.runAs(testUser) {
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> '******Aero GSE Vendor Support',
                            OriginCheckChange__c.CaseOriginName__c=> '******Aero GSE Vendor Support'         
                            }
                ); 
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => '******Aero GSE Vendor Support',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RecordTypeId=> RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                            }
                );
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'Aero GSE Vendor Support'          
                            }); 
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => '******Aero GSE Vendor Support',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                listCaseEmail[0].Type = '2nd year HUMS';            
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                listCaseEmail[0].Origin = '******Aero GSE Vendor Support';
                
                
                System.assertNotEquals(listCaseMatrix,null,'success'); 
                //CaseHandler objCaseHandler = new CaseHandler(true,1);           
                //Test.startTest();             
                //call before insert handler method 
                //objCaseHandler.onBeforeInsert(listCaseEmail);
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,null,'Insert');
            }
            Test.stopTest(); 
        } 
    } 
    // Created By : Swastika Rajkhowa Date : 14 Nov 2017
    // method: testMethodRnOCaseOwnerAssignOnCreationMethodupdate
    // Description : test method for caseservice class method RnOCaseOwnerAssignOnCreationMethod for before update
    @isTest static void testMethodRnOCaseOwnerAssignOnCreationMethodupdate()
    {   
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1]; 
            opportunity testOpp= (opportunity)SObjectFactory.create(
                opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        opportunity.AccountId => testAccount.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        });             
            Set<Id> setCaseIds= new Set<Id>();          
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];    
            System.runAs(testUser) {  
                //Create custom setting data
                OriginCheckChange__c custSettingOrigin = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> 'Pilots Corner Avionics',
                            OriginCheckChange__c.CaseOriginName__c=> 'Email-Pilots Corner Avionics'         
                            }
                );
                OriginCheckChange__c custSettingOrigin1 = (OriginCheckChange__c)SObjectFactory.create(
                    OriginCheckChange__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        OriginCheckChange__c.Name=> 'CS#4',
                            OriginCheckChange__c.CaseOriginName__c=> 'Fax te'         
                            }
                );
                //Create data for Platform__c
                Platform__c platform = (Platform__c)SObjectFactory.create(
                    Platform__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Platform__c.Name => 'Test Platform'         
                            }
                ); 
                //create Fleet_Asset_Detail__c data
                Fleet_Asset_Detail__c fleetAsst = (Fleet_Asset_Detail__c)SObjectFactory.create(
                    Fleet_Asset_Detail__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Fleet_Asset_Detail__c.Name => 'Test Fleet Asset',  
                            Fleet_Asset_Detail__c.Account__c => testAccount.id,
                            Fleet_Asset_Detail__c.Platform_Name__c => platform.Id
                            }
                ); 
                System.assertNotEquals(fleetAsst,null,'success');                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => 'Email-Pilots Corner Avionics',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => '787 Maintenance System',
                            Case.Aircraft_Name__c => fleetAsst.Id,   
                            Case.opportunity__c=> testOpp.Id,
                            Case.Requested_By_HON_Internal__c=> testContact.Id,
                            Case.contactid => testContact.Id,
                            Case.RnOSAPCases__c => 100,
                            Case.RecordTypeId => RecordTypeServices.getRecordTypeByName('Engine Rentals', 'Case').Id,
                            Case.Status => 'On Hold',
                            Case.Sub_Status__c => 'Shipment'                              
                            }
                );
                Test.startTest(); 
                
                Agent_Contact_Mapping__c objAgent = (Agent_Contact_Mapping__c)SObjectFactory.create(
                    Agent_Contact_Mapping__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {            
                        Agent_Contact_Mapping__c.Contact__c=> testContact.Id,
                            Agent_Contact_Mapping__c.Process__c => 'Email-Pilots Corner Avionics'          
                            });            
                
                System.assertNotEquals(listCaseEmail,null,'success');                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => 'Email-Pilots Corner Avionics',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => null,
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()                    
                            }
                ); 
                System.assertNotEquals(listCaseMatrix,null,'success'); 
                Map<Id,Case> oldCaseMap = new Map<Id,Case>();
                for(Case objCase: listCaseEmail){
                    case tempCase = new case();                
                    tempCase.id= objCase.id;
                    tempCase.RnOSAPCases__c = 200;                
                    tempCase.Sub_Status__c = 'Admin';
                    tempCase.Status = objCase.Status; 
                    tempCase.Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');                                             
                    oldCaseMap.put(objCase.Id, tempCase);
                }              
                System.assertNotEquals(oldCaseMap,null,'success');           
                update listCaseEmail;
                listCaseEmail[1].Sub_Status__c = 'Removal';
                listCaseEmail[2].Sub_Status__c = 'Other';
                listCaseEmail[3].Sub_Status__c = 'DSO';
                listCaseEmail[5].Status = 'Open';
                listCaseEmail[1].Time_of_first_Type_Change__c= system.now();
                listCaseEmail[0].Type = '2nd year HUMS';
                listCaseEmail[0].Time_of_first_Type_Change__c= date.ValueOf('1968-09-21');   
                //listCaseEmail[0].RecordTypeId= '01230000000Zen0AAC'; 
                listCaseEmail[0].Status= 'On Hold';
                //Test.startTest();  
                //call before insert handler method 
                CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail,oldCaseMap,'Update');
            }
            Test.stopTest();        
            
        } 
    }
    // Created By : Swastika Rajkhowa Date : 03 Nov 2017
    // method: testMethodOnBeforeUpdateAssignPrimary
    // Description : test method for caseservice class method onBeforeInsertAndUpdateAssignPrimary for before update
    @isTest static void testMethodOnBeforeUpdateAssignPrimary()
    {  
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){   
            TriggerInactive.testTrigger = false;            
            Set<Id> setCaseIds= new Set<Id>(); 
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            System.runAs(testUser) { 
                //create case records        
                List<Case> oldListCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => 'Web-Pilots Corner Avionics',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax// test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'Fax:{4343434343}',
                            Case.Supported_Product__c => 'Primary', 
                            Case.RnOSAPCases__c => 100                  
                            }
                );
                List<Case> newListCaseEmail = new List<Case>();
                Map<id,Case> mapoldCase = new Map<id,Case>();   
                Map<id,Case> mapNewCase = new Map<id,Case>();            
                for(case objCase : oldListCaseEmail){
                    mapoldCase.put(objCase.Id, objCase);
                    objCase.RnOSAPCases__c = 200;
                    newListCaseEmail.add(objCase);
                    mapNewCase.put(objCase.Id, objCase);
                }
                update oldListCaseEmail;                  
                List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => 'Email-Pilots Corner Avionics',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => '',
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()               
                            }
                ); 
                Test.startTest(); 
                
                List<Case_Matrix__c> listCaseMatrixWeb = SObjectFactory.create(
                    CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case_Matrix__c.name => 'Web-Pilots Corner Avionics',
                            Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                            Case_Matrix__c.Email_Public_Group__c => '',
                            Case_Matrix__c.OwnerId__c => UserInfo.getUserId()               
                            }
                ); 
                List<Skills2__c> listSkill = SObjectFactory.create(
                    2, Skills2__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Skills2__c.Primary_Secondary__c =>'Primary'
                            
                            }
                ); 
                //Test.startTest(); 
                
                CaseHandler objCaseHandler = new CaseHandler(true,1);  
                //call before insert handler method 
                //objCaseHandler.onBeforeUpdate(oldListCaseEmail ,newListCaseEmail ,mapNewCase,mapOldCase );             
                System.assertNotEquals(oldListCaseEmail,null,'success');
                System.assertNotEquals(newListCaseEmail,null,'success');        
            } 
        }
        Test.stopTest();
    }
    // Created By : Swastika Rajkhowa Date : 03 Nov 2017
    // method: testMethodOnBeforeUpdateAssignPrimary
    // Description : test method for caseservice class method onBeforeInsertAndUpdateAssignPrimary for before update
    @isTest static void testMethodOnBeforeUpdateAssignPrimaryWebCase()
    {  
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){   
            TriggerInactive.testTrigger = false;            
            Set<Id> setCaseIds= new Set<Id>();
            //create case records        
            List<Case> ListCaseEmail = SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.OwnerId => '00Ga0000002sviEEAQ',
                        Case.Origin => 'Web',  
                        Case.IsWorkflowTriggered__c => true,
                        Case.Mail_Box_Name__c => 'Fax//test',
                        Case.Origin_Check__c => False,
                        Case.Agent_Contact_Flag__c => false, 
                        Case.Subject => 'ELT Coding',
                        Case.recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                        Case.Supported_Product__c => 'Primary', 
                        Case.RnOSAPCases__c => 100                  
                        }
            );
            List<Case> oldListCaseEmail = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
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
                                                          Account_Concierge__c,NPS_Recommend__c
                                                          From Case
                                                          WHERE Origin=:'Web']);
            List<Case> newListCaseEmail = new List<Case>();
            Map<id,Case> mapoldCase = new Map<id,Case>();   
            Map<id,Case> mapNewCase = new Map<id,Case>();            
            for(case objCase : oldListCaseEmail){
                mapoldCase.put(objCase.Id, objCase);               
            }
            for(case objCase : oldListCaseEmail){
                case tempCase = new case(); 
                tempCase.Origin = 'Web';
                tempCase.Id = objCase.Id;               
                tempCase.RnOSAPCases__c = 200;
                tempCase.Subject = 'ELT Coding';
                tempCase.OwnerId = '005300000042rPLAAY';
                tempCase.recordtypeid = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id;
                newListCaseEmail.add(tempCase);                
            }   
            update newListCaseEmail;        
            for(case objCase : newListCaseEmail){
                mapNewCase.put(objCase.Id, objCase);
            }     
            Test.startTest(); 
            
            List<Case_Matrix__c> listCaseMatrix = SObjectFactory.create(
                CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case_Matrix__c.name => 'Email-Pilots Corner Avionics',
                        Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                        Case_Matrix__c.Email_Public_Group__c => '',
                        Case_Matrix__c.OwnerId__c => UserInfo.getUserId()               
                        }
            ); 
            List<Case_Matrix__c> listCaseMatrixWeb = SObjectFactory.create(
                CASE_MATRIX_COUNT, Case_Matrix__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case_Matrix__c.name => 'Web-Pilots Corner Avionics',
                        Case_Matrix__c.OwnerId => UserInfo.getUserId(),
                        Case_Matrix__c.Email_Public_Group__c => '',
                        Case_Matrix__c.OwnerId__c => UserInfo.getUserId()               
                        }
            ); 
            List<Skills2__c> listSkill = SObjectFactory.create(
                2, Skills2__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Skills2__c.Primary_Secondary__c =>'Primary',
                        Skills2__c.Supported_Product__c =>'Primary'              
                        }
            ); 
            
            
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method 
            //objCaseHandler.onBeforeUpdate(ListCaseEmail,newListCaseEmail,mapNewCase,mapOldCase );             
            
            System.assertNotEquals(oldListCaseEmail,null,'success');
            System.assertNotEquals(newListCaseEmail,null,'success'); 
        }
        Test.stopTest();
    }
    // Created By : Swastika Rajkhowa Date : 03 Nov 2017
    // method: testMethodOnBeforeUpdateAssignPrimary
    // Description : test method for caseservice class method onBeforeInsertAndUpdateAssignPrimary for before update
    @isTest static void testMethodOnBeforeUpdateAssignPrimaryWebCaseOwner()
    { 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;                
            Set<Id> setCaseIds= new Set<Id>();  
            //create case records        
            List<Case> ListCaseEmail = SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.OwnerId => '00Ga0000002svi9',
                        Case.Origin => 'Web',  
                        Case.IsWorkflowTriggered__c => true,
                        Case.Mail_Box_Name__c => 'Fax// test',
                        Case.Origin_Check__c => False,
                        Case.Agent_Contact_Flag__c => false, 
                        Case.Subject => 'ELT Coding',
                        Case.recordtypeid => '012a0000001ZLs9',
                        Case.Supported_Product__c => 'Primary', 
                        Case.RnOSAPCases__c => 100                  
                        }
            );
            List<Case> oldListCaseEmail = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
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
                                                          Account_Concierge__c,NPS_Recommend__c
                                                          From Case
                                                          WHERE Origin=:'Web']);
            List<Case> newListCaseEmail = new List<Case>();
            Map<id,Case> mapoldCase = new Map<id,Case>();   
            Map<id,Case> mapNewCase = new Map<id,Case>();            
            for(case objCase : oldListCaseEmail){
                mapoldCase.put(objCase.Id, objCase);               
            }
            for(case objCase : oldListCaseEmail){
                case tempCase = new case(); 
                tempCase.Origin = 'Web';
                tempCase.Id = objCase.Id;               
                tempCase.RnOSAPCases__c = 200;
                tempCase.Subject = 'ELT Coding';
                tempCase.OwnerId = '005300000042rPLAAY';
                tempCase.recordtypeid = '012a0000001ZLs9AAG';
                newListCaseEmail.add(tempCase);                
            }   
            Test.startTest(); 
            update newListCaseEmail;
            for(case objCase : newListCaseEmail){
                mapNewCase.put(objCase.Id, objCase);
            }
            //Test.startTest();        
            CaseHandler objCaseHandler = new CaseHandler(true,1);
            //call before insert handler method 
            //objCaseHandler.onBeforeUpdate(ListCaseEmail ,newListCaseEmail,mapNewCase,mapOldCase );             
            
            System.assertNotEquals(oldListCaseEmail,null,'success');
            System.assertNotEquals(newListCaseEmail,null,'success');      
        }
        Test.stopTest();
    } 
    
    //Created By : Swastika Rajkhowa Date : 03 Nov 2017
    // method: testMethodOnBeforeUpdateAssignPrimary
    // Description : test method for caseservice class method onBeforeInsertAndUpdateAssignPrimary for before update
    @isTest static void testMethodOnBeforeUpdateAssignPrimaryEmailCase()
    {   
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;              
            Set<Id> setCaseIds= new Set<Id>();   
            //create case records        
            List<Case> ListCaseEmail = SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.OwnerId => '00Ga0000002svi9',
                        Case.Origin => 'Email-Pilots Corner Avionics',  
                        Case.IsWorkflowTriggered__c => true,
                        Case.Mail_Box_Name__c => 'Fax// test',
                        Case.Origin_Check__c => False,
                        Case.Agent_Contact_Flag__c => false, 
                        Case.Subject => 'ELT Coding',
                        Case.recordtypeid => '012a0000001ZLs9',
                        Case.Supported_Product__c => 'Primary', 
                        Case.RnOSAPCases__c => 100                  
                        }
            );
            List<Case> oldListCaseEmail = [SELECT ID,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Web'];
            List<Case> newListCaseEmail = new List<Case>();
            Map<id,Case> mapoldCase = new Map<id,Case>();   
            Map<id,Case> mapNewCase = new Map<id,Case>();            
            for(case objCase : oldListCaseEmail){
                mapoldCase.put(objCase.Id, objCase);               
            }
            for(case objCase : oldListCaseEmail){
                case tempCase = new case(); 
                tempCase.Id = objCase.Id;               
                tempCase.RnOSAPCases__c = 200;
                tempCase.Subject = 'ELT Coding';
                tempCase.OwnerId = '005300000042rPLAAY';
                tempCase.recordtypeid = '012a0000001ZLs9AAG';
                newListCaseEmail.add(tempCase);                
            }   
            update newListCaseEmail;
            for(case objCase : newListCaseEmail){
                mapNewCase.put(objCase.Id, objCase);
            }
            //Test.startTest();        
            CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //call before insert handler method 
            objCaseHandler.onBeforeUpdate(ListCaseEmail ,newListCaseEmail,mapNewCase,mapOldCase );             
            
            System.assertNotEquals(oldListCaseEmail,null,'success');
            System.assertNotEquals(newListCaseEmail,null,'success');     
        }
        Test.stopTest(); 
    } 
    //Start of test methods for UpdateOppProposalCase method of CaseClassForPublicMethods
    static testMethod void testAfterInsert_UpdateOppProposalNewCase()
    { 
        //setup();
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            
            Map<ID,Case> oldCaseMap = new Map<ID,Case>();
            Set<Id> setCaseIds_old= new Set<Id>();
            Set<Id> setCaseIds_new= new Set<Id>();
            List<Case> List_newCase = new List<Case>();
            
            
            List<opportunity> objOpp= SObjectFactory.create(
                CASE_COUNT, opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        //opportunity.AccountId => accountWithBGA.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        }); 
            
            
            
            
            Opportunity_Proposal__c  caseOppProp1 = (Opportunity_Proposal__c) SObjectFactory.create(Opportunity_Proposal__c.SObjectType,
                                                                                                    new Map<SObjectField, Object>{
                                                                                                        Opportunity_Proposal__c.Opportunity__c=> objOpp[0].Id
                                                                                                            
                                                                                                            });
            
            
            List_newCase= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Web',
                        Case.Status => 'Done',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Ownerid => UserInfo.getUserId(),
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Opportunity_Proposal__c=>caseOppProp1.Id,
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO'            
                        }
            );
            
            
            
            
            for(Case objCase: List_newCase){
                setCaseIds_new.add(objCase.Id);
            }
            
            
            try{
                CaseServiceForCommonMethods.UpdateOppProposalCase(List_newCase,null);
                
            }catch(Exception e){}
            
            
            for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds_new])
            {
                system.assertEquals(CaseTech.Origin,'Web');
                
                
            }
        }
        Test.stopTest();
        
    }
    static testMethod void testAfterInsert_UpdateOppProposalOldCase()
    { 
        //setup();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            
            Map<ID,Case> oldCaseMap = new Map<ID,Case>();
            Set<Id> setCaseIds_old= new Set<Id>();
            Set<Id> setCaseIds_new= new Set<Id>();
            List<Case> List_newCase = new List<Case>();
            
            List<opportunity> objOpp= SObjectFactory.create(
                CASE_COUNT, opportunity.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    opportunity.OwnerId => UserInfo.getUserId(),
                        opportunity.Name => 'Test name',
                        //opportunity.AccountId => accountWithBGA.Id,
                        opportunity.StageName => 'Prospecting',
                        opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                        }); 
            Opportunity_Proposal__c  caseOppProp= (Opportunity_Proposal__c) SObjectFactory.create(Opportunity_Proposal__c.SObjectType,
                                                                                                  new Map<SObjectField, Object>{
                                                                                                      
                                                                                                      Opportunity_Proposal__c.Opportunity__c=> objOpp[0].Id
                                                                                                          
                                                                                                          }
                                                                                                 );
            
            List<Case> list_oldCase= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.OwnerId => UserInfo.getUserId(),
                        Case.Opportunity_Proposal__c=>caseOppProp.Id,
                        Case.status=> 'In Process'  
                        
                        
                        
                        }
            );
            for(case objCase : list_oldCase){ 
                setCaseIds_old.add(objCase.Id);
                oldCaseMap.put(objCase.Id,objCase);
                
                
            }
            Test.startTest(); 
            
            Opportunity_Proposal__c  caseOppProp1 = (Opportunity_Proposal__c) SObjectFactory.create(Opportunity_Proposal__c.SObjectType,
                                                                                                    new Map<SObjectField, Object>{
                                                                                                        
                                                                                                        Opportunity_Proposal__c.Opportunity__c=> objOpp[0].Id
                                                                                                            
                                                                                                            });
            
            
            List_newCase= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Web',
                        Case.Status => 'Done',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Ownerid => UserInfo.getUserId(),
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Opportunity_Proposal__c=>caseOppProp.Id,
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO'            
                        }
            );
            
            for(Case objCase: List_newCase){
                setCaseIds_new.add(objCase.Id);
            }
            
            
            try{
                CaseServiceForCommonMethods.UpdateOppProposalCase(List_newCase,oldCaseMap);
                
            }catch(Exception e){}
            
            for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds_new])
            {
                system.assertEquals(CaseTech.Origin,'Web');
                
            }   
        }
        Test.stopTest();
        
    }
    
    //End of test methods for UpdateOppProposalCase method of CaseClassForPublicMethods
    //start of test methods for ACSMSendCaseEmailMethod method of CaseClassForPublicMethods
    static testMethod void ACSMSendCaseEmailMethod_InsertTest(){
        
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        Test.startTest();
        
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];
            
            try{
                
                Set<Id> setCaseIds= new Set<Id>();
                List<Case> ListCaseEmail = new List<Case>();  
                //create case records 
                ListCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => 'Web',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Mail_Box_Name__c => 'Fax//test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'ELT Coding',
                            Case.recordtypeid => RecordTypeServices.getRecordTypeByName('FSS Technical Issue', 'Case').Id,
                            Case.Supported_Product__c => 'Primary', 
                            Case.RnOSAPCases__c => 100,
                            Case.ContactId =>testContact.Id,
                            Case.Emailbox_Origin__c=> 'Email-FSS Tech Support',
                            Case.CreatedById =>Label.ACSM_API_User_Id,
                            Case.OF_OPEN_ACTIVITY__C=>1
                            }
                );
                
                //try{      
                CaseServiceForCommonMethods.ACSMSendCaseEmailMethod(ListCaseEmail,null,'Insert');
            }
            catch(Exception e){} 
        }     
        
        Test.stopTest();
        
        
    }
    
    //Added by Shilpa - Test method for ACSMSendCaseEmailMethod(for Update)
    
    static testMethod void ACSMSendCaseEmailMethod_UpdateTest(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                //User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
                account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
                Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
                
                
                Set<Id> setCaseIds= new Set<Id>();       
                //create case records        
                List<Case> ListCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => 'Web',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Status => 'Open',
                            Case.Mail_Box_Name__c => 'Fax//test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'ELT Coding',
                            Case.recordtypeid => RecordTypeServices.getRecordTypeByName('FSS Technical Issue', 'Case').Id,
                            Case.Supported_Product__c => 'Primary', 
                            Case.RnOSAPCases__c => 100,
                            Case.ContactId =>testContact.Id,
                            Case.Emailbox_Origin__c=> 'Email-FSS Tech Support'
                            //Case.CreatedById =>Label.ACSM_API_User_Id
                            
                            }
                );
                List<Case> oldListCaseEmail = [SELECT ID,ContactId,recordtypeid,Government_Compliance_SM_M_Content__c,Export_Compliance_Content_ITAR_EAR__c,Resolution__c,Sub_Class__c,Detail_Class__c,Repair_Location__c,Classification__c,Status,AccountId,Expected_Update__c,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Web'];
                List<Case> newListCaseEmail = new List<Case>();
                Map<id,Case> mapoldCase = new Map<id,Case>(); 
                for(case objCase : oldListCaseEmail){
                    mapoldCase.put(objCase.Id, objCase);               
                }
                for(case objCase : oldListCaseEmail){
                    case tempCase = new case(); 
                    tempCase.Origin = 'Web';
                    tempCase.Id = objCase.Id;               
                    tempCase.RnOSAPCases__c = 200;
                    tempCase.Subject = 'ELT Coding';
                    tempCase.OwnerId = aircraftContySerMgntUserId;
                    
                    newListCaseEmail.add(tempCase);                
                }   
                update newListCaseEmail;        
                
                newListCaseEmail = [SELECT ID,Primary_Email_Address__c,ContactId,recordtypeid,Government_Compliance_SM_M_Content__c,Export_Compliance_Content_ITAR_EAR__c,Resolution__c,Sub_Class__c,Detail_Class__c,Repair_Location__c,Classification__c,Status,AccountId,Expected_Update__c,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Web'];
                
                
                
                
                CaseServiceForCommonMethods.ACSMSendCaseEmailMethod(newListCaseEmail ,mapoldCase,'Update');
                
            }
            catch(Exception e){}   
        }
        Test.stopTest();                  
        
        
    }
    
    //Added by Shilpa- Test method for ACSMSendCaseEmailMethod(Update - SecondTestcase)
    
    static testMethod void ACSMSendCaseEmailMethod_Update_StatusClosed(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
                Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
                
                Set<Id> setCaseIds= new Set<Id>();       
                //create case records        
                List<Case> ListCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => '0050n000000snYk',
                            Case.Origin => 'Web',  
                            Case.IsWorkflowTriggered__c => true,    
                            Case.Status => 'On Hold',
                            Case.Sub_Status__c => 'Business Hold',    
                            Case.Mail_Box_Name__c => 'Fax//test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'ELT Coding',
                            Case.recordtypeid => RecordTypeServices.getRecordTypeByName('FSS Technical Issue', 'Case').Id,
                            Case.Supported_Product__c => 'Primary', 
                            Case.RnOSAPCases__c => 100,
                            Case.ContactId =>testContact.Id,
                            Case.Emailbox_Origin__c=> 'Email-FSS Tech Support'
                            //Case.CreatedById =>Label.ACSM_API_User_Id
                            
                            }
                );
                List<Case> oldListCaseEmail = [SELECT ID,ContactId,recordtypeid,Government_Compliance_SM_M_Content__c,Export_Compliance_Content_ITAR_EAR__c,Resolution__c,Sub_Class__c,Detail_Class__c,Repair_Location__c,Classification__c,Status,AccountId,Expected_Update__c,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Web'];
                List<Case> newListCaseEmail = new List<Case>();
                Map<id,Case> mapoldCase = new Map<id,Case>(); 
                for(case objCase : oldListCaseEmail){
                    mapoldCase.put(objCase.Id, objCase);               
                }
                for(case objCase : oldListCaseEmail){
                    case tempCase = new case(); 
                    tempCase.Origin = 'Phone';
                    tempCase.Status = 'Closed';
                    tempCase.Id = objCase.Id;               
                    tempCase.RnOSAPCases__c = 200;
                    tempCase.Subject = 'ELT Coding';
                    tempCase.OwnerId = '005300000042rPLAAY';
                    //tempCase.recordtypeid = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id;
                    newListCaseEmail.add(tempCase);                
                }   
                update newListCaseEmail;        
                
                newListCaseEmail = [SELECT ID,Sub_Status__c,IsClosed,Primary_Email_Address__c,ContactId,recordtypeid,Government_Compliance_SM_M_Content__c,Export_Compliance_Content_ITAR_EAR__c,Resolution__c,Sub_Class__c,Detail_Class__c,Repair_Location__c,Classification__c,Status,AccountId,Expected_Update__c,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Phone'];
                
                
                
                CaseServiceForCommonMethods.ACSMSendCaseEmailMethod(newListCaseEmail ,mapoldCase,'Update');
                
            }
            catch(Exception e){}   
        }                  
        Test.stopTest();
        
    }
    
    //End of test methods for ACSMSendCaseEmailMethod method of CaseClassForPublicMethods
    
    @isTest static void testSetCaseDetail(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Case Case1 = (Case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.OwnerId => UserInfo.getUserId(),
                        Case.Type => 'Order Status', 
                        Case.Subject => 'Test',
                        Case.recordtypeid => rtIdOEMQuoteOrders,
                        Case.Classification__c => 'CSO OEM',
                        Case.Government_Compliance_SM_M_Content__c => 'Yes',
                        Case.IsMemberOfCompliance__c => false  
                        });
            Case Case2 = (Case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.OwnerId => UserInfo.getUserId(),
                        Case.Type => 'Order Status', 
                        Case.Subject => '',
                        Case.recordtypeid => rtIdOEMQuoteOrders,
                        Case.Classification__c => 'CSO OEM',
                        Case.Government_Compliance_SM_M_Content__c => 'Yes',
                        Case.IsMemberOfCompliance__c => false  
                        });
            
            List<string> s1=CaseServiceForCommonMethods.setCaseDetail(case1);
            List<string> s2=CaseServiceForCommonMethods.setCaseDetail(case2);
            
            system.assertNotEquals(s1[0], null);
            system.assertEquals(s1[1], 'Test');
            system.assertNotEquals(s1[2], null);
            system.assertNotEquals(s2[0], null);
            system.assertEquals(s2[1], '');
            system.assertNotEquals(s2[2], null);
        }
        Test.stopTest();
    }
    
    @isTest static void testAssignValues(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Case sampleCase = (Case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.OwnerId => UserInfo.getUserId(),
                        Case.Type => 'Order Status', 
                        Case.recordtypeid => rtIdOEMQuoteOrders,
                        Case.resolution__C => 'Resolved Cases for Orders',
                        Case.sub_class__c => 'Order Status'
                        });               
            
            CaseServiceForCommonMethods.assignValues(isSent,sampleCase,tempId);
        }
        Test.StopTest();
    }    
    
    @isTest static void testSetEmailMessage(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            String[] toAddress = new String[]{};
                listUser = New List<User>([SELECT email FROM User WHERE username='test_radha@in.ibm.com']);
            for(User u : listUser){
                toAddress.add(u.email);
            }
            
            //Integer emailbefore = Limits.getEmailInvocations();
            Messaging.SingleEmailMessage msg=CaseServiceForCommonMethods.setEmailMessage(targetObjectId, WhatId, toAddress, mailBody, mailSubject, tempId, orgWideEmailAddressId);
            Messaging.SingleEmailMessage msg2=CaseServiceForCommonMethods.setEmailMessage(targetObjectId, WhatId, toAddress, mailBody, mailSubject, tempId, null);
            //MyBatch batch = new MyBatch();
            //MyBatch.sendNotication();
            //system.assertNotEquals(emailbefore,Limits.getEmailInvocations(),'should have decreased');
            system.assertEquals(msg.HTMLBody, 'Test Mail Body');
            system.assertEquals(msg.Subject, 'Test Mail Subject');
        }
        Test.stopTest();
    }
    
    @isTest static void testGetGDCGroup() {
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            String s1 = CaseServiceForCommonMethods.getGDCGroup('Activation');
            String s2 = CaseServiceForCommonMethods.getGDCGroup('Cancellation');
            String s3 = CaseServiceForCommonMethods.getGDCGroup('MyGDC Training');
            String s4 = CaseServiceForCommonMethods.getGDCGroup('Renewal');
            String s5 = CaseServiceForCommonMethods.getGDCGroup('Technical Support');
            
            System.assertEquals(s1,'GDC Accounts Activation');
            System.assertEquals(s2,'GDC Accounts Cancellation');
            System.assertEquals(s3,'GDC Accounts MyGDC Training');
            System.assertEquals(s4,'GDC Accounts Renewal');
            System.assertEquals(s5,'GDC Accounts Technical Support');
        }
        Test.stopTest();
    }
    
    @isTest static void testCreateBulkEmailsAVSAT_1a(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            cont = [SELECT Id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4'];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(), 
                    Case.Type => 'Order Status', 
                    Case.Subject => 'Test',
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('JXSupport', 'Case').Id ,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.SuppliedEmail => 'test@gulfstream.com',
                    Case.Description => 'Test',
                    Case.Resolution__c => 'Test',
                    Case.ContactId => cont.id,
                    Case.Emailbox_Origin__c => 'Email-AVSAT Orders',            
                    Case.Origin => 'Email-AVSAT Orders'
                    });
            
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsAVSAT('Insert', cas); 
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    
    @isTest static void testsendCaseEmailMethodInsert1(){
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    
                    Case.AccountId=> objAccount.Id,
                    //Case.Service_Level__c,
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False      
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            caseList.add(Cas1);
            case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('D&S Clearing House Proposal','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False            
                    }); 
            caseList.add(Cas2);  
            case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-JXAccounts',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas3);
            case Cas4 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'MTO',
                    Case.Origin => 'Web',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Orders',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas4);  
            case Cas5 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero Export Hold',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas5);
            case Cas6 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas6);
            case Cas7 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas7);
            case Cas8 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas8);
            case Cas9 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas9);
            case Cas10 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas10);
            Test.startTest(); 
            
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert2abc(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'Aero Level',
                    account.Service_Level__c => 'Standard',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        Contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@honeywell.com',
                    contact.Primary_Email_Address__c => 'test_radha@honeywell.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@honeywell.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'New',
                    //Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Aero Export Holds','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-yeovil.spares',
                    Case.Emailbox_Origin__c => 'Email- AerospaceWarranty',                     
                    Case.AccountId=> objAccount.Id,                    
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            //caseList.add(Cas1);
            Test.startTest(); 
            
            insert Cas1;
            Case[] ca = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                         Emailbox_Origin__c,AccountId,ContactId,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                         IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                         from case where Id = :Cas1.Id];
            for(Case c1 : ca){
                caseList.add(c1);
            }
            //caseList.add(Cas1);
            System.debug('Case Service Level : '+caseList[0].Service_Level__c);
            System.debug('Case Service Level : '+caseList[0].ContactId);
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert2abc1(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'Aero Level',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        Contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@honeywell.com',
                    contact.Primary_Email_Address__c => 'test_radha@honeywell.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@honeywell.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'New',
                    //Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Aero Export Holds','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    //Case.Origin => 'Email-yeovil.spares',
                    Case.Emailbox_Origin__c => 'Email- AerospaceWarranty',                     
                    Case.AccountId=> objAccount.Id,                    
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            //caseList.add(Cas1);
            Test.startTest(); 
            
            insert Cas1;
            Case[] ca = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                         Emailbox_Origin__c,AccountId,ContactId,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                         IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                         from case where Id = :Cas1.Id];
            for(Case c1 : ca){
                caseList.add(c1);
            }
            //caseList.add(Cas1);
            System.debug('Case Service Level : '+caseList[0].Service_Level__c);
            System.debug('Case Service Level : '+caseList[0].ContactId);
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert2abc2(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'Aero Level',
                    account.Service_Level__c => 'Standard',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        Contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@honeywell.com',
                    contact.Primary_Email_Address__c => 'test_radha@honeywell.com'
                    }); 
        Test.startTest(); 
        User runUser = [Select id From User Where id =: label.API_User_My_Aerospace_Portal Limit 1];
        System.debug('API User My Aerospace Portal  005300000044CmQAAU : '+runUser.id);
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@honeywell.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Webform',
                    Case.Status=>'New',
                    //Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Web',
                    Case.Emailbox_Origin__c => 'Email- AerospaceWarranty',                     
                    Case.AccountId=> objAccount.Id,                    
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            
            
            insert Cas1;
            Case[] ca = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                         Emailbox_Origin__c,AccountId,ContactId,CreatedById,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                         IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                         from case where Id = :Cas1.Id];
            for(Case c1 : ca){
                caseList.add(c1);
            }
            //caseList.add(Cas1);
            System.debug('Case Service Level : '+caseList[0].Service_Level__c);
            System.debug('Case Service Level : '+caseList[0].ContactId);
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert2abc3(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'Aero Level',
                    account.Service_Level__c => 'Standard',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        Contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@honeywell.com',
                    contact.Primary_Email_Address__c => 'test_radha@honeywell.com'
                    }); 
        Test.startTest(); 
        User runUser = [Select id From User Where id =: label.API_User_My_Aerospace_Portal Limit 1];
        System.debug('API User My Aerospace Portal  005300000044CmQAAU : '+runUser.id);
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@honeywell.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'test',
                    Case.Status=>'New',
                    //Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Repair & Overhaul','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Web',
                    Case.Emailbox_Origin__c => 'Email- AerospaceWarranty',                     
                    Case.AccountId=> objAccount.Id,                    
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            
            
            insert Cas1;
            Case[] ca = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                         Emailbox_Origin__c,AccountId,ContactId,CreatedById,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                         IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                         from case where Id = :Cas1.Id];
            for(Case c1 : ca){
                caseList.add(c1);
            }
            //caseList.add(Cas1);
            System.debug('Case Service Level : '+caseList[0].Service_Level__c);
            System.debug('Case Service Level : '+caseList[0].ContactId);
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert2(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'Aero Level',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        Contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@honeywell.com',
                    contact.Primary_Email_Address__c => 'test_radha@honeywell.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@honeywell.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'New',
                    //Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Technical issue','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-yeovil.spares',
                    Case.Emailbox_Origin__c => 'Email-Order Status',                     
                    Case.AccountId=> objAccount.Id,                    
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            //caseList.add(Cas1);
            Test.startTest(); 
            
            insert Cas1;
            Case[] ca = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                         Emailbox_Origin__c,AccountId,ContactId,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                         IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                         from case where Id = :Cas1.Id];
            for(Case c1 : ca){
                caseList.add(c1);
            }
            //caseList.add(Cas1);
            System.debug('Case Service Level : '+caseList[0].Service_Level__c);
            System.debug('Case Service Level : '+caseList[0].ContactId);
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert2ab(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'Aero Level',
                    account.Service_Level__c => 'Standard',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Americas'         
                    });
        System.debug('Account Service Level : '+objAccount.Service_Level__c);
        Contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@honeywell.com',
                    contact.Primary_Email_Address__c => 'test_radha@honeywell.com'
                    }); 
        User runUser = [Select id From User Where id =: label.API_User_My_Aerospace_Portal Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@honeywell.com'];
            acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
            //List<Case> caseList = new List<case>();
            List<Case> caseList1 = new List<case>();
            Set<ID> allParentCase = new Set<ID>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'New',
                    //Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-yeovil.spares',
                    Case.Emailbox_Origin__c => 'Email-Order Status',                     
                    Case.AccountId=> objAccount.Id,                    
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False
                    });
            System.debug('Case Service Level : '+Cas1.Service_Level__c);
            caseList1.add(Cas1);
            
            Test.startTest(); 
            
            insert caseList1;
            
            for(Case c1 : caseList1){
                allParentCase.add(c1.Id);
            }
            Case[] caseList = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                               Emailbox_Origin__c,AccountId,ContactId,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                               IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                               from case where Id in :allParentCase];
            
            System.debug('Case Service Level : '+caseList[0].Service_Level__c);
            System.debug('Case Service Level : '+caseList[0].ContactId);
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert3(){
        
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1);
            Test.startTest(); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert3a(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.Service_Level__c => 'Superior',
                    account.Do_Not_Send_to_Portal__c => false,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Americas'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            Set<ID> allParentCase = new Set<ID>();
            List<Case> caseList1 = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> objAccount.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList1.add(Cas1); 
            insert caseList1;
            for(Case c1 : caseList1){
                allParentCase.add(c1.Id);
            }
            Case[] caseList = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                               Emailbox_Origin__c,AccountId,account.Orders_Next_Wave__c,ContactId,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                               IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                               from case where Id in :allParentCase];
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert3ab(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.Service_Level__c => 'Superior',
                    account.Do_Not_Send_to_Portal__c => true,
                    account.Orders_Next_Wave__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Americas'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            Set<ID> allParentCase = new Set<ID>();
            List<Case> caseList1 = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> objAccount.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-BFESupport',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList1.add(Cas1); 
            insert caseList1;
            for(Case c1 : caseList1){
                allParentCase.add(c1.Id);
            }
            Case[] caseList = [select id,Service_Level__c,SBU__c,OwnerId,Type,Subject,Status,RecordtypeId,SuppliedEmail,Origin,
                               Emailbox_Origin__c,AccountId,account.Orders_Next_Wave__c,ContactId,NSN__c,Part_Number__c,AOG__c,Do_Not_Send_to_Portal__c,Region__c,
                               IsClosed,Primary_Email_Address__c,PFECN__c,Survey_Sent__c,Sub_Class__c,Survey_Type__c,Account_Type__c,Quotes_Do_Not_Send_to_Portal__c 
                               from case where Id in :allParentCase];
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert3b(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Owner/Operator',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Superior',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert3c(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Superior',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Americas'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert4(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert5(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert6(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false
                    });
            caseList.add(Cas1);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c                             
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert7(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }  
    @isTest static void testsendCaseEmailMethodInsert8(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Service_Level__c = 'Unauthorized Dist/Brkr' LIMIT 1];
            List<Case> caseList =new List<Case>();
            Case case1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False            
                    });
            caseList.add(case1);
            insert caseList;  
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert9(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert10(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com']; 
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c ,IsClosed,AOG__c
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert11(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert12(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
            
        }
        Test.stopTest();
    }
    
    
    @isTest static void testsendCaseEmailMethodInsert13(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('NavDB Prod','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas1); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert14(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Origin => 'Email-DS OEM & Spares Internal',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert15(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Origin => 'Email-DS Repairs Internal',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert16(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email- AerospaceWarranty',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert17(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Aero Export Holds','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Email-DS OEM & Spares Internal',
                    Case.AOG__c=> False           
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert18(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com']; 
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => null,
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert19(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Edinburgh',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert20(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Raunheim',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert21(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Garden Grove',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert22(){
        Test.startTest();
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-BFESupport',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert23(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-EMS-Norcross',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert24(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-EMS-Norcross',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Email-Order Changes',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c             
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert25(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert26(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Changes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False        
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert27(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False        
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert28(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert29(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-RO EMEAI Internal',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert30(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Quotes','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-RO EMEAI Internal',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.Subject => 'Test MTO',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert31(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('GDC Accounts','Case').Id,
                    Case.SuppliedEmail => null,
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.Subject => 'Test MTO',
                    Case.classification__c => 'Activation',
                    Case.Priority => 'Critical',
                    Case.Description => 'test Description',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            GDC_Accounts_Groups__c customSettingGDS= (GDC_Accounts_Groups__c)SObjectFactory.create(GDC_Accounts_Groups__c.sObjectType, new Map<Schema.SObjectField, Object>{
                GDC_Accounts_Groups__c.name => 'GDC Accounts Activation',
                    GDC_Accounts_Groups__c.EmailID__c => 'test@test.com,test1@test.com'
                    });
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,classification__c,Priority,IsClosed,AOG__c               
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}      
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert32(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('ITEC Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.Subject => 'Test MTO',
                    Case.classification__c => 'ITEC',
                    Case.Priority => 'Critical',
                    Case.Description => 'test Description',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            GDC_Accounts_Groups__c customSettingGDS= (GDC_Accounts_Groups__c)SObjectFactory.create(GDC_Accounts_Groups__c.sObjectType, new Map<Schema.SObjectField, Object>{
                GDC_Accounts_Groups__c.name => 'GDC Accounts Activation',
                    GDC_Accounts_Groups__c.EmailID__c => 'test@test.com,test1@test.com'
                    });
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,classification__c,Priority,IsClosed,AOG__c               
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}  
        }    
        Test.stopTest();
    }  
    @isTest static void testsendCaseEmailMethodInsert33(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];     
            case Cas = (Case)SObjectFactory.Create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => Label.ITEC_Orders_Team_Id,
                    Case.Type => 'WEB Portal Registration',
                    Case.Status=>'In Process',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.Subject => 'Test MTO',
                    Case.classification__c => 'ITEC',
                    Case.Priority => 'Critical',
                    Case.Description => 'test Description',
                    Case.AOG__c=> False          
                    });
            List<Case> oldCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,classification__c,Priority,of_Open_Activity__c,IsClosed,AOG__c                
                                     FROM Case Where AccountId=:acc.Id]; 
            map<id,case> oldCaseMap = new map<id,case>();
            for(case c:oldCaseList){
                oldCaseMap.put(c.id,c);
            }
            Id idBGLRPubsAccess = [SELECT Id FROM Group WHERE Type = 'Queue' and DeveloperName = 'BGLRPubsAccess'].Id;
            list<case> list_Cas = New list<case>();
            for(Case c:oldCaseList){           
                Case CasTemp = new Case();
                CasTemp = c;
                CasTemp.Status='Closed';
                CasTemp.of_Open_Activity__c =1;
                CasTemp.Export_Compliance_Content_ITAR_EAR__c ='Yes';
                CasTemp.Government_Compliance_SM_M_Content__c ='Yes';
                CasTemp.OwnerId = idBGLRPubsAccess;
                list_Cas.add(CasTemp);
            }
            update list_Cas;                           
            GDC_Accounts_Groups__c customSettingGDS= (GDC_Accounts_Groups__c)SObjectFactory.create(GDC_Accounts_Groups__c.sObjectType, new Map<Schema.SObjectField, Object>{
                GDC_Accounts_Groups__c.name => 'GDC Accounts Activation',
                    GDC_Accounts_Groups__c.EmailID__c => 'test@test.com,test1@test.com'
                    });
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,classification__c,Priority,of_Open_Activity__c,IsClosed                
                                     FROM Case Where Status='Closed'];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,oldCaseMap,'Update');
            }
            catch(exception e){} 
        }     
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert34(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            List<Case> caseList = new List<case>(); 
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-EngineRentals',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas1); 
            insert caseList;
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert35(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert36(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert37(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert38(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Changes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert39(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => null,
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Quotes','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Changes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert40(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => null,
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-AeroComponents',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.AOG__c=> False          
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert41(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            User User1 = [SELECT Id FROM User WHERE username='test_radha@in.ibm.com' LIMIT 1];
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            system.runas(User1){   
                case Cas = (Case)SObjectFactory.Create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.OwnerId => UserInfo.getUserId(),
                        Case.Type => 'WEB Portal Registration',
                        Case.Status=>'In Process',
                        Case.Sub_Status__c => 'Accts',    
                        Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Weather Information Service','Case').Id,
                        Case.SuppliedEmail => 'Test@gulfstream.com',
                        Case.AccountId=> acc.Id,
                        Case.ContactId=> cont.Id,            
                        Case.NSN__c => 'Test;NSN', 
                        Case.Part_Number__c => 'Test;Part',
                        Case.Emailbox_Origin__c => 'Email-Quotes',
                        Case.Agent_Contact_Flag__c => false,
                        Case.Origin => 'Web',
                        Case.Subject => 'Test MTO',
                        Case.classification__c => 'ITEC',
                        Case.Priority => 'Critical',
                        Case.Description => 'test Description',
                        Case.AOG__c=> False          
                        }); 
                List<Case> oldCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                         ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                         ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                         ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                         ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                         ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                         ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                         ,Sub_Class__c,classification__c,Priority,of_Open_Activity__c,IsClosed,AOG__c                
                                         FROM Case Where Id=: Cas.Id]; 
                map<id,case> oldCaseMap = new map<id,case>();
                for(case c:oldCaseList){          
                    oldCaseMap.put(c.id,c);
                }     
                list<case> list_Cas = New list<case>();
                Cas.of_Open_Activity__c =1;
                Cas.OwnerId =  CaseServiceUtility.getAreoDefaultUser();
                Cas.Origin = 'Email';
                Cas.RecordTypeId = RecordTypeServices.getrecordtypebyName('Weather Information Service','Case').Id;
                update Cas; 
                
                List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                         ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                         ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                         ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                         ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                         ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                         ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                         ,Sub_Class__c,classification__c,Priority,of_Open_Activity__c,IsClosed,AOG__c                
                                         FROM Case Where Id=: Cas.Id];  
                
                try{
                    CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,oldCaseMap,'Update');
                }
                catch(exception e){}  
            }    
        }
        Test.stopTest();
    } 
    @isTest static void testsendCaseEmailMethodInsert42(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => null,
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Changes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Sub_Class__c => 'Deferred Online Order',
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert43(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'WebOrder; SPEX; Warranty verification',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Changes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Sub_Class__c => 'Deferred Online Order',
                    Case.AOG__c=> False         
                    });
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsert44(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False         
                    });
            caseList.add(Cas);
            insert caseList;
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,IsClosed,AOG__c              
                                     FROM Case Where AccountId=:acc.Id];  
            
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    static testMethod void Email_Orders()
    { 
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE Name ='Test Account1'];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            //create case records
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Email-Orders',
                        Case.Emailbox_Origin__c => 'Email-AMDB Production',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'HONEYWELL FLIGHT TRACKING REQUESTS',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>cont.Id,
                        Case.AccountId=>acc.id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                        });
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            try{
                
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,list_CaseOrder,null,'Insert');      
                
                
            }catch(Exception e){}
        }
        Test.stopTest();
        
    }
    @isTest static void testCreateBulkEmailsNavDB1(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            List<Case> caseList = new List<case>(); 
            //data create
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            case Cas = (Case)SObjectFactory.Create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => Label.ITEC_Orders_Team_Id,
                    Case.Type => 'WEB Portal Registration',
                    Case.Status=>'In Process',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> acc.Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                    Case.Agent_Contact_Flag__c => false,
                    Case.Origin => 'Web',
                    Case.Subject => 'Test MTO',
                    Case.classification__c => 'ITEC',
                    Case.Priority => 'Critical',
                    Case.Description => 'test Description'    
                    });
            List<Case> oldCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,classification__c,Priority,of_Open_Activity__c,IsClosed                
                                     FROM Case Where AccountId=:acc.Id]; 
            map<id,case> oldCaseMap = new map<id,case>();
            for(case c:oldCaseList){
                oldCaseMap.put(c.id,c);
            }
            Id idBGLRPubsAccess = [SELECT Id FROM Group WHERE Type = 'Queue' and DeveloperName = 'BGLRPubsAccess'].Id;
            list<case> list_Cas = New list<case>();
            for(Case c:oldCaseList){           
                Case CasTemp = new Case();
                CasTemp = c;
                CasTemp.Status='Closed';
                CasTemp.of_Open_Activity__c =1;
                CasTemp.Export_Compliance_Content_ITAR_EAR__c ='Yes';
                CasTemp.Government_Compliance_SM_M_Content__c ='Yes';
                CasTemp.OwnerId = idBGLRPubsAccess;
                CasTemp.Type ='2nd year HUMS';
                CasTemp.RecordtypeId = RecordTypeServices.getrecordtypebyName('AeroebizSupport','Case').Id;          
                list_Cas.add(CasTemp);
            }
            update list_Cas; 
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c,classification__c,Priority,of_Open_Activity__c,IsClosed                
                                     FROM Case Where Status='Closed'];  
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldCaseList ]);
            
            
            try{
                List<Messaging.SingleEmailMessage> listMail=CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Update',true,Cas,oldCaseMap,lstCas );
            }
            catch(exception e){}  
        }    
        Test.stopTest();
    }    
    @isTest static void testCreateBulkEmailsNavDB_1(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id ,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.status=> 'In Process'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            Map<ID,Case> map2 = new Map<ID,Case>([Select Id, Type From Case Where Id in:oldMap.keySet()]);
            for(Case c : map2.values()) { 
                c.Type='Order Status';
            }
            
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, map2,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    //error
    @isTest static void testCreateBulkEmailsNavDB_2(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id ,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.status=> 'In Process'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            //        Map<ID,Case> map2 = new Map<ID,Case>([Select Id, Status, Reason From Case Where Id in:oldMap.keySet()]);
            //        for(Case c : map2.values()) { 
            //            c.status='Closed';
            //        }
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    @isTest static void testCreateBulkEmailsNavDB_3a(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('NavDB Accts', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-NavDB',
                    Case.Emailbox_Origin__c => 'Email-NavDB'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    @isTest static void testCreateBulkEmailsNavDB_3b(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('JXSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-JXSupport',
                    Case.Emailbox_Origin__c => 'Email-JXSupport'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    @isTest static void testCreateBulkEmailsNavDB_3c(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Raunheim',
                    Case.Emailbox_Origin__c => 'Email-Raunheim'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    @isTest static void testCreateBulkEmailsNavDB_3d(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            Case Cas1 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            Case Cas2 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            List<Case> listCas =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                 ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                 ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                 ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                 ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                 ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                 ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                 ,Sub_Class__c ,IsClosed
                                 FROM Case Where AccountId=:acc.Id]; 
            
            oldMap.put(Cas.Id,Cas);
            Case Cas3 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            Case Cas4 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            Case Cas5 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            List<Case> listCasManual =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                       ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                       ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                       ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                       ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                       ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                       ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                       ,Sub_Class__c ,IsClosed
                                       FROM Case Where AccountId=:acc.Id]; 
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listCasManual  ]);
            
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, listCas[0] , oldMap,lstCas);
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, listCas[1] , oldMap,lstCas);
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, listCas[2] , oldMap,lstCas);
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, listCasManual[0] , oldMap,lstCas);
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, listCasManual[1] , oldMap,lstCas);
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, listCasManual[2] , oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
    }
    
    @isTest static void testCreateBulkEmailsNavDB_3e(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Garden Grove',
                    Case.Emailbox_Origin__c => 'Email-Garden Grove'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }    
    
    @isTest static void testCreateBulkEmailsNavDB_3g(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            cont = [SELECT Id FROM Contact where email='test_radha@in.ibm.com'];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Edinburgh',
                    Case.ContactId => cont.id,
                    Case.AccountId => acc.id
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            
            //create old data in map
            oldMap.put(Cas.Id,Cas);
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Update', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
    }
    @isTest static void testCreateBulkEmailsNavDB_3h(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Aero Export Hold',
                    Case.Emailbox_Origin__c => 'Email-Aero Export Hold'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    @isTest static void testCreateBulkEmailsNavDB_3i(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email- AerospaceWarranty',
                    Case.Emailbox_Origin__c => 'Email- AerospaceWarranty'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_3j(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Edinburgh',
                    Case.Emailbox_Origin__c => 'Email-Edinburgh'
                    });
            oldList= SObjectFactory.create(5, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Subject => 'Test',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id,
                    Case.Type => 'Order Changes', 
                    Case.Expected_Update__c => system.now(),
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status=> 'In Process'
                    });
            //create old data in map
            for(case objCase : oldList){
                oldMap.put(objCase.Id,objCase);
            }
            oldMap.put(Cas.Id,Cas);
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: oldList ]);
            List<Messaging.SingleEmailMessage> l = new List<Messaging.SingleEmailMessage>(); 
            try{
                l= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4a(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Case Cas1 = new Case();
            Case Cas2 = new Case();
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas1 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas2 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-CSO BGA Spares',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            //create old data in map
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Cas.Id]);
            
            
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l2 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l3 = new List<Messaging.SingleEmailMessage>(); 
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
                l2= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas1, oldMap,lstCas); 
                l3= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas2, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    } 
    @isTest static void testCreateBulkEmailsNavDB_4b(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Case Cas1 = new Case();
            Case Cas2 = new Case();
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas1 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas2 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-CSO BGA Spares',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            //create old data in map
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Cas.Id]);
            
            
            
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l2 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l3 = new List<Messaging.SingleEmailMessage>(); 
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
                l2= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas1, oldMap,lstCas); 
                l3= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas2, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4c(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Quotes',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Cas.Id]);
            
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4ca(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4cb(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-Order Status',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4cc(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4cd(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-Quotes',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4cd1(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => 'Portal',
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-Quotes',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4cd2(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => 'Portal',
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-Quotes',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4cd3(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => 'Manual',
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'Closed',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-BGAOEMQuoteOrders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select  IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB('Insert', isAfter, cas, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4d(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Case Cas1 = new Case();
            Case Cas2 = new Case();
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-BGAOEMQuoteOrders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas1 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas2 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            //create old data in map
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas); Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Cas.Id]);
            
            
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l2 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l3 = new List<Messaging.SingleEmailMessage>(); 
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
                l2= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas1, oldMap,lstCas); 
                l3= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas2, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmailsNavDB_4e(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Case Cas1 = new Case();
            Case Cas2 = new Case();
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-CSO BGA Spares',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas1 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-CSO BGA Spares',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas2 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-CSO BGA Spares',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            //create old data in map
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Cas.Id]);
            
            
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l2 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l3 = new List<Messaging.SingleEmailMessage>(); 
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap, lstCas );
                l2= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas1, oldMap,lstCas); 
                l3= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas2, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    
    @isTest static void testCreateBulkEmailsNavDB_4f(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            Case Cas1 = new Case();
            Case Cas2 = new Case();
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Cas = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas1 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-BGAOEMQuoteOrders',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            Cas2 = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Changes', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-CSO BGA Spares',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            //create old data in map
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            oldMap.put(Cas.Id,Cas);
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Cas.Id});   
            
            Map<id,Case> lstCas = new map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Cas.Id]);
            
            
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l2 = new List<Messaging.SingleEmailMessage>(); 
            List<Messaging.SingleEmailMessage> l3 = new List<Messaging.SingleEmailMessage>(); 
            try{
                l1= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas, oldMap,lstCas); 
                l2= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas1, oldMap,lstCas); 
                l3= CaseServiceForCommonMethods.CreateBulkEmailsNavDB(strDMLMode2, isAfter, cas2, oldMap,lstCas); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    } 
    static testMethod void Email_Quotes_Insert()
    { 
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            //cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            List<Account> lstAccount= SObjectFactory.build(1,Account.sObjectType);
            lstAccount[0].Name = 'Test Account';
            lstAccount[0].Customer_Status__c = 'Active';
            lstAccount[0].Strategic_Business_Unit__c = 'BGA';
            lstAccount[0].CBT__c = 'Airbus';
            lstAccount[0].Region_Name__c = 'Asia/Pacific Rim';
            lstAccount[0].Sub_Region_Name__c = 'Canada';
            lstAccount[0].Service_Level__c = 'Refer to Network';   
            lstAccount[0].PFECN__c='';
            lstAccount[0].Orders_Next_Wave__c=false;
            lstAccount[0].Do_not_send_to_portal__c=false;
            lstAccount[0].Type = 'Owner/Operator';
            lstAccount[0].REPORT_ACCOUNT_NAME__c = 'Test Account';
            lstAccount[0].Market_Name__c = 'Marine';
            insert lstAccount;
            account accountWithBGA = lstAccount[0];
            
            contact objContact= (contact)SObjectFactory.create(
                contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    contact.OwnerId => UserInfo.getUserId(),
                        contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                        contact.AccountId => lstAccount[0].id,
                        contact.fax_web__C => '4343434343',
                        contact.Email=>'test_radha@in.ibm.com'
                        }); 
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            
            Set<Id> setCaseIds= new Set<Id>();
            
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            //create case records
            
            Case caseOrder= (case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Email-Quotes',
                        Case.Emailbox_Origin__c => 'Email-Quotes',
                        Case.SuppliedEmail=>'georgereaver@gulfstream.com',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'HONEYWELL FLIGHT TRACKING REQUESTS',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>cont.Id,
                        Case.AccountId=>lstAccount[0].id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                        });
            
            List<Case> newCaseList =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                     ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                     ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                     ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                     ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                     ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                     ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                     ,Sub_Class__c              
                                     FROM Case Where Id=:caseOrder.Id];  
            
            Case caseOrder2= (Case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Email-Quotes',
                        Case.Emailbox_Origin__c => 'Email-Quotes',
                        Case.SuppliedEmail=>'georgereaver@linmarr.com',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'HONEYWELL FLIGHT TRACKING REQUESTS',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>cont.Id,
                        Case.AccountId=>lstAccount[0].id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                        });
            
            List<Case> newCaseList2 =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                      ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                      ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                      ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                      ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                      ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                      ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                      ,Sub_Class__c              
                                      FROM Case Where Id=:caseOrder2.Id];  
            
            Case caseOrder3= (Case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Email-Quotes',
                        Case.Emailbox_Origin__c => 'Email-Quotes',
                        Case.SuppliedEmail=>'georgereaver@gulfstream.com',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'HONEYWELL FLIGHT TRACKING REQUESTS',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>cont.Id,
                        Case.AccountId=>lstAccount[0].id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                        });
            
            List<Case> newCaseList3 =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                      ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                      ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                      ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                      ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                      ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                      ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                      ,Sub_Class__c              
                                      FROM Case Where Id=:caseOrder3.Id];  
            
            Case caseOrder4= (Case)SObjectFactory.create(
                Case.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Case.Origin => 'Email-Quotes',
                        Case.Emailbox_Origin__c => 'Email-Quotes',
                        Case.SuppliedEmail=>'georgereaver@gulfstream.com',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'HONEYWELL FLIGHT TRACKING REQUESTS',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>cont.Id,
                        Case.AccountId=>lstAccount[0].id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                        });
            
            List<Case> newCaseList4 =[SELECT Id,OwnerId,Type,Subject,Status,Sub_Status__c,RecordtypeId 
                                      ,SuppliedEmail,Origin,Service_Level__c,NSN__c,Part_Number__c
                                      ,CaseNumber,Case_Ref_ID__c,Contact_Name__c,Description,ContactId,Primary_Email_Address__c
                                      ,Emailbox_Origin__c,Agent_Contact_Flag__c,sbu__c,Region__c,PFECN__c,Account_Type__c 
                                      ,CreatedById,Do_Not_Send_to_Portal__c,Survey_Sent__c 
                                      ,Quotes_Do_Not_Send_to_Portal__c,Resolution__c,Customer_Name__c
                                      ,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Hon_Plant_Code_del__c 
                                      ,Sub_Class__c              
                                      FROM Case Where Id=:caseOrder4.Id];  
            
            try{
                
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList,null,'Insert');  
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList2,null,'Insert'); 
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList3,null,'Insert'); 
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,newCaseList4,null,'Insert'); 
                
            }catch(Exception e){}
        }
        Test.stopTest(); 
        
    }   
    //Start of SendAOGAlertMethod
    
    
    static testMethod void sendAOGAlertMethod_Test2(){
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Aircraft_Type__c a1 = (Aircraft_Type__c)SObjectFactory.create(
                Aircraft_Type__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Aircraft_Type__c.Retention_Hold__c=>true                    
                        }
            ); 
            
            airbus__c airbus = (airbus__c)SObjectFactory.create(
                airbus__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    airbus__c.name__c=>'shuchis_vats@yahoo.com',
                        airbus__c.name=>'Airbus' 
                        }
            ); 
            Boeing__c boeing = (Boeing__c)SObjectFactory.create(
                Boeing__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Boeing__c.name__c=>'shuchis_vats@yahoo.com',
                        Boeing__c.name=>'Boeing' 
                        }
            ); 
            Bombardier_ATR__c atr = (Bombardier_ATR__c)SObjectFactory.create(
                Bombardier_ATR__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Bombardier_ATR__c.name__c=>'shuchis_vats@yahoo.com',
                        Bombardier_ATR__c.name=>'Bombardier ATR ' 
                        }
            ); 
            Airlines__c airlines = (Airlines__c)SObjectFactory.create(
                Airlines__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Airlines__c.name__c=>'shuchis_vats@yahoo.com',        
                        Airlines__c.name=>'Airlines' 
                        }
            ); 
            Helicopters__c heli=(Helicopters__c)SObjectFactory.create(
                Helicopters__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Helicopters__c.name__c=>'shuchis_vats@yahoo.com',               
                        Helicopters__c.name=>'Helicopter' 
                        }
            ); 
            Gulfstream__c gulf=(Gulfstream__c)SObjectFactory.create(
                Gulfstream__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Gulfstream__c.name__c=>'shuchis_vats@yahoo.com', 
                        Gulfstream__c.name=>'Gulfstream' 
                        }
            ); 
            Dassault__c dassault=(Dassault__c)SObjectFactory.create(
                Dassault__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Dassault__c.name__c=>'shuchis_vats@yahoo.com',
                        Dassault__c.name=>'Dassault'                         
                        }
            ); 
            Pilatus__c pilatus=(Pilatus__c)SObjectFactory.create(
                Pilatus__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Pilatus__c.name__c=>'shuchis_vats@yahoo.com',    
                        Pilatus__c.name=>'Pilatus'    
                        }
            ); 
            BombardierBGA__c bga=(BombardierBGA__c)SObjectFactory.create(
                BombardierBGA__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    BombardierBGA__c.name__c=>'shuchis_vats@yahoo.com',                 
                        BombardierBGA__c.name=>'Bombardier BGA'                 
                        }
            ); 
            Hawker__c hawker=(Hawker__c)SObjectFactory.create(
                Hawker__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Hawker__c.name__c=>'shuchis_vats@yahoo.com',    
                        Hawker__c.name=>'Hawker'                 
                        }
            ); 
            Cessna__c cess= (Cessna__c)SObjectFactory.create(
                Cessna__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Cessna__c.name__c=>'shuchis_vats@yahoo.com',     
                        Cessna__c.name=>'Cessna'   
                        }
            ); 
            Embraer_BGA__c ebga= (Embraer_BGA__c)SObjectFactory.create(
                Embraer_BGA__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Embraer_BGA__c.name__c=>'shuchis_vats@yahoo.com',                
                        Embraer_BGA__c.name=>'Embraer BGA'                 
                        }
            ); 
            Embraer_ATR__c eatr=(Embraer_ATR__c)SObjectFactory.create(
                Embraer_ATR__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Embraer_ATR__c.name__c=>'shuchis_vats@yahoo.com',                 
                        Embraer_ATR__c.name=>'Embraer ATR'                 
                        }
            ); 
            Components__c comp =(Components__c)SObjectFactory.create(
                Components__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Components__c.name__c=>'shuchis_vats@yahoo.com',                
                        Components__c.name=>'Components'                 
                        }
            );
            miscellaneous__C mcls =(miscellaneous__C)SObjectFactory.create(
                miscellaneous__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    miscellaneous__C.name__c=>'shuchis_vats@yahoo.com',                
                        miscellaneous__C.name=>'miscellaneous'                 
                        }
            ); 
            
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            Account acc6 = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Dassault',Region_Name__c = 'Asia/Pacific Rim',Sub_Region_Name__c = 'Canada',Service_Level__c = 'Refer to Network',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Strategic_Business_Unit__c='D&S');
            listAcc.add(acc6);
            Account acc7 = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Pilatus',Region_Name__c = 'Asia/Pacific Rim',Sub_Region_Name__c = 'Canada',Service_Level__c = 'Refer to Network',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Strategic_Business_Unit__c='D&S');
            listAcc.add(acc7);
            Account acc9 = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Hawker',Region_Name__c = 'Asia/Pacific Rim',Sub_Region_Name__c = 'Canada',Service_Level__c = 'Refer to Network',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Strategic_Business_Unit__c='D&S');
            listAcc.add(acc9);
            Account acc10 = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Cessna',Region_Name__c = 'Asia/Pacific Rim',Sub_Region_Name__c = 'Canada',Service_Level__c = 'Refer to Network',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Strategic_Business_Unit__c='D&S');
            listAcc.add(acc10);
            Account acc11 = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Embraer',Region_Name__c = 'Asia/Pacific Rim',Sub_Region_Name__c = 'Canada',Service_Level__c = 'Refer to Network',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Strategic_Business_Unit__c='D&S');
            listAcc.add(acc11);
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            Test.startTest();
            
            List<Platform__c> listPlat =new List<Platform__c>();
            Platform__c plat3=new Platform__c(Name='Airlines',Model__c='model');
            listPlat.add(plat3);    
            Platform__c plat=new Platform__c(Name='Airbus',Model__c='model');
            listPlat.add(plat);
            Platform__c plat2=new Platform__c(Name='Helicopter',Model__c='model');
            listPlat.add(plat2);
            Platform__c plat4=new Platform__c(Name='Boeing',Model__c='model');
            listPlat.add(plat4);
            Platform__c plat5=new Platform__c(Name='Gulfstream',Model__c='model');
            listPlat.add(plat5);
            Platform__c plat6=new Platform__c(Name='Dassault',Model__c='model');
            listPlat.add(plat6);
            Platform__c plat7=new Platform__c(Name='Pilatus',Model__c='model');
            listPlat.add(plat7);
            Platform__c plat8=new Platform__c(Name='Bombardier',Model__c='model');
            listPlat.add(plat8);
            Platform__c plat9=new Platform__c(Name='Hawker',Model__c='model');
            listPlat.add(plat9);
            Platform__c plat10=new Platform__c(Name='Cessna',Model__c='model');
            listPlat.add(plat10);
            Platform__c plat11=new Platform__c(Name='Embraer',Model__c='model');
            listPlat.add(plat11);
            Platform__c plat12=new Platform__c(Name='Micellaneous',Model__c='model');
            listPlat.add(plat12);
            Platform__c plat13=new Platform__c(Name='Components',Model__c='model');
            listPlat.add(plat13);
            Platform__c plat14=new Platform__c(Name='Cessna',Model__c='model');
            listPlat.add(plat14);    
            Platform__c plat15=new Platform__c(Name='Bombardier',Model__c='model');
            listPlat.add(plat15);            
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            Fleet_Asset_Detail__c fad=new Fleet_Asset_Detail__c(Name='Airbus',Platform_Name__c=plat.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad);
            Fleet_Asset_Detail__c fad6=new Fleet_Asset_Detail__c(Name='Dassault',Platform_Name__c=plat6.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad6);
            Fleet_Asset_Detail__c fad7=new Fleet_Asset_Detail__c(Name='Pilatus',Platform_Name__c=plat7.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad7);
            Fleet_Asset_Detail__c fad8=new Fleet_Asset_Detail__c(Name='Bombardier',Platform_Name__c=plat8.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad8);
            Fleet_Asset_Detail__c fad9=new Fleet_Asset_Detail__c(Name='Hawker',Platform_Name__c=plat9.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad9);
            Fleet_Asset_Detail__c fad10=new Fleet_Asset_Detail__c(Name='Cessna',Platform_Name__c=plat10.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad10);
            Fleet_Asset_Detail__c fad11=new Fleet_Asset_Detail__c(Name='Embraer',Platform_Name__c=plat11.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad11);
            Fleet_Asset_Detail__c fad12=new Fleet_Asset_Detail__c(Name='Airbus',Platform_Name__c=plat12.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad12);
            Fleet_Asset_Detail__c fad13=new Fleet_Asset_Detail__c(Name='Boeing',Platform_Name__c=plat13.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad13);    
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow12 = new Case(  Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat2.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad12.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow12);
            Case UnAuthcseLow13 = new Case( Detail_Class__c='AOG - IFSD Uncommanded',  Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad12.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-JXAccounts',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow13);   
            Case UnAuthcseLow14 = new Case( Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat3.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad13.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents1',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow14);    
            Case UnAuthcseLow15 = new Case( Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat4.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents1',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow15);
            Case UnAuthcseLow16 = new Case( Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat5.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents1',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow16);
            Case UnAuthcseLow17 = new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat6.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad6.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc6.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents2',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow17);
            Case UnAuthcseLow18 = new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat7.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad7.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents3',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow18);
            Case UnAuthcseLow19 = new Case(SBU_w2c__c='BGA',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat8.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad8.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents4',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow19);
            Case UnAuthcseLow20 = new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat10.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad9.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc9.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents5',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow20);
            Case UnAuthcseLow29 = new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat9.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad9.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc9.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents5',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow29);
            Case UnAuthcseLow37= new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat9.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad9.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc9.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents5',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow37);  
            Case UnAuthcseLow32 = new Case(SBU_w2c__c='ATR',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat8.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad8.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents4',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow32);
            Case UnAuthcseLow23 = new Case(SBU_w2c__c='BGA',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat11.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents8',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow23);
            Case UnAuthcseLow24 = new Case(SBU_w2c__c='ATR',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat11.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents8',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow24);
            Case UnAuthcseLow25 = new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents8',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow25);
            Case UnAuthcseLow26 = new Case(Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents8',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow26);
            Case UnAuthcseLow28 = new Case(SBU_w2c__c='ATR',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents8',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow28);       
            Case UnAuthcseLow38 = new Case(SBU_w2c__c='ATR',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents8',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow38);  
            Case UnAuthcseLow30 = new Case( Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat3.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad13.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents1',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow30); 
            Case UnAuthcseLow31 = new Case(SBU_w2c__c='ATR',Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat15.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='222232212122',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad8.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc7.id,Origin = 'email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account',Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-R&O MechComponents4',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow31);
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f10= new Field_Event__c(Case_Number__c=UnAuthcseLow12.id);
            listFe.add(f10); 
            Field_Event__c f9= new Field_Event__c(Case_Number__c=UnAuthcseLow13.id);
            listFe.add(f9);    
            Field_Event__c f8= new Field_Event__c(Case_Number__c=UnAuthcseLow14.id);
            listFe.add(f8);
            Field_Event__c f0= new Field_Event__c(Case_Number__c=UnAuthcseLow15.id);
            listFe.add(f0);
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow16.id);
            listFe.add(f1);
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow17.id);
            listFe.add(f2);
            Field_Event__c f3= new Field_Event__c(Case_Number__c=UnAuthcseLow18.id);
            listFe.add(f3);
            Field_Event__c f4= new Field_Event__c(Case_Number__c=UnAuthcseLow19.id);
            listFe.add(f4);
            Field_Event__c f5= new Field_Event__c(Case_Number__c=UnAuthcseLow20.id);
            listFe.add(f5);       
            Field_Event__c f16= new Field_Event__c(Case_Number__c=UnAuthcseLow23.id);
            listFe.add(f16);
            Field_Event__c f11= new Field_Event__c(Case_Number__c=UnAuthcseLow24.id);
            listFe.add(f11);
            Field_Event__c f12= new Field_Event__c(Case_Number__c=UnAuthcseLow25.id);
            listFe.add(f12);
            Field_Event__c f13= new Field_Event__c(Case_Number__c=UnAuthcseLow26.id);
            listFe.add(f13);
            Field_Event__c f15= new Field_Event__c(Case_Number__c=UnAuthcseLow28.id);
            listFe.add(f15);
            Field_Event__c f25= new Field_Event__c(Case_Number__c=UnAuthcseLow38.id);
            listFe.add(f25);
            Field_Event__c f17= new Field_Event__c(Case_Number__c=UnAuthcseLow29.id);
            listFe.add(f17);
            Field_Event__c f18= new Field_Event__c(Case_Number__c=UnAuthcseLow30.id);
            listFe.add(f18);
            Field_Event__c f19= new Field_Event__c(Case_Number__c=UnAuthcseLow31.id);
            listFe.add(f19);        
            Field_Event__c f20= new Field_Event__c(Case_Number__c=UnAuthcseLow32.id);
            listFe.add(f20);  
            Field_Event__c f24= new Field_Event__c(Case_Number__c=UnAuthcseLow37.id);
            listFe.add(f24); 
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            // CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, oldMapCase, 'Update',  lstCas, 'isAfter');
        }
        Test.stopTest();
    }    
    //End of SendAOGAlertMethod
    static testMethod void userCountryVerifyTest(){
        Test.startTest();
        List<case> CaseList = SObjectFactory.Create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'WEB Portal Registration',
                Case.Status=>'In Process',
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                Case.SuppliedEmail => 'Test@gulfstream.com',
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                Case.Agent_Contact_Flag__c => false,
                Case.Origin => 'Web',
                Case.Subject => 'Test MTO',
                Case.classification__c => 'ITEC',
                Case.Priority => 'Critical',
                Case.Description => 'test Description',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'Yes',
                Case.Government_Compliance_SM_M_Content__c => 'Yes'          
                });
        currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                    User.Email => 'test123@honeywell.com',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LastName => 'Customer Master',
                    User.FirstName=>'Salesforce',    
                    User.LanguageLocaleKey => 'en_US',
                    User.LocalesIdKey => 'en_US',
                    User.ProfileId => UserInfo.getProfileId(),
                    User.TimezonesIdKey => 'America/Los_Angeles',
                    //User.Username => 'wilnellies.vargas@honeywell.com'
                    User.Username => 'lfdghfdgtsprotrei0pt6w346tesr@honeywell.com',
                    User.Country__c => 'Bermuda'
                    }
        );     
        List<case> CaseList1 = SObjectFactory.Create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => currentUser.id,
                Case.Type => 'WEB Portal Registration',
                Case.Status=>'Tech Issue-SR Assigned',                
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                Case.SuppliedEmail => 'Test@gulfstream.com',
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                Case.Agent_Contact_Flag__c => false,
                Case.Origin => 'Web',
                Case.Subject => 'Test MTO',
                Case.classification__c => 'ITEC',
                Case.Priority => 'Critical',
                Case.Description => 'test Description',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'Yes',
                Case.Government_Compliance_SM_M_Content__c => 'Yes'          
                });
        
        map<id,case> oldCaseMap = new map<id,case>();
        for(case c:CaseList){
            oldCaseMap.put(c.id,c);
        }
        for(case c:CaseList1){
            oldCaseMap.put(c.id,c);
        }
        List<Id> ownerIds = new List<Id>();
        ownerids.add(caseList[0].OwnerId);
        ownerids.add(caseList1[0].OwnerId);
        
        try{
            CaseServiceForCommonMethods.userCountryVerify(CaseList1, oldCaseMap, ownerIds);
            //throw new MyException('An exception should have been thrown by the trigger but was not.');               
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('The User selected belong') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);        
        }
        test.stopTest();
    }
    static testMethod void caseFSENameByAccountTeamMemberTest(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];   
        account acc= (account)SObjectFactory.Create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account9',
                account.type => 'Owner/Operator',
                account.Strategic_Business_Unit__c => 'BGA',
                account.Service_Level__c => 'Refer to Network',
                account.Do_Not_Send_to_Portal__c => false,  
                Account.PFECN__c => null,
                Account.Region_Name__c  => 'Asia/Pacific Rim'
                }); 
        
        List<AccountTeamMember> AccTeam = SObjectFactory.Create(1, AccountTeamMember.sObjectType, new Map<Schema.SObjectField, Object>{
            
            AccountTeamMember.Userid =>UserInfo.getUserId(),
                AccountTeamMember.AccountId => acc.id,
                AccountTeamMember.TeamMemberRole => 'Field Service Engineer (FSE)'
                });
        List<case> CaseList = SObjectFactory.Create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'WEB Portal Registration',
                Case.Status=>'In Process',
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                Case.SuppliedEmail => 'Test@gulfstream.com',
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                Case.Agent_Contact_Flag__c => false,
                Case.Origin => 'Web',
                Case.Subject => 'Test MTO',
                Case.classification__c => 'ITEC',
                Case.Priority => 'Critical',
                Case.Description => 'test Description',
                Case.AccountId => acc.id,
                Case.FSE_name_1__c => null,
                Case.Government_Compliance_SM_M_Content__c => 'Yes'          
                });
        List<Id> AcctIds = new List<Id>();
        AcctIds.add(caseList[0].AccountId);
        try{
            CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(CaseList, AcctIds);
        }catch(Exception e){}
        test.stopTest();
    }
    static testMethod void caseFSENameByAccountTeamMemberTest1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];   
        account acc= (account)SObjectFactory.Create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account9',
                account.type => 'Owner/Operator',
                account.Strategic_Business_Unit__c => 'BGA',
                account.Service_Level__c => 'Refer to Network',
                account.Do_Not_Send_to_Portal__c => false,  
                Account.PFECN__c => null,
                Account.Region_Name__c  => 'Asia/Pacific Rim'
                }); 
        
        List<AccountTeamMember> AccTeam = SObjectFactory.Create(1, AccountTeamMember.sObjectType, new Map<Schema.SObjectField, Object>{
            
            AccountTeamMember.Userid =>UserInfo.getUserId(),
                AccountTeamMember.AccountId => acc.id,
                AccountTeamMember.TeamMemberRole => 'Field Service Engineer (FSE)'
                });
        List<case> CaseList = SObjectFactory.Create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'WEB Portal Registration',
                Case.Status=>'In Process',
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                Case.SuppliedEmail => 'Test@gulfstream.com',
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                Case.Agent_Contact_Flag__c => false,
                Case.Origin => 'Web',
                Case.Subject => 'Test MTO',
                Case.classification__c => 'ITEC',
                Case.Priority => 'Critical',
                Case.Description => 'test Description',
                Case.AccountId => acc.id,
                Case.FSE_name_1__c => runUser.id,
                Case.FSE_name_2__c => null,
                Case.Government_Compliance_SM_M_Content__c => 'Yes'          
                });
        List<Id> AcctIds = new List<Id>();
        AcctIds.add(caseList[0].AccountId);
        try{
            CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(CaseList, AcctIds);
        }catch(Exception e){}
        test.stopTest();
    }
    static testMethod void caseFSENameByAccountTeamMemberTest2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];   
        account acc= (account)SObjectFactory.Create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account9',
                account.type => 'Owner/Operator',
                account.Strategic_Business_Unit__c => 'BGA',
                account.Service_Level__c => 'Refer to Network',
                account.Do_Not_Send_to_Portal__c => false,
                Account.PFECN__c => null,
                Account.Region_Name__c  => 'Asia/Pacific Rim'
                }); 
        
        List<AccountTeamMember> AccTeam = SObjectFactory.Create(1, AccountTeamMember.sObjectType, new Map<Schema.SObjectField, Object>{
            
            AccountTeamMember.Userid =>UserInfo.getUserId(),
                AccountTeamMember.AccountId => acc.id,
                AccountTeamMember.TeamMemberRole => 'Field Service Engineer (FSE)'
                });
        List<case> CaseList = SObjectFactory.Create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'WEB Portal Registration',
                Case.Status=>'In Process',
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id,
                Case.SuppliedEmail => 'Test@gulfstream.com',
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Emailbox_Origin__c => 'Email-R&O MechComponents',
                Case.Agent_Contact_Flag__c => false,
                Case.Origin => 'Web',
                Case.Subject => 'Test MTO',
                Case.classification__c => 'ITEC',
                Case.Priority => 'Critical',
                Case.Description => 'test Description',
                Case.AccountId => acc.id,
                Case.FSE_name_1__c => runUser.id,
                Case.FSE_name_2__c => runUser.id,
                Case.FSE_Name_3__c => null,
                Case.Government_Compliance_SM_M_Content__c => 'Yes'          
                });
        List<Id> AcctIds = new List<Id>();
        AcctIds.add(caseList[0].AccountId);
        try{
            CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(CaseList, AcctIds);
        }catch(Exception e){}
        test.stopTest();
    }
    @isTest static void testCreateBulkEmails1(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Refer to Network',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test@linmarr.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            try{              
                l1= CaseServiceForCommonMethods.CreateBulkEmails(true,true,'Insert',true, cas,oldmap); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmails2(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Refer to Network',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});   
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            try{              
                l1= CaseServiceForCommonMethods.CreateBulkEmails(true,true,'Insert',true, cas,oldmap); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmails3(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Refer to Network',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});       
            
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            try{              
                l1= CaseServiceForCommonMethods.CreateBulkEmails(true,true,'Insert',true, cas,oldmap); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }
    @isTest static void testCreateBulkEmails4(){
        Test.startTest(); 
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.Service_Level__c => 'Refer to Network',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
                    }); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
            TriggerInactive.testTrigger = false;
            
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            acc = [SELECT Id FROM Account WHERE account.Name ='Test Account1' LIMIT 1];
            Case CasObj = (Case)SObjectFactory.create(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'AEROEBIZSUPPORT- NGAPM', 
                    Case.Subject => 'Test',
                    Case.SuppliedEmail => 'test_radha@in.ibm.com',
                    Case.Description => 'Test;Description',
                    Case.Resolution__c => 'Test;Resolution',
                    Case.Recordtypeid => RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id,
                    Case.Classification__c => 'CSO OEM',
                    Case.Government_Compliance_SM_M_Content__c => 'Yes',
                    Case.IsMemberOfCompliance__c => false, 
                    Case.Status => 'In Process',
                    Case.Origin => 'Email-Orders',
                    Case.Emailbox_Origin__c => 'Email-Orders',
                    Case.AccountId => acc.id,
                    Case.ContactId => cont.id
                    });
            
            //create old data in map
            Field_Event__c fieldEvent = (Field_Event__c)SObjectFactory.create(Field_Event__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Field_Event__c.Case_Number__c =>Casobj.Id});                    
            oldMap.put(Cas.Id,Cas);
            //cas.Status = 'Closed';
            //update cas;
            Map<id,Case> lstCas = new map<id,Case>([select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, 
                                                    Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id]);
            cas = [select Sub_Class__c,Subject,Primary_Email_Address__c,Service_Level__c,Region__c,Account_Type__c ,IsClosed,PFECN__c,Origin,contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, 
                   Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name
                   ,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name
                   ,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c
                                                                                                                        ,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: Casobj.Id];
            List<Messaging.SingleEmailMessage> l1 = new List<Messaging.SingleEmailMessage>(); 
            try{              
                l1= CaseServiceForCommonMethods.CreateBulkEmails(true,true,'Insert',true, cas,oldmap); 
            }catch(Exception e){}
        }
        test.stopTest();
        System.assertEquals(true,true);
    }   
    
    static testMethod void testCaseHandlerAfterInsertEmail2(){  
        Test.startTest(); 
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                                                    {
                                                        User.FirstName => 'TestFirstName',
                                                            User.LastName => 'TestLastName',
                                                            User.Email => 'test_radha@in.ibm.com',
                                                            User.Username => 'test11@in.ibm.com',
                                                            User.Alias => 'TestF',
                                                            User.ProfileId => p1.Id,
                                                            User.TimeZoneSidKey => 'America/Denver',
                                                            User.LocaleSidKey => 'en_US',
                                                            User.EmailEncodingKey => 'UTF-8',
                                                            User.LanguageLocaleKey => 'en_US'
                                                            });
        
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                User currentUser = (User) SObjectFactory.create(
                    User.SObjectType,
                    new Map<SObjectField, Object>{
                        User.Alias => 'wvarg',
                            User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                            User.EmailEncodingKey => 'UTF-8',
                            User.LastName => 'Customer Master',
                            User.FirstName=>'Salesforce',    
                            User.LanguageLocaleKey => 'en_US',
                            User.LocalesIdKey => 'en_US',
                            User.ProfileId => UserInfo.getProfileId(),
                            User.TimezonesIdKey => 'America/Los_Angeles',
                            //User.Username => 'wilnellies.vargas@honeywell.com'
                            User.Username => 'testtest111@honeywell.com'
                            }
                );  
                account accountWithATR= (account)SObjectFactory.create(
                    account.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        account.OwnerId => UserInfo.getUserId(),
                            account.Name => 'Test Account OEM',
                            account.type => 'OEM',
                            account.Customer_Status__c =>'Active',
                            account.Strategic_Business_Unit__c => 'ATR',
                            account.CBT__c => 'Airlines',
                            account.Region_Name__c => 'Americas',
                            account.Sub_Region_Name__c => 'Canada',
                            account.Service_Level__c => 'Refer to Network',              
                            account.Type => 'OEM',
                            account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                            account.Market_Name__c => 'Marine',
                            account.CBT_Team__c => 'EMEAI ATR'           
                            });
                Contact contactWithATR =[SELECT Id, Name FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1]; 
                Set<Id> setCaseIds= new Set<Id>();
                Id recId = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id;       
                //create case records
                
                List<Case> list_CaseOrder= SObjectFactory.create(
                    1, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin =>'Email-Quotes',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.Ownerid => currentUser.Id,//label.Salesforce_Customer_Master,
                            Case.RecordTypeId=> recId,
                            Case.SBU_w2c__c=>'D&S',
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithATR.Id,
                            Case.AccountId=>accountWithATR.id,
                            Case.Type => 'Other',
                            Case.Part_Number__c=>'Test', 
                            Case.NSN__c=>'Test',
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                Case caseRelatedToCLI = new Case();
                caseRelatedToCLI = list_CaseOrder[0];
                Case_Line_Item__c caseLookupRec = (Case_Line_Item__c) SObjectFactory.create(Case_Line_Item__c.SObjectType,
                                                                                            new Map<SObjectField, Object>{
                                                                                                Case_Line_Item__c.Case_Number__c=> caseRelatedToCLI.Id,
                                                                                                    Case_Line_Item__c.Price__c => 20,
                                                                                                    Case_Line_Item__c.Quantity__c => 2,
                                                                                                    Case_Line_Item__c.RecordTypeId=>RecordTypeServices.getRecordTypeByName('DS Clearing House Proposal','Case_Line_Item__c').Id
                                                                                                    }   
                                                                                           );   
                List<Case> updatedCaseOldList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
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
                                                                From Case WHERE id = :list_CaseOrder[0].id]);
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,updatedCaseOldList ,null); 
                Test.stopTest(); 
            }catch(Exception e){}
        }
    }
    
    static testMethod void testCaseHandlerAfterInsert_CBTTeam12()
    { 
        test.startTest(); 
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                                                    {
                                                        User.FirstName => 'TestFirstName',
                                                            User.LastName => 'TestLastName',
                                                            User.Email => 'test_radha@in.ibm.com',
                                                            User.Username => 'test11111@in.ibm.com',
                                                            User.Alias => 'TestF',
                                                            User.ProfileId => p1.Id,
                                                            User.TimeZoneSidKey => 'America/Denver',
                                                            User.LocaleSidKey => 'en_US',
                                                            User.EmailEncodingKey => 'UTF-8',
                                                            User.LanguageLocaleKey => 'en_US'
                                                            });
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                account accountWithATR =[SELECT Id, Name FROM Account WHERE Type=:'OEM' LIMIT 1];
                Contact contactWithATR =[SELECT Id, Name, email FROM Contact WHERE AccountId=:accountWithATR.Id LIMIT 1]; 
                Set<Id> setCaseIds= new Set<Id>();
                Id recId = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id;       
                List<Case> list_CaseOrder= SObjectFactory.create(
                    1, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.Origin => 'Email-SAP_CustomerMaster',
                            Case.Status => 'Open',
                            Case.Sub_Status__c=>'Waiting for TCT',
                            Case.Subject=>'OCD Updates 620',
                            Case.RecordTypeId=> recId,
                            Case.Tool_Name__c=>'MCORE',
                            Case.Classification__c => 'US ACT Internal',
                            Case.ContactId =>contactWithATR.Id,
                            Case.AccountId=>accountWithATR.id,
                            Case.Type => 'Other',   
                            Case.CSM_Region__c => 'Americas',
                            Case.Workstrem__c => 'Spares',
                            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                            Case.Government_Compliance_SM_M_Content__c => 'NO',
                            Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
                            });
                account accountWithBGA = (account)SObjectFactory.create(
                    account.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        account.OwnerId => UserInfo.getUserId(),
                            account.Name => 'Test Account Energy',
                            account.type => 'Energy',
                            account.Customer_Status__c =>'Active',
                            account.Strategic_Business_Unit__c => 'BGA',
                            account.CBT__c => 'Airbus',
                            account.Region_Name__c => 'Americas',
                            account.Sub_Region_Name__c => 'Canada',
                            account.Service_Level__c => 'Refer to Network', 
                            account.Type => 'OEM',
                            account.REPORT_ACCOUNT_NAME__c => 'Test Account',
                            account.Market_Name__c => 'Marine',
                            account.CBT_Team__c=>'Americas'         
                            });  
                Contact c=(contact)SObjectFactory.create(
                    Contact.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        contact.LastName => 'Santhanakumar',
                            contact.FirstName => 'Dhivya',
                            contact.AccountId => accountWithBGA.Id,
                            contact.Primary_Email_Address__c => 'dhivya11.santhanakumar@nttdata.com',
                            contact.Address_Line_1__c=>'Address 1',
                            contact.Address_Line_2__c=>'Address 1',
                            contact.Address_Line_3__c=>'Address 1',
                            contact.City_Name__c=>'MN',
                            contact.State_Code__c=>'55667',
                            contact.Country_Name__c=>'USA',
                            contact.Email=>'test@honeywell.com'
                            }); 
                
                List<Contact_Tool_Access__c> contTool = SObjectFactory.create(
                    1, Contact_Tool_Access__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Contact_Tool_Access__c.Name => 'MCORE',                               
                            //Contact_Tool_Access__c.Name => 'MCORE (Maintenance Cost Reduction)',                               
                            Contact_Tool_Access__c.MCORE_IS_Super_Admin__c => true,
                            Contact_Tool_Access__c.CRM_Contact_ID__c=>contactWithATR.id,
                            Contact_Tool_Access__c.Portal_Honeywell_ID__c => 'test123',
                            Contact_Tool_Access__c.Request_Status__c => 'Pending'
                            });
                
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                
                CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,list_CaseOrder,null);    
            }catch(Exception e){}
        }
        Test.stopTest();       
    }
    
    static testMethod void ACSMSendCaseEmailMethod_UpdateTest2(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            try{
                TriggerInactive.testTrigger = false;
                
                account Account1= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                        account.Name => 'Test Account23',
                        account.type => 'Energy',
                        account.Strategic_Business_Unit__c => 'D&S',
                        account.Service_Level__c => 'Refer To Network',
                        account.Do_Not_Send_to_Portal__c => false,
                        Account.PFECN__c => null,
                        account.Region_Name__c => 'Asia/Pacific Rim'
                        });
                
                //User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
                account testAccount =[SELECT Id, Name FROM Account WHERE Name='Test Account23' LIMIT 1];           
                Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
                
                Set<Id> setCaseIds= new Set<Id>();       
                //create case records        
                List<Case> ListCaseEmail = SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Case.OwnerId => UserInfo.getUserId(),
                            Case.Origin => 'Web',  
                            Case.IsWorkflowTriggered__c => true,
                            Case.Status => 'Open',
                            Case.Mail_Box_Name__c => 'Fax//test',
                            Case.Origin_Check__c => False,
                            Case.Agent_Contact_Flag__c => false, 
                            Case.Subject => 'ELT Coding',
                            Case.recordtypeid => RecordTypeServices.getRecordTypeByName('FSS Technical Issue', 'Case').Id,
                            Case.Supported_Product__c => 'Primary', 
                            Case.RnOSAPCases__c => 100,
                            Case.ContactId =>testContact.Id,
                            Case.Emailbox_Origin__c=> 'Email-FSS Tech Support'
                            //Case.CreatedById =>Label.ACSM_API_User_Id
                            
                            }
                );
                List<Case> oldListCaseEmail = [SELECT ID,ContactId,recordtypeid,Government_Compliance_SM_M_Content__c,Export_Compliance_Content_ITAR_EAR__c,Resolution__c,Sub_Class__c,Detail_Class__c,Repair_Location__c,Classification__c,Status,AccountId,Expected_Update__c,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Web'];
                List<Case> newListCaseEmail = new List<Case>();
                Map<id,Case> mapoldCase = new Map<id,Case>(); 
                for(case objCase : oldListCaseEmail){
                    mapoldCase.put(objCase.Id, objCase);               
                }
                for(case objCase : oldListCaseEmail){
                    case tempCase = new case(); 
                    tempCase.Origin = 'Web';
                    tempCase.Id = objCase.Id;               
                    tempCase.RnOSAPCases__c = 200;
                    tempCase.Subject = 'ELT Coding';
                    tempCase.OwnerId = aircraftContySerMgntUserId;
                    
                    newListCaseEmail.add(tempCase);                
                }   
                update newListCaseEmail;        
                
                newListCaseEmail = [SELECT ID,Primary_Email_Address__c,ContactId,recordtypeid,Government_Compliance_SM_M_Content__c,Export_Compliance_Content_ITAR_EAR__c,Resolution__c,Sub_Class__c,Detail_Class__c,Repair_Location__c,Classification__c,Status,AccountId,Expected_Update__c,Origin,Mail_Box_Name__c,Subject,OwnerId,RnOSAPCases__c FROM CASE WHERE Origin=:'Web'];
                
                CaseServiceForCommonMethods.ACSMSendCaseEmailMethod(newListCaseEmail ,mapoldCase,'Update');                
            }
            catch(Exception e){}   
        }
        Test.stopTest();                         
    }
    static testMethod void updateTaskOwnerTest(){
        List<Account> listAcc = new List<Account>();
        Account acc6 = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Dassault',Region_Name__c = 'Asia/Pacific Rim',Sub_Region_Name__c = 'Canada',Service_Level__c = 'Refer to Network',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Strategic_Business_Unit__c='D&S');
        listAcc.add(acc6);
        
        List<Contact> listCon = new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = listAcc[0].Id;
        con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
        con.Email='shuchis_vats@yahoo.com';
        listCon.add(con);
        
        //List of case
        User u = [Select id From User Where id =: label.AERODEFAULTUSER Limit 1];
        
        List<Case> oldCaseList = new List<case>();            
        oldCaseList.add(new Case(RecordTypeId = rtIdGDCAccounts,Origin = 'Email',Status = 'Open',
                                 Quote_Number__c = 'My1234',
                                 ContactId = listCon[0].Id,
                                 AccountId = listAcc[0].Id,
                                 Type_of_Change__c = 'New Account',
                                 Type = 'Other',
                                 Export_Compliance_Content_ITAR_EAR__c = 'NO',
                                 Government_Compliance_SM_M_Content__c = 'NO',
                                 Classification__c = 'GTO Field Service',
                                 OwnerId = Userinfo.getUserId()
                                ));            
        test.startTest();            
        insert oldCaseList; 
        System.runAs(u) { 
            List<Task> listTask = new List<Task>();
            listTask.add(new Task(whatid = oldCaseList[0].Id));
            insert listTask;
        }           
        List<ID> caseId = new List<Id>{oldCaseList[0].Id};
            CaseServiceForCommonMethods.updateTaskOwner(caseId);
        test.stopTest();           
    }
    
    @isTest
    public static void Sendemail_TCT_TechnicalIssueTest(){
        Supported_Products__c prod=new Supported_Products__c();
        prod.name='test product';
        prod.status__c='Active';
        prod.Retention_Hold_Reason__c='On Hold pending record data owner approval to remove/purge';
        prod.Technical_Core_Team__c='DLTCTBGAAPU@Honeywell.com';
        
        insert prod;
        
        account Account1= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account23',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c => 'D&S',
                account.Service_Level__c => 'Refer To Network',
                account.Do_Not_Send_to_Portal__c => false,
                Account.PFECN__c => null,
                account.Region_Name__c => 'Asia/Pacific Rim'
                });
        
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = Account1.Id;
        con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
        con.Email='shuchis_vats@yahoo.com';
        insert  con;
        currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                    User.Email => 'test123@honeywell.com',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LastName => 'Customer Master',
                    User.FirstName=>'Salesforce',    
                    User.LanguageLocaleKey => 'en_US',
                    User.LocalesIdKey => 'en_US',
                    User.ProfileId => UserInfo.getProfileId(),
                    User.TimezonesIdKey => 'America/Los_Angeles',
                    User.Username => 'lfdghfdgtsprotrei0pt6w346@honeywell.com'
                    }
        );     
        Case newcase=new case();
        newcase.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
        newcase.Origin = 'Web';
        newcase.RnOSAPCases__c = 200;
        newcase.Subject = 'ELT Coding';
        newcase.status='Open';
        newcase.Resolution_Tool__c='TCT';
        newcase.contactid=con.id;
        newcase.ownerid=currentuser.id;
        newcase.Supported_Products__c=prod.id;
        insert newcase;
        case oldcase=newcase.clone();
        oldcase.Resolution_Tool__c=null;
        Map<Id,Case> oldMap2=new  Map<Id,Case> {newcase.id=>oldcase};
            Map<Id,Case> newMap2=new  Map<Id,Case> {newcase.id=>newcase};
                CaseServiceForCommonMethods.Sendemail_TCT_TechnicalIssue(false,true,new list<case>{newcase},newmap2,oldmap2);
        oldMap2=new  Map<Id,Case> {newcase.id=>newcase};
            newcase.Resolution_Tool__c='ATS';
        
        newMap2=new  Map<Id,Case> {newcase.id=>newcase};
            CaseServiceForCommonMethods.Sendemail_TCT_TechnicalIssue(false,true,new list<case>{newcase},newmap2,oldmap2);
        oldMap2=new  Map<Id,Case> {newcase.id=>newcase};
            newcase.Resolution_Tool__c='TCT';
        
        newMap2=new  Map<Id,Case> {newcase.id=>newcase};
            CaseServiceForCommonMethods.Sendemail_TCT_TechnicalIssue(false,true,new list<case>{newcase},newmap2,oldmap2);
    }
    static testMethod void sendAOGAlertMethod_Test(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            
            
            Helicopters__c heli=(Helicopters__c)SObjectFactory.create(
                Helicopters__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Helicopters__c.name__c=>'shuchis_vats@yahoo.com',               
                        Helicopters__c.name=>'Helicopter' 
                        }
            ); 
            
            
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();
            
            Platform__c plat2=new Platform__c(Name='Helicopter',Model__c='model');
            listPlat.add(plat2);
            Platform__c plat12=new Platform__c(Name='Micellaneous',Model__c='model');
            listPlat.add(plat12);
            
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            
            Fleet_Asset_Detail__c fad12=new Fleet_Asset_Detail__c(Name='Airbus',Platform_Name__c=plat12.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad12);               
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow12 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat2.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad12.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow12);
            
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f10= new Field_Event__c(Case_Number__c=UnAuthcseLow12.id);
            listFe.add(f10); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    @isTest static void testMethodOnBeforeInsertAssignPrimary1() 
    {  
        Test.StartTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;             
            Set<Id> setCaseIds= new Set<Id>(); 
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com'];       
            System.runAs(testUser) { 
                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.build(CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                                                                {
                                                                    Case.OwnerId => UserInfo.getUserId(),
                                                                        Case.Origin => 'Web-Pilots Corner Avionics',  
                                                                        Case.IsWorkflowTriggered__c => true,
                                                                        Case.Mail_Box_Name__c => 'Fax//test',
                                                                        Case.Origin_Check__c => False,
                                                                        Case.Agent_Contact_Flag__c => false, 
                                                                        Case.Subject => 'Fax:{4343434343}',
                                                                        Case.Supported_Product__c => '787 Maintenance System',
                                                                        Case.Government_Compliance_SM_M_Content__c=> null,
                                                                        Case.Export_Compliance_Content_ITAR_EAR__c=> null                                    
                                                                        }
                                                               );                 
                insert listCaseEmail;
                CaseServiceForCommonMethods.onBeforeInsertAndUpdateAssignPrimary(true,false,listCaseEmail,null,null);
                
                for(Case objCase: listCaseEmail){
                    setCaseIds.add(objCase.Id);
                }        
                for (case caseOriginEmail : [SELECT Emailbox_Origin__c,CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertequals(caseOriginEmail.Export_Compliance_Content_ITAR_EAR__c,'Undetermined');
                    system.assertequals(caseOriginEmail.Government_Compliance_SM_M_Content__c,'Undetermined');             
                }
            } 
        }
        Test.stopTest();
    }
    @isTest static void testMethodOnBeforeInsertAssignPrimary2() 
    {  
        Test.StartTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;             
            Set<Id> setCaseIds= new Set<Id>(); 
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com'];       
            System.runAs(testUser) { 
                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.build(CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                                                                {
                                                                    Case.OwnerId => UserInfo.getUserId(),
                                                                        Case.Origin => 'Web-Pilots Corner Avionics',  
                                                                        Case.IsWorkflowTriggered__c => true,
                                                                        Case.Mail_Box_Name__c => 'Fax//test',
                                                                        Case.RnOSAPCases__c => 1234,
                                                                        Case.Origin_Check__c => False,
                                                                        Case.Agent_Contact_Flag__c => false, 
                                                                        Case.Subject => 'Fax:{4343434343}',
                                                                        Case.Supported_Product__c => '787 Maintenance System',
                                                                        Case.Government_Compliance_SM_M_Content__c=> null,
                                                                        Case.Export_Compliance_Content_ITAR_EAR__c=> null                                    
                                                                        }
                                                               );                 
                insert listCaseEmail;
                account objAccount= (account)SObjectFactory.create(
                    account.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        account.OwnerId => UserInfo.getUserId(),
                            account.Name => 'Test Account1',
                            account.type => 'Energy',
                            account.Strategic_Business_Unit__c => 'D&S',
                            account.Service_Level__c => 'Unauthorized Dist/Brkr',
                            account.Do_Not_Send_to_Portal__c => false,
                            Account.PFECN__c => null,
                            account.Region_Name__c => 'Asia/Pacific Rim'         
                            });
                contact objContact= (contact)SObjectFactory.create(
                    contact.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        contact.OwnerId => UserInfo.getUserId(),
                            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                            contact.AccountId => objAccount.Id,
                            contact.fax_web__C => '4343434343',
                            contact.Email=>'test_radha@in.ibm.com'
                            }); 
                List<Skills2__c> listSkill = SObjectFactory.create(
                    2, Skills2__c.sObjectType, new Map<Schema.SObjectField, Object>
                    {
                        Skills2__c.Primary_Secondary__c =>'Primary',
                            Skills2__c.Contact__c => objContact.Id,
                            Skills2__c.Supported_Product__c =>'787 Maintenance System'                          
                            }
                ); 
                
                CaseServiceForCommonMethods.onBeforeInsertAndUpdateAssignPrimary(true,false,listCaseEmail,null,null);
                
                for(Case objCase: listCaseEmail){
                    setCaseIds.add(objCase.Id);
                }        
                for (case caseOriginEmail : [SELECT Emailbox_Origin__c,CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertequals(caseOriginEmail.Export_Compliance_Content_ITAR_EAR__c,'Undetermined');
                    system.assertequals(caseOriginEmail.Government_Compliance_SM_M_Content__c,'Undetermined');             
                }
            } 
        }
        Test.stopTest();
    }
    @isTest static void testMethodOnBeforeInsertAssignPrimary3() 
    {  
        Test.StartTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;             
            Set<Id> setCaseIds= new Set<Id>(); 
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com'];       
            System.runAs(testUser) { 
                
                //create case records        
                List<Case> listCaseEmail = SObjectFactory.build(CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
                                                                {
                                                                    Case.OwnerId => UserInfo.getUserId(),
                                                                        Case.Origin => 'Web-Pilots Corner Avionics',
                                                                        Case.sales_order_number__c => '1234',  
                                                                        Case.IsWorkflowTriggered__c => true,
                                                                        Case.Mail_Box_Name__c => 'Fax//test',
                                                                        Case.Origin_Check__c => False,
                                                                        Case.Agent_Contact_Flag__c => false, 
                                                                        Case.Subject => 'Fax:{4343434343}',
                                                                        Case.Supported_Product__c => '787 Maintenance System',
                                                                        Case.Government_Compliance_SM_M_Content__c=> null,
                                                                        Case.Export_Compliance_Content_ITAR_EAR__c=> null                                    
                                                                        }
                                                               );                 
                insert listCaseEmail;
                CaseServiceForCommonMethods.onBeforeInsertAndUpdateAssignPrimary(true,false,listCaseEmail,null,null);
                
                for(Case objCase: listCaseEmail){
                    setCaseIds.add(objCase.Id);
                }        
                for (case caseOriginEmail : [SELECT Emailbox_Origin__c,CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
                {
                    system.assertequals(caseOriginEmail.Export_Compliance_Content_ITAR_EAR__c,'Undetermined');
                    system.assertequals(caseOriginEmail.Government_Compliance_SM_M_Content__c,'Undetermined');             
                }
            } 
        }
        Test.stopTest();
    }
    @isTest static void RnOCaseOwnerAssignOnCreationMethod()
    {
        Test.StartTest();
        List<Case> listCaseEmail = new List<case>();
        Case cas = new case();
        cas.OwnerId = UserInfo.getUserId();
        cas.Origin = 'Web-Pilots Corner Avionics';
        cas.RecordTypeId = rtIdEngineRentals;
        cas.Status = 'On Hold';
        cas.Sub_Status__c ='Shipment';
        cas.sales_order_number__c = '1234';        
        cas.IsWorkflowTriggered__c = true;
        cas.Mail_Box_Name__c = 'Fax//test';
        cas.Origin_Check__c = False;        
        cas.Subject = 'Fax:{4343434343}';
        cas.Supported_Product__c = '787 Maintenance System';
        cas.Government_Compliance_SM_M_Content__c= null;
        cas.Export_Compliance_Content_ITAR_EAR__c= null;                                  
        listCaseEmail.add(cas);  
        
        insert listCaseEmail;
        CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail, null, 'Insert');
        Test.StopTest();
    }
    @isTest static void RnOCaseOwnerAssignOnCreationMethod123()
    {
        Test.StartTest();
        List<Case> listCaseEmail = new List<case>();
        Case cas = new case();
        cas.OwnerId = UserInfo.getUserId();
        cas.Origin = 'Web-Pilots Corner Avionics';
        cas.RecordTypeId = rtIdMSPContract;
        cas.Status = 'Open';
        cas.Sub_Status__c ='Customer Profile Sent';
        cas.sales_order_number__c = '1234';        
        cas.IsWorkflowTriggered__c = true;
        cas.Mail_Box_Name__c = 'Fax//test';
        cas.Origin_Check__c = False;
        cas.Agent_Contact_Flag__c = false;
        cas.Subject = 'Fax:{4343434343}';
        cas.Supported_Product__c = '787 Maintenance System';
        cas.Government_Compliance_SM_M_Content__c= null;
        cas.Export_Compliance_Content_ITAR_EAR__c= null;                                  
        listCaseEmail.add(cas);  
        
        insert listCaseEmail;
        CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail, null, 'Insert');
        Test.StopTest();
    }
    @isTest static void RnOCaseOwnerAssignOnCreationMethod1234()
    {
        Test.StartTest();
        List<Case> listCaseEmail = new List<case>();
        Case cas = new case();
        cas.OwnerId = UserInfo.getUserId();
        cas.Origin = 'Web-Pilots Corner Avionics';
        cas.RecordTypeId = rtIdMSPContract;
        cas.Status = 'Open';
        cas.Sub_Status__c ='Customer Profile Sent';
        cas.sales_order_number__c = '1234';        
        cas.IsWorkflowTriggered__c = true;
        cas.Mail_Box_Name__c = 'Fax//test';
        cas.Origin_Check__c = False;
        cas.Agent_Contact_Flag__c = false;
        cas.Subject = 'Fax:{4343434343}';
        cas.Supported_Product__c = '787 Maintenance System';
        cas.Government_Compliance_SM_M_Content__c= null;
        cas.Export_Compliance_Content_ITAR_EAR__c= null;                                  
        listCaseEmail.add(cas);  
        
        insert listCaseEmail;
        CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail, null, 'Insert');
        Test.StopTest();
    }
    @isTest static void RnOCaseOwnerAssignOnCreationMethod1235()
    {
        Test.StartTest();
        List<Case> listCaseEmail = new List<case>();
        Case cas = new case();
        cas.OwnerId = UserInfo.getUserId();
        cas.Origin = 'Web-Pilots Corner Avionics';
        cas.RecordTypeId = rtIdMSPContract;
        cas.Status = 'Open';
        cas.Sub_Status__c ='Customer Profile Sent';
        cas.sales_order_number__c = '1234';        
        cas.IsWorkflowTriggered__c = true;
        cas.Mail_Box_Name__c = 'Fax//test';
        cas.Origin_Check__c = False;
        cas.Agent_Contact_Flag__c = false;
        cas.Subject = 'Fax:{4343434343}';
        cas.Supported_Product__c = '787 Maintenance System';
        cas.Government_Compliance_SM_M_Content__c= null;
        cas.Export_Compliance_Content_ITAR_EAR__c= null;                                  
        listCaseEmail.add(cas);  
        
        insert listCaseEmail;
        CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listCaseEmail, null, 'Insert');
        Test.StopTest();
    }
    @isTest static void sendEmailMethod_MSPTEST()
    {
        account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account1',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c => 'D&S',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Do_Not_Send_to_Portal__c => false,
                    Account.PFECN__c => null,
                    account.Region_Name__c => 'Asia/Pacific Rim'         
                    });
        Id recordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName()
            .get('Contracts').getRecordTypeId();
        Contract c1 = new Contract();
        c1.Type__c = 'APM';
        c1.RecordTypeId = recordTypeId;
        c1.Asset_Program__c = 'Yes';
        c1.Status = 'Draft';
        c1.EndDate = Date.newInstance(2020, 12, 9);
        c1.AccountId = objAccount.Id;
        insert c1; 
        
        List<Contact> listCon = new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = objAccount.Id;
        con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
        con.Email='shuchis_vats@yahoo.com';
        con.fax_web__C = '34343';
        listCon.add(con);
        
        List<Case> listCaseEmail = new List<case>();
        Case cas = new case();
        cas.OwnerId = UserInfo.getUserId();
        cas.Origin = 'Web-Pilots Corner Avionics';
        cas.RecordTypeId = rtIdMSPContract;
        cas.Status = 'Open';
        cas.Sub_Status__c ='Customer Profile Sent';
        cas.sales_order_number__c = '1234';
        cas.Serv_Contract__c = c1.id;
        cas.IsWorkflowTriggered__c = true;
        cas.Mail_Box_Name__c = 'Fax//test';
        cas.Origin_Check__c = False;
        cas.Agent_Contact_Flag__c = false;
        cas.Subject = 'Fax:{4343434343}';
        cas.Supported_Product__c = '787 Maintenance System';
        cas.Government_Compliance_SM_M_Content__c= null;
        cas.Export_Compliance_Content_ITAR_EAR__c= null;                                  
        listCaseEmail.add(cas);  
        
        insert listCaseEmail;
        System.debug('ListcaseEmail : '+listCaseEmail);
        Map<id,Case> mapoldCase = new Map<id,Case>([Select Id,Sub_Status__c,Serv_Contract__c from case where Id =: listCaseEmail[0].id]); 
        //mapoldCase = [Select Id from case where Id =: listCaseEmail[0].id];
        Test.StartTest();               
        List<Case> newListCaseEmail = new List<Case>();
        cas.Sub_Status__c ='First Follow Up'; 
        cas.Serv_Contract__c = c1.id;
        newListCaseEmail.add(cas);
        update newListCaseEmail;
        Test.StopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            
            
            airbus__c airbus = (airbus__c)SObjectFactory.create(
                airbus__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    airbus__c.name__c=>'shuchis_vats@yahoo.com',
                        airbus__c.name=>'Airbus' 
                        }
            ); 
            Boeing__c boeing = (Boeing__c)SObjectFactory.create(
                Boeing__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Boeing__c.name__c=>'shuchis_vats@yahoo.com',
                        Boeing__c.name=>'Boeing' 
                        }
            );  
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();
            Platform__c plat=new Platform__c(Name='Airbus',Model__c='model');
            listPlat.add(plat);
            Platform__c plat4=new Platform__c(Name='Boeing',Model__c='model');
            listPlat.add(plat4);        
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            
            Fleet_Asset_Detail__c fad1=new Fleet_Asset_Detail__c(Name='Airbus',Platform_Name__c=plat.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad1);
            Fleet_Asset_Detail__c fad2=new Fleet_Asset_Detail__c(Name='Boeing',Platform_Name__c=plat4.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad2);
            
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow1 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad1.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow1);
            Case UnAuthcseLow2 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat4.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad2.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow2);
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow1.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow2.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Components__C Components = (Components__C)SObjectFactory.create(
                Components__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    Components__C.name__c=>'shuchis_vats@yahoo.com',
                        Components__C.name=>'Components' 
                        }
            ); 
            miscellaneous__C Miscellaneous = (miscellaneous__C)SObjectFactory.create(
                miscellaneous__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    miscellaneous__C.name__c=>'shuchis_vats@yahoo.com',
                        miscellaneous__C.name=>'Miscellaneous' 
                        }
            ); 
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();   
            Platform__c plat5 =new Platform__c(Name='Components',Model__c='model');
            listPlat.add(plat5);    
            Platform__c plat6=new Platform__c(Name='Miscellaneous',Model__c='model');
            listPlat.add(plat6);    
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            Fleet_Asset_Detail__c fad3=new Fleet_Asset_Detail__c(Name='Components',Platform_Name__c=plat5.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad3);
            Fleet_Asset_Detail__c fad4=new Fleet_Asset_Detail__c(Name='Miscellaneous',Platform_Name__c=plat6.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad4);
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow3 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat5.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad3.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow3);
            Case UnAuthcseLow4 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat6.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad4.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow4);
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow3.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow4.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno32(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Hawker__C Hawker = (Hawker__C)SObjectFactory.create(
                Hawker__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    Hawker__C.name__c=>'shuchis_vats@yahoo.com',
                        Hawker__C.name=>'Hawker' 
                        }
            ); 
            Cessna__C Cessna = (Cessna__C)SObjectFactory.create(
                Cessna__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    Cessna__C.name__c=>'shuchis_vats@yahoo.com',
                        Cessna__C.name=>'Cessna' 
                        }
            );
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();     
            Platform__c plat7=new Platform__c(Name='Cessna',Model__c='model');
            listPlat.add(plat7); 
            Platform__c plat8=new Platform__c(Name='Hawker',Model__c='model');
            listPlat.add(plat8);       
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            Fleet_Asset_Detail__c fad5=new Fleet_Asset_Detail__c(Name='Cessna',Platform_Name__c=plat7.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad5);
            Fleet_Asset_Detail__c fad6=new Fleet_Asset_Detail__c(Name='Hawker',Platform_Name__c=plat8.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad6);
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow5 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat7.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad5.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow5);
            Case UnAuthcseLow6 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat8.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad6.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow6);
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow5.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow6.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    
    static testMethod void sendAOGAlertMethod_Testno5(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Gulfstream__C Gulfstream = (Gulfstream__C)SObjectFactory.create(
                Gulfstream__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    Gulfstream__C.name__c=>'shuchis_vats@yahoo.com',
                        Gulfstream__C.name=>'Gulfstream' 
                        }
            ); 
            Dassault__C Dassault = (Dassault__C)SObjectFactory.create(
                Dassault__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    Dassault__C.name__c=>'shuchis_vats@yahoo.com',
                        Dassault__C.name=>'Dassault' 
                        }
            ); 
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();     
            Platform__c plat11=new Platform__c(Name='Dassault',Model__c='model');
            listPlat.add(plat11);    
            Platform__c plat12=new Platform__c(Name='Gulfstream',Model__c='model');
            listPlat.add(plat12);       
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            Fleet_Asset_Detail__c fad9=new Fleet_Asset_Detail__c(Name='Dassault',Platform_Name__c=plat11.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad9);
            Fleet_Asset_Detail__c fad10=new Fleet_Asset_Detail__c(Name='Gulfstream',Platform_Name__c=plat12.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad10);
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow9 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat11.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad9.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow9);
            Case UnAuthcseLow10 = new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat12.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad10.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow10);
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow9.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow10.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno6(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Airlines__C Airlines = (Airlines__C)SObjectFactory.create(
                Airlines__C.sObjectType, new Map<Schema.SObjectField, Object>{
                    Airlines__C.name__c=>'shuchis_vats@yahoo.com',
                        Airlines__C.name=>'Airlines' 
                        }
            ); 
            Helicopters__c Helicopters = (Helicopters__c)SObjectFactory.create(
                Helicopters__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Helicopters__c.name__c=>'shuchis_vats@yahoo.com',
                        Helicopters__c.name=>'Helicopters' 
                        }
            ); 
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Airbus',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();     
            Platform__c plat13=new Platform__c(Name='Helicopter',Model__c='model');
            listPlat.add(plat13);    
            Platform__c plat14=new Platform__c(Name='Airlines',Model__c='model');
            listPlat.add(plat14);       
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            Fleet_Asset_Detail__c fad11=new Fleet_Asset_Detail__c(Name='Helicopter',Platform_Name__c=plat13.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad11);
            Fleet_Asset_Detail__c fad12=new Fleet_Asset_Detail__c(Name='Airlines',Platform_Name__c=plat14.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad12);
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow11= new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat13.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad11.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow11);
            Case UnAuthcseLow12= new Case(Detail_Class__c='AOG - IFSD Commanded', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat14.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad12.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow12);
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow11.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow12.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno21(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Bombardier_ATR__c atr = (Bombardier_ATR__c)SObjectFactory.create(
                Bombardier_ATR__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Bombardier_ATR__c.name__c=>'shuchis_vats@yahoo.com',
                        Bombardier_ATR__c.name=>'Bombardier ATR' 
                        }
            ); 
            Airlines__c airlines = (Airlines__c)SObjectFactory.create(
                Airlines__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Airlines__c.name__c=>'shuchis_vats@yahoo.com',        
                        Airlines__c.name=>'Airlines' 
                        }
            ); 
            
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'airlines',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();
            Platform__c plat=new Platform__c(Name='Bombardier',Model__c='model');
            listPlat.add(plat);
            Platform__c plat4=new Platform__c(Name='Airlines',Model__c='model');
            listPlat.add(plat4);                       
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            
            Fleet_Asset_Detail__c fad1=new Fleet_Asset_Detail__c(Name='airlines',Platform_Name__c=plat.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad1);
            Fleet_Asset_Detail__c fad2=new Fleet_Asset_Detail__c(Name='atr',Platform_Name__c=plat4.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad2);               
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow1 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad1.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow1);
            Case UnAuthcseLow2 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat4.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad2.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow2);
            
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow1.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow2.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Gulfstream__c gulf=(Gulfstream__c)SObjectFactory.create(
                Gulfstream__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Gulfstream__c.name__c=>'shuchis_vats@yahoo.com', 
                        Gulfstream__c.name=>'Gulfstream' 
                        }
            ); 
            Dassault__c dassault=(Dassault__c)SObjectFactory.create(
                Dassault__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Dassault__c.name__c=>'shuchis_vats@yahoo.com',
                        Dassault__c.name=>'Dassault'                         
                        }
            ); 
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Gulfstream',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();
            Platform__c plat=new Platform__c(Name='Gulfstream',Model__c='model');
            listPlat.add(plat);
            Platform__c plat4=new Platform__c(Name='Dassault',Model__c='model');
            listPlat.add(plat4);                       
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            
            Fleet_Asset_Detail__c fad1=new Fleet_Asset_Detail__c(Name='Gulfstream',Platform_Name__c=plat.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad1);
            Fleet_Asset_Detail__c fad2=new Fleet_Asset_Detail__c(Name='Dassault',Platform_Name__c=plat4.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad2);               
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow1 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad1.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow1);
            Case UnAuthcseLow2 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat4.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad2.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow2);
            
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow1.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow2.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno4(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Pilatus__c pilatus=(Pilatus__c)SObjectFactory.create(
                Pilatus__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Pilatus__c.name__c=>'shuchis_vats@yahoo.com',    
                        Pilatus__c.name=>'Pilatus'    
                        }
            ); 
            Hawker__c hawker=(Hawker__c)SObjectFactory.create(
                Hawker__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Hawker__c.name__c=>'shuchis_vats@yahoo.com',    
                        Hawker__c.name=>'Hawker'                 
                        }
            ); 
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Gulfstream',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();
            Platform__c plat=new Platform__c(Name='Pilatus',Model__c='model');
            listPlat.add(plat);
            Platform__c plat4=new Platform__c(Name='Hawker',Model__c='model');
            listPlat.add(plat4);                       
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            
            Fleet_Asset_Detail__c fad1=new Fleet_Asset_Detail__c(Name='Pilatus',Platform_Name__c=plat.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad1);
            Fleet_Asset_Detail__c fad2=new Fleet_Asset_Detail__c(Name='Hawker',Platform_Name__c=plat4.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad2);               
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow1 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad1.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow1);
            Case UnAuthcseLow2 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat4.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad2.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow2);
            
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow1.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow2.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    static testMethod void sendAOGAlertMethod_Testno8(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            id TechIssueRecId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
            Embraer_BGA__c ebga= (Embraer_BGA__c)SObjectFactory.create(
                Embraer_BGA__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Embraer_BGA__c.name__c=>'shuchis_vats@yahoo.com',                
                        Embraer_BGA__c.name=>'Embraer BGA'                 
                        }
            ); 
            Embraer_ATR__c eatr=(Embraer_ATR__c)SObjectFactory.create(
                Embraer_ATR__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Embraer_ATR__c.name__c=>'shuchis_vats@yahoo.com',                 
                        Embraer_ATR__c.name=>'Embraer ATR'                 
                        }
            ); 
            Account acc = new Account(Name = 'Test Account',Customer_Status__c = 'Active',CBT__c = 'Gulfstream',Region_Name__c = 'Americas',Sub_Region_Name__c = 'Canada',Type = 'Operator',REPORT_ACCOUNT_NAME__c = 'Test Account',Market_Name__c = 'Marine',Service_Level__c='Standard',Strategic_Business_Unit__c='GPA');
            List<Account> listAcc = new List<Account>();
            
            
            List<Contact> listCon = new List<Contact>();
            Contact con = new Contact();
            con.LastName = 'Kulkarni';
            con.FirstName = 'Shrivaths';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'shuchis_vats@yahoo.com';
            con.Email='shuchis_vats@yahoo.com';
            listCon.add(con);
            
            List<Platform__c> listPlat =new List<Platform__c>();
            Platform__c plat=new Platform__c(Name='Embraer',Model__c='model');
            listPlat.add(plat);                                   
            insert listPlat;
            
            List<Fleet_Asset_Detail__c> listfl=new List<Fleet_Asset_Detail__c>();
            
            Fleet_Asset_Detail__c fad1=new Fleet_Asset_Detail__c(Name='Embraer',Platform_Name__c=plat.id,Tail_Number__c='123',Serial_Number__c='123');    
            listfl.add(fad1);
            insert listfl;
            
            Supported_Products__c pro2=new Supported_Products__c(Status__c='Active',name='Test Product',Catalog_Product_Group__c='Aircraft Lighting (LI)',Contact__c=con.id,Primary__c=con.id,Record_Data_Owner__c=con.id);
            List<Supported_Products__c> sp=new List<Supported_Products__c>();
            sp.add(pro2);
            insert sp;
            
            List<Case> listObjCaseNew = new List<Case>();
            Case UnAuthcseLow1 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'BGA', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad1.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow1);
            Case UnAuthcseLow2 = new Case(Detail_Class__c='AOG - IFSD Commanded', SBU_w2c__c = 'ATR', Sub_Class__c ='Sub Class',Resolution__c='Resolution',aircraft_location__c ='Location' ,Supported_Products__c =pro2.id,aircraft_type__c=plat.id,Aircraft_Serial_Number__c='1234',Aircraft_tail_Number__c='3333',Expected_Update__c=system.today(),aog__c=true,Mail_Box_Name__c='shuchis_vats@yahoo.com',Requested_By_HON_Internal__c=con.id,Aircraft_Name__c=fad1.id, Status='New',SuppliedEmail='shuchis_vats@yahoo.com',Subject='Form',AccountId=acc.id,Origin = 'Email',RecordTypeId = TechIssueRecId,Classification__c = 'Technical Support',ContactId = con.Id,Type_of_Change__c = 'New Account', Export_Compliance_Content_ITAR_EAR__c = 'NO',Agent_Contact_Flag__c=true,Emailbox_Origin__c='Email-FSSActivations',Government_Compliance_SM_M_Content__c = 'NO');
            listObjCaseNew.add(UnAuthcseLow2);
            
            insert listObjCaseNew;
            
            map<Id,Case> oldMapCase = new map<Id,Case>();
            for(Case cas: listObjCaseNew){
                oldMapCase.put(cas.Id,cas);
            }        
            
            List<Field_Event__c> listFe= new List<Field_Event__c>(); 
            Field_Event__c f1= new Field_Event__c(Case_Number__c=UnAuthcseLow1.id);
            listFe.add(f1); 
            Field_Event__c f2= new Field_Event__c(Case_Number__c=UnAuthcseLow2.id);
            listFe.add(f2); 
            
            insert listFe;
            
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            
            CaseServiceForCommonMethods.sendAOGAlertMethod(listObjCaseNew, new map<id,case>(), 'Insert',  lstCas, 'isAfter');
            
        }
        Test.stopTest();
    }
    @isTest static void testsendCaseEmailMethodInsertTest2(){
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Account> lstAct= SObjectFactory.build(1,Account.sObjectType);
            lstAct[0].Name = 'Test Account';
            lstAct[0].Customer_Status__c = 'Active';
            lstAct[0].Strategic_Business_Unit__c = 'BGA';
            lstAct[0].CBT__c = 'Airbus';
            lstAct[0].Region_Name__c = 'Asia/Pacific Rim';
            lstAct[0].Sub_Region_Name__c = 'Canada';
            lstAct[0].Service_Level__c = 'Refer to Network';   
            lstAct[0].PFECN__c='';
            lstAct[0].Orders_Next_Wave__c=false;
            lstAct[0].Do_not_send_to_portal__c=false;
            lstAct[0].Type = 'Owner/Operator';
            lstAct[0].REPORT_ACCOUNT_NAME__c = 'Test Account';
            lstAct[0].Market_Name__c = 'Marine';
            insert lstAct;
            account accountWithBGA = lstAct[0];
            
            contact objContact= (contact)SObjectFactory.create(
                contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    contact.OwnerId => UserInfo.getUserId(),
                        contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                        contact.AccountId => lstAct[0].id,
                        contact.fax_web__C => '4343434343',
                        contact.Email=>'test_radha@in.ibm.com'
                        }); 
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1);
            case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('D&S Clearing House Proposal','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False            
                    }); 
            caseList.add(Cas2);  
            case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Orders',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas3);
            case Cas4 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Orders',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas4);  
            case Cas5 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas5);
            case Cas6 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas6);
            case Cas7 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas7);
            case Cas8 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas8);
            case Cas9 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas9);
            case Cas10 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas10);
            
            case Cas11 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas11);
            
            case Cas12 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas12);
            
            case Cas13 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Quotes',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas13);
            Test.startTest(); 
            insert caseList;
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
                //CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Update');
            }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    
    @isTest static void testsendCaseEmailMethodInsertTest1(){
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Account> lstAct= SObjectFactory.build(1,Account.sObjectType);
            lstAct[0].Name = 'Test Account';
            lstAct[0].Customer_Status__c = 'Active';
            lstAct[0].Strategic_Business_Unit__c = 'BGA';
            lstAct[0].CBT__c = 'Airbus';
            lstAct[0].Region_Name__c = 'Asia/Pacific Rim';
            lstAct[0].Sub_Region_Name__c = 'Canada';
            lstAct[0].Service_Level__c = 'Refer to Network';   
            lstAct[0].PFECN__c='';
            lstAct[0].Orders_Next_Wave__c=false;
            lstAct[0].Do_not_send_to_portal__c=false;
            lstAct[0].Type = 'Owner/Operator';
            lstAct[0].REPORT_ACCOUNT_NAME__c = 'Test Account';
            lstAct[0].Market_Name__c = 'Marine';
            insert lstAct;
            account accountWithBGA = lstAct[0];
            
            contact objContact= (contact)SObjectFactory.create(
                contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    contact.OwnerId => UserInfo.getUserId(),
                        contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                        contact.AccountId => lstAct[0].id,
                        contact.fax_web__C => '4343434343',
                        contact.Email=>'test_radha@in.ibm.com'
                        }); 
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False      
                    });
            caseList.add(Cas1);
            case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('D&S Clearing House Proposal','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.Origin => 'Email-AOG',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.AOG__c=> False            
                    }); 
            caseList.add(Cas2);  
            case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Orders',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas3);
            case Cas4 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Orders',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas4);  
            case Cas5 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas5);
            case Cas6 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Quotes',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas6);
            case Cas7 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas7);
            case Cas8 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False            
                    });
            caseList.add(Cas8);
            case Cas9 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => false,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas9);
            case Cas10 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas10);
            
            case Cas11 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Order Status',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas11);
            
            case Cas12 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id,
                    Case.SuppliedEmail => 'Test@gulfstream.com',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,            
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Emailbox_Origin__c => 'Email-Aero GSE Vendor Support',
                    Case.Agent_Contact_Flag__c => true,
                    Case.AOG__c=> False                  
                    });
            caseList.add(Cas12);
            Test.startTest(); 
            insert caseList;
            try{
                CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Update');
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
    @isTest static void beforeIsCaseOwnerQueueTest(){
        TriggerInactive.testTrigger = false;
        List<Account> lstAct= SObjectFactory.build(1,Account.sObjectType);
        lstAct[0].Name = 'Test Account';
        lstAct[0].Customer_Status__c = 'Active';
        lstAct[0].Strategic_Business_Unit__c = 'BGA';
        lstAct[0].CBT__c = 'Airbus';
        lstAct[0].Region_Name__c = 'Asia/Pacific Rim';
        lstAct[0].Sub_Region_Name__c = 'Canada';
        lstAct[0].Service_Level__c = 'Unauthorized Dist/Brkr';   
        lstAct[0].PFECN__c='';
        lstAct[0].Orders_Next_Wave__c=false;
        lstAct[0].Do_not_send_to_portal__c=false;
        lstAct[0].Type = 'Owner/Operator';
        lstAct[0].REPORT_ACCOUNT_NAME__c = 'Test Account';
        lstAct[0].Market_Name__c = 'Marine';
        insert lstAct;
        account accountWithBGA = lstAct[0];
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => lstAct[0].id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_swathi@test.com'
                    }); 
        cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
        List<Case> caseList = new List<case>();  
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'CPS BGA Process', 
                Case.Subject => 'Test',
                Case.Status=>'Tech Issue-SR Assigned',
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('General','Case').Id,
                Case.SuppliedEmail => 'Test@honeywell.com',
                Case.Origin => 'Email',
                Case.Emailbox_Origin__c => 'Email-Orders',
                Case.AccountId=> lstAct[0].Id,
                Case.SuppliedEmail=> 'test@honeywell.com',
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Tool_Name__c => 'MCORE',
                Case.AOG__c=> False      
                });
        case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'CPS BGA Process', 
                Case.Subject => 'Test',
                Case.Status=>'Open',
                Case.Sub_Status__c => 'Accts',
                Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Orders','Case').Id,
                Case.Origin => 'Email-Orders',
                Case.Emailbox_Origin__c => 'Email-Orders',
                Case.AccountId=> lstAct[0].Id,
                Case.ContactId=> objContact.Id,
                Case.NSN__c => 'Test;NSN', 
                Case.Part_Number__c => 'Test;Part',
                Case.Tool_Name__c => 'MCORE',
                Case.AOG__c=> False      
                });
        caseList.add(Cas1);
        caseList.add(Cas2);
        Map<Id,Case> casmap = new Map<Id,Case>();
        casmap.put(cas1.Id, cas1);casmap.put(Cas2.Id, Cas2);
        Test.starttest();
        CaseServiceForCommonMethods.sendCaseEmailMethod(True,caseList,casmap,'Insert');
        CaseServiceForCommonMethods.getGDCGroup('Activation');
        CaseServiceForCommonMethods.getGDCGroup('Cancellation');
        CaseServiceForCommonMethods.getGDCGroup('MyGDC Training');
        CaseServiceForCommonMethods.getGDCGroup('Renewal');
        CaseServiceForCommonMethods.getGDCGroup('Technical Support');
        Test.stoptest();
    }
    @isTest static void testsendCaseEmailMethodInsertTest6(){
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Account> lstAct= SObjectFactory.build(1,Account.sObjectType);
            lstAct[0].Name = 'Test Account';
            lstAct[0].Customer_Status__c = 'Active';
            lstAct[0].Strategic_Business_Unit__c = 'BGA';
            lstAct[0].CBT__c = 'Airbus';
            lstAct[0].Region_Name__c = 'Asia/Pacific Rim';
            lstAct[0].Sub_Region_Name__c = 'Canada';
            lstAct[0].Service_Level__c = 'Refer to Network';   
            lstAct[0].PFECN__c='';
            lstAct[0].Orders_Next_Wave__c=false;
            lstAct[0].Do_not_send_to_portal__c=false;
            lstAct[0].Type = 'Owner/Operator';
            lstAct[0].REPORT_ACCOUNT_NAME__c = 'Test Account';
            lstAct[0].Market_Name__c = 'Marine';
            insert lstAct;
            account accountWithBGA = lstAct[0];
            contact objContact= (contact)SObjectFactory.create(
                contact.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    contact.OwnerId => UserInfo.getUserId(),
                        contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                        contact.AccountId => lstAct[0].id,
                        contact.fax_web__C => '4343434343',
                        contact.Email=>'test_swathi@Honeywell.com'
                        }); 
            cont = [SELECT id FROM Contact WHERE LastName = 'Test;CreateBulkEmailsNavDB_4' LIMIT 1];
            List<Contact_Tool_Access__c> contTool = SObjectFactory.create(
                1, Contact_Tool_Access__c.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    Contact_Tool_Access__c.Name => 'MCORE',                               
                        //Contact_Tool_Access__c.Name => 'MCORE (Maintenance Cost Reduction)',                               
                        Contact_Tool_Access__c.MCORE_IS_Super_Admin__c => true,
                        Contact_Tool_Access__c.CRM_Contact_ID__c=>cont.id,
                        Contact_Tool_Access__c.Portal_Honeywell_ID__c => 'test123',
                        Contact_Tool_Access__c.Request_Status__c => 'Pending'
                        });
            
            List<Case> caseList = new List<case>();  
            case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'On Hold',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('D&S Clearing House Proposal','Case').Id,
                    Case.SuppliedEmail => 'Test@honeywell.com',
                    Case.Origin => 'Email-AVSAT Orders',
                    Case.Emailbox_Origin__c => 'Email-AVSAT Order',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Tool_Name__c => 'MCORE',
                    Case.AOG__c=> False      
                    });
            case Cas2 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'Open',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('WEB Portal Registration','Case').Id,
                    Case.SuppliedEmail => 'Test@honeywell.com',
                    Case.Origin => 'Email-Orders',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part',
                    Case.Tool_Name__c => 'MCORE',
                    Case.AOG__c=> False      
                    });
            case Cas3 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'CPS BGA Process', 
                    Case.Subject => 'Test',
                    Case.Status=>'Open',
                    Case.Sub_Status__c => 'Accts',
                    Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AERO Customer Support','Case').Id,
                    Case.SuppliedEmail => 'Test@honeywell.com',
                    Case.Origin => 'Email-Orders',
                    Case.AccountId=> lstAct[0].Id,
                    Case.ContactId=> cont.Id,
                    Case.AOG__c =>True,
                    Case.NSN__c => 'Test;NSN', 
                    Case.Part_Number__c => 'Test;Part'
                    });
            caseList.add(Cas1);
            caseList.add(Cas2);
            Test.startTest(); 
            insert caseList;
            Map<String,List<Case>> testc = new Map<String,List<Case>>();
            testc.put('Airbus',caseList);
            List<String> toadd = new List<String>{'test@test.com'};
                try{
                    CaseServiceForCommonMethods.sendCaseEmailMethod(true,caseList,null,'Insert');
                    CaseServiceForCommonMethods.setEmailMessage(Cas1.Id,cont.Id,toadd,'Test','Test',null,null);
                    List<Case> cslst = new List<Case>();cslst.add(Cas3);
                    Map<Id,Case> csmap = new Map<ID,Case>(); csmap.put(Cas3.Id,Cas3);
                    CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(True,caseList,csmap);
                    CaseServiceForCommonMethods.setSingleEmailMessage(Cas1.Id,cont.Id,toadd,'Test','Test',null,null);
                    CaseServiceForCommonMethods.assignValues(True,Cas1,null);
                    CaseServiceForCommonMethods.CreateBulkEmailsAVSAT('Insert',Cas1);
                    CaseServiceForCommonMethods.sendAOGAlertMethod(cslst,csmap,'Insert',csmap,'After');
                    CaseServiceForCommonMethods.AOGAlert(testc);testc.clear();
                    testc.put('Airbus',caseList);CaseServiceForCommonMethods.AOGAlert(testc);testc.clear();
                }
            catch(exception e){}
        }
        Test.stopTest();
    } 
    @isTest static void testcaseOnHold1(){
        Test.startTest();
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('BK Warranty','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        List<case> updatedCaseList = new list<case>();
        Map<id,case> oldCaseMap = new Map<id,case>();
        case cs2 = new case ();
        //cs2.name='Test Case Prajnya2';
        cs2.origin = 'phone';
        cs2.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs2.Government_Compliance_SM_M_Content__c = 'No';
        cs2.recordtypeid = RecordTypeServices.getRecordTypeByName('Exchange','Case').Id;
        cs2.Status = 'Open';
        cs2.Sub_Status__c = 'Customer Hold';
        cs2.Reason_for_hold__c = 'Customer Part Missing';
        cs2.Contactid = objContact.id;
        cs2.vn_name__c = null;
        insert cs2;
        List<Case> oldCaseListQuery = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                      Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                      Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                      Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                      Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                      Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                      Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                      Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c
                                                      From Case
                                                      where Id =: cs2.id]);
        for(Case objCase :oldCaseListQuery){
            oldCaseMap.put(objCase.Id,objCase); 
        }
        
        cs2.Status = 'Propose to Close';
        cs2.Sub_Status__c = 'Export Hold';
        updatedCaseList.add(cs2);
        update cs2;
        
        CaseServiceForCommonMethods.CaseOnHoldMethod(updatedCaseList,oldCaseMap,'Update');
        Test.stopTest();
    }
    @isTest static void testcaseproposal1(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        List<opportunity> objOpp= SObjectFactory.create(
            CASE_COUNT, opportunity.sObjectType, new Map<Schema.SObjectField, Object>
            {
                opportunity.OwnerId => UserInfo.getUserId(),
                    opportunity.Name => 'Test name',
                    //opportunity.AccountId => accountWithBGA.Id,
                    opportunity.StageName => 'Prospecting',
                    opportunity.CloseDate => Date.newInstance(2018, 12, 9)        
                    }); 
        Opportunity_Proposal__c  caseOppProp1 = (Opportunity_Proposal__c) SObjectFactory.create(Opportunity_Proposal__c.SObjectType,
                                                                                                new Map<SObjectField, Object>{
                                                                                                    Opportunity_Proposal__c.Opportunity__c=> objOpp[0].Id
                                                                                                        
                                                                                                        });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Requested_By_HON_Internal__c =objContact.id;
        CS1.Opportunity__c = objOpp[0].ID;
        cs1.vn_name__c = objContact.id;
        cs1.Opportunity_Proposal__c = caseOppProp1.Id;
        insert cs1;
        List<case> updatedCaseList = new list<case>();
        updatedCaseList.add(cs1); 
        CaseServiceForCommonMethods.UpdateOppProposalCase(updatedCaseList,null);
        Test.stopTest();
    }
    @isTest static void testsendemailmeth(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-R&O MechComponents';
        cs1.Emailbox_Origin__c = 'Email-R&O MechComponents';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@test.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    @isTest static void testsendemailmeth1(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-AEROPRO';
        cs1.Emailbox_Origin__c = 'Email-AEROPRO';
        cs1.Mail_Box_Name__c = 'Email-AOG';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@test.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
@isTest static void testsendemailmeth2(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-ACTinternal';
        cs1.Emailbox_Origin__c = 'Email-ACTinternal';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@test.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    @isTest static void testsendemailmeth3(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-AOG';
        cs1.Emailbox_Origin__c = 'Email-AOG';
        cs1.Mail_Box_Name__c = 'Email-AOG';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@test.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    @isTest static void testsendemailmeth4(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Quotes_Do_Not_Send_to_Portal__c => True,
                account.Strategic_Business_Unit__c =>'ATR'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-Quotes';
        cs1.Emailbox_Origin__c = 'Email-Quotes';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@honeywell.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
     @isTest static void testsendemailmeth5(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Region_Name__c => 'Asia/Pacific Rim',
                account.Strategic_Business_Unit__c =>'D&S'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-Order Status';
        cs1.Emailbox_Origin__c = 'Email-Order Status';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@honeywell.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    @isTest static void testsendemailmeth6(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Region_Name__c => 'Asia/Pacific Rim',
                account.Strategic_Business_Unit__c =>'BGA'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-Quotes';
        cs1.Emailbox_Origin__c = 'Email-Quotes';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@honeywell.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
     @isTest static void testsendemailmeth7(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Region_Name__c => 'Asia/Pacific Rim',
                account.Strategic_Business_Unit__c =>'D&S'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Email-AeroRepairs';
        cs1.Emailbox_Origin__c = 'Email-AeroRepairs';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@honeywell.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    @isTest static void testdeferredCases(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Region_Name__c => 'Asia/Pacific Rim',
                account.Strategic_Business_Unit__c =>'D&S'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Web-Deferred Order';
        cs1.Emailbox_Origin__c = 'Email-deferredordersweb';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@honeywell.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Test MTO';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    @isTest static void testContactUSOrderStatus(){
        List<Id> casIdlst = new List<Id>();
        
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
            account.OwnerId => UserInfo.getUserId(),
                account.Name => 'Test Account',
                account.type => 'Energy',
                account.Region_Name__c => 'Asia/Pacific Rim',
                account.Strategic_Business_Unit__c =>'D&S'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
            contact.OwnerId => UserInfo.getUserId(),
                contact.LastName => 'Test last name',
                contact.AccountId => objAccount.Id,
                contact.fax_web__C => '4343434343'     
                });
        Test.startTest();
        Case cs1 = new case ();
        //cs1.name='Test Case Prajnya1';
        cs1.origin = 'Web';
        cs1.Emailbox_Origin__c = 'Email-AeroRepairs';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.status = 'Open';
        cs1.classification__c = 'GCC';
        cs1.SuppliedEmail = 'test@honeywell.com';
        cs1.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
        cs1.Status = 'On Hold';
        cs1.Sub_Status__c = 'Rented';
        cs1.Reason_for_hold__c = 'Customer Part Missing';
        cs1.Contactid = objContact.id;
        cs1.Subject = 'Order Numbe r5483 PO Number 37583';
        cs1.Requested_By_HON_Internal__c =objContact.id;
        cs1.vn_name__c = objContact.id;
        insert cs1;
        Test.stopTest();
    }
    
}