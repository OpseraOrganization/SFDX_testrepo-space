/****************************************
* Class Name : CH_BatchToDeactiveCDBCLI
* Created Date: 13 Jan 2019
* Created By : Rajeshwari
* Description : NOKIASC-15192 - Automatic deactivation of Contract Line Items that are out of synch with CDB
* Test Class: CH_BatchToDeactiveCDBCLI_Test
Name			Modified DATE	Comments
*****************************************/
global class CH_BatchToDeactiveCDBCLI implements Database.Batchable<sObject> {
	 
	global Database.QueryLocator start(Database.BatchableContext BC) {
		// collect the batches of records or objects to be passed to execute
		String cliRecordType = 'CARE Service Contract';
		String activestatus = 'Active';
		String query = 'SELECT Id,NCP_External_Status__c,LineItemNumber, ServiceContract.recordType.Name,ServiceContract.Name, ServiceContractId , createdDate , ServiceContract.CH_LastFullResyncDate__c, CH_LastFullResynchDate__c  ';
		query = query + ' FROM ContractLineItem where NCP_External_Status__c = :activestatus and ServiceContract.recordType.Name= :cliRecordType   ';
		query = query + '  ';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<ContractLineItem> contractLineItemList) {
		system.debug(contractLineItemList.size()+' Execute '+contractLineItemList);
		// process each batch of records
		String body =  '';
		List<string> bodyList = new List<string>();
		for(ContractLineItem cli : contractLineItemList){
			
			// Update the Status as Inactive 
			if(cli.ServiceContract.CH_LastFullResyncDate__c != cli.CH_LastFullResynchDate__c	&& cli.createdDate < cli.ServiceContract.CH_LastFullResyncDate__c ){
	system.debug(' -- 1 '+cli.ServiceContract.Name);
	string bodyContent = '';
	bodyContent =  bodyContent + 'Service Contract '+cli.ServiceContract.Name +' ';
	bodyContent = bodyContent + 'Contract Line Item '+ cli.LineItemNumber+' External Status updated to Inactive - ';
	bodyContent = bodyContent + 'Service Contract Last Full Synch Date value was '+cli.ServiceContract.CH_LastFullResyncDate__c;
	bodyContent = bodyContent + ' and Contract Line Item Last Full Sycnh Date was '+ cli.CH_LastFullResynchDate__c+'.'+' \r\n';
	String bodyValue = body+bodyContent;
	if(bodyValue.length() >=10000){
		bodyList.add(body);
		body ='';
	}else{
		body =  bodyValue;	   
	}
	cli.NCP_External_Status__c = 'Inactive';
	//cli.CH_LastFullResynchDate__c = cli.ServiceContract.CH_LastFullResyncDate__c;
			}
		}
		try {
			
			if( bodyList == null || bodyList.isempty() ){
	bodyList.add(body);
			}
			//Error-CLI Last Full Synch Date mismatch
			if(!bodyList.isempty()){
	system.debug(' body --'+body);
	// Update the contractLineItemList Record
	update contractLineItemList;
	List <FeedItem> FeedItemUpsert = new List<FeedItem>();
	List<CollaborationGroup> chatterGroup = [Select id,Name from CollaborationGroup where Name='Error-CLI Last Full Synch Date mismatch' LIMIT 1];
	for(String bodyText : bodyList){
		FeedItem post=new FeedItem();
		post.createdbyID=UserInfo.getuserId();
		post.Body=bodyText;
		post.ParentID=chatterGroup[0].id;
		FeedItemUpsert.add(post);
	}
	
	
	insert FeedItemUpsert;
	
	
			}
			
		} catch(Exception e) {
			System.debug('Exception Ex'+e);
		}
		
	}   
	
	global void finish(Database.BatchableContext BC) {
		// execute any post-processing operations
	}
	
}