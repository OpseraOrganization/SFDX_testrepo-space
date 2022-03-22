@istest
public class DS_CCREServiceInfoRelatedListTest {
	
	public testmethod static void getStatusDeatilsTest(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		
			Account acct = TestDataFactory.createAccount(1)[0];
			acct.AccountNumber='8990767834';  
			database.insert(acct);
			
			SWx_Upsell_Proposal__c DigitalProposal = TestDataFactory.upsellList(1,acct)[0];
			DigitalProposal.Account_ID__c=acct.id;
			DigitalProposal.Analytics_Source__c='CXM';
			DigitalProposal.Upsell_Status__c='Draft';
			DigitalProposal.CurrencyIsoCode='INR';
			DigitalProposal.Sold_To_Party__c=acct.id;
			insert DigitalProposal; 
			  
			Set <Id> dpSet = new set<Id>();
			dpSet.add(DigitalProposal.Id);
			
			CCRE_UpSell_LineItem__c ccreLineItem= new CCRE_UpSell_LineItem__c();
			ccreLineItem = TestDataFactory.createCCRELineItems(dpSet,1)[0];
			insert ccreLineItem;
					  
		   SWx_Upsell_Items__c swxLineItem= new SWx_Upsell_Items__c();
		   swxLineItem = TestDataFactory.createSWXLineItems(dpSet,1)[0];
		   insert swxLineItem;
		 
		   Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		   oppty.StageName = 'Develop Opportunity';//
		   oppty.Phase_Status__c = 'Opportunity in Progress';
		   oppty.Lead_BG__c = 'MN';
		   oppty.SWx_Upsell_Proposal__c=DigitalProposal.id;
		   insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		   database.insert(oppty);
		 
		   Apttus_Proposal__Proposal__c quoteProposal = TestDataFactory.createProposal(1)[0];  
		   quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		   quoteProposal.Apttus_Proposal__Approval_Stage__c='Draft';
		   quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		   quoteProposal.SWx_Upsell_Proposal__c=DigitalProposal.id;  
		   quoteProposal.RecordTypeID= Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId(); 
		   database.insert(quoteProposal); 
			Test.startTest();
		   DS_CCREServiceInfoRelatedList.getCCREServiceInfoLineItem(DigitalProposal.id);
		   DS_CCREServiceInfoRelatedList.getCCREProductInfoLineItem(DigitalProposal.id);
		   
			 Test.stopTest();
		  
		  
		}
		 
	 }

}