/****************
 * Last Modified By Rajeshwari - Added New Method : NOKIASC-18141 Aug 20 2019
 * Last Modified By Rajeshwari - Added New Method : 		NOKIASC-23159 Sept 2019
 * Last Modified By Suman-Added New Method : NOKIASC-26534 Feb 2020
 * Last Modified By Vinod -Added New Methods : NOKIASC-34727 Mar 2021
 ****************/
public without sharing class CH_CaseField_SideHighlightApex {
	
	public static final String errorMsg='You are not authorized to change this case';
	public static final String errorMsg2 ='Contact System Administrator, Do not have enough permission to edit';
	
	@AuraEnabled
	public static void setAssignment(string fieldId){
		case findCase = new case();
		findCase = [select Id, CH_Reassignment__c from case where Id=:fieldId];
		if(findCase.Id == fieldId && findCase!=NULL)
		{
			findCase.CH_Reassignment__c=true;
		}
		update findCase;
	}
	
	@AuraEnabled
	public static void displayWorkgroupInstructions(string fieldId){
		case findCase = new case(id = fieldId, CH_Display_Workgroup_Instructions__c = true);
		update findCase;
	}
	
	@AuraEnabled
	public static boolean checkTCAReady(string fieldId) {
		case findCase = new case();
		findCase = [select Id, CH_TCAReady__c from case where Id=:fieldId];
		return findCase.CH_TCAReady__c;
	}

	@AuraEnabled
	public static Boolean getCaseStatus(Id caseId){
		Case findCase = new Case();
		findCase = [SELECT Id FROM Case WHERE Id = :caseId AND Status = 'Solution Provided'];
		if(findCase != NULL){			
			return true;
		} else {
			return false;
		}
	}
	
	@AuraEnabled
	public static boolean accessCheck(Id caseId){
		// Changes added as a part of NOKIASC-31961
		Boolean flag=CH_Utils.accessCheck(caseId, true);
		return flag;
	}

   @AuraEnabled
	public static String transferRndAccessCheck(Id caseId) {
		String interfaceType = '';
		List<Case> problems = [SELECT Id, CH_RDInterface__c FROM Case WHERE Id =: caseId AND CH_RDInterface__c IN ('JIRA', 'PRONTO')];
		
		if (!problems.isEmpty()) {
			List<CH_Problem_RnD_Reference__c> rndInteractions = [SELECT Id FROM CH_Problem_RnD_Reference__c 
		WHERE CH_Related_Record__c =: caseId AND CH_RnD_Type__c = 'Transfer to R&D'];
			if (rndInteractions.isEmpty()) {
	interfaceType = problems[0].CH_RDInterface__c;
			}
		}
	
		return interfaceType;
	}
	
	@AuraEnabled
	public static Boolean transferRndRequiredFieldsCheck(Id caseId) {
		Case problem = [SELECT Id, CH_RDInterface__c, Description, CH_Originating_Incident_Number__c, Subject, CH_CustomerDescription__c, CH_ProblemStatement__c, Severity__c, 
	CH_AssessedOutage__c, CH_ReportedDate__c, ProductId, CH_Product_Release__c, CH_Problem_Type__c, CH_Pronto_Group__c, CH_Discovered_in__c, 
	CH_Repeatability__c, Account.AccountNumber, Account.NCP_P20_ID__c, CH_ProductVariant__c, CH_OwnerName__c
			FROM Case WHERE Id =: caseId];
		return transferRndRequiredFieldsCheck(problem);
	}

	@TestVisible
	private static Boolean transferRndRequiredFieldsCheck(Case problem) {
		
		Boolean hasRequiredFields = true;
		return hasRequiredFields;
	}
	/****
	 * Added New Method : NOKIASC-18141
	 * Modified By Rajeshwari
	 * CLose the case on click of Close Problem
	 ***********/
	@AuraEnabled
	public static void closeProblemRecord(string recordId, string closureReason){
	  String errorMsg; 
		try{
			case closeCase = new case();
			closeCase.Id = recordId;
			closeCase.CH_Closure_Reason__c=closureReason;
			closeCase.Status ='Closed';
			update closeCase;
			
		}
		catch(DmlException e){
			for (Integer i = 0; i < e.getNumDml(); i++) {	  
	errorMsg =+ e.getDmlMessage(i) +  '\n' ;
			}	 
			throw new AuraHandledException(errorMsg);
		}
		catch(Exception e){
			
			throw new AuraHandledException(e.getMessage());
		}
		
	}
	/****
	 * Added New Method : NOKIASC-23159
	 * Modified By Rajeshwari
	 
	 ***********/
	@AuraEnabled
	public static Case transferRndFlowFieldsQuery(Id caseId) {
		Case problem = [SELECT Id, CH_RDInterface__c, CH_Originating_Incident_Number__c, Subject, CH_CustomerDescription__c, CH_ProblemStatement__c, Severity__c, 
	CH_AssessedOutage__c, CH_ReportedDate__c, ProductId, CH_Product_Release__c, CH_Problem_Type__c, CH_Pronto_Group__c, CH_Discovered_in__c, 
	CH_Repeatability__c, Account.AccountNumber, Account.NCP_P20_ID__c, 
			CH_ProductVariant__c, CH_OwnerName__c,CH_Workgroup__r.Name,Owner.Name,
			OwnerId, CH_Workgroup__c,CaseNumber ,CH_Case_Number__c, Steps_to_Reproduce_Issue__c, 
			CH_SummaryofAnalysis__c, CH_ValidationofRootCause__c, CH_Product_Release_Name__c , CH_Product_Name__c,
			CH_Reported_By__c, CH_Discovered_During__c,CH_CurrentQueue__c,CH_IssueDescription__c
			FROM Case WHERE Id =: caseId];
		
		 if (!String.isEmpty(problem.CH_CustomerDescription__c)) {
			problem.CH_CustomerDescription__c = problem.CH_CustomerDescription__c.stripHtmlTags();
		}
		
		//NOKIASC-26230
		if (!String.isEmpty(problem.CH_IssueDescription__c)) {
			problem.CH_IssueDescription__c = problem.CH_IssueDescription__c.stripHtmlTags();
		}
		return problem;
	}
	/****
	 * Added New Method : NOKIASC-21816
	 * Modified By Ajesh 
	 * Return the title of Article corresponding Case
	 ***********/
	@AuraEnabled
	public static String getArticaleKnownError(Id caseId) {
		Id devRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('CH_KnownError').getRecordTypeId();
		Knowledge__kav[] knownError = [Select Id,Title from Knowledge__kav where CH_CaseId__r.Id =: caseId and RecordTypeId=:devRecordTypeId];
		if(knownError .size()>0 ){
			return knownError[0].Title;
		}
		else{
			return null;
		}
	}
	@AuraEnabled
	  public static boolean disablebuttoncheckcreateArticle(Id caseId) {   
		Id devRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('CH_KnownError').getRecordTypeId();
		List<Knowledge__kav> knownError = [Select Id,Title from Knowledge__kav where CH_CaseId__r.Id =: caseId and RecordTypeId=:devRecordTypeId and PublishStatus='Online'];   
		if(knownError.size()!=0){   
			return true;   
		}   
		else{
			knownError = [Select Id,Title from Knowledge__kav where CH_CaseId__r.Id =: caseId and RecordTypeId=:devRecordTypeId and PublishStatus='Draft'];   
			if(knownError.size()!=0){   
	return true;   
			}
			else{
	return false;   
			}	  
		}
	}
	/****
	 * Added New Method : NOKIASC-23163
	 * Modified By Rajeshwari
	 
	 ***********/
	@InvocableMethod(label='InvokeOutboundRnDApex')
	public static Void invokeFromFlowsendCreateAnalysisRndInteraction(List<String> flowInput) {
		//This is empty block of code
		
	}
	/****
	 * Added New Method : NOKIASC-23163
	 * Modified By Rajeshwari
	 
	 ***********/
	@AuraEnabled
	public static Void sendCreateAnalysisRndInteraction(String rndId) {
		List<CH_Problem_RnD_Reference__c> rndInteractions = [SELECT Id FROM CH_Problem_RnD_Reference__c 
		WHERE Id =: rndId AND CH_RnD_Type__c = 'Transfer to R&D'];
		if(!rndInteractions.isempty() && rndInteractions!=null && rndInteractions[0].id !=null){
			CH_ExternalInterfaceUTIL.sendOutboundCreateAnalysisRndInteraction(rndInteractions[0].id);	
		} 
		
	}
	/****
	 * Added New Method : NOKIASC-17514
	 * Added by Kunal Mandal
	 ***********/
	@AuraEnabled
	public static boolean checkODRValidationQuery(Id caseId) {
		list<CH_OutageDuration__c> odrData = [SELECT id,CH_DurationEndDate__c FROM CH_OutageDuration__c WHERE CH_SupportTicket__c =: caseId];
		if(odrData.size()!=0){
			Boolean odrEnddateValidation = true;
			for(CH_OutageDuration__c odr:odrData){
	if(odr.CH_DurationEndDate__c==null){
		odrEnddateValidation = true;
	}else{
		odrEnddateValidation = false;
	}
	}
			return odrEnddateValidation;
		}else {
			return false;
		}
	}
	/****
	 * Added New Method : NOKIASC-23978
	 * Added by Suman
	 ***********/
	@AuraEnabled
	public static Case transferProblemDetailsQuery(string recordId) {
		Case caseval = [Select id,RecordType.Name,CH_OwnerName__c,CH_Workgroup__r.Name,Owner.Name, AccountID, Account.BillingCountry,
			OwnerId, CH_Workgroup__c,CH_CurrentQueue__c from Case where id=: recordId];
		 string rid = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		caseval.RecordTypeId = rid;
		return caseval;
	}  
	
	 @AuraEnabled
	public static String transfercaseornot(Id recordId) {
		String returnval;
		
		List <Case> caseval = [Select id,RecordType.Name from Case where id=: recordId];
		if (caseval.Size()==0 ){
			returnval='false';
		}
		else{
			returnval='true';
		}
			return returnval;
	}  
	
	
	 @AuraEnabled
	public static Product2 transferNewProblemDetailsQuery(string recordId) {
		
		Product2 productval = [Select id, RecordtypeId, RecordType.Name from Product2 where id=: recordId];
		string rid = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		productVal.RecordTypeId = rid;
			return productval;
	}  
	/******Added by Suman End******/////
   
	/****
	 * Added New Method : NOKIASC-24016
	 ***********/
	 @AuraEnabled
	public static boolean statusValue(Id caseId) {
		list<Case> odrData = [SELECT id,status,RecordTypeId FROM Case WHERE Id =: caseId];
		string rectypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(odrData[0].RecordTypeId).getname();
		if(rectypeName==SWS_Constants.NSC){
			return true;
		}
		else{
			return false;
		}
	}
	@AuraEnabled
	public static string statusValueforResolve(Id caseId) {
		list<Case> odrData = [SELECT id,status,RecordTypeId FROM Case WHERE Id =: caseId];
		return odrData[0].status;
		
	}
	/****Added by Ajesh ***********/
	@AuraEnabled
	public static boolean fetchODRrecords(Id caseId) {
		list<CH_OutageDuration__c> odrData = [SELECT id FROM CH_OutageDuration__c WHERE CH_SupportTicket__c =: caseId];
		if(odrData.size()!=0){
			return false;
		}else {
			return true;
		}   
	}
	//Added By Gouri for CleanUp US: 24017//
	@AuraEnabled
	public static boolean disablebuttoncheck(Id caseId){
		boolean createarticleflag =false;
		Case fetchCase=[SELECT Id, Status
			FROM Case
			WHERE Id=:caseId];
		if(fetchCase.Status=='Assigned'|| fetchCase.Status=='Created' )
			{
	createarticleflag = true;
			}
		return createarticleflag;
	}
	 @AuraEnabled
	public static boolean disablebuttoncheckSIR(Id caseId){
		boolean setissueresolveflag =false;
			Case fetchCase=[SELECT Id, CH_CaseCause__c
			FROM Case
			WHERE Id=:caseId];
		if(fetchCase.CH_CaseCause__c== null || fetchCase.CH_CaseCause__c=='' )
			{
	setissueresolveflag = true;
			}
		return setissueresolveflag;
		
	
}
   //Added By suman :24018////// 
  @AuraEnabled
	public static boolean disablebuttoncheckGenerateSDR(Id caseId){
		boolean createarticleflag =false;
		list<Case> fetchCase=[SELECT Id, Status,RecordTypeId
			FROM Case
			WHERE Id=:caseId];
	string rectypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(fetchCase[0].RecordTypeId).getname();
		if(rectypeName== SWS_Constants.NSC){
			createarticleflag= true;
		}
		else If(rectypeName=='Nokia Incident with Restoration') 
		{
			if (fetchCase[0].Status=='Assigned'|| fetchCase[0].Status=='Created' ){
			createarticleflag= true;
			}
		}
		Else
		{
			createarticleflag= false;
		}
	  
	
		return createarticleflag;
	}
	
	
	
	@AuraEnabled
	public static boolean disablesetissueresolved(Id caseId)
	{
		boolean setissueresolveflag =false;
		try{
		list<Case> fetchCase=[SELECT Id, CH_CaseCause__c,RecordTypeId,CH_Stage__c,Status,CH_TCAReady__c FROM Case WHERE Id=:caseId];
		string rectypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(fetchCase[0].RecordTypeId).getname();
		
		If(rectypeName=='Nokia Incident with Restoration') 
		{
	  
	if((fetchCase[0].CH_CaseCause__c!= null )&&(fetchCase[0].CH_TCAReady__c== true )&& ( fetchCase[0].Status =='Restoration Provided' && fetchCase[0].CH_Stage__c=='Resolve' || fetchCase[0].Status =='Temp Sol. Provided' && fetchCase[0].CH_Stage__c=='Resolve' || fetchCase[0].Status ==SWS_Constants.SolnProvided && fetchCase[0].CH_Stage__c =='Close' ) )
	{
		setissueresolveflag = false;
	}
	else
	{
		setissueresolveflag= true;
	}
		}
		else if(rectypeName==SWS_Constants.NSC)
		{
	if((fetchCase[0].CH_CaseCause__c!= null )&&(fetchCase[0].CH_TCAReady__c== true )&& ( fetchCase[0].Status ==SWS_Constants.Rip && fetchCase[0].CH_Stage__c=='Diagnosis & Technical Analysis' || fetchCase[0].Status ==SWS_Constants.Rip && fetchCase[0].CH_Stage__c=='Resolve' || fetchCase[0].Status =='Temp Sol. Provided' && fetchCase[0].CH_Stage__c == 'Resolve'  || fetchCase[0].Status == SWS_Constants.SolnProvided && fetchCase[0].CH_Stage__c == 'Close' ))
	{
		setissueresolveflag = false;
	}
	else
	{
		setissueresolveflag= true;
	}
		}
		else if(rectypeName=='Nokia Information Request') 
		{
	if((fetchCase[0].CH_CaseCause__c!= null ) && ( (fetchCase[0].Status == SWS_Constants.Rip && fetchCase[0].CH_Stage__c=='Resolve') || (fetchCase[0].Status ==SWS_Constants.SolnProvided && fetchCase[0].CH_Stage__c =='Close') ) )
	{
		setissueresolveflag = false;
	}
	else
	{
		setissueresolveflag= true;
	}
		
		}
		else
		{
	setissueresolveflag = true;  
		}
			
		}
		catch(Exception e)
		{
			//This is empty
		}
		return setissueresolveflag;
		
	}
	
@AuraEnabled
	public static boolean disableDistributecommentUpdate(Id caseId){
		boolean commentflag =false;
			list<Case> fetchCase=[SELECT Id, Comment__c ,RecordTypeId
			FROM Case
			WHERE Id=:caseId];
			if(fetchCase[0].Comment__c== null || fetchCase[0].Comment__c=='' )
			{
	commentflag = true;
			}
		
		Else
		{
	commentflag = false;  
		}
		return commentflag;
		
	
}	
	
	//	 NOKIASC-26534 ////
	@AuraEnabled
	public static boolean disableSharebutton(Id caseId){
		boolean commentflag =false;
			list<Case> fetchCase=[SELECT Id,CH_TemporarySolution__c,CH_Workaround_Available__c FROM Case
			WHERE Id=:caseId];
		
		if((fetchCase[0].CH_TemporarySolution__c != null && fetchCase[0].CH_Workaround_Available__c=='Yes') || fetchCase[0].CH_Workaround_Available__c=='No')
			{
	commentflag = false;
			}
		
		Else
		{
	commentflag = true;  
		}
		return commentflag;
	}
	/****************
	 * Method Name: fetchCaseDetails
	 * Parameter: caseId
	 * Last updated by: eashwarkumar.alluri@nokia.com
	 * Description: To Get Case Number , Country and NCIB URL
	 * User Story: NOKIASC-28968 and 28969
	****************/
	@AuraEnabled
	public static Map<String,String> fetchCaseDetails(Id caseId) {
		Map<String,String> countryCaseMap= new Map<String,String>();
		List<Case> caseList = [Select CaseNumber,Country__c from Case where id=:caseId];
		//Added for NOKIASC-35336
		String showFIR = CH_CHASettings__c.getValues('EnableFIR') != null ? CH_CHASettings__c.getValues('EnableFIR').SettingValue__c :'false';
		String showCCR = CH_CHASettings__c.getValues('EnableCCR') != null ? CH_CHASettings__c.getValues('EnableCCR').SettingValue__c :'false';
		countryCaseMap.Put('showFIR',showFIR);//Added for NOKIASC-35336
		countryCaseMap.Put('showCCR',showCCR);//Added for NOKIASC-35336
		countryCaseMap.put('caseNumber',caseList[0].CaseNumber);
		if(caseList[0].Country__c!=null){
		countryCaseMap.put('caseCountry',caseList[0].Country__c);
		List<ISO_Country_Codes__c> countryList =[Select NCIBURL__c from ISO_Country_Codes__c where Country_Name__c=:caseList[0].Country__c];
		
			if(countryList[0].NCIBURL__c!=null){
	countryCaseMap.put('caseURL',countryList[0].NCIBURL__c);
			}
			else
			{
	countryCaseMap.put('caseURL','noValue');
			}
			
		}
		else{
			countryCaseMap.put('caseURL','noValue');
		}
		return countryCaseMap;
	}
	
	@AuraEnabled
	public static CH_CaseTag__c getCaseTag(Id caseId) {
		List<Case> oCaseList = DML_SObject.doQuery(
			'SELECT CH_Tag__r.Id, CH_Tag__r.CH_TagName__c FROM Case WHERE Id = "' + caseId  + '" LIMIT 1'
		, true);
		return oCaseList.get(0).CH_Tag__r;
	}
	/****************
	 * Method Name: getCaseDetails
	 * Parameter: caseId
	 * Last updated: 18-feb-2021
	 * Description: returns boolean vaue based on the record and busines group of the Case
	 * User Story: NOKIASC-33903
	****************/
	@AuraEnabled
	public static boolean getCaseDetails(Id caseId) {
		Boolean disableFirButton= false;
		String businessGrouop = CH_CHASettings__c.getValues('BusinessGroup') != null ? CH_CHASettings__c.getValues('BusinessGroup').SettingValue__c :'';
		String recordType = CH_CHASettings__c.getValues('RecordType') != null ? CH_CHASettings__c.getValues('RecordType').SettingValue__c :'';
		List<Case> caseList = [Select CH_RecordTypeDevName__c, Product.CH_Business_Group__c from Case where id=:caseId];
		if(caseList.Size()>0&&(caseList[0].Product.CH_Business_Group__c!= businessGrouop || caseList[0].CH_RecordTypeDevName__c == recordType)){
			disableFirButton = true;
		}
		return disableFirButton;
	}
	/****************
	 * Method Name: validUser
	 * Parameter: caseId
	 * Last updated: 07-03-2021
	 * Description: returns boolean value based on the workgroup
	 * User Story: NOKIASC-34727
	****************/
	@AuraEnabled
	public static boolean validUser(Id caseId){
		return CH_AcceptOwnership_Controller.validUser(caseId);
	}
	/****************
	 * Method Name: caseOwnerUpdate
	 * Parameter: caseId
	 * Last updated: 07-03-2021
	 * Description: returns boolean value based on the case owner update
	 * User Story: NOKIASC-34727
	****************/
	@AuraEnabled
	public static boolean caseOwnerUpdate(Id caseId){
		return CH_AcceptOwnership_Controller.assignSelfOwnership(caseId);
	}
	
	//Changes added as a Part of NOKIASC-35322
	@AuraEnabled
	Public Static Boolean isPausedDate(Id caseId){
		Boolean flag=false;
		Case fetchPausedSinceDate=[SELECT Id, CH_PausedSinceDate__c FROM Case WHERE Id=:caseId];
		if(fetchPausedSinceDate!=NULL && fetchPausedSinceDate.CH_PausedSinceDate__c!= null){
	 
	flag = True;
			
		}
		return flag;
	}
	//Changes added as part of NOKIASC-35941
	@AuraEnabled
	public static Case updateComment(Id caseId,string comment){
		case getcase;
		try{
			getcase=new Case(Id = caseId, Comment__c = comment);
			update 	getcase;
		}catch(Exception e){
			throw new AuraHandledException(CH_CaseFlow_Controller.errorMsg3  + e.getMessage());
		}
		return getcase;
	}
	
	//Changes added for NOKIASC-24257
	@AuraEnabled
	public Static Boolean isAccessEnabled(Id caseId){
		Boolean isValidUser = false;
		List<Case> getProblemList=[Select Id from case where Id=: caseId and Owner.Id=:UserInfo.getUserId()];
		if(!getProblemList.isEmpty()&& getProblemList.size()>0){ isValidUser=True;  }
		if(!isValidUser){
		List<CaseTeamMember> getCaseTeamMembers=[SELECT Id, Member.Name, TeamRole.Name, CreatedDate,Member.Id FROM CaseTeamMember 
			 WHERE ParentId =:caseId and Member.Id=:UserInfo.getUserId()];
		if(!getCaseTeamMembers.isEmpty()&& getCaseTeamMembers.size()>0){ isValidUser=True; }}
		if(!isValidUser){
			List<CollaborationGroupMember>  getCollaboration=[SELECT CollaborationGroup.Name FROM CollaborationGroupMember WHERE MemberId =:UserInfo.getUserId()
				 AND CollaborationGroup.CollaborationType = 'Private'];
			if(!getCollaboration.isEmpty() && getCollaboration.size()>0){			  
			List<CH_PrivateFeed__Feed> publishedPrivateFeedRecords = new List<CH_PrivateFeed__Feed>();
	Map<Id, CH_PrivateFeed__Feed> privateFeedMap = new Map<Id, CH_PrivateFeed__Feed>([SELECT Id, ParentId, Body FROM CH_PrivateFeed__Feed Where Parent.CH_Problem__c=:caseId]);
	for(FeedItem oFeedItem : [SELECT Id, Status FROM FeedItem WHERE Id IN :privateFeedMap.keySet()]) {
		if(oFeedItem.Status.equals('Published')) {
			publishedPrivateFeedRecords.add(privateFeedMap.get(oFeedItem.Id));
		}
	}
	if(!publishedPrivateFeedRecords.isEmpty() && publishedPrivateFeedRecords.size()>0){
		for(CollaborationGroupMember getCollMem:getCollaboration){
			for(CH_PrivateFeed__Feed getFeedRec:publishedPrivateFeedRecords){
				system.debug('getFeedRec body is : '+getFeedRec.Body);
				system.debug('CollaborationGroup.Name is : '+getCollMem.CollaborationGroup.Name);
				if(getFeedRec.Body.contains(getCollMem.CollaborationGroup.Name)){
		isValidUser=True;
		break;
				}
			}
		}
	}
			}	
		}
		return isValidUser;
	}
	
	//Changes added for NOKIASC-35878
	@AuraEnabled	
	Public static void savePrivateFeed(Id privateFeedId, String privateNotes,String targetRelease,Date targetReleaseDate){
		CH_PrivateFeed__c updatePrivateFeed = new CH_PrivateFeed__c(Id=privateFeedId, CH_PrivateNotes__c = privateNotes,CH_TargetRelease__c=targetRelease,CH_TargetReleaseDate__c=targetReleaseDate);
		update updatePrivateFeed; 
	}
	
	//Changes added for NOKIASC-24257/35878
	@AuraEnabled
	Public Static List<CH_PrivateFeed__c> getPrivateFeedRecord(Id caseId){
		List<CH_PrivateFeed__c> getFeedRecord=new List<CH_PrivateFeed__c>();
		CH_PrivateFeed__c[] feedRec=[Select Id,ch_problem__c,CH_PrivateNotes__c,CH_TargetRelease__c,CH_TargetReleaseDate__c from CH_PrivateFeed__c where ch_problem__c=:caseId];
		if(feedRec.size()>0){ getFeedRecord.add(feedRec[0]);   }
		if(feedRec.size()<1){
			CH_PrivateFeed__c createFeedRecord =  new CH_PrivateFeed__c(ch_problem__c=caseId);
			insert createFeedRecord;
			getFeedRecord.add(createFeedRecord);
		}
		
		return getFeedRecord;
	}
	//Changes added for NOKIASC-35878
	@AuraEnabled	
	Public static void updateProblemRecord(Id caseId,String targetRelease,Date targetReleaseDate){
		Case updateCaseRec = new Case(Id=caseId,CH_Target_Release__c=targetRelease,CH_Target_Release_Date__c=targetReleaseDate);
		update updateCaseRec; 
	}
	
	//Changes added for NOKIASC-35878
	Public Static Void createorUpdatePrivateFeedRecord(Id caseId,String targetRelease,Date targetReleaseDate){
		CH_PrivateFeed__c[] feedRec=[Select Id,ch_problem__c,CH_PrivateNotes__c,CH_TargetRelease__c,CH_TargetReleaseDate__c from CH_PrivateFeed__c where ch_problem__c=:caseId];
		if(feedRec.size()>0){ for (CH_PrivateFeed__c fedRec : feedRec) {
			fedRec.CH_TargetRelease__c=targetRelease;fedRec.CH_TargetReleaseDate__c=targetReleaseDate;
		}  }
		if(feedRec.size()<1){
			CH_PrivateFeed__c createFeedRecord =  new CH_PrivateFeed__c(ch_problem__c=caseId,CH_TargetRelease__c=targetRelease,CH_TargetReleaseDate__c=targetReleaseDate);
			feedRec.add(createFeedRecord);}
		upsert feedRec;
		
	}
	
	//Changes added for NOKIASC-38611
	@AuraEnabled
	public static String hasCaseEditAcess(Id caseRecordId, List<String> fields) {
		String message = '';
		if (caseRecordId != null ) {
			//Checking record level access
			message = checkRecordLevelAccess(caseRecordId);
			if (String.isNotBlank(message)) {
	return message = errorMsg;  
			}
			//Checking object level access
			message = checkObjectAccess('Case', new String[] {'Edit'});
			if (String.isNotBlank(message)) {
	return message = errorMsg;
			}
			//Checking field level access
			Map < String, String > fieldLevelPermissionMap = new Map < String, String >();
			for(String field : fields){
	fieldLevelPermissionMap.put(field, 'Edit');
			}
			Map < String, String > fieldLevelAccessMap =  CH_CreateCaseController.checkFieldAccess('Case', fieldLevelPermissionMap);
			for(String field : fields){
	if(String.isNotBlank(fieldLevelAccessMap.get(field))){
		message = errorMsg;
		return message ;
	}
			}
			if(String.isBlank(message)) {
	Case caseObj = [SELECT Id, CH_Stage__c, RecordType.Name, AccountId, EntitlementId, ContactId, CH_IsCompleteInitialResponse__c,CH_IsCompleteRestore__c,CH_IsCompleteTemporarySolution__c,CH_IsCompleteSolutionProvided__c,CH_IsCompleteServiceDisruptionReport__c,status FROM Case WHERE Id =: caseRecordId LIMIT 1];
	if(caseObj != null && caseObj.RecordType.Name.equals('Problem')) {
		//Defect 26533: Status has been added in the below criteria-TCS-Partha Roy-3rd Feb,2020		 
		 
		if(caseObj.CH_Stage__c.equals('Close') && caseObj.Status.equals('Closed')) {
			message = 'Problem Details cannot be modified once Problem is closed.';
		}
	}
	else {
		if(caseObj.CH_IsCompleteRestore__c || caseObj.CH_IsCompleteTemporarySolution__c || caseObj.CH_IsCompleteSolutionProvided__c || caseObj.CH_IsCompleteServiceDisruptionReport__c) {
			message = 'Entitlement related details cannot be modified once Restore, Temporary Solution or Solution Provided events have been completed.';
		}
	}
			}
			return message;
		}	
		return errorMsg2;
	}
	
	/*******************
	* Method Name: checkRecordLevelAccess
	* Parameter: Id objectID
	* Description: TO check the record level access
	* Reference: NOKIASC-16337
	*******************/   
	//Changes added for NOKIASC-38611
	public static String checkRecordLevelAccess(Id objectID){ 
		String message = '';
		if (objectID != null){
			UserRecordAccess recordAccess =  [SELECT RecordId  ,HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId =: objectID Limit 1];
			if(recordAccess != null && recordAccess.HasEditAccess){
	message = ''; 
			} else {
	message = 'Does not have edit access over record for this user';
			}	 
		}  
		return message;
	}
	
	/********************
	* Method Name: checkObjectAccess
	* Parameter: String sObjectName, String[] accessLevel
	* Description: Used to check access of given object with provided access level
	* Reference: NOKIASC-15495/15083
	*******************/
	//Changes added for NOKIASC-38611
	public static string checkObjectAccess(String sObjectName, String[] accessLevel) {
		SObjectType sObjectTypeName = Schema.getGlobalDescribe().get(sObjectName);
		for(String access: accessLevel) {
			if(access == 'Read' && !sObjectTypeName.getDescribe().isAccessible()) {
	return 'No Read Access';
			} else if(access == 'Create' && !sObjectTypeName.getDescribe().isCreateable()) {
	return 'No Create Access';
			} else if(access == 'Edit' && !sObjectTypeName.getDescribe().isUpdateable()) {
	return 'No Edit Access';
			} else if(access == 'Delete' && !sObjectTypeName.getDescribe().isDeletable()) {
	return 'No Delete Access';
			} else {
	return '';
			}
		}
		return 'Invalid object access level';	
	}
}