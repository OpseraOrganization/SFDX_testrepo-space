/**
* @name  NF_FacilitatorNotificationCtrl_Clone
* @author
* @since   July 08, 2017
* @desc  Class used to notify the facilitator for G3 Gate

* @history
*/
 
public without sharing class NF_FacilitatorNotificationCtrl_Clone extends NF_QueueHandler {
	public Opportunity currentOpp {get;set;}
	public Boolean facilitatorFound {get;set;}
	public Boolean showMandatoryInfo {get;set;}
	public String currentOppId {get;set;}
	public string selectedRole {get;set;}
	public string facilitatorName {get;set;}
	public string organization {get;set;}
	public String delegate1 {get;set;}
	public string delegate2 {get;set;}
	public string delegate3 {get;set;}
	public String redirectionChoice{get;set;}
	public Boolean isBigCase {get;set;}

	private Map<Integer, String> roleCodesMap = new Map<Integer,String>{
		7 => 'NSNG_OQM',
		6 => 'NSNE_OQM',
		5 => 'NSND_OQM',
		4 => 'NSNC_OQM'
	};
	private Map<Integer, String> orgLevelsMap = new Map<Integer,String>{
		7 => 'Org_L7__c',
		6 => 'Org_L6__c',
		5 => 'Org_L5__c',
		4 => 'Org_L4__c'
	};
	@Testvisible private static final String Market_Latin_America='Market Latin America';
	@Testvisible private static final String Market_North_America='Market North America';
	@Testvisible private static final String Market_NFS = 'Market NFS';
	@Testvisible private static final String MU_LAT='LAT';
	@Testvisible private static final String MU_NAM='NAM';
	@Testvisible private static final String NAM_MARKET_UNIT_CAN  ='NAM Market ';
	@Testvisible private static final String NE_EA ='NE E&A ';
	@Testvisible private static final String NE_WEB ='NE Web ';

	public Sales_Role__c facilitator ;
	public Group facilitatorQueue;
	public Set<String> mandParams = new Set<String>();
	public Set<String> mandParamsBigCases = new Set<String>();
	public Set<String> mandParamsSmallCases = new Set<String>();
	public Id oppAM;
	public String oppAMName;
	public enum ApprovalsRedirection { APPROVALCONTEXTSUBMIT, MYAPPROVALS , PREVIEWSUBMITAPPROVALS }

	/*
* @desc  the method used to initiate the VF NF_FacilitatorNotification
* @return   PageReference:
*/
	public PageReference init(){
		currentOppId = ApexPages.currentPage().getParameters().get('oppId');

		String query = buildQuery();

		if(currentOppId !=null ){
			currentOpp = Database.query(query);
		} else {
			return null;
		}

		if(currentOpp.SWx_Upsell_Proposal__c !=null){
			return  accManagerAsG3Fac();
		}

		if(!isOpportunityEligible()){
			facilitatorFound = false;
			return null;
		}

		if(showMandatoryInfo == null){
			categorizeOpportunity();
			showMandatoryInfo = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.G3_FACILITATOR_INFO_MSG));
			return null;
		}

		return notifyFacilitator();

	}

	public PageReference  accManagerAsG3Fac(){
		PageReference myPAge;
		for(OpportunityTeamMember TM :currentOpp.OpportunityTeamMembers){
			oppAM = TM.User.id;
			oppAMName = TM.User.Name;
		}
		System.debug('oppAM--->'+oppAM);

		if(oppAM != NULL){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,String.format(GlobalConstants.G3_FACILITATOR_NOTIFIED_UPSELL,new String[] {oppAMName})));
			facilitatorFound  = true;
			currentOpp.Queue_Id__c = '';
			currentOpp.Queue_Name__c = '';
			currentOpp.NF_Facilitator_User__c = oppAM;
			facilitatorName = oppAMName;
		}
		else
		{
			facilitatorFound=false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.G3_FACILITATOR_NOTFOUND));
			myPAge = null;
		}

		return myPAge;
	}


	/**
*   @description : Method used to verify if the opportunity has the conditions to notify the facilitator
*   @return : Boolean
*/
	public Boolean isOpportunityEligible(){

		if(!currentOpp.StageName.equalsIgnoreCase(GlobalConstants.DEVELOP_OPPORTUNITY)){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, String.format(Label.NF_OnlyFacilitatorCanBeNotified,new String[] {GlobalConstants.DEVELOP_OPPORTUNITY})));
			return false;
		}
		if( currentOpp.Gate_3_Bypass_no_offer_support__c ) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, GlobalConstants.G3_FACILITATOR_BYPASS));
			return false;
		}
		//G4 Planned date cannot be empty before Notifying G3 Facilitator - Release 7
		if( currentOpp.G4_Planned_Date__c == NULL )
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.NF_G4_PlannedDate_Error));
			return false;
		}
		//check if at least 1 record of OIF object should be created before opening G3
		if(currentOpp.OIF_Lines__c==0 ){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, GlobalConstants.MANDATORY_OIF_FOR_APPROVAL));
			return false;
		}
		if(currentOpp.NF_Facilitator_Notified__c==TRUE){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.NF_Facilitator_already_notified));
			return false;
		}
		return true;
	}

	/**
*   @description : Method used to fill FacilitatorUser and notify him.
*   @return : PageReference
*/
	public PageReference notifyFacilitator(){
		//Market North America & NFS
		if( Market_North_America.equalsIgnoreCase(currentOpp.Org_L4__c)){ //|| Market_NFS.equalsIgnoreCase(currentOpp.Org_L4__c)
			facilitatorQueue = searchForQueue(currentOpp);
		}
		//Market Latin America
		else if ( Market_Latin_America.equalsIgnoreCase(currentOpp.Org_L4__c) &&
	 GlobalConstants.BG_NI.equalsIgnoreCase(currentOpp.Lead_BG__c) && !GlobalConstants.BU_NI_FN.equalsIgnoreCase(currentOpp.Lead_BU__c) && !currentOpp.isMultiBG__c){
		 facilitatorQueue = getQueue(currentOpp);
	 }//Market NFS
		else if(Market_NFS.equalsIgnoreCase(currentOpp.Org_L4__c)){
			facilitatorQueue = searchNFSForQueue(currentOpp);
		}
		//Other Markets
		else {
			facilitator = getFacilitator(7);
		}


		if(facilitatorQueue != null){
			facilitatorFound =true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, GlobalConstants.G3_FACILITATOR_FOUND));
			currentOpp.Queue_Id__c = facilitatorQueue.Id;
			currentOpp.Queue_Name__c = facilitatorQueue.Name;
			currentOpp.NF_Facilitator_User__c = null;
			currentOpp.Facilitator_Delegate_1__c = null;
			currentOpp.Facilitator_Backup__c = null;
			currentOpp.Facilitator_Delegate_2__c = null;
			currentOpp.Facilitator_Delegate_3__c = null;
			return null;
		}

		if(facilitator != null){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, GlobalConstants.G3_FACILITATOR_FOUND));
			facilitatorFound  = true;
			currentOpp.Queue_Id__c = '';
			currentOpp.Queue_Name__c = '';
			currentOpp.NF_Facilitator_User__c = facilitator.User__c;
			facilitatorName = facilitator.User__r.Name;
			organization = facilitator.Organisation__c;
			List<Apttus_Approval__Backup_Approver__c> facilitatorBackups =  [SELECT Apttus_Approval__Backup_User__c ,Apttus_Approval__DelegateUserIds__c,Apttus_Approval__IsDelegate__c ,Delegate_Approver1__r.name , Delegate_Approver2__r.Name, Delegate_Approver3__r.name
		FROM Apttus_Approval__Backup_Approver__c WHERE Apttus_Approval__Current_User__c =: facilitator.User__c AND Apttus_Approval__IsActive__c = true AND Apttus_Approval__InEffect__c = true LIMIT 1 ];
			if(!facilitatorBackups.isEmpty() && facilitatorBackups[0].Apttus_Approval__DelegateUserIds__c != null){
	List<String> delegateFacilitatorIds = facilitatorBackups[0].Apttus_Approval__DelegateUserIds__c.split(',');
	Map<Id,User> users = getUsers(delegateFacilitatorIds);
	Integer delegateFacilitatorSize =  delegateFacilitatorIds.size() ;
	delegate1 = users.get(delegateFacilitatorIds[0]).Name;
	if(facilitatorBackups[0].Apttus_Approval__IsDelegate__c){
		currentOpp.Facilitator_Delegate_1__c = ID.valueOf(delegateFacilitatorIds[0]);
	} else {
		currentOpp.Facilitator_Backup__c = ID.valueOf(delegateFacilitatorIds[0]);
	}
	if(delegateFacilitatorSize >= 2 ){
		currentOpp.Facilitator_Delegate_2__c = ID.valueOf(delegateFacilitatorIds[1]);
		delegate2 = users.get(delegateFacilitatorIds[1]).Name;
	}
	if(delegateFacilitatorSize == 3 ){
		currentOpp.Facilitator_Delegate_3__c = ID.valueOf(delegateFacilitatorIds[2]);
		delegate3 = users.get(delegateFacilitatorIds[2]).Name;
	}
			}
		}else{
			facilitatorFound=false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, GlobalConstants.G3_FACILITATOR_NOTFOUND));
			return null;
		}
		return null;
	}

	/**
*   @description : Method used to redirect back to the opportunity
*   @return : PageReference
*/
	public PageReference cancel() {
		return new PageReference('/'+currentOppId);
	}

	/**
*   @description : Method used to confirm G3 facilitator
*   @return : PageReference
*/
	public PageReference confirmG3Facilitator(){

		try{
			if (facilitatorQueue != null) {
	System.debug('send Email facilitatorQueue value ====='+facilitatorQueue +'currentOpp value ===='+currentOpp);
	notifyQueue(facilitatorQueue,CurrentOpp);
			}
			currentOpp.NF_Facilitator_Notified__c = true;
			validateG3Prepared();
			update currentOpp;
			return new PageReference('/'+currentOppId);

		}catch(DmlException e){
			facilitatorFound  = true;
			if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
	String requiredFields = 'Required Fields missing : '+e.getDmlFieldNames(0);
	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,requiredFields));
			}
			return null;
		}

	}

	/**
*   @description : method to check if can proceed for approval
*   @return : PageReference
*/

	public PageReference proceed(){
		for(String mandField : mandParams){
			if(currentOpp.get(mandField) == null){
	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.G3_FACILITATOR_MANDATORY_MSG));
	facilitatorFound = false;
	showMandatoryInfo = true;
	return null;
			}
			if( (mandField == 'Probability' && !validateProbability()) || (mandField == 'G4_Planned_Date__c' && !validateG4PlannedDate())){
	return null;
			}
		}
		validateG3Prepared();
		if(!currentOpp.G3_Prepared__c){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, GlobalConstants.G3_FACILITATOR_MANDATORY_MSG ));
			facilitatorFound = false;
			showMandatoryInfo = true;
			return null;
		}
		showMandatoryInfo = false;
		return notifyFacilitator();
	}

	/**
*   @description : method to check if can proceed for approval
*   @return : PageReference
*/

	public PageReference saveAndReturn(){
		try{
			for(String mandField : mandParams){
	if( (mandField == 'Probability' && !validateProbability()) || (mandField == 'G4_Planned_Date__c' && !validateG4PlannedDate())){
		return null;
	}
			}
			validateG3Prepared();
			update currentOpp;
		} catch (Exception e) {
			System.debug('Exception : ' + e.getMessage());
		}
		return cancel();
	}

	/**
*   @description : Method used to find the faciliator starting at L7 until L4 if not found
*   @return : Sales_Role__c
*/
	private Sales_Role__c getFacilitator(Integer orgLevel){
		List<Sales_Role__c> facilitatorList = null;
		String roleCodeSearch = roleCodesMap.get(orgLevel);
		String oppOrganizationLevel = (String)currentOpp.get(orgLevelsMap.get(orgLevel));
		selectedRole = roleCodeSearch;
		facilitatorList = querySalesRole(oppOrganizationLevel,roleCodeSearch);
		if(facilitatorList != null && !facilitatorList.isEmpty()) {
			return facilitatorList[0];
		} else if(orgLevel==4){
			return null;
		} else {
			--orgLevel;
			return getFacilitator(orgLevel);
		}
	}

	/**
*   @description : Method used to query on Users
*   @return : Map<Id,User>
*/
	public Map<Id,User> getUsers (List<Id> userIds){
		return new Map<Id,User>([SELECT Id, Name FROM User WHERE Id IN : userIds ]);
	}

	/**
*   @description : Method used to notify all queue members
*   @return : Boolean
*/
	public boolean notifyQueue(Group facilitatorQueue, Opportunity currentOpp ){
		try{
			notifyQueueMembers(facilitatorQueue.Id, currentOpp.Id);
			return true;
		}catch(exception e){
			system.debug(Logginglevel.ERROR ,'######### ERROR' + e.getMessage());
			return false;
		}

	}

	/**
*   @description : Method used to query Sales Roles
*   @return : List<Sales_Role__c>
*/
	public List<Sales_Role__c> querySalesRole(String Organisation , String Role_Code){
		return [ SELECT Id, User__c, Organisation__c, User__r.Name FROM Sales_Role__c WHERE Role_Code__c = :Role_Code AND Organisation__c = :Organisation limit 1];
	}

	/**
*   @description : Method used to get fields API name in fieldset
*   @return : String
*/
	public static Set<String> getFieldSetFieldsAPI(String fieldSetName, String ObjectName)
	{
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
		Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

		Set<String> fieldsAPI = new Set<String>();
		for(Schema.FieldSetMember field : fieldSetObj.getFields()){
			fieldsAPI.add(field.getFieldPath());
		}

		return fieldsAPI;
	}

	/**
*   @description : Method used to build query for opportunity object
*   @return : String
*/
	public String buildQuery(){
		Set<String> extraFieldsForQuery = new Set<String>();
		mandParamsBigCases.addAll(getFieldSetFieldsAPI('G3_Facilitator_Mand_Params_Big_Cases', 'Opportunity'));
		mandParamsSmallCases.addAll(getFieldSetFieldsAPI('G3_Facilitator_Mand_Params_Small_Cases', 'Opportunity'));
		extraFieldsForQuery.addAll(mandParamsBigCases);
		extraFieldsForQuery.addAll(mandParamsSmallCases);
		List<String> noDuplicatesFieldsAPI = new List<String>(extraFieldsForQuery);

		String query = 'SELECT Id, Amount, NF_Facilitator_Notified__c, NF_Facilitator_User__c, StageName, Facilitator_Delegate_1__c, Facilitator_Delegate_2__c, Facilitator_Delegate_3__c, Facilitator_Backup__c, Lead_BG__c, Lead_BU__c, Org_L5__c, Org_L4__c, Org_L6__c, Org_L7__c, No_Offer_Support__c, Queue_Id__c, Queue_Name__c,SWx_Upsell_Proposal__c, G3_Planned_Date__c, G3_Prepared__c, Gate_3_Bypass_no_offer_support__c, G5_Planned_Date__c, OIF_Lines__c, isMultiBG__c, Unweighted_Amount_EUR__c, MultiBGException_AllowG2Bypass__c,Risk_Assessment__c,'+

			String.escapeSingleQuotes(String.join(noDuplicatesFieldsAPI,',')) + ' , (SELECT Id, TeamMemberRole, User.Id, User.Name FROM OpportunityTeamMembers where TeamMemberRole = \''+ String.escapeSingleQuotes(CSWXGlobalConstant.AM) +'\' limit 1) FROM Opportunity WHERE Id = \''+ String.escapeSingleQuotes(currentOppId) +'\'';

		return query;
	}

	/**
*   @description : Method used to find if the opportunity is a big or small case
*   @return :
*/
	public void categorizeOpportunity(){
		if(currentOpp.Unweighted_Amount_EUR__c > integer.valueof(Label.G3_Strategy_Submit_Faciliator_Treshold) )
		{
			mandParams.addAll(mandParamsBigCases);
			isBigCase = true;
		} else {
			mandParams.addAll(mandParamsSmallCases);
			isBigCase = false;
		}
	}

	/**
*   @description : Method used to validate probability introduced by the user in the UI
*   @return : Boolean
*/
	public boolean validateProbability(){
		String probability = currentOpp.Probability.toPlainString();
		System.debug(probability);
		Pattern pt = Pattern.compile('^[0-9]+$');
		Boolean probabityCheck = pt.matcher(probability).matches();
		if(String.isEmpty(probability) || !probabityCheck || Integer.valueOf(probability)>100 || Integer.ValueOf(probability)<=0 )
		{
			facilitatorFound = false;
			showMandatoryInfo = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, GlobalConstants.G3_FACILITATOR_VALID_PROBABILITY));
			return false;
		}
		return true;
	}

	/**
	*   @description : Method used to validate G4 Planned Date introduced by the user in the UI
	*   @return : Boolean
	*/
	public boolean validateG4PlannedDate(){
		Date g4PlannedDate = currentOpp.G4_Planned_Date__c;
		if(g4PlannedDate == null || currentOpp.G3_Planned_Date__c > g4PlannedDate || currentOpp.G5_Planned_Date__c < g4PlannedDate || System.today() > g4PlannedDate)
		{
			facilitatorFound = false;
			showMandatoryInfo = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.NF_G4_PlannedDate_Validation));
			return false;
		}
		return true;
	}

	/**
	*   @description : Method used to validate if WtD has already returned info on G3 Prepared
	*   @return : PageReference
	*/
	public void validateG3Prepared(){
		Opportunity validateOppty = [Select id , G3_Prepared__c from Opportunity where Id = :currentOppId];
		if(validateOppty == null ){
			currentOpp.G3_Prepared__c = false;
		} else if ( currentOpp.G3_Prepared__c != validateOppty.G3_Prepared__c ){
			currentOpp.G3_Prepared__c = validateOppty.G3_Prepared__c ;
		}

	}
}