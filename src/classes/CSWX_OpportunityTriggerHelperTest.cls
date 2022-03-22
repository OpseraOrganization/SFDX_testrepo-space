@istest
/****************************************
* Name : CSWX_OpportunityTriggerHelperTest 
* Author : Accenture
* Description : Test class CSWX_OpportunityTriggerHelper 
*****************************************/
private with sharing class CSWX_OpportunityTriggerHelperTest {
  /******************************
    *Method Name: createProposalTest
    *Description: Test Method to cover createProposal method
    ********************************/
     public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
     public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
      public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
     
     static testMethod void createProposalTest(){
            Set<Id> accId = new Set<Id>();
            Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
         
            Test.startTest();
            List<Account> accountCreation = TestDataFactory.createAccount(2);
            accountCreation[0].AccountNumber = '3011234';
            accountCreation[1].AccountNumber = '3011235';
            database.insert(accountCreation);
            accId.add(accountCreation[0].Id);
            accId.add(accountCreation[1].Id);
            
            Account acc = new Account();
            acc.Name='Legal Entinty Account For Test';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
            acc.ParentId = accountCreation[0].Id;
            acc.AccountNumber = '100006843';
            database.insert(acc);
           
            
            List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(3,accountCreation[0]);
            upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
            upsellProposalList[0].RecordTypeID=swxRecordTypeId;
            upsellProposalList[0].Sold_To_Party__c = acc.Id;

            upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
            upsellProposalList[0].Account_ID__c = accountCreation[0].id;
            upsellProposalList[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
            upsellProposalList[1].RecordTypeID=swxRecordTypeId;
            upsellProposalList[1].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
            upsellProposalList[1].Sold_To_Party__c = acc.Id;
            upsellProposalList[1].Account_ID__c = accountCreation[1].id;
            upsellProposalList[2].Analytics_Source__c = 'CXM';//CSWXGlobalConstant.AnalyticsSource_CCRE;
            upsellProposalList[2].RecordTypeID= swxRecordTypeId;  //ccreRecordTypeId;
            upsellProposalList[2].Account_ID__c = accountCreation[1].id;
            upsellProposalList[2].Sold_To_Party__c = acc.Id;
            database.insert(upsellProposalList);
            System.assertEquals(accountCreation[0].id, upsellProposalList[0].Account_ID__c);
            System.assertEquals(accountCreation[1].id, upsellProposalList[1].Account_ID__c);
            System.assertEquals( upsellProposalList[0].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
            System.assertEquals( upsellProposalList[1].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
         
      
            List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
            optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[0].Id;
            upsellProposalToOppty.put(upsellProposalList[0].Id, optyCreation[0]);
            upsellProposalToOppty.put(upsellProposalList[1].Id, optyCreation[0]);
            upsellProposalToOppty.put(upsellProposalList[2].Id, optyCreation[0]);
            Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
            quoteProposal.RecordTypeId=swxQuoteRecordTypeId ;
            
            Apttus_Config2__PriceList__c priceList = TestDataFactory.priceList(1)[0];
            priceList.Type__c  = CSWXGlobalConstant.AnalyticsSource;
            priceList.Apttus_Config2__AccountId__c = accountCreation[0].id;
            database.insert(priceList);
            System.assertEquals(accountCreation[0].id, priceList.Apttus_Config2__AccountId__c);
        
            CSWX_OpportunityTriggerHelper job = new CSWX_OpportunityTriggerHelper(upsellProposalToOppty,accId);
            ID jobID = System.enqueueJob(job);
            Test.stopTest();
        }
}