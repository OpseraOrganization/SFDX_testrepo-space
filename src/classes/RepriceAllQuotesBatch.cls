public class RepriceAllQuotesBatch implements Database.Batchable<sObject>, Database.Stateful{
	
	String OppId;
	Map<String,List<String>> configLineItemMap;
	
	public RepriceAllQuotesBatch(String opportunityId){
		this.OppId = opportunityId;
		configLineItemMap = new Map<String,List<String>>();
	}
	
	public Database.QueryLocator start(Database.BatchableContext bc){
		String quoteStages = Label.Skip_Reprice_Stages;
		List<String> quoteStageList = new List<String>();
		if(String.isNotBlank(quoteStages)){
			quoteStageList.addAll(quoteStages.split(';'));
		}
		Integer limitQuoteRecords = Integer.valueOf(Label.Quote_Reprice_One_Time_Limit);
		//Query Quote records associated to Opportunity which have NokiaCPQ_Needs_Reprice__c as true and stage other than Approved, Expired, Rejected and Closed(not won)	 
		String query = 'Select Id, NokiaCPQ_Needs_Reprice__c, Reprice_In_Progress__c, Old_RecordType_Id__c, RecordTypeId From Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =:OppId AND NokiaCPQ_Needs_Reprice__c = true AND Reprice_In_Progress__c = false AND IsCollaborationProgress__c = false AND Quote_Type__c =\'' + Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ + '\' AND Apttus_Proposal__Approval_Stage__c NOT IN :quoteStageList LIMIT ' + limitQuoteRecords; 
		system.debug('Query***' + query);
		return Database.getQueryLocator(query);
	}
	
	public void execute(Database.BatchableContext BC, List<Apttus_Proposal__Proposal__c> quotes){
		
		Map<String,String> qouteProdConfigMap = new Map<String,String>();
		List<String> quoteIds = new List<String>();
		Set<String> tobeUpdatedQuoteIds = new Set<String>(); 
		List<Apttus_Proposal__Proposal__c> toBeUpdatedQuoteSet = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Config2__LineItem__c> tobeUpdatedList = new List<Apttus_Config2__LineItem__c>();
		
		//Update all the quote records
		for(Apttus_Proposal__Proposal__c quote : quotes){
			quoteIds.add(quote.Id);
		}
		
		//Query Product Configuration records related to quotes and store the latest ones
		for(Apttus_Config2__ProductConfiguration__c config : [Select Id, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c,Apttus_Config2__Status__c From Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c IN: quoteIds AND Apttus_Config2__BusinessObjectType__c = 'Proposal' Order by CreatedDate ASC]){
			system.debug((config.Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c==true && (config.Apttus_Config2__Status__c!='Saved' && config.Apttus_Config2__Status__c!='Finalized')));
		   if(config.Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c==true && (config.Apttus_Config2__Status__c!='Saved' && config.Apttus_Config2__Status__c!='Finalized')) continue;
			qouteProdConfigMap.put(config.Apttus_QPConfig__Proposald__c, config.Id);
		}
		system.debug('product configuration record'+qouteProdConfigMap);
		//Query Line Items in the product configurations and make Pricing Status as Pending for all
		for(Apttus_Config2__LineItem__c lineItem : [Select Id, Apttus_Config2__ChargeType__c,Apttus_Config2__PricingStatus__c,NokiaCPQ_Is_Maintenance_Quote__c, Apttus_Config2__IsHidden__c,Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c From Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN: qouteProdConfigMap.values()]){
			//map to be used in finish method
			if(configLineItemMap.containsKey(lineItem.Apttus_Config2__ConfigurationId__c)){
				configLineItemMap.get(lineItem.Apttus_Config2__ConfigurationId__c).add(lineItem.Id);
			}
			else{
				configLineItemMap.put(lineItem.Apttus_Config2__ConfigurationId__c, new List<String>{lineItem.Id});
			}
			//Heema : Requirement 6383
			lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
			if(lineItem.NokiaCPQ_Is_Maintenance_Quote__c ==true && 'Standard Price'.equalsIgnoreCase(lineItem.Apttus_Config2__ChargeType__c)){
				lineItem.Apttus_Config2__IsHidden__c = false;
			}
			
			tobeUpdatedList.add(lineItem);
			//store only relevant quote records. This makes sure if don't update quotes without Product configuration / line items
			tobeUpdatedQuoteIds.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
		}
		
		//Update quote and line item records
		try{
			for(Apttus_Proposal__Proposal__c quote : quotes){
				if(tobeUpdatedQuoteIds.contains(quote.Id)){
					//quote.NokiaCPQ_Needs_Reprice__c = false; //so that batch does not run multiple times from same oppty unnecessarily.
					quote.Reprice_In_Progress__c = true; // to show on UI if reprice is in progress
					quote.Old_RecordType_Id__c = quote.RecordTypeId; 
					quote.recordTypeId = Label.Approved_Quote_Record_Type; //to make page layout read only.
					toBeUpdatedQuoteSet.add(quote);
				}
			}
			if(!toBeUpdatedQuoteSet.isEmpty()){
				update toBeUpdatedQuoteSet;
			}
			if(!tobeUpdatedList.isEmpty()){
				update tobeUpdatedList;
			}
		}
		catch(Exception e){
			system.debug('Error while updating quote/line items**' +e.getMessage());
			ExceptionHandler.addException(e,RepriceAllQuotesBatch.class.getName(),'Reprice Batch Error');
			for(Apttus_Proposal__Proposal__c quote : toBeUpdatedQuoteSet){
				//quote.NokiaCPQ_Needs_Reprice__c = true; //so that batch does not run multiple times from same oppty unnecessarily.
				quote.Reprice_In_Progress__c = false; // to show on UI if reprice is in progress
				quote.recordTypeId = quote.Old_RecordType_Id__c; //to make page layout read only.
			}
			update toBeUpdatedQuoteSet;
		}
	}
	
	public void finish(Database.BatchableContext BC){	
		System.debug('finished***' + configLineItemMap.keySet());
		List<String> lineItemIdSet = new List<String>();
		List<String> temList;
		Integer increment = 1;
		List<Apttus_Config2__ConfigSystemProperties__c> configSettings = Apttus_Config2__ConfigSystemProperties__c.getAll().values();
		if(configSettings != null && configSettings.size() > 0 && configSettings[0].Apttus_Config2__PricingBatchSize__c != null){
			increment = Integer.valueOf(configSettings[0].Apttus_Config2__PricingBatchSize__c);
		}
		system.debug('**Increment size **' + increment);
		//Dividing total line items by 6 in number so that reprice API is not called extra times. It reprices 6 lines in one go.
		for(String configId : configLineItemMap.keySet()){
			temList = new List<String>();
			temList = configLineItemMap.get(configId);
			if(temList.size() > 1){
				lineItemIdSet.add(temList[1]);
			}
			for(Integer i=0;i<temList.size();i=i+increment){
				lineItemIdSet.add(temList[i]);
			}
		}
		if(!lineItemIdSet.isEmpty()){
			//Calling Batch which reprices the line items and performs further processing like sending chatter, etc.
			Id batchId = Database.executeBatch(new ProcessLineItemBatch(lineItemIdSet),1);
		}
	}
}