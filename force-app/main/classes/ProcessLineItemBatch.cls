/****************************************
* Class Name : ProcessLineItemBatch
* Created Date: 3 Febuary 2018
* Created By : Accenture
* Description : Process records in Batch for LineItem Object in case of Quote reprice from Opportunity

*****************************************/
global class ProcessLineItemBatch  implements Database.Batchable<sObject>{
	
	List<String> lineItemIdList;
	/*********************************
	* author: Accenture
	* Date: 3 Febuary 2018
	* Return: 
	* Description:Line Item list
	* High Level Process : Constructor
	**********************************/ 
	public ProcessLineItemBatch(List<String> lineItemIds){
		this.lineItemIdList = lineItemIds;
	}
	/*********************************
	* author: Accenture
	* Date: 3 Febuary 2018
	* Return: Database.QueryLocator
	* Description:Batch Start Method
	* High Level Process : queries valid records 
	**********************************/	
	public Database.QueryLocator start(Database.BatchableContext bc){	 
		String query = 'Select Id, Apttus_Config2__ConfigurationId__c From Apttus_Config2__LineItem__c where Id IN: lineItemIdList'; 
		system.debug('Query***' + query);
		return Database.getQueryLocator(query);
	}
	
	/*********************************
	* author: Accenture
	* Date: 3 Febuary 2018
	* Return: 
	* Description:Batch Execute Method
	* High Level Process :  call apttus API for repricing and finalizing   
	**********************************/	 
	public void execute(Database.BatchableContext BC, List<Apttus_Config2__LineItem__c> lineItemList){
		Boolean hasPendingItems = false;
		try{
			Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
			objUpdatePriceRequestDO.CartId = lineItemList[0].Apttus_Config2__ConfigurationId__c;
			Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
			system.debug('result of reprice api**' + result);
			hasPendingItems = result.IsPricePending;
			if(!hasPendingItems){
				Apttus_CpqApi.CPQ.FinalizeCartRequestDO requestFinalizeCart = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();				  
				requestFinalizeCart.CartId = lineItemList[0].Apttus_Config2__ConfigurationId__c;		
				Apttus_CpqApi.CPQ.FinalizeCartResponseDO responseFinalizeCart = Apttus_CpqApi.CPQWebService.finalizeCart(requestFinalizeCart);
				system.debug('result of reprice api**' + responseFinalizeCart);
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,ProcessLineItemBatch.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
	}
	/*********************************
	* author: Accenture
	* Date: 3 Febuary 2018
	* Description:Batch Finish Method
	* High Level Process : send chatter and emails  
	**********************************/	 
	public void finish(Database.BatchableContext BC){ 
		
		System.debug('finished reprice***' );
		Set<String> quoteIdSet = new Set<String>();
		Set<String> quoteWithPendingLI = new Set<String>();
		List<Apttus_Proposal__Proposal__c> quotesToBeUpdated = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Config2__LineItem__c> lineItemtobeUpdated = new List<Apttus_Config2__LineItem__c>();
		
		for(Apttus_Config2__LineItem__c lineItem : [Select id, Apttus_Config2__PricingStatus__c,Apttus_Config2__ChargeType__c,NokiaCPQ_Is_Maintenance_Quote__c,Apttus_Config2__IsHidden__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c From Apttus_Config2__LineItem__c Where id IN:lineItemIdList]){
			system.debug('line item to be ishidden flase'+lineItem);
			quoteIdSet.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
			if(!string.isBlank(lineItem.Apttus_Config2__PricingStatus__c) && lineItem.Apttus_Config2__PricingStatus__c.equals(Nokia_CPQ_Constants.PENDING_STRING) ){
				quoteWithPendingLI.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
			}
			//Heema : 6383 Requirement
			if(lineItem.NokiaCPQ_Is_Maintenance_Quote__c ==true && 'Standard Price'.equalsIgnoreCase(lineItem.Apttus_Config2__ChargeType__c) && lineItem.Apttus_Config2__IsHidden__c == false){
				system.debug('creating list');
				lineItem.Apttus_Config2__IsHidden__c = true;
				lineItemtobeUpdated.add(lineItem);
			}
			
		}
		
		//update quote records
		for(Apttus_Proposal__Proposal__c prop: [Select Id, NokiaCPQ_Needs_Reprice__c, NokiaCPQ_Last_Reprice__c, Reprice_In_Progress__c, Old_RecordType_Id__c, recordtypeId,Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.Name From Apttus_Proposal__Proposal__c Where id IN: quoteIdSet]){
			if(!quoteWithPendingLI.isEmpty() && quoteWithPendingLI.contains(prop.Id)){
				prop.Reprice_In_Progress__c = false;
				system.debug('***Old_RecordType_Id__c' + prop.Old_RecordType_Id__c);
				prop.recordTypeId = prop.Old_RecordType_Id__c;
				prop.Old_RecordType_Id__c = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			}
			else{
				prop.NokiaCPQ_Needs_Reprice__c = false;
				prop.Reprice_In_Progress__c = false;
				prop.NokiaCPQ_Last_Reprice__c = system.now();
				system.debug('***Old_RecordType_Id__c' + prop.Old_RecordType_Id__c);
				prop.recordTypeId = prop.Old_RecordType_Id__c;
				prop.Old_RecordType_Id__c = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			}
			quotesToBeUpdated.add(prop);
		}
		try{
			if(!quotesToBeUpdated.isEmpty()){
				Database.update(quotesToBeUpdated, false);
			}
			//Heema : 6383 Requirement
			system.debug('updated line item'+lineItemtobeUpdated);
			 if(!lineItemtobeUpdated.isEmpty()){
				Database.update(lineItemtobeUpdated, false);
			}
		
			AsyncApexJob a = [Select Status, ExtendedStatus, NumberOfErrors, CreatedById, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
		
			//Send email to user regarding reprice completion
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {a.CreatedBy.Email};
			mail.setToAddresses(toAddresses);
			mail.setSubject(Nokia_CPQ_Constants.Finish);
			mail.setPlainTextBody(Nokia_CPQ_Constants.Repricing + quotesToBeUpdated[0].Apttus_Proposal__Opportunity__r.Name + Nokia_CPQ_Constants.Refer + Label.Quote_Reprice_Report);
		
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
			
			//Send chatter to Opportunity and User
			List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

			ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
			messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			// add the text segment
			ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
			textSegment.text = Nokia_CPQ_Constants.Repricing + quotesToBeUpdated[0].Apttus_Proposal__Opportunity__r.Name + Nokia_CPQ_Constants.Refer + Label.Quote_Reprice_Report;
			messageInput.messageSegments.add(textSegment);
		
			//For User record
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			feedItemInput.body = messageInput;
			feedItemInput.subjectId = a.CreatedById;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			//ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
			batchInputs.add(new ConnectApi.BatchInput(feedItemInput));
		
			//For Opportunity
			ConnectApi.FeedItemInput feedItemInputOpp = new ConnectApi.FeedItemInput();
			feedItemInputOpp.body = messageInput;
			feedItemInputOpp.subjectId = quotesToBeUpdated[0].Apttus_Proposal__Opportunity__c;
			feedItemInputOpp.feedElementType = ConnectApi.FeedElementType.FeedItem;
			//ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInputOpp);
			batchInputs.add(new ConnectApi.BatchInput(feedItemInputOpp));
		
			// post it
			List<Network> communityList = new List<Network>();
			communityList = [Select Id From Network where Name =: Nokia_CPQ_Constants.Nokia_Partner Limit 1];
			if(!communityList.isEmpty()){
				ConnectApi.ChatterFeeds.postFeedElementBatch(communityList[0].Id, batchInputs);
				//ConnectApi.ChatterFeeds.postFeedElement(communityList[0].Id, feedItemInput); 
			}
		}
		catch(Exception e){
			 ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			
		}
	}
	
}