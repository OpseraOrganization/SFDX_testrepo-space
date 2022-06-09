@istest
public class DS_DPRelatedListTest {
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
			DigitalProposal.Sold_To_Party__c = acct.Id;
			insert DigitalProposal; 
			  
			Set <Id> dpSet = new set<Id>();
			dpSet.add(DigitalProposal.Id);
			
			DS_DPRelatedList.getDPAnalyticsSource(DigitalProposal.Id); 
	   
		
		  
			CCRE_UpSell_LineItem__c ccreLineItem= new CCRE_UpSell_LineItem__c();
			ccreLineItem = TestDataFactory.createCCRELineItems(dpSet,1)[0];
			insert ccreLineItem;
			DS_DPRelatedList.getCCRELineItem(DigitalProposal.ID);
			
		   
		   SWx_Upsell_Items__c swxLineItem= new SWx_Upsell_Items__c();
		   swxLineItem = TestDataFactory.createSWXLineItems(dpSet,1)[0];
		   insert swxLineItem;
		   DS_DPRelatedList.getCXMLineItem(DigitalProposal.ID);
			
		   Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		   oppty.StageName = 'Develop Opportunity';//
		   oppty.Phase_Status__c = 'Opportunity in Progress';
		   oppty.Lead_BG__c = 'MN';
		   oppty.SWx_Upsell_Proposal__c=DigitalProposal.id;
		   insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		   database.insert(oppty);
		   DS_DPRelatedList.getOpportunity(DigitalProposal.id);
		  
		   Apttus_Proposal__Proposal__c quoteProposal = TestDataFactory.createProposal(1)[0];  
		   quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		   quoteProposal.Apttus_Proposal__Approval_Stage__c='Draft';
		   quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		   quoteProposal.SWx_Upsell_Proposal__c=DigitalProposal.id;
		   quoteProposal.RecordTypeID= Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();   
		   database.insert(quoteProposal); 
		   DS_DPRelatedList.getQuote(DigitalProposal.id);
			 
		   delete DigitalProposal;
		   DS_DPRelatedList.getDPAnalyticsSource(DigitalProposal.id); 
	   //   DS_DPRelatedList.getCCRELineItem(oppty.Id);
		  
	   
		  
		  
		}
		 
	 }
	
  /*  public testmethod static void catchcoverageTest(){
		DS_DPRelatedList.getOpportunity(Null);
		DS_DPRelatedList.getOpportunity('aCH1g0000004CLo');
		 DS_DPRelatedList.getQuote(null);
		 DS_DPRelatedList.getCXMLineItem(null); 
		DS_DPRelatedList.getCCRELineItem(null);
		DS_DPRelatedList.getDPAnalyticsSource(Null);
		
	} */
	
}