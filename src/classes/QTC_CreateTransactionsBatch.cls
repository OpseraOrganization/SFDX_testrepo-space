/*********************************
  * Param: list of staging records from QTC_proposalStagingBatch
  * Return: NA  
  * Description: create Txn records from Staging records
	**********************************/
global class QTC_CreateTransactionsBatch implements Database.Batchable<sObject>,Database.Stateful {
	public list<Quote_Staging__c> quoteStagingListBatch = new list<Quote_Staging__c>();
	Map<String,String> quoteNumberWithId= new Map<String,String>(); 
	Set<String> stagingIds= new Set<String>();
	public QTC_CreateTransactionsBatch(Set<String> quoteStagingList){		   
		   this.stagingIds=  quoteStagingList;		 
	   }
   global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = 'SELECT Id,CurrencyIsoCode,PARTNRTYPE__c,qualifier__c,RoundingAdjustment__c,CONTRACT__c,SALESORG__c,TRANSPORT__c,TIMEZONE__c,TASK__c,CURRENCY__c,SetMasterQuoteIndicator__c,SALESPERSN__c,GENERATION__c,HOUR__c,ITEM__c,EXPIRATION__c,EXTENDED__c,DOCUMENT__c,DOCUMENTID__c,EFFECTIVE__c,BASE__c,QUANTITY__c,Name__c,PARTNRID__c,WarrantyContractNumber__c,UOM__c,MasterQuoteIndicator__c,LUCENT_ContextualDocType__c,ITEMTYPE__c,LUCENT_ParentLineNum__c,RFQTYPE__c,QTELINENUM__c,DIVISION__c,DOCTYPE__c,ITEMDESC__c,Name,RFQID__c,QTEID__c,Quote_Number__c,DESCRIPTN__c,Type__c from Quote_Staging__c WHERE Quote_Number__c IN:stagingIds';
		system.debug('Query created=>'+query);
		return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext bc, List<Quote_Staging__c> records){
	   system.debug('list in execute==>'+records);	   
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
	  
			QTC_CreateTransactionsLineBatch obj = new QTC_CreateTransactionsLineBatch(stagingIds,quoteNumberWithId);
			Database.executebatch(obj);
   
   }	
}