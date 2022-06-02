/*********************************
  * Param: list of staging records from QTC_CreateTransactionsBatch
  * Return: NA  
  * Description: create Txn line items records from Staging records
	**********************************/
global class QTC_CreateTransactionsLineBatch implements Database.Batchable<sObject>,Database.Stateful {
	public Set<String> newStagingIds= new Set<String>();
	public Map<String,String> quoteNumberWithIdBatch= new Map<String,String>(); 
	public QTC_CreateTransactionsLineBatch(Set<String> stagingIds,Map<String,String> quoteNumberWithId){
		system.debug('stagindIds==>'+stagingIds);
		this.quoteNumberWithIdBatch=quoteNumberWithId;
		this.newStagingIds=stagingIds;				   
	}
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = 'SELECT id,CurrencyIsoCode,PARTNRTYPE__c,qualifier__c,RoundingAdjustment__c,CONTRACT__c,SALESORG__c,TRANSPORT__c,TIMEZONE__c,TASK__c,CURRENCY__c,SetMasterQuoteIndicator__c,SALESPERSN__c,GENERATION__c,HOUR__c,ITEM__c,EXPIRATION__c,EXTENDED__c,DOCUMENT__c,DOCUMENTID__c,EFFECTIVE__c,BASE__c,QUANTITY__c,Name__c,PARTNRID__c,WarrantyContractNumber__c,UOM__c,MasterQuoteIndicator__c,LUCENT_ContextualDocType__c,ITEMTYPE__c,LUCENT_ParentLineNum__c,RFQTYPE__c,QTELINENUM__c,DIVISION__c,DOCTYPE__c,ITEMDESC__c,Name,RFQID__c,QTEID__c,Quote_Number__c,DESCRIPTN__c,Type__c from Quote_Staging__c WHERE Quote_Number__c IN:newStagingIds';
		system.debug('Query created=>'+query);
		return Database.getQueryLocator(query);
   }
global void execute(Database.BatchableContext bc, List<Quote_Staging__c> records){
	system.debug('list in execute==>'+records);	   
	 List<QTC_Transaction__c> headers= new List<QTC_Transaction__c>();
	 List<Quote_Staging__c> lineItems= new List<Quote_Staging__c>();	
	 List<QTC_Transaction__c> listToInsertLines = new List<QTC_Transaction__c>();
	 for(Quote_Staging__c qtstg:records){			
		 if(qtstg.Type__c=='LINE ITEM'){
			lineItems.add(qtstg);
		 }
	}	
	// create Header Transactions
	for(Quote_Staging__c qtstg:lineItems){
		QTC_Transaction__c obj = new QTC_Transaction__c();
			obj.Type__c=qtstg.Type__c;
			obj.CurrencyIsoCode=qtstg.CurrencyIsoCode;
			obj.EXTENDED__c=qtstg.EXTENDED__c;
			obj.UOM__c=qtstg.UOM__c;
			obj.ITEM__c=qtstg.ITEM__c;
			obj.QTELINENUM__c=qtstg.QTELINENUM__c;
			obj.DOCUMENTID__c=qtstg.DOCUMENTID__c;
			obj.DESCRIPTN__c=qtstg.DESCRIPTN__c;
			obj.QTEID__c=qtstg.QTEID__c;
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
			obj.QTC_TransactionHeader__c=quoteNumberWithIdBatch.get(qtstg.Quote_Number__c);		 
			listToInsertLines.add(obj);	
		}
		if(!listToInsertLines.isEmpty()){
			Database.insert(listToInsertLines,false);
		}	 
	
}
global void finish(Database.BatchableContext bc){
	
	} 
}