/*----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:	  IRApplicationCase
Description:	1. IRApplicationCase class to get values and perform DML operations on Case object
2. Used in IRPDF VF page			
Date	Version	Author	Summary of Changes 
-----------   ----------	-----------------  ---------------------------------------------------------------------------------------------------
27-Jan-2021   1.0:	 Commented unused variables
26-June-2021  2.0:	 Redesign
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class IRApplicationCase {
	public static id pageid {get; set;}
 
	public static List<Case> childIds{get; set;}
	public static case caseDetails{get;set;}
	//Contains all picklist fields api name loaded in the IR application form
	public static final Set<String> picklistFields=new Set<String> {'Select_Your_Market__c','Company_type_CP__c','Annual_revenues_CP__c','Percentage_revenues_through_Services_CP__c','Total_Number_of_employees_CP__c','Percentage_of_Technical_Professionals_CP__c','Percentage_of_Total_EmployeesIn_Sales_CP__c','Percentage_of_Total_Employees_in_Serv_CP__c','of_Total_Employees_in_Marketing_CP__c','of_Employees_to_represent_Nokia_CP__c','Top_3_Targeted_Vertical_focus_Industries__c','Current_Manufacturers_CP__c','Primary_Interest_CP__c','Offer_your_own_Maintenance_and_Support__c','State__c','Country__c','Which_countries__c','Which_Sales_Territory_Country_Are_You__c','PRM_Year_of_Departure__c'};
   
		
		/**
  * Description : constructor to fetch vf page id
  * @param NA
  * @return User
  * @throws NA
  **/
  public IRApplicationCase(ApexPages.StandardController controller) {
	pageid = ApexPages.currentPage().getParameters().get('Id');
	caseDetails =  [Select caseNumber from Case where id=:pageid Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	childIds = [Select Id from Case where ParentId =:pageid Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	Apexpages.currentPage().getHeaders().put(PRMGlobalConstants.contentdisposition, PRMGlobalConstants.attachment_PDF);
  }
		/*
@methodName-createCaseWithBasicInfo
@parameter-Case
@returntype-String
@use-This method is only invoked when user switches to Company head quarters tab from Nokia Partner registration tab
and also from save button from individual country modal (only for the first time) it creates the parent and child case with basic details
*/
		@AuraEnabled
		public static String createCaseWithBasicInfo(Case caseObj)
	{
		Id caserecordTypeId;
		//Checking the case not been created yet
		if(caseObj.Id==null)
		{
			//Identifying child case
			if(caseObj.ParentId!=null)
			{
	String salesRec = PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE;
	caserecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(salesRec).getRecordTypeId();
	caseObj.Subject='IR Application – ['+caseObj.Full_Legal_Name_of_Your_Organization_CP__c+'] - ['+caseObj.Country__c+']';
	caseObj.Description='IR Application – ['+caseObj.Full_Legal_Name_of_Your_Organization_CP__c+'] - ['+caseObj.Country__c+']';
			}
			//Parent case identifier
			else
			{
	String recordType_case = PRMGlobalConstants.recordType_case;
	caserecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordType_case).getRecordTypeId();
	caseObj.Subject='IR Application – []';
	caseObj.Description='IR Application – []';
			}
			caseObj.recordTypeId= caseRecordTypeId;
		}
		String caseId='';
		

		//create the case record
		insert caseObj;
		caseId=caseObj.Id;
		Case objCase=[Select id,caseNumber from Case where Id=:caseObj.Id];
		//return combination of case Id and case Number
		return caseId+':'+objCase.caseNumber;
	}
	/*
@methodName-saveAndReturn
@parameter-Case,Map<Id,Case>childCaseMap
@returntype-String
@use-This method is invoked when user wants to save and return at intermediate stage while filling up the form.
*/
	@auraEnabled
	public static String  saveAndReturn(Case parentCase,Map<Id,Case>childCaseMap)
	{
		//List contains all child cases for individual conutries
		List<Case>casesToUpdate=new List<Case>();
		parentCase.Is_Headquater__c = false;
		
		//All the parent case field is set through the javascript hence only DML is called   
		upsert parentCase;
		//If childcase has been created before saving then below fields on child case are updated
		if(childCaseMap!=null && !childCaseMap.values().isEmpty())
		{
			for(Id childCaseId:childCaseMap.KeySet())
			{
	Case childCase=childCaseMap.get(childCaseId);
	childCase.Id=childCaseId;
	childCase.PRM_Last_Modified_By_Guest_User__c = Date.today();
	childCase.Primary_Interest_CP__c = parentCase.Primary_Interest_CP__c;
	childCase.Which_Sales_Territory_are_You__c = parentCase.Which_Sales_Territory_are_You__c;
	if(Country_To_Market__c.getValues(childCase.Country__c) != null) {
		childCase.Select_Your_Market__c = Country_To_Market__c.getValues(childCase.country__c).Market__c;
	}
	casesToUpdate.add(childCase);  
			} 
			//If child case list is not empty then excute below lines
			if(!casesToUpdate.isEmpty())
			{
	String jsonString = json.serialize(casesToUpdate);
	//Call the future method to update child cases and remove the cases the unselected countries
	deleteUnrelatedChildCases(parentCase.Id,jsonString,null,false); 
			}
		}
		else
		{
		deleteUnrelatedChildCases(parentCase.Id,'',null,false);	
		}
		Case objParentCase=[Select id,caseNumber from Case where Id=:parentCase.Id];
		//Return Parent Ccase number to the user for future reference
		return objParentCase.Id+':'+objParentCase.caseNumber;
	}
	/*
@methodName-submitCaseDetails
@parameter-Case,Map<Id,Case>childCaseMap
@returntype-String
@use-This method is invoked when user finally submits the form with all details
*/
	@auraEnabled
	public static String  submitCaseDetails(Case parentCase,Map<Id,Case>childCaseMap)
	{
		//Creating the DMLOptions for assignment rule
		Database.DMLOptions dmlOpts = new Database.DMLOptions();
		dmlOpts.AssignmentRuleHeader.useDefaultRule = true;

		
		//List of child cases to update
		List<Case>casesToUpdate=new List<Case>();
		//List of junction objects to create
		List<junction__c> lstJun = new List<junction__c>();
		//Set contains all unique distributor name specfic to country
		Set<String> distName=new Set<String>();
		//List of all legal countries
		List<String> country=new List<String>();
		//Map of all partner company Id as key and  Partner company name and headquarter as value
		Map<Id,String> partnerCompanyMap=new Map<Id,String>(); 
		//Iterate over all child cases received from the IR from
		for(Id childCaseId:childCaseMap.KeySet())
		{
			Case childCase=childCaseMap.get(childCaseId);
			childCase.Id=childCaseId;
			//include quotes in the country for using in dynamic soql
			country.add('\''+childCase.Country__c+'\'');
			//Select market based on the country from custom settings
			if(Country_To_Market__c.getValues(childCase.Country__c) != null) {
	childCase.Select_Your_Market__c = Country_To_Market__c.getValues(childCase.country__c).Market__c;
			}
			//Set all child case fields
			childCase.Subject = 'IR Application – ['+parentCase.Full_Legal_Name_of_Your_Organization_CP__c+'] - ['+childCase.Country__c+']' ;
			childCase.Description = 'IR Application – ['+parentCase.Full_Legal_Name_of_Your_Organization_CP__c+'] - ['+childCase.Country__c+']' ;
			childCase.Primary_Interest_CP__c = parentCase.Primary_Interest_CP__c;
			childCase.List_Ref_and_4G_5G_Experience__c = parentCase.List_Ref_and_4G_5G_Experience__c;
			childCase.Radio_Networks_Installation_Experience__c = parentCase.Radio_Networks_Installation_Experience__c;
			childCase.Radio_Frequency_Expirience__c = parentCase.Radio_Frequency_Expirience__c;
			childCase.Tier1_Tier2_Support_Level__c = parentCase.Tier1_Tier2_Support_Level__c; 
			childCase.PRM_NoandScopeOfPotentialNDACDeploy__c = parentCase.PRM_NoandScopeOfPotentialNDACDeploy__c;
			childCase.Full_Legal_Name_of_Your_Organization_CP__c = parentCase.Full_Legal_Name_of_Your_Organization_CP__c;
			childCase.PB_First_Name__c = parentCase.PB_First_Name__c;
			childCase.PB_Last_Name__c = parentCase.PB_Last_Name__c;
			childCase.PB_Email__c = parentCase.PB_Email__c;
			childCase.Which_Sales_Territory_are_You__c = parentCase.Which_Sales_Territory_are_You__c;
			childCase.Which_countries__c = parentCase.Which_countries__c;
			childCase.PRM_Last_Modified_By_Guest_User__c = Date.today(); 
			casesToUpdate.add(childCase);
			//Store all distribtor name in the set which is received from distributor multiselect picklist
			distName.addAll(childCase.Distributor_with_whom_transact_business__c.split(';'));
		}
		//Set all parent case fields
		parentCase.Is_Headquater__c = false;
		parentCase.Subject='IR Application – ['+parentCase.Full_Legal_Name_of_Your_Organization_CP__c+']';
		parentCase.Description='IR Application – ['+parentCase.Full_Legal_Name_of_Your_Organization_CP__c+']';
		if(Country_To_Market__c.getValues(parentCase.Country__c) != null) {
			parentCase.Select_Your_Market__c = Country_To_Market__c.getValues(parentCase.country__c).Market__c;
		}
		parentCase.PRM_Last_Modified_By_Guest_User__c = Date.today();
		//Query the partner company based on head quarters and partner type
		String query='select id, Name,Partner_Name__r.Name,Country_Headquarters__c from Partner_Company__c where Partner_Type__c= \'Distributor\' and Partner_Name__r.Name in : distName and Country_Headquarters__c includes('+ String.join(country, ',') + ')';
		List<Partner_Company__c> lstPartner = database.query(query);  
		for(Partner_Company__c partnercompany:lstPartner){
			partnerCompanyMap.put(partnercompany.Id,partnercompany.Partner_Name__r.Name+':'+partnercompany.Country_Headquarters__c);	 
		}
		//if only one child case is created and the  child case country matches with parent case head quarter country execute below code
		if(childCaseMap!=null && !childCaseMap.values().isEmpty()&& childCaseMap.values().size()==1 && childCaseMap.values()[0].country__c==parentCase.Country__c)   
		{
			
			Case childCase=childCaseMap.values()[0];
			//Set all the below fields from child case to parent
			parentCase.Company_Registration_Number__c = childCase.Company_Registration_Number__c;
			parentCase.First_Name_Sales__c = childCase.First_Name_Sales__c;
			parentCase.Last_Name_Sales__c = childCase.Last_Name_Sales__c;
			parentCase.Email_Sales__c = childCase.Email_Sales__c;
			parentCase.Primary_Phone_Sales__c = childCase.Primary_Phone_Sales__c;
			parentCase.Affiliates_Subsidiary_Name__c = childCase.Affiliates_Subsidiary_Name__c;
			//Set Is headquarter field on parent case as true
			parentCase.Is_Headquater__c = true;
			//Transfer all uploaded files from child to parent and delete the child case
			deleteChildAndTransferAttachments(parentCase.id,childCase.Id);
			casesToUpdate.clear();
		}
		//Added for case assignment
		parentCase.setOptions(dmlOpts);
		//update Parent Case
		update parentCase;
		//If parentcase  is headquarter field is true add the junction records in the list for all the partner companies
		if(parentCase.Is_Headquater__c) {
			for(Partner_Company__c pc : lstPartner){
	junction__c jun = new junction__c();
	jun.Case__c = parentCase.Id;
	jun.Partner_Company__c = pc.id;
	lstJun.add(jun);
			}
		}
		//If parent  head quarter country is not set to true execute below
		else {
			if(childCaseMap!=null && !childCaseMap.values().isEmpty()&& childCaseMap.values().size()>1)
			{
	String jsonString;
	if(!casesToUpdate.isEmpty())
	{
		jsonString = json.serialize(casesToUpdate);   
	}
	//Delete the cases for unselected countries and create junction object for selected countries
	deleteUnrelatedChildCases(parentCase.Id,jsonString,partnerCompanyMap,true); 
			}
			
		}
		//create junction record if list is not empty(only when parent head quarter is true)
		if(!lstJun.isEmpty())
		{
			insert lstJun;  
		}
		//Submit the parent case for approval if head quarter is true
		if(parentCase.Is_Headquater__c)
			Approval.unlock(parentCase.id);
		
		return  parentCase.CaseNumber;
	}
	/*
@methodName-deleteUnrelatedChildCases
@parameter-Id,String,Map<Id,String>,Boolean
@returntype-NA
@use-This method is invoked from Save and return or at final case submission to update the cases and delete unwanted cases
*/
	@future
	public static void deleteUnrelatedChildCases(Id parentcaseId,String childCases,Map<Id,String>partnerCompanyMap,Boolean isSubmit)
	{
		//Child cases stored in the list after query
		List<Case> childCaseListFromDB;
		//Child cases coming from Ui
		List<Case> childCaseList;
		Set<Id> childCaseIds=new Set<Id>();
		if(String.isNotBlank(childCases))
		{
			Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.AssignmentRuleHeader.useDefaultRule = true;
			
			//Deserialize the child cases into list
			childCaseList = (List<Case>)Json.deserialize(childCases,List<Case>.class);
			for(Case caseObj:childCaseList)
			{
	childCaseIds.add(caseObj.Id); 
				if(isSubmit)
					caseObj.setOptions(dmlOpts);
			}
			//Update the child cases using direct DML as fields are set in Javascript
			if(childCaseList!=null&& !childCaseList.isEmpty())
	update childCaseList;
		}
		if(String.isNotBlank(parentcaseId) )
		{
			//List of cases to be deleted for unselected countries and was created on initial selection
			List<Case> caseListToDelete;
			childCaseListFromDB=[Select Id,Country__c,Distributor_with_whom_transact_business__c from Case where parentId=:parentcaseId];
			caseListToDelete=new List<Case>();
			if(childCaseListFromDB!=null && !childCaseListFromDB.isEmpty() )
			{
	if(!childCaseIds.isEmpty())
	{
	for(Integer i=0;i<childCaseListFromDB.size();i++) 
	{
		//If the DB record does not exist in UI record list then elegible for deletion
		if(!childCaseIds.contains(childCaseListFromDB[i].Id))
		{
			caseListToDelete.add(childCaseListFromDB[i]);
			childCaseListFromDB.remove(i);
		}
	}
			}
			else
			{
	caseListToDelete.addAll(childCaseListFromDB) ;  
			}
			}
			if(!caseListToDelete.isEmpty()) 
	Delete caseListToDelete;
		}
		//Execute the below block only if the method is invoked through final submission
		if(isSubmit)
		{
			//List of junction records to be created for child 
			List<junction__c> lstJun=new List<junction__c>();  
			for(Id  id :partnerCompanyMap.keyset() ) {
	for(Case c : childCaseListFromDB) {
		if(String.isNotBlank(partnerCompanyMap.get(id)))
		{
			List<String> parnterNameAndCountry=partnerCompanyMap.get(id).split(':');
			//If child case country match with partner company head quarter and child case distributor matches with partner company name then crate the corresponding junction objects 
			if(String.isNotBlank(parnterNameAndCountry[0])&&String.isNotBlank(parnterNameAndCountry[1])&&c.Distributor_with_whom_transact_business__c.contains(parnterNameAndCountry[0])&& parnterNameAndCountry[1].contains(c.country__c)) {
				junction__c jun = new junction__c();
				jun.Case__c = c.id;
				jun.Partner_Company__c = id;
				lstJun.add(jun);
			}
		}
	}
			}
			if(!lstJun.isEmpty())
			{
	insert lstJun;  
			}
			//Submit parent case for approval
			Approval.unlock(parentcaseId);
			//submit the child cases for approval
			for(Case objCase:childCaseListFromDB)
			{
	Approval.unlock(objCase.id);   
			}   
		}
	}
	/*
@methodName-deleteChildAndTransferAttachments
@parameter-Id,Id
@returntype-NA
@use-This method is invoked to transfer the files from child case to parent if country head quarter is true on parent
*/  
	@future
	public static void deleteChildAndTransferAttachments(Id parentcaseId,Id childCaseId)
	{
		List<ContentDocumentLink> listOfAttachmentsToBeTranferred=new List<ContentDocumentLink>();
		//query the documents based on childcaseId
		List<ContentDocumentLink> documentList=[Select id,contentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:childCaseId];
		//Query the child cases from parent case Id
		List<Case> childCaseList=[Select Id from Case where parentId=:parentcaseId];
		//Change the reference of all files from child to parent
		for(ContentDocumentLink file: documentList){
			ContentDocumentLink newclnk = file.clone();
			newclnk.linkedentityid = parentcaseId; 
			listOfAttachmentsToBeTranferred.add(newclnk);
		}
		//Transfer the files through new rcord creation
		if(!listOfAttachmentsToBeTranferred.isEmpty())
			insert listOfAttachmentsToBeTranferred;
		//Delete all the child cases along with uploaded files 
		if(childCaseList!=null && !childCaseList.isEmpty())
			delete childCaseList;
	}
	
	/**
* Description : Method to getStateValues 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
	@AuraEnabled
	public static List<String> getStateValues(String country){
		List<String> options = new List<String>();
		try{   
			List<Country_State_Dependency__c> lstState = [select name,state__c,country__c 
				from Country_State_Dependency__c  order by state__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			//System.debug('List of States'+ lstState);
			if(lstState.size()>0){
	for(Country_State_Dependency__c c:lstState){
		if(c.Country__c == country){
			options.add(c.State__c);
		}
	}
			}
			
		}
		catch(System.Exception e){ 
			//String message=e.getMessage();//unused variable
			ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getDistributor); }
		return options;
	}
	
	/**
* Description : Method to getPickListValues 
* @param NA
* @return String to with case number
* @throws NA
**/
	@AuraEnabled
	public static Map<String,List<String>> getPickListValues(){
		Map<String,List<String>> pickListMap = new Map<String,List<String>>();
		try{
			// Get the describe for the object
			String objType='Case';
			DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objType).getDescribe();
			//Iterate over all the picklist field  Api declared as the class member
			for(String fieldAPI:picklistFields)
			{
	//Fetch the values for each picklist and store in options
	Schema.DescribeFieldResult fieldResult = objResult.fields.getMap().get(fieldAPI).getDescribe();
	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	List<String> options=new List<String>();
	for (Schema.PicklistEntry f: ple) {
		options.add(f.getLabel());
	}
	//Fill the map with picklist field api as key and  set of picklist values
	pickListMap.put(fieldAPI,options);
			}
		}
		Catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseRepNokia);
		}
		return pickListMap;
	}   
	/**
* Description : Method to get case from case no 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
	@AuraEnabled
	public static RetrieveWrapper caseFromCaseNo(String loginCaseNumber  ){ 
		RetrieveWrapper retObj = new RetrieveWrapper();
		
		List<Case> caseList = new List<Case>();
		retObj.CaseMap = new Map<string,Map<String,String>>();
		
		List<String> caseChildList = new List<String>();
		caseList = [Select Id,CaseNumber, PB_Email__c, Provide_a_detailed_expelanation__c,Postal_Code_per_country__c, Guideline_URL__c, Describe__c, Organizations_which_your_company_belong__c, Annual_industry_conferences_you_attend__c, Persons_responsible_for_work__c, Describe_your_current_business_activity__c, Describe_the_expereince_or_relationships__c, H_First_Name__c, H_Last_Name__c, PRM_H_Title__c, State__c, First_Name__c, PB_First_Name__c, PB_Last_Name__c, PB_Mobile_Phone__c, PB_Office_Phone__c, Pri_Retype_Email__c, PB_Title__c, Last_Name__c, Email__c, Mobile_Phone__c, Office_Phone__c, CRetype_Email__c, Title__c, Offer_your_own_Maintenance_and_Support__c, Current_Manufacturers_CP__c, Who_are_your_leading_competitors__c, Which_countries__c,Primary_Interest_CP__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_Sales_Territory_are_You__c,Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,Country__c,Phone_No__c,State_Province_per_country__c,FAX__c,Company_s_Website__c,Number_of_Branch_locations_CHQ__c,Branch_Offices__c,Full_Legal_Name_of_Your_Organization_CP__c,VAT_Number__c,Dun_Bradstreet_D_U_N_S_Number_CP__c,Company_type_CP__c,Number_of_years_in_business_CP__c,Annual_revenues_CP__c,Percentage_revenues_through_Services_CP__c,Total_Number_of_employees_CP__c,Percentage_of_Technical_Professionals_CP__c,Percentage_of_Total_Employees_in_Serv_CP__c,Percentage_of_Total_EmployeesIn_Sales_CP__c,of_Total_Employees_in_Marketing_CP__c,of_Employees_to_represent_Nokia_CP__c,Are_you_already_a_Nokia_Direct_Reseller__c,Willing_to_resell_to_USA_Federal_CP__c ,Willing_to_sell_to_non_USA_Govt_CP__c ,Bribery_or_corruption__c ,Current_criminal_investigation_pending__c ,Code_of_Conduct_Compliance_program__c , Anti_corruption_training_to_employees__c ,Direct_Indirect_ownership_in_Company__c , STREET_ADDRESS_1_CHQ__c , POSTAL_CODE_CHQ__c , PHONE_NO_CHQ__c , EMAIL_DOMAINS_CHQ__c, STREET_ADDRESS_2_CHQ__c , STREET_ADDRESS_3_CHQ__c , Company_website_CHQ__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c ,PRM_NoandScopeOfPotentialNDACDeploy__c, PRM_Is_former_Nokia__c,PRM_Last_Title__c,PRM_Year_of_Departure__c,PRM_NIRAAdditionalInfo__c,CH_Article_Attached__c FROM case WHERE CaseNumber =: loginCaseNumber and status='Draft'];
		if(!caseList.IsEmpty()){
			retObj.CaseObj = caseList[0];
			
			List<Case> childCases = [SELECT  Country__c,Primary_Interest_CP__c,Postal_Code_per_country__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_countries__c,Which_Sales_Territory_are_You__c,id,Affiliates_Subsidiary_Name__c,Company_Registration_Number__c,Street_Address_1__c,Street_Address_2__c,Company_s_Website__c,Street_Address_3__c,Email_Domain__c,Phone_No__c,Fax_per_country__c,City_per_country__c,First_Name_Sales__c,Last_Name_Sales__c,Email_Sales__c,Primary_Phone_Sales__c,First_Name_Marketing__c,Last_Name_Marketing__c,Email_Marketing__c,Primary_Phone_Marketing__c,First_Name_Service__c,Last_Name_Service__c,Email_Service__c,Primary_Phone_Service__c,Distributor_with_whom_transact_business__c,State_Province_per_country__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c, PRM_NoandScopeOfPotentialNDACDeploy__c, (Select id,contentDocument.Title,contentDocument.fileextension from ContentDocumentlinks ) from Case where ParentId=:caseList[0].Id AND Country__c!=null];
			for(case caseIns :  childCases){
	caseChildList.add(caseIns.Country__c);
	Map<string,string> countryDetails = new Map<string,string>();
	if(caseIns.Affiliates_Subsidiary_Name__c != null){
		countryDetails.put('affil',caseIns.Affiliates_Subsidiary_Name__c);
	}else{
		countryDetails.put('affil','');
	}
	if(caseIns.Company_Registration_Number__c != null){
		countryDetails.put('regno',caseIns.Company_Registration_Number__c);
	}else{
		countryDetails.put('regno','');
	}
	if(caseIns.Street_Address_1__c != null){
		countryDetails.put('sa1',caseIns.Street_Address_1__c);
	}else{
		countryDetails.put('sa1','');
	}
	if(caseIns.Street_Address_2__c != null){
		countryDetails.put('sa2',caseIns.Street_Address_2__c);
	}else{
		countryDetails.put('sa2','');
	}
	if(caseIns.Company_s_Website__c != null){
		countryDetails.put('website',caseIns.Company_s_Website__c);
	}else{
		countryDetails.put('website','');
	}
	if(caseIns.Street_Address_3__c != null){
		countryDetails.put('sa3',caseIns.Street_Address_3__c);
	}else{
		countryDetails.put('sa3','');
	}
	if(caseIns.Email_Domain__c != null){
		countryDetails.put('domain',caseIns.Email_Domain__c);
	}else{
		countryDetails.put('domain','');
	}
	if(caseIns.Phone_No__c != null){
		countryDetails.put('phone',caseIns.Phone_No__c);
	}else{
		countryDetails.put('phone','');
	}
	if(caseIns.City_per_country__c != null){
		countryDetails.put('city',caseIns.City_per_country__c);
	}else{
		countryDetails.put('city','');
	}
	if(caseIns.Postal_Code_per_country__c != null){
		countryDetails.put('postal',string.ValueOf(caseIns.Postal_Code_per_country__c));
	}else{
		countryDetails.put('postal','');
	} 
	if(caseIns.First_Name_Sales__c != null){
		countryDetails.put('salesfname',caseIns.First_Name_Sales__c);
	}else{
		countryDetails.put('salesfname','');
	}
	if(caseIns.Last_Name_Sales__c != null){
		countryDetails.put('saleslname',caseIns.Last_Name_Sales__c);
	}else{
		countryDetails.put('saleslname','');
	}
	if(caseIns.Email_Sales__c != null){
		countryDetails.put('salesemail',caseIns.Email_Sales__c);
	}else{
		countryDetails.put('salesemail','');
	}
	if(caseIns.Primary_Phone_Sales__c != null){
		countryDetails.put('salesphone',caseIns.Primary_Phone_Sales__c);
	}else{
		countryDetails.put('salesphone','');
	}
	if(caseIns.Distributor_with_whom_transact_business__c != null){
		countryDetails.put('distributor',caseIns.Distributor_with_whom_transact_business__c);
	}else{
		countryDetails.put('distributor','');
	}
	if(caseIns.State_Province_per_country__c != null){
		countryDetails.put('state',caseIns.State_Province_per_country__c);
	}else{
		countryDetails.put('state','');
	}
	countryDetails.put('Id',caseIns.Id);
	List<Id> contentDocumentLinkIds=new List<Id>();
	List<String> fileNames=new List<String>();
	for(ContentDocumentLink cdLink:caseIns.ContentDocumentLinks)
	{
		contentDocumentLinkIds.add(cdLink.Id);
		fileNames.add(cdLink.ContentDocument.Title+'.'+cdLink.ContentDocument.fileextension);
	}
	if(!contentDocumentLinkIds.isEmpty())
	{
		countryDetails.put('uploadFileIds',json.serialize(contentDocumentLinkIds)); 
			
		countryDetails.put('fileNames',json.serialize(fileNames));  
	   
	}
	else	
	{
		countryDetails.put('uploadFileIds','');
		countryDetails.put('fileNames','');  
	}
	retObj.CaseMap.put(caseIns.Country__c,countryDetails);	
			}
			if(!caseChildList.IsEMpty()){
	retObj.caseList = caseChildList;
			}
			retObj.isErrorExist = false;
		}else{
			retObj.isErrorExist = true;
			retObj.errorMessage = 'Application not found';
		}
		
		Return retObj;	
	} 
	
	/**
* Description : Method to get distributors for different countries on NIRA 
* @param Strings Country Name
* @return DiStributor List
* @throws NA
**/
	@AuraEnabled  
	public static List<String> getDistributors(String countryDis){
		String distName=PRMGlobalConstants.Distr;
		List<String> options = new List<String>();
		try{
			if(String.isNotBlank(countryDis) || countryDis != null){
	for(Partner_Company__c c : [select Partner_Name__r.name  from Partner_Company__c 
					where Partner_Type__c=:distName 
					and Country_Headquarters__c Includes (:countryDis)
					order by Partner_Name__r.name Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			options.add(c.Partner_Name__r.name );
			
					}
			}	  
		}
		catch(System.Exception e){ 
			ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getDistributor);}
		return options;	
	}
	
	@AuraEnabled
	public static LIST<Multi_Language_Terms__c> getLanguageTerm(String selectedLanguage) 
	{
		LIST<Multi_Language_Terms__c> TermValue=new LIST<Multi_Language_Terms__c>();
		try{
			TermValue = [Select Terms__c,Language__c from Multi_Language_Terms__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		}   
		catch(System.Exception e) 
		{
			ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,'Language Term');
		}
		return TermValue;
	}
	
	@AuraEnabled
	public static String getMaintenanceStatus(){
		List<PRM_NIRAMaintenance__mdt> prmNiraMaintLst = [SELECT Id, PRM_IsUnderMaintenance__c, PRM_MaintenanceMessage__c FROM PRM_NIRAMaintenance__mdt where PRM_IsUnderMaintenance__c = true LIMIT 1];
		if(prmNiraMaintLst!= null && !prmNiraMaintLst.isEmpty()){
			return prmNiraMaintLst[0].PRM_MaintenanceMessage__c;
		}
		return 'false';
	}
	
	public with sharing class RetrieveWrapper {
		
		@auraEnabled
		public Boolean isErrorExist;
		
		@auraEnabled 
		public String errorMessage;
		
		@auraEnabled
		public Case CaseObj;
		
		@auraEnabled
		public List<String> caseList;
		
		@auraEnabled
		public Map<string,Map<String,String>>  CaseMap;
		
	}
}