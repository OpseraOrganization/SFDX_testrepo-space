public without sharing class CH_CA_Workgroup_Instructions_Controller {
	
   // Get the workgroup instructions
	@AuraEnabled
	public static CH_WorkgroupInstructions__c getWorkgroupInstructions(Id caseId,Id workgroupId, String byPassCaseTeam){
		system.debug('CH_CA: Entered');
		CH_CA_Service service = new CH_CA_Service(caseId); 
		CH_CA_DTO.SearchCriteriaDTO caseFields = service.getCaseDetails();
		CH_WorkgroupInstructions__c workgroupInstructions = service.getWorkgroupInstructions(caseFields,workgroupId,caseId,byPassCaseTeam);
		System.debug('CH_CA: LIM CH_CA_OwnerAssignment_Controller.getWorkgroupInstructions SOQL limit: ' + Limits.getQueries());
		return workgroupInstructions;
	}
	@AuraEnabled
	public static void requestAssistanceToWG(Id caseId, String wgName){
		try{
		CAse currentCase = [Select id, CaseNumber, Severity__c, ProductId from Case where id =: caseId];
		String body = 'The Case ' + currentCase.CaseNumber + ', product ' + currentCase.ProductId + ' and severity ' + currentCase.Severity__c + ' is requiring your attention for assistance.';
		CH_Workgroup__c workgroup = [Select id from CH_Workgroup__c where Name =: wgName LIMIT 1];
		
		ConnectApi.FeedItemInput feedItemCase = new ConnectApi.FeedItemInput();
		ConnectApi.FeedItemInput feedItemWorkgroup = new ConnectApi.FeedItemInput();	
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();   
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		
		ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
		textSegmentInput1.text = 'The Case ';   
		messageBodyInput.messageSegments.add(textSegmentInput1);
		ConnectApi.EntityLinkSegmentInput entityLinkSegmentInputContact = new ConnectApi.EntityLinkSegmentInput();
		entityLinkSegmentInputContact.entityId = currentCase.Id;   
		messageBodyInput.messageSegments.add(entityLinkSegmentInputContact);
		ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
		textSegmentInput2.text = ', Product ';	 
		messageBodyInput.messageSegments.add(textSegmentInput2);
		ConnectApi.EntityLinkSegmentInput entityLinkSegmentInputOpportunity = new ConnectApi.EntityLinkSegmentInput();
		entityLinkSegmentInputOpportunity.entityId = currentCase.ProductId;  
		messageBodyInput.messageSegments.add(entityLinkSegmentInputOpportunity); 
		ConnectApi.TextSegmentInput textSegmentInput3 = new ConnectApi.TextSegmentInput();
		textSegmentInput3.text = ' and severity ' + currentCase.Severity__c + ' is requiring your attention for assistance.';
		messageBodyInput.messageSegments.add(textSegmentInput3);
		
		feedItemCase.body = messageBodyInput;
		feedItemcase.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemCase.subjectId = currentCase.Id;
		ConnectApi.FeedElement feedElementCase = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemCase);
		
		feedItemWorkgroup.body = messageBodyInput;
		feedItemWorkgroup.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemWorkgroup.subjectId = workgroup.Id;
		ConnectApi.FeedElement feedElementWorkgroup = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemWorkgroup);
	}
		catch(Exception e){
			System.debug('CH_CA :Exception requestAssistanceToWG' + e);
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static boolean accessCheckWGInstructions( string wgInstructionsID){
		
		try{
			boolean flag=false;
			if(String.isBlank(wgInstructionsID)){
	Schema.DescribeSObjectResult describeSObject = CH_WorkgroupInstructions__c.sObjectType.getDescribe();
	flag = describeSObject.isCreateable(); 
	System.debug('CH_CA :describeSObject accessCheckWGInstructions' + describeSObject);
			}
			else{			
	UserRecordAccess userAccess=[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId()  AND RecordId =:wgInstructionsID  LIMIT 1];
	flag=userAccess.HasEditAccess;
	System.debug('CH_CA :userAccess accessCheckWGInstructions' + userAccess);
			}
			return flag;
		}catch(Exception e){
			System.debug('CH_CA :Exception accessCheckWGInstructions' + e);
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	 @AuraEnabled
	public static Case getWorkgroupDetails(Id caseId){
		System.debug('CH_CA: caseId ' + caseId);
		Case getWrkgpDetails=[SELECT Id,CH_Workgroup__c ,CH_Workgroup__r.Name FROM CASE WHERE Id =:caseId LIMIT 1];
		if(getWrkgpDetails.CH_Workgroup__r.Name == null ){
			getWrkgpDetails.CH_Workgroup__r.Name = '';
		}
		System.debug('CH_CA: getWrkgpDetails ' + getWrkgpDetails);
		return getWrkgpDetails;
	}
	
	 // Get the workgroupinstructions for the Record Id
	@AuraEnabled
	public static CH_WorkgroupInstructions__c getWorkgroupInstructionRecord(string recordId){
		 CH_WorkgroupInstructions__c getWrkgpInsRecord=[SELECT Id,CH_Workgroup__r.Id,CH_WorkgroupInstructions__c,CH_Severity__c,CH_Active__c,CH_AssignmentType__c FROM CH_WorkgroupInstructions__c WHERE Id =:recordId LIMIT 1];
		 return getWrkgpInsRecord;
	}
}