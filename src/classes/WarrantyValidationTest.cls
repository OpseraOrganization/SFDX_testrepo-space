@istest
public class WarrantyValidationTest{
       static final Integer CASE_COUNT = 10;
       static final Integer CASE_COUNT_PROVIDE = 1;

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
        }
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

        
    }
      
  
    static testmethod void ValidateWarrantytest()
    {

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
            sales.Failed_Part_Number__c = '7001850-939';
            sales.Falied_Part_SN__c = 'V1';
            insert sales;

            string caseid = cas[0].Id;

            Test.starttest();

            WarrantyValidation.UpdateWarrantyDetails(caseid);

            Test.stoptest();

    }
    }

}