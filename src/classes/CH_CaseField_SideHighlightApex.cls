/****************
 * Last Modified By Rajeshwari - Added New Method : NOKIASC-18141 Aug 20 2019
 * Last Modified By Rajeshwari - Added New Method : 		NOKIASC-23159 Sept 2019
 * Last Modified By Suman-Added New Method : NOKIASC-26534 Feb 2020
 * Last Modified By Gouri-Adeed workaround available=n/a to enable share update-NOKIASC-29225-03.07.2020 (Line-449)
 ****************/
public class CH_CaseField_SideHighlightApex {
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
	public static boolean accessCheck(Id caseId){
		boolean flag=false;
		boolean createarticleflag =false;
		String caseTeamMemberId;
		Case fetchCase=[SELECT Id, OwnerId, Status
			FROM Case
			WHERE Id=:caseId];
		List<CaseTeamMember> caseTeamMemberList =[SELECT MemberId ,TeamRoleId ,ParentId 
			  FROM CaseTeamMember 
			  WHERE ParentId=:caseId 
			  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		if(fetchCase!=NULL){
			for(caseTeamMember member : caseTeamMemberList){
	if(member.MemberId == UserInfo.getUserId()){
		flag=true;
	}
			}
			if(fetchCase.Status=='Assigned'|| fetchCase.Status=='Created' )
			{
	createarticleflag = false;
			}
	
			if(fetchCase.OwnerId == UserInfo.getUserId()){
	flag=true;
			}
			if(profileName == 'CH_Agent' || profileName == 'System Administrator'){
	flag=true;
			}
		}
		else{
			flag=false;
		}
		
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
		//Boolean hasRequiredFields = false;
		Boolean hasRequiredFields = true;
		/*if (problem != NULL &&
	problem.Subject != NULL &&
	problem.Description != NULL &&
	//problem.CH_CustomerDescription__c != NULL &&
	problem.CH_ProblemStatement__c != NULL &&
	problem.Severity__c != NULL &&
	problem.CH_AssessedOutage__c != NULL &&
	problem.CH_ReportedDate__c != NULL &&
	problem.ProductId != NULL &&
	problem.CH_Product_Release__c != NULL &&
	problem.CH_Problem_Type__c != NULL &&
	((problem.CH_RDInterface__c == 'PRONTO' &&
	  problem.CH_Pronto_Group__c != NULL &&
	  problem.CH_Discovered_in__c != NULL &&
	  problem.CH_Repeatability__c != NULL) ||
	 problem.CH_RDInterface__c == 'JIRA')) {
			hasRequiredFields = true;
		}*/

		return hasRequiredFields;
	}
	/****
	 * Added New Method : NOKIASC-18141
	 * Modified By Rajeshwari
	 * CLose the case on click of Close Problem
	 ***********/
	@AuraEnabled
	public static void closeProblemRecord(string recordId, string closureReason){
		
		case closeCase = new case();
		closeCase.Id = recordId;
		closeCase.CH_Closure_Reason__c=closureReason;
		closeCase.Status ='Closed';
		update closeCase;
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
		Id devRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get('Known Error').getRecordTypeId();
		Knowledge__kav knownError = [Select Id,Title from Knowledge__kav where CH_CaseId__r.Id =: caseId and RecordTypeId=:devRecordTypeId];
		if(knownError!=null){
			return knownError.Title;
		}
		else{
			return null;
		}
	}
	@AuraEnabled
	  public static boolean disablebuttoncheckcreateArticle(Id caseId) {   
		Id devRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get('Known Error').getRecordTypeId();   
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
		//CH_ExternalInterfaceUTIL.sendOutboundCreateAnalysisRndInteraction(flowInput[0]);
		
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
		 string rid = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		caseval.RecordTypeId = rid;
		return caseval;
	}  
	
	 @AuraEnabled
	public static String transfercaseornot(Id recordId) {
		String returnval;
		//Case Caseval=new Case();
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
		String returnval;
		Product2 productval = [Select id, RecordtypeId, RecordType.Name from Product2 where id=: recordId];
		string rid = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Problem').getRecordTypeId();
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
		if(rectypeName=='Nokia Standard Case'){
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
		if(rectypeName=='Nokia Standard Case'){
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
	  /////////  
	
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
			   
	if((fetchCase[0].CH_CaseCause__c!= null )&&(fetchCase[0].CH_TCAReady__c== true )&& ( fetchCase[0].Status =='Restoration Provided' && fetchCase[0].CH_Stage__c=='Resolve' || fetchCase[0].Status =='Temp Sol. Provided' && fetchCase[0].CH_Stage__c=='Resolve' || fetchCase[0].Status =='Solution Provided' && fetchCase[0].CH_Stage__c =='Close' ) )
	{
		setissueresolveflag = false;
	}
				else
				{
					setissueresolveflag= true;
				}
		}
		else if(rectypeName=='Nokia Standard Case')
		{
	if((fetchCase[0].CH_CaseCause__c!= null )&&(fetchCase[0].CH_TCAReady__c== true )&& ( fetchCase[0].Status =='Responded in Progress' && fetchCase[0].CH_Stage__c=='Diagnosis & Technical Analysis' || fetchCase[0].Status =='Responded in Progress' && fetchCase[0].CH_Stage__c=='Resolve' || fetchCase[0].Status =='Temp Sol. Provided' && fetchCase[0].CH_Stage__c == 'Resolve'  || fetchCase[0].Status == 'Solution Provided' && fetchCase[0].CH_Stage__c == 'Close' ))
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
	if((fetchCase[0].CH_CaseCause__c!= null ) && ( (fetchCase[0].Status == 'Responded in Progress' && fetchCase[0].CH_Stage__c=='Resolve') || (fetchCase[0].Status =='Solution Provided' && fetchCase[0].CH_Stage__c =='Close') ) )
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
			System.debug('Server Error'+e.getMessage());
		}
		return setissueresolveflag;
		
	}
	
@AuraEnabled
	public static boolean disableDistributecommentUpdate(Id caseId){
		boolean commentflag =false;
			list<Case> fetchCase=[SELECT Id, Comment__c ,RecordTypeId
			FROM Case
			WHERE Id=:caseId];
		 //string rectypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(fetchCase[0].RecordTypeId).getname();
		//If(rectypeName=='Nokia Incident with Restoration') {
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
		 //string rectypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(fetchCase[0].RecordTypeId).getname();
		//If(rectypeName=='Nokia Incident with Restoration') {
		if((fetchCase[0].CH_TemporarySolution__c != null && fetchCase[0].CH_Workaround_Available__c=='Yes') || fetchCase[0].CH_Workaround_Available__c=='No' || fetchCase[0].CH_Workaround_Available__c=='n/a')
			{
	commentflag = false;
			}
		
		Else
		{
	commentflag = true;  
		}
		return commentflag;
		
	
}	  
	
   
}