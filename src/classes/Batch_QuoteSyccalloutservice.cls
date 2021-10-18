global class Batch_QuoteSyccalloutservice implements Database.Batchable<sObject>,Database.Stateful,Schedulable,Database.allowscallouts 
{ 
		Public  Integer countofquery   = 0;
		Public  Integer Curcountrecords   = 0;
		public  set<String> ILogids = new set<string>();  

	 global void execute(SchedulableContext SC)
	{
		Batch_QuoteSyccalloutservice  batch= new Batch_QuoteSyccalloutservice();
		Database.executebatch(batch,25);		   
	} 
	
	  public void CheckData()
	{ 
		for(CQ_Sync_Quote_EAI__c Sync_EAI:CQ_Sync_Quote_EAI__c.getall().values())
		{
		   //if(Sync_EAI.Is_Interfacelog__c)
				//ILogids.add(Sync_EAI.Name);
		}
		
	}
	   global Database.QueryLocator start(Database.BatchableContext BC)
	{ 
		
			 if(countofquery==0)CheckData();
		
		 return Database.getQueryLocator([ Select Id,Name,Old_Value__c,New_Value__c,Interface_Log__r.Operation_type__c,Interface_Log__c from Interface_Record_Detail_Log__c where Interface_Log__c IN:ILogids 
											AND Object_Name__c=:GlobalConstants.QUOTE_PROPOSAL_OBJECT AND Interface_Log__r.Interface_Type__c=:GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE AND Status_and_Action__c=:GlobalConstants.INTERFACE_DETAILLOG_SYNC_ERROR  
											AND Interface_Log__r.Message_Type__c=:Globalconstants.OUTBOUND AND
										   Interface_Log__r.status__c=: Globalconstants.FAILURE AND 
										  ( Interface_Log__r.Operation_type__c=:Globalconstants.INSERT_VALUE OR Interface_Log__r.Operation_type__c=:Globalconstants.UPDATE_VALUE)
										  ORDER BY  Interface_Log__r.Operation_type__c ASC]);
	}
	 
	 global void execute(Database.BatchableContext BC, List<Interface_Record_Detail_Log__c> IrLogs)
	{ 
	   
				  Curcountrecords +=IrLogs.Size();
				  set<Id> newQuoteInsertIds=new set<Id>();
				  set<Id> newQuoteupdateIds=new set<Id>();
				  Map<Id, string> Old_QuoteApprovalstagemap=new Map<Id, string>();
				  Map<Id, string> Old_QuoteNamemap=new Map<Id, string>();
				  Map<Id, boolean> Old_CqActivemap=new Map<Id, Boolean>();
				  Boolean  isinsertSuccess=false;
				  Boolean  isupdateSuccess=false;
				  list<String> ILogsforDelete=new list<String>();
		
		try{
			   for(Interface_Record_Detail_Log__c IR_Log:IrLogs){
				 
					  If(Globalconstants.INSERT_VALUE.equalsignorecase(IR_Log.Interface_Log__r.Operation_type__c))
						  newQuoteInsertIds.add(IR_Log.Name);
					  
					  If(Globalconstants.UPDATE_VALUE.equalsignorecase(IR_Log.Interface_Log__r.Operation_type__c)){
						 newQuoteupdateIds.add(IR_Log.Name);
						  if(IR_Log.Old_Value__c<>null){
						  string[] OldQuoteVal=IR_Log.Old_Value__c.split(';');
								Boolean activeValue = OldQuoteVal[1].substringAfter('=').Trim() == 'Active' ? true : false;
							  Old_CqActivemap.put(IR_Log.Name,activeValue);
							  Old_QuoteApprovalstagemap.put(IR_Log.Name,OldQuoteVal[0].substringAfter('=').Trim());
							  Old_QuoteNamemap.put(IR_Log.Name,OldQuoteVal[2].substringAfter('=').Trim());
						  }
					  }
					  }
						  
		if(!newQuoteInsertIds.isempty()&&CQ_Sync_Quote_EAI__c.getInstance(Globalconstants.INSERT_VALUE).sync__c)
		 //isinsertSuccess=QuoteSyncCalloutService.Datapreparation(newQuoteInsertIds,Null,Null,Null,Null,Globalconstants.INSERT_VALUE,true);   
		 if(!newQuoteupdateIds.isempty()&&!Old_QuoteApprovalstagemap.isempty()&&CQ_Sync_Quote_EAI__c.getInstance(Globalconstants.UPDATE_VALUE).sync__c)
		 //isupdateSuccess=QuoteSyncCalloutService.Datapreparation(newQuoteupdateIds,Old_QuoteApprovalstagemap,Old_QuoteNamemap,Old_CqActivemap,Null,Globalconstants.UPDATE_VALUE,true);   
		
		if(isinsertSuccess ||isupdateSuccess)
		{
	   for(Interface_Record_Detail_Log__c IR_Log:IrLogs){
		   if(isinsertSuccess&&Globalconstants.INSERT_VALUE.equalsIgnoreCase(IR_Log.Interface_Log__r.Operation_type__c)&&!ILogsforDelete.contains(CQ_Sync_Quote_EAI__c.getInstance(IR_Log.Interface_Log__c).Id))ILogsforDelete.add(CQ_Sync_Quote_EAI__c.getInstance(IR_Log.Interface_Log__c).Id);
		   if(isupdateSuccess&&Globalconstants.UPDATE_VALUE.equalsIgnoreCase(IR_Log.Interface_Log__r.Operation_type__c)&&!ILogsforDelete.contains(CQ_Sync_Quote_EAI__c.getInstance(IR_Log.Interface_Log__c).Id))ILogsforDelete.add(CQ_Sync_Quote_EAI__c.getInstance(IR_Log.Interface_Log__c).Id);
	   }

		if(!ILogsforDelete.isempty())
			Database.delete(ILogsforDelete,false);
		}
					system.debug('IrLogs.Size()-->'+IrLogs.Size());
					system.debug('newQuoteInsertIds.Size()-->'+newQuoteInsertIds.Size());
					system.debug('newQuoteupdateIds.Size()-->'+newQuoteupdateIds.Size());


		}
		
		  catch(Exception e) {
					system.debug('An unexpected erorr occurred:-->' + e.getMessage());
		  }
	}
	 global void finish(Database.BatchableContext BC)
	{
	}
}