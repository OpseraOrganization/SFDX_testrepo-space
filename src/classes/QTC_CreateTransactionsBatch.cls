/*********************************
  * Param: list of staging records from QTC_proposalStagingBatch
  * Return: NA  
  * Description: create Txn records from Staging records
	**********************************/
global with sharing class QTC_CreateTransactionsBatch implements Database.Batchable<sObject>,Database.Stateful {
	public list<Quote_Staging__c> quoteStagingListBatch = new list<Quote_Staging__c>();
	public Map<String,String> quoteNumberWithId= new Map<String,String>(); 
	Set<String> stagingIds= new Set<String>();
	Map<String,Apttus_Proposal__Proposal__c> quoteNumberWithRec = new Map<String,Apttus_Proposal__Proposal__c>();
	
	public QTC_CreateTransactionsBatch(Set<String> quoteStagingList){		   
		   this.stagingIds=  quoteStagingList;
		   
		   //List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		   for(Apttus_Proposal__Proposal__c quote :[select Id,CPQ_Application_Code__c,CQ_Master_Quote__c,NokiaCPQ_Proposal_Id__c,CPQ_CLLI_Code__c,CPQ_Site_Number__c,CQ_Customer_Project_Site_City__c,CQ_Customer_Project_Site_State__c,
		   CPQ_Reseller_Name__c,CPQ_Transaction_Type__c,CPQ_Customer_Type__c,CPQ_Purchase_Order_Number__c,CPQ_Total_Transportation__c,
		   CPQ_Quote_Sub_Type__c,Owner.Email,RecordTypeId from Apttus_Proposal__Proposal__c where NokiaCPQ_Proposal_Id__c IN: stagingIds]){ // AND RecordTypeId =: New_CQ_RecId];
				quoteNumberWithRec.put(quote.NokiaCPQ_Proposal_Id__c, quote);
		   }
		   /*if(!quoteList.isEmpty()){
		   for(Apttus_Proposal__Proposal__c pr:quoteList){
			quoteNumberWithRec.put(pr.NokiaCPQ_Proposal_Id__c,pr);   
		   }   
		   }*/
		   
	   }
   global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = 'SELECT Id,CurrencyIsoCode,PARTNRTYPE__c,qualifier__c,RoundingAdjustment__c,CONTRACT__c,SALESORG__c,TRANSPORT__c,TIMEZONE__c,TASK__c,CURRENCY__c,SetMasterQuoteIndicator__c,SALESPERSN__c,GENERATION__c,HOUR__c,ITEM__c,EXPIRATION__c,EXTENDED__c,DOCUMENT__c,DOCUMENTID__c,EFFECTIVE__c,BASE__c,QUANTITY__c,Name__c,PARTNRID__c,WarrantyContractNumber__c,UOM__c,MasterQuoteIndicator__c,LUCENT_ContextualDocType__c,ITEMTYPE__c,LUCENT_ParentLineNum__c,RFQTYPE__c,QTELINENUM__c,DIVISION__c,DOCTYPE__c,ITEMDESC__c,Name,RFQID__c,QTEID__c,Quote_Number__c,DESCRIPTN__c,Type__c from Quote_Staging__c WHERE Quote_Number__c IN:stagingIds';
		system.debug('Query created=>'+query);
		return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext bc, List<Quote_Staging__c> records){
	   system.debug('list in execute==>'+records);
	   Id New_CQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
		List<Quote_Staging__c> headers= new List<Quote_Staging__c>();		
		List<QTC_Transaction__c> listToInsert = new List<QTC_Transaction__c>();		
		for(Quote_Staging__c qtstg:records){			
			if(qtstg.Type__c=='HEADER'){
				headers.add(qtstg);
			}
	   }
	   // create Header Transactions
	   for(Quote_Staging__c qtstg:headers){
		QTC_Transaction__c obj = new QTC_Transaction__c();
		obj.Type__c=qtstg.Type__c;
		obj.CurrencyIsoCode=qtstg.CurrencyIsoCode;
		obj.WarrantyContractNumber__c=qtstg.WarrantyContractNumber__c;
		obj.RFQTYPE__c=qtstg.RFQTYPE__c;
		obj.DOCUMENTID__c=qtstg.DOCUMENTID__c;
		obj.SALESORG__c=qtstg.SALESORG__c;
		obj.TASK__c=qtstg.TASK__c;
		obj.DESCRIPTN__c=qtstg.DESCRIPTN__c;
		obj.QTEID__c=qtstg.QTEID__c;
		obj.DIVISION__c=qtstg.DIVISION__c;
		obj.RFQID__c=qtstg.RFQID__c;
		obj.Quote_Number__c=qtstg.Quote_Number__c;
		obj.ITEMDESC__c=qtstg.ITEMDESC__c;
		obj.LUCENT_ParentLineNum__c=qtstg.LUCENT_ParentLineNum__c;
		obj.QUANTITY__c=qtstg.QUANTITY__c;
		obj.BASE__c=qtstg.BASE__c;
		
		obj.EFFECTIVE__c=qtstg.EFFECTIVE__c;
		obj.DOCUMENT__c=qtstg.DOCUMENT__c;
		obj.EXPIRATION__c=qtstg.EXPIRATION__c;
		obj.GENERATION__c=qtstg.GENERATION__c;
		obj.CONTRACT__c=qtstg.CONTRACT__c;
		obj.RoundingAdjustment__c=qtstg.RoundingAdjustment__c;
		obj.PARTNRTYPE__c=qtstg.PARTNRTYPE__c;
		obj.PARTNRID__c = qtstg.PARTNRID__c;
		obj.Name__c = qtstg.Name__c;

		 //For Quote based parameters		
		if(!quoteNumberWithRec.isEmpty() && quoteNumberWithRec.containsKey(qtstg.Quote_Number__c)){
		Apttus_Proposal__Proposal__c quoteRec = new Apttus_Proposal__Proposal__c();
		quoteRec = quoteNumberWithRec.get(qtstg.Quote_Number__c);
		
		obj.QTC_QuoteProposal__c = quoteRec.Id;
		obj.QTC_Notification_email__c = quoteRec.Owner.Email;
		obj.MasterQuoteIndicator__c = String.valueof(quoteRec.CQ_Master_Quote__c);
			
			//For CQ quote
			if(quoteRec.RecordTypeId == New_CQ_RecId){				
				if(quoteRec.CPQ_CLLI_Code__c != null){
				obj.Telco_CLLI__c = quoteRec.CPQ_CLLI_Code__c;
				}
				if(quoteRec.CPQ_Site_Number__c != null){
				obj.SiteName__c = quoteRec.CPQ_Site_Number__c;
				}
				if(quoteRec.CQ_Customer_Project_Site_City__c != null && quoteRec.CQ_Customer_Project_Site_State__c != null){
				obj.SiteLocation__c = quoteRec.CQ_Customer_Project_Site_City__c+' '+quoteRec.CQ_Customer_Project_Site_State__c;
				}
				if(quoteRec.CPQ_Reseller_Name__c != null){
				obj.Reseller_Name__c = quoteRec.CPQ_Reseller_Name__c;
				}
				if(quoteRec.CPQ_Transaction_Type__c != null){
				obj.Transaction_Type__c = quoteRec.CPQ_Transaction_Type__c;
				}
				if(quoteRec.CPQ_Customer_Type__c != null){
				obj.Customer_Type__c = quoteRec.CPQ_Customer_Type__c;
				}
				if(quoteRec.CPQ_Purchase_Order_Number__c != null){
				obj.Purchase_Order_Number__c = quoteRec.CPQ_Purchase_Order_Number__c;
				}
				if(quoteRec.CPQ_Total_Transportation__c != null){
				obj.Total_Transportation__c = quoteRec.CPQ_Total_Transportation__c;
				}
				if(quoteRec.CPQ_Quote_Sub_Type__c != null){
				obj.Quote_Sub_Type__c = quoteRec.CPQ_Quote_Sub_Type__c;
				}
			}
		}
		listToInsert.add(obj);	
   }
   if(!listToInsert.isEmpty()){
	  Database.insert(listToInsert,false);
   }
   
   for(QTC_Transaction__c txnH:listToInsert){
	  quoteNumberWithId.put(txnH.Quote_Number__c,txnH.id);
}
   }	
   global void finish(Database.BatchableContext bc){
	   //create transaction Batch
	  // If(!Test.isRunningTest()){
			QTC_CreateTransactionsLineBatch obj = new QTC_CreateTransactionsLineBatch(stagingIds,quoteNumberWithId);
			Database.executebatch(obj);
	  // }
   }	
}