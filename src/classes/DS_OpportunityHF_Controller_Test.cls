@isTest
public class DS_OpportunityHF_Controller_Test {
    @testSetup static void setupData() {
        
        Profile adminProfile = [select id from Profile where name = 'System Administrator'];
        List<User> lstUser = SObjectFactory.create(
            1, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO2',
                User.Username => 'tu2cso@test.com',
                User.Email => 'testuser@test.com',
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
        //insert lstUser;
        List<Account> lstAccount = SObjectFactory.create(
            1, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account', 
                Account.Type => 'OEM',
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
        //insert lstAccount;
        List<Contact> lstContact = SObjectFactory.build(1,Contact.sObjectType);

               lstContact[0].LastName = 'Test';
               lstContact[0].FirstName = 'Contact';
               lstContact[0].AccountId = lstAccount[0].Id;
               lstContact[0].Primary_Email_Address__c = 'testuser@test.com';
               //lstContact[0].Last_Survey_Date__c = Date.parse('12/16/15');
               lstContact[0].Last_Survey_Date__c = system.Today()-90;
               lstContact[0].Email = 'testuser@test.com';
               lstContact[0].Survey_Opt_Out__c = false;
               lstContact[0].NPS_Survey__c = 'No';
               
               insert lstContact;
        Platform__c pt=new Platform__c(Name='Test');
        insert pt;
        Plant_Code_Master__c cm = new Plant_Code_Master__c(Name='Test');
        insert cm;
        PlantCodeMaster__c pcm = new PlantCodeMaster__c(Name='Test', PlantCode__c='100', SiteID__c=cm.Id, CurrencyIsoCode='USD' );
        insert pcm;
        Opportunity opp = new Opportunity();
        opp.Description = 'Description';
        opp.Customer_Issue_Date__c = system.today();
        opp.Request_Type__c = 'UCA';
        opp.Solicitation_No__c = 'Test';
        opp.Contract_Type__c='BPA';
        opp.Certification_Requirements__c = 'Direct Commercial';
        opp.Platform__c = pt.Id;
        opp.Bid_Type_Name__c = 'LTA';
        opp.Site__c = cm.Id;
        opp.Revenue_Type__c = 'ENG';
        opp.Estimated_Proposal_Value__c = '1234567890';
        opp.AccountId = lstAccount[0].Id;
        opp.Comments__c = 'Test Comments';
        opp.CloseDate = system.today()+5;
        opp.Name='Test';
        insert opp;
        
    }
     static testMethod void testDSHouseClearingForm(){
         
         User runUser = [Select id From User Where Username =: 'tu2cso@test.com' Limit 1];
         System.runAs(runUser){
             Test.startTest();
             TriggerInactive.testTrigger = false;
             Account acct = [Select Id From Account Where Name =: 'Test Account' Limit 1];
             Contact cont = [Select id from Contact where Email =: 'testuser@test.com'  Limit 1]; 
             Plant_Code_Master__c pt=[Select name from Plant_Code_Master__c where Name='Test' limit 1];
             Opportunity opp = [select Id,Name,opportunity_number__c,Account_Contact_Name__c,accountid,Account.Name,Type,Description,Tech_Sales__c,Tech_Sales_Product_Area__c,Certification_Requirements__c,Platform__c,Platform__r.Name,
                           Bid_Type_Name__c,Site__c,Site__r.name,Received_Date_at_Clearing_House__c,HAPP_Email__c,Customer_Issue_Date__c,Contract_Type__c,prime_sub__c,
                           Request_Type__c,Solicitation_No__c,Proposal_Due_Date__c,Type_of_Pricing__c,Proposal_Content__c,Revenue_Type__c,Estimated_Proposal_Value__c,
                           HW_SW__c,Comments__c,Account_Name_formula__c,Opportunity_Type__c,Record_Type_Name__c,recordtypeid,recordtype.name,RFP_Expected_Date__c from Opportunity limit 1];
        
             DS_OpportunityHF_Controller.getWrapperDetails(opp.Id);
             DS_OpportunityHF_Controller.getOpportunityRecord(opp.Id);
             DS_OpportunityHF_Controller.saveCaseRecord( JSON.serialize(opp), 'ENG', pt.Id,false);
             Test.stopTest();
         } 
         
     }
    
}