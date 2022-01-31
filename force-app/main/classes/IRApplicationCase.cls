/*----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:	  IRApplicationCase
Description:	1. IRApplicationCase class to get values and perform DML operations on Case object
	2. Used in IRPDF VF page			
Date	Version	Author	Summary of Changes 
-----------   ----------	-----------------  ---------------------------------------------------------------------------------------------------
27-Jan-2021   1.0:	 Commented unused variables
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class IRApplicationCase {
  public static id pageid {get; set;}
  public static List<Case> childIds{get; set;}
  public static case caseDetails{get;set;}

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
  /**
  * Description : Method to fetch current user's details for Lightning Components
  * @param NA
  * @return User
  * @throws NA
  **/
  @AuraEnabled
  public static String getCurrentUser() 
  {
	String message=null;
	User toReturn = new User();
	String sProfile = PRMGlobalConstants.uProfile;
	try{
	  toReturn = [SELECT Id, Name, FirstName, MobilePhone, LastName, Profile.Name ,
	  Phone FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
	}Catch(System.Exception e) { 
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCurrentUser);
	}
  if( toReturn.Profile.Name == sProfile) {   
	  message = PRMGlobalConstants.Message;
	}
	return message;
  }
  /**
  * Description : Method to create case and contact
  * @param Strings to stamp values to case object
  * @return String to with case number
  * @throws NA
  **/
  @AuraEnabled
  public static List<String> mGetCaseDetails(String details,Id parentId,
			 String[] CountryToSell,String[] vertical,
			 String[] ManufactureRep,String[] PrimaryInterest,String fileName,
			 String base64Data,String contentType,String fileId, String[] SalesTerritory,
			 String CountryData, String[] terrSelected, Boolean saveAndReturn, 
			 String caseId, String childFilesMap, String refand4G5GExp, String radioNetworksInstallationExp, String radioFrequencyExp, String tiersSupportLevel) 
  {
	system.debug(' mGetCaseDetails Method Starts here -->');
	//Boolean submitCase=true;//unused variable
	List<String> iDwithCaseNumber = new List<String>();
	String success_Message;
	String errorMsg;
	String recordType_case = PRMGlobalConstants.recordType_case;
	String vertic = GlobalConstants.BLANK_VALUE;
	String manufact = GlobalConstants.BLANK_VALUE;
	String primaryInt = GlobalConstants.BLANK_VALUE;
	String distribut = GlobalConstants.BLANK_VALUE;
	String countrySell = GlobalConstants.BLANK_VALUE;
	String salesTerr = GlobalConstants.BLANK_VALUE;
	Case obj=new Case();
	Case casenum;
	//Boolean val; //unused variable
	Boolean onlyParentRequired = false;
	Database.DMLOptions dmo = new Database.DMLOptions();
	dmo.AssignmentRuleHeader.useDefaultRule = true;
	List<RecordType> recordTypeID_case = [Select Id FROM RecordType 
			WHERE SobjectType =: PRMGlobalConstants.CaseName and DeveloperName =: recordType_case LIMIT 1] ;
	try
	{
	  //String[] Distributor = new  List<String>();//unused variable
	  Map<String, Object> countryDataMap = (Map<String, Object>)JSON.deserializeUntyped(CountryData);
	  Map<String, Object> countryFileDataMap = new Map<String, Object>();
	  if(childFilesMap != null)
	  {
		countryFileDataMap = (Map<String, Object>)JSON.deserializeUntyped(childFilesMap);  
	  }
	  List<String> detailsList = (List<String>)JSON.deserialize(details,List<String>.class);
	  RecordType recordTypeID_caseobj=recordTypeID_case.get(0);
	  obj.RecordTypeId = recordTypeID_caseobj.Id;
	  if(saveAndReturn == false){
		obj.Status=PRMGlobalConstants.CaseStatus;
	  }else{
		obj.Status=GlobalConstants.quoteStage;
	  }
	  
	  obj.Subject='IR Application – ['+detailsList[9]+']';
	  obj.Description='IR Application – ['+detailsList[9]+']';
	  if(Country_To_Market__c.getValues(detailsList[5]) != null) {
		obj.Select_Your_Market__c = Country_To_Market__c.getValues(detailsList[5]).Market__c;
	  }
	  obj.STREET_ADDRESS_1_CHQ__c = detailsList[2];
	  obj.City__c = detailsList[3];
	  obj.POSTAL_CODE_CHQ__c = detailsList[4];
	  obj.Country__c = detailsList[5];
	  obj.PHONE_NO_CHQ__c = detailsList[6];
	  obj.State__c = detailsList[7];
	  obj.EMAIL_DOMAINS_CHQ__c = detailsList[8];
	  obj.Full_Legal_Name_of_Your_Organization_CP__c = detailsList[9];
	  obj.Company_type_CP__c = detailsList[10];
	  obj.Annual_revenues_CP__c = detailsList[11];
	  obj.Total_Number_of_employees_CP__c = detailsList[12];
	  obj.First_Name__c = detailsList[15];
	  obj.Last_Name__c = detailsList[16];
	  obj.Email__c = detailsList[17];
	  obj.Title__c = detailsList[18];
	  obj.Office_Phone__c = detailsList[19];
	  obj.Mobile_Phone__c = detailsList[20];
	  obj.PB_First_Name__c = detailsList[21];
	  obj.PB_Last_Name__c = detailsList[22];
	  obj.PB_Title__c = detailsList[23];   
	  obj.PB_Email__c = detailsList[24];
	  obj.PB_Office_Phone__c = detailsList[25];
	  obj.PB_Mobile_Phone__c = detailsList[26];
	  obj.H_First_Name__c = detailsList[27];
	  obj.H_Last_Name__c = detailsList[28];
	  //obj.MC_First_Name__c = detailsList[29];
	  //obj.MC_Last_Name__c = detailsList[30];
	  //obj.MC_Email__c = detailsList[31];
	  //obj.SC_First_Name__c = detailsList[32];
	  //obj.SC_Last_Name__c = detailsList[33];
	  //obj.SC_Email__c = detailsList[34];
	  //obj.SC_Primary_Phone__c = detailsList[35];
	  //obj.MC_Primary_Phone__c = detailsList[36];
	  //obj.SEC_First_Name__c = detailsList[37];
	  //obj.SEC_Last_Name__c = detailsList[38];
	  //obj.SEC_Email__c = detailsList[39];
	  //obj.SEC_Primary_Phone__c = detailsList[40];
	  obj.STREET_ADDRESS_2_CHQ__c = detailsList[41];
	  obj.STREET_ADDRESS_3_CHQ__c = detailsList[42];
	  obj.Company_website_CHQ__c = detailsList[44];
	  obj.Branch_Offices__c = detailsList[52];
	  obj.Percentage_revenues_through_Services_CP__c = detailsList[54];
	  obj.Percentage_of_Technical_Professionals_CP__c = detailsList[55];
	  obj.Percentage_of_Total_EmployeesIn_Sales_CP__c = detailsList[56];
	  obj.Percentage_of_Total_Employees_in_Serv_CP__c = detailsList[57];
	  obj.of_Total_Employees_in_Marketing_CP__c = detailsList[58];
	  obj.of_Employees_to_represent_Nokia_CP__c = detailsList[59];
	  obj.Who_are_your_leading_competitors__c = detailsList[63];
	  //Start Modification By Deeksha
	  obj.Offer_your_own_Maintenance_and_Support__c = detailsList[64];
	  obj.Are_you_already_a_Nokia_Direct_Reseller__c = detailsList[65];
	  obj.Willing_to_resell_to_USA_Federal_CP__c =detailsList[66];
	  obj.Willing_to_sell_to_non_USA_Govt_CP__c = detailsList[67];
	  obj.Bribery_or_corruption__c = detailsList[68];
	  obj.Current_criminal_investigation_pending__c = detailsList[69];
	  obj.Code_of_Conduct_Compliance_program__c = detailsList[70];
	  obj.Anti_corruption_training_to_employees__c = detailsList[71];
	  //End Modification By Deeksha
	  obj.Direct_Indirect_ownership_in_Company__c = detailsList[72];
	  obj.Describe_your_current_business_activity__c = detailsList[73];
	  obj.Describe_the_expereince_or_relationships__c = detailsList[74];
	  obj.Organizations_which_your_company_belong__c = detailsList[75];
	  obj.Annual_industry_conferences_you_attend__c = detailsList[76];
	  obj.Provide_a_detailed_expelanation__c = detailsList[77];
	  obj.Describe__c = detailsList[78];
	  obj.Persons_responsible_for_work__c = detailsList[79];
	  obj.CRetype_Email__c = detailsList[80];
	  obj.Pri_Retype_Email__c = detailsList[81];
	  //obj.Which_Sales_Territory_Country_Are_You__c = detailsList[82];
	  obj.VAT_Number__c = detailsList[82];
	  obj.PRM_H_Title__c = detailsList[84];
	  obj.PRM_Is_former_Nokia__c = detailsList[85];
	  obj.PRM_Last_Title__c = detailsList[86];
	  obj.PRM_Year_of_Departure__c = detailsList[87]; 
	  //obj.Guideline_URL__c = detailsList[84];
	  for(String s:vertical){
		vertic+=s+';';
	  }
	  for(String s:SalesTerritory){
		salesTerr+=s+';';
	  }
	  for(String s:PrimaryInterest){
		primaryInt+=s+';';
	  }
	  for(String s:CountryToSell){
		countrySell+=s+';';
	  }
	  for(String s:ManufactureRep){
		manufact+=s+';';
	  }
	  
	  obj.Which_countries__c = countrySell;
	  obj.Top_3_Targeted_Vertical_focus_Industries__c = vertic;
	  obj.Current_Manufacturers_CP__c = manufact;
	  obj.Primary_Interest_CP__c = primaryInt;
	  obj.List_Ref_and_4G_5G_Experience__c = refand4G5GExp;
	  obj.Radio_Networks_Installation_Experience__c = radioNetworksInstallationExp;
	  obj.Radio_Frequency_Expirience__c = radioFrequencyExp;
	  obj.Tier1_Tier2_Support_Level__c = tiersSupportLevel;  
	  obj.FAX__c = detailsList[43];
	  obj.Which_Sales_Territory_are_You__c = salesTerr;
	  obj.PRM_Last_Modified_By_Guest_User__c = Date.today();
	  if(detailsList[45]!= ' '){
		obj.Number_of_Branch_locations_CHQ__c = Integer.valueof(detailsList[45]); 
	  }
	  
	  obj.Dun_Bradstreet_D_U_N_S_Number_CP__c = detailsList[48]; 
	  
	  if(detailsList[51]!= ' '){
		obj.Number_of_years_in_business_CP__c = Integer.valueof(detailsList[51]); 
	  }
	  
	  if(terrSelected.size() == 1 && terrSelected.contains(detailsList[5])) {
		obj.Is_Headquater__c = true;
		obj.Distributor_with_whom_transact_business__c = distribut;
		if(saveAndReturn == false){
	dmo.AssignmentRuleHeader.useDefaultRule = true;
	obj.setOptions(dmo);
		}
		onlyParentRequired = true;
	  }
	  //added by priyanka
	  else {
		obj.Is_Headquater__c = false;
	  }
	  // ends here
	  system.debug(CaseId+' obj -->'+obj);
	  if(CaseId != null) {
		system.debug('CaseId Inside If trye -->'+iDwithCaseNumber);
		obj.Id = caseId;
		update obj;  
		if(obj.status == 'New') {
	Approval.UnlockResult unlockedRersult = Approval.unlock(obj.id);
		}
		//Added Below code - Rajeshwari
		casenum = [select id,CaseNumber from Case where id =:caseId Limit 1];
		success_Message= casenum.CaseNumber+'.';
		iDwithCaseNumber.add(success_Message);
		 //Added BelowEnds here code - Rajeshwari
	  }else {
		insert obj;
		if(obj.status == 'New') {
	Approval.UnlockResult unlockedRersult = Approval.unlock(obj.id);
		}  
		casenum = [select id,CaseNumber from Case where id =:Obj.Id Limit 1];
		success_Message= casenum.CaseNumber+'.';
		iDwithCaseNumber.add(success_Message);
	  }
	  system.debug('Inside trye -->'+iDwithCaseNumber);
	}
	catch(Exception e) 
	{
	  errorMsg = e.getMessage();
	  if(String.ISBLANK(errorMsg)){
		success_Message =   System.label.PS_SelfService_ErrorMessage;
		iDwithCaseNumber.add(success_Message);
		system.debug('iDwithCaseNumber --> ' + iDwithCaseNumber);
	  }
	}
	system.debug('iDwithCaseNumber --> ' + iDwithCaseNumber);
	NIRAFutureHandler(details, obj.id, obj.Status, primaryInt, distribut, countrySell, salesTerr, onlyParentRequired,
	 PrimaryInterest, fileName, base64Data, contentType, fileId, CountryData, terrSelected, saveAndReturn, 
	 childFilesMap, refand4G5GExp, radioNetworksInstallationExp, radioFrequencyExp, tiersSupportLevel);
	return iDwithCaseNumber;
  }
  
  @future
  public static void NIRAFutureHandler(String details,Id parentId,String caseStatus,String primaryInt,String distribut,String countrySell,
		 String salesTerr,Boolean onlyParentRequired, String[] PrimaryInterest,String fileName,String base64Data,
		 String contentType,String fileId,String CountryData,String[] terrSelected,
		 Boolean saveAndReturn,String childFilesMap, String refand4G5GExp,
		 String radioNetworksInstallationExp, String radioFrequencyExp, String tiersSupportLevel){   
		
	//obj.Which_countries__c = countrySell;
	  List<Case> childCases = new List<Case>();
	  String salesRec = PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE;
	  Id childCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(salesRec).getRecordTypeId();
	  
	  Database.DMLOptions dmo = new Database.DMLOptions();
	  dmo.AssignmentRuleHeader.useDefaultRule = true;
	  
	  Map<String, Object> countryDataMap = (Map<String, Object>)JSON.deserializeUntyped(CountryData);
	  List<String> detailsList = (List<String>)JSON.deserialize(details,List<String>.class);
	  Map<String, Object> countryFileDataMap = new Map<String, Object>();
	  if(childFilesMap != null){
  countryFileDataMap = (Map<String, Object>)JSON.deserializeUntyped(childFilesMap);  
	  }	 
		 
	  Set<String> distName = new Set<String>();
	  system.debug('@@@@'+countryDataMap);
	  system.debug('@@@@ 1111'+terrSelected);
  try{
	  if(countryDataMap != null){
  for(String countryKey : countryDataMap.keySet() ){
	system.debug('@@@@');
	if(!terrSelected.contains(countryKey)) {
	  continue;
	}
	Case cc = new Case();
	if(saveAndReturn == false){
	  cc.Status=PRMGlobalConstants.CaseStatus;
	}else{
	  cc.Status='Draft';
	}
	cc.Subject = 'IR Application – ['+detailsList[9]+'] - ['+countryKey+']' ;
	cc.Description = 'IR Application – ['+detailsList[9]+'] - ['+countryKey+']' ;
	//cc.Sales_to_Country__c = countryKey;
	cc.Country__c = countryKey;
	cc.RecordTypeId = childCaseRecordTypeId;
	if(Country_To_Market__c.getValues(countryKey) != null) {
	  cc.Select_Your_Market__c = Country_To_Market__c.getValues(countryKey).Market__c;
	}
	cc.Primary_Interest_CP__c = primaryInt;
	cc.List_Ref_and_4G_5G_Experience__c = refand4G5GExp;
	cc.Radio_Networks_Installation_Experience__c = radioNetworksInstallationExp;
	cc.Radio_Frequency_Expirience__c = radioFrequencyExp;
	cc.Tier1_Tier2_Support_Level__c = tiersSupportLevel;  
	cc.Full_Legal_Name_of_Your_Organization_CP__c = detailsList[9];
	cc.PB_First_Name__c = detailsList[21];
	cc.PB_Last_Name__c = detailsList[22];
	cc.PB_Email__c = detailsList[24];
	cc.Which_Sales_Territory_are_You__c = salesTerr;
	cc.Which_countries__c = countrySell;
	cc.PRM_Last_Modified_By_Guest_User__c = Date.today();
	if(saveAndReturn == false){
  system.debug('@@@@ 1111--saveAndReturn'+ saveAndReturn);
  system.debug('@@@@ 1111--saveAndReturn--dmo'+ dmo);
	  cc.setOptions(dmo);
	}
	map<String,Object> valueKey = (map<String,Object>) countryDataMap.get(countryKey);
	for(String fieldKey : valueKey.keySet()) {
	  if(String.valueOf(fieldKey) == 'affil'){
  cc.Affiliates_Subsidiary_Name__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'regno'){
  cc.Company_Registration_Number__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'sa1'){
  cc.Street_Address_1__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'sa2'){
  cc.Street_Address_2__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'website'){
  cc.Company_s_Website__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'sa3'){
  cc.Street_Address_3__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'domain'){
  cc.Email_Domain__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'phone'){
  cc.Phone_No__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'fax'){
  cc.Fax_per_country__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'city'){
  cc.City_per_country__c = String.valueOf(valueKey.get(fieldKey));
	  }
  else if(String.valueOf(fieldKey) == 'postal'){
  cc.Postal_Code_per_country__c = String.valueOf(valueKey.get(fieldKey));
	  } 
	  else if(String.valueOf(fieldKey) == 'salesfname'){
  cc.First_Name_Sales__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'saleslname'){
  cc.Last_Name_Sales__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'salesemail'){
  cc.Email_Sales__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'salesphone'){
  cc.Primary_Phone_Sales__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'markfname'){
  cc.First_Name_Marketing__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'marklname'){
  cc.Last_Name_Marketing__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'markemail'){
  cc.Email_Marketing__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'markphone'){
  cc.Primary_Phone_Marketing__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'servfname'){
  cc.First_Name_Service__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'servlname'){
  cc.Last_Name_Service__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'servemail'){
  cc.Email_Service__c = String.valueOf(valueKey.get(fieldKey));
	  }
	  else if(String.valueOf(fieldKey) == 'servphone'){
  cc.Primary_Phone_Service__c = String.valueOf(valueKey.get(fieldKey));
	  } else if(String.valueOf(fieldKey) == 'distributor'){
  distName.addAll(String.valueOf(valueKey.get(fieldKey)).split(';'));
  cc.Distributor_with_whom_transact_business__c = String.valueOf(valueKey.get(fieldKey));
  distribut = String.valueOf(valueKey.get(fieldKey));
	  } else if(String.valueOf(fieldKey) == 'state'){
  cc.State_Province_per_country__c = String.valueOf(valueKey.get(fieldKey));
	  } else if(String.valueOf(fieldKey) == 'Id'){
  cc.Id = String.valueOf(valueKey.get(fieldKey));
	  }
	}
	childCases.add(cc); 
  }   
	  }
	  
   
	List<Case> caseInserted = new List<Case>();
	List<Case> caseUpdated = new List<Case>();
	if(childCases.size() > 0){
	  for(Case c : childCases) {
		c.ParentId = parentId;
		if(c.Id != null) {
	caseUpdated.add(c);
		}else {
	if(onlyParentRequired && c.status == 'New') {
			//
	}else {
			caseInserted.add(c);
	}
		}
	  }
	  if(caseUpdated.size() > 0) {
		if(onlyParentRequired) {
	caseUpdated[0].Status = 'Draft';
		}
		update caseUpdated;
		for(Case c: caseUpdated) {
	if(c.status == 'New') {
			Approval.UnlockResult unlockedRersult = Approval.unlock(c.id);
	}
	
		}
	  }
	  if(caseInserted.size() > 0) {
		insert caseInserted;
		for(case c : caseInserted) {
	if(c.status == 'New') {
			Approval.UnlockResult unlockedRersult = Approval.unlock(c.id);
	}
		}
	  }
	}
	
	//Add child files
	List<Attachment> childAttachList = new List<Attachment>();
	for(Case cc : caseUpdated){
	  if(countryFileDataMap != null && countryFileDataMap.get(cc.Country__c) != null){
	map<String,Object> childFileData = (map<String,Object>)countryFileDataMap.get(cc.Country__c);
	childAttachList.add(createChildAttachment(childFileData, cc.Id));
	System.Debug(childAttachList);   
		}
	}
	System.debug(caseInserted);  
	for(Case cc : caseInserted){  
	  if(countryFileDataMap != null && countryFileDataMap.get(cc.Country__c) != null){
	map<String,Object> childFileData = (map<String,Object>)countryFileDataMap.get(cc.Country__c);
	childAttachList.add(createChildAttachment(childFileData, cc.Id));
	System.Debug(childFileData);
	  }
	}
	database.insert(childAttachList);
   }
   catch(Exception e){
	System.debug('error'+e.getMessage());
   }
	  //}
   try{
	  List<junction__c> lstJun = new List<junction__c>();
	  List<Partner_Company__c> lstPartner = [select id, Name from Partner_Company__c where Partner_Type__c= 'Distributor' and Partner_Name__r.Name in : distName];
		system.debug('onlyParentRequired+distName' + distName);
	  system.debug('onlyParentRequired+Partner_Company__c' + lstPartner);
	  Set<ID> caseids = new Set<ID>();
	  Set<ID> partnercompanyid = new Set<ID>();
	  
	  if(onlyParentRequired) {
		for(Partner_Company__c pc : lstPartner){
			junction__c jun = new junction__c();
			jun.Case__c = parentId;
			jun.Partner_Company__c = pc.id;
			lstJun.add(jun);
			partnercompanyid.add(pc.id);
	}
		caseids.add(parentId);
	  }else {
		for(Partner_Company__c pc : lstPartner) {
			for(Case c : childCases) {
	if(c.Distributor_with_whom_transact_business__c.contains(pc.Name)) {
	  junction__c jun = new junction__c();
	  jun.Case__c = c.id;
	  jun.Partner_Company__c = pc.id;
	  lstJun.add(jun);
	  caseids.add(c.id);
	  partnercompanyid.add(pc.id);
	}
			}
		}
	}
	  system.debug('lstJun--427'+lstJun);
		/*for(Partner_Company__c pc : lstPartner){
	junction__c jun = new junction__c();
	jun.Case__c = obj.id;
	jun.Partner_Company__c = pc.id;
	lstJun.add(jun);
	 }*/
	  if(lstJun.size()>0){
		system.debug('lstJun--427 -insert');
		List<junction__c> verijun = [Select id from junction__c where Case__c in:caseids AND Partner_Company__c in:partnercompanyid Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		system.debug('verijunlist------'+verijun);
		if(!(verijun.size()>0)){
			insert lstJun;
		}
	  }
	  
	  if(String.isNotBlank(fileName) && fileName != null){
		saveTheChunk(parentId, fileName,base64Data, contentType, fileId); 
  
	  }
   //success_Message= System.Label.PS_SelfService_SuccessMessage+' '+CaseNumber+'.';
	  if(caseStatus == 'New') {
		List<Case> caseList = [SELECT Id from Case where Status = 'Draft' and ParentId =: parentId];
		if(caseList.size() > 0 ) {
			delete caseList;
		}
	  }
	}catch(dmlexception e) {
		ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.mGetCaseDetails);
	  }
	}
  
  /**
* Description : Method to upload file in chatterfeed
* @param Id parentID ,String fileName, String base64Data, String contentType
* @return Id
* @throws NA
**/
  @AuraEnabled
  public static Id saveTheFile( Id parentID ,String fileName, String base64Data, String contentType) { 
	Attachment attach = new Attachment();
	try{
	  String base64Data1 = EncodingUtil.urlDecode(base64Data, PRMGlobalConstants.FileUTF);
	  attach.parentId = parentID;
	  attach.Body = EncodingUtil.base64Decode(base64Data1);
	  attach.Name = fileName;
	  attach.ContentType = contentType;
	  database.insert(attach);
	}catch(dmlexception e) {
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.saveTheFile);
	  //String message=e.getMessage();//unused variable
   
	}
	return attach.id;
  } 
  /**
* Description : Method to save file
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
	String fileIdUpdated = fileId;
	try{
	  if (String.isBlank(fileIdUpdated)|| fileIdUpdated.equalsIgnoreCase(null)) {
  fileIdUpdated = saveTheFile(parentId, fileName, base64Data, contentType);
	  } else {
  appendToFile(fileIdUpdated, base64Data);
	  }
	}Catch(System.Exception e){
  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.saveTheChunk);
	 // String message=e.getMessage();//unused variable
	}
	return Id.valueOf(fileIdUpdated);
  }
  
  /**
* Description : Method to save file
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @TestVisible private static void appendToFile(Id fileId, String base64Data) {
	String base64Data1 = EncodingUtil.urlDecode(base64Data, PRMGlobalConstants.FileUTF);
	try{
	  Attachment attach = [SELECT Id, Body
	 FROM Attachment
	 WHERE Id = :fileId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
	  
	  String existingBody = EncodingUtil.base64Encode(attach.Body);
	  attach.Body = EncodingUtil.base64Decode(existingBody + base64Data1); 
	  database.update(attach);
	}
	catch(dmlexception e) {
	  //String message=e.getMessage();//unused variable

	}
  }
  /**
* Description : Method to get case market
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseMarket(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Select_Your_Market__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
		options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseMarket);
	  //String message=e.getMessage();//unused variable	  
	}
	return options;
  }
  /**
* Description : Method to get company type
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseCompanytype(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Company_type_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
		options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseCompanytype);
	 // String message=e.getMessage();//unused variable
	}
	return options;
  }
  /**
* Description : Method to get case annual Revenue
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseAnnualRevenue(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Annual_revenues_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
		options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseAnnualRevenue);
	  //String message=e.getMessage();//unused variable
	  
	}
	return options;
  }
  /**
* Description : Method to getCaseRevServices 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseRevServices(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Percentage_revenues_through_Services_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
		options.add(f.getLabel());
	  }
	  
	} 
	Catch(System.Exception e) {
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseRevServices);
	 // String message=e.getMessage();//unused variable
	  
	}
	return options;
  }
  /**
* Description : Method to getCaseNumOfEmployees 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseNumOfEmployees(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Total_Number_of_employees_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseNumOfEmployees);
	  //String message=e.getMessage();//unused variable
	  
	}
	return options;
  }
  /**
* Description : Method to getCaseTechProfessional 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseTechProfessional(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Percentage_of_Technical_Professionals_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e) {
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseTechProfessional);}
	return options;
  }
  /**
* Description : Method to getCaseEmpInSales 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseEmpInSales(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Percentage_of_Total_EmployeesIn_Sales_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseEmpInSales); }
	return options;
  }
  /**
* Description : Method to getCaseEmpInService 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseEmpInService(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Percentage_of_Total_Employees_in_Serv_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e) {
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseEmpInService);
	  
	}
	return options;
  }
  /**
* Description : Method to getCaseEmpInMarketing 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseEmpInMarketing(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.of_Total_Employees_in_Marketing_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseEmpInMarketing);}
	return options;
  }
  /**
* Description : Method to getCaseRepNokia 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseRepNokia(){
	List<String> options = new List<String>();
	try{
	  Schema.DescribeFieldResult fieldResult = case.of_Employees_to_represent_Nokia_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseRepNokia);}
	return options;
  }   
  /**
* Description : Method to getCaseVerticalFocus 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseVerticalFocus(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Top_3_Targeted_Vertical_focus_Industries__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	Catch(System.Exception e){
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseVerticalFocus);}
	return options;
  }   
  /**
* Description : Method to getCaseManufacture 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseManufacture(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Current_Manufacturers_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	catch(System.Exception e){
		//String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseManufacture); }
	return options;
  }   
  /**
* Description : Method to getCasePrimaryInterest 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCasePrimaryInterest(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Primary_Interest_CP__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	catch(System.Exception e) {
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCasePrimaryInterest);}
	return options;
  }   
  /**
* Description : Method to getCaseMaintenanceSupport 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseMaintenanceSupport(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Offer_your_own_Maintenance_and_Support__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	catch(System.Exception e) {
	  //String message=e.getMessage();//unused variable
	 ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseMaintenanceSupport);}
	return options;
  }
   /**
* Description : Method to getCaseCountry 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseAllState(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.State__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	catch(System.Exception e){
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseCountry);
	  
	}
	return options;
  } 
  /**
* Description : Method to getCaseCountry 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseCountry(){
	List<String> options = new List<String>();
	try{
	  
	  Schema.DescribeFieldResult fieldResult = case.Country__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	  
	}
	catch(System.Exception e){
		//String message=e.getMessage();//unused variable
		ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseCountry);}
	return options;
  } 
  
  /**
* Description : Method to getCaseState 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseState(){
	List<String> options = new List<String>();
	try{
	  Schema.DescribeFieldResult fieldResult = case.State__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	}
	catch(System.Exception e){
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseState);}
	return options;
  }   
  /**
* Description : Method to getCaseSellNokia 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseSellNokia(){
	List<String> options = new List<String>();
	try
	{
	  
	  Schema.DescribeFieldResult fieldResult = case.Which_countries__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }
	}
	catch(System.Exception e)  {
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseSellNokia);}
	return options;
  }
  /**
* Description : Method to getDistributor 
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getDistributor(String market){
	String distName=PRMGlobalConstants.Distr;
	List<String> options = new List<String>();
	try{
	  if(String.isNotBlank(market) || market != null){
  for(Partner_Company__c c : [select Partner_Name__r.name  from Partner_Company__c 
	where Market__c=:market and Partner_Type__c=:distName 
	order by Partner_Name__r.name Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	  options.add(c.Partner_Name__r.name);
	}
	  }
	  
	}
	catch(System.Exception e) {
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getDistributor); }
	return options;
	
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
* Description : Method to get case market   
* @param Strings to stamp values to case object
* @return String to with case number
* @throws NA
**/
  @AuraEnabled
  public static List<String> getCaseSalesTerr(){
	List<String> options = new List<String>();
	try{
	  Schema.DescribeFieldResult fieldResult = case.Which_Sales_Territory_Country_Are_You__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  
	  for (Schema.PicklistEntry f: ple) {
  options.add(f.getLabel());
	  }	
	}
	catch(System.Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseSalesTerr);
	  //String message=e.getMessage();//unused
	  }
	return options;
  }
  /**
* Description : Method to get Employee Departure Years   
* @param NA
* @return List<String>
* @throws NA
**/
  @AuraEnabled
  public static List<String> getDepartureYears(){
	List<String> options = new List<String>();
	try{
	  Schema.DescribeFieldResult fieldResult = case.PRM_Year_of_Departure__c.getDescribe();
	  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	  
	  for (Schema.PicklistEntry f: ple) {
	options.add(f.getLabel());
	  }	
	}
	catch(System.Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getCaseSalesTerr);
	  //String message=e.getMessage();//unused
	  }
	return options;
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
  
  //system.debug('loginCaseNumber>>>>>>>>>'+loginCaseNumber);
  //Case logincase ;//unused variable
  List<Case> caseList = new List<Case>();
  retObj.CaseMap = new Map<string,Map<String,String>>();
  
  List<String> caseChildList = new List<String>();
  caseList = [Select Id, PB_Email__c, Provide_a_detailed_expelanation__c,Postal_Code_per_country__c, Guideline_URL__c, Describe__c, Organizations_which_your_company_belong__c, Annual_industry_conferences_you_attend__c, Persons_responsible_for_work__c, Describe_your_current_business_activity__c, Describe_the_expereince_or_relationships__c, H_First_Name__c, H_Last_Name__c, PRM_H_Title__c, State__c, First_Name__c, PB_First_Name__c, PB_Last_Name__c, PB_Mobile_Phone__c, PB_Office_Phone__c, Pri_Retype_Email__c, PB_Title__c, Last_Name__c, Email__c, Mobile_Phone__c, Office_Phone__c, CRetype_Email__c, Title__c, Offer_your_own_Maintenance_and_Support__c, Current_Manufacturers_CP__c, Who_are_your_leading_competitors__c, Which_countries__c,Primary_Interest_CP__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_Sales_Territory_are_You__c,Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,Country__c,Phone_No__c,State_Province_per_country__c,FAX__c,Company_s_Website__c,Number_of_Branch_locations_CHQ__c,Branch_Offices__c,Full_Legal_Name_of_Your_Organization_CP__c,VAT_Number__c,Dun_Bradstreet_D_U_N_S_Number_CP__c,Company_type_CP__c,Number_of_years_in_business_CP__c,Annual_revenues_CP__c,Percentage_revenues_through_Services_CP__c,Total_Number_of_employees_CP__c,Percentage_of_Technical_Professionals_CP__c,Percentage_of_Total_Employees_in_Serv_CP__c,Percentage_of_Total_EmployeesIn_Sales_CP__c,of_Total_Employees_in_Marketing_CP__c,of_Employees_to_represent_Nokia_CP__c,Are_you_already_a_Nokia_Direct_Reseller__c,Willing_to_resell_to_USA_Federal_CP__c ,Willing_to_sell_to_non_USA_Govt_CP__c ,Bribery_or_corruption__c ,Current_criminal_investigation_pending__c ,Code_of_Conduct_Compliance_program__c , Anti_corruption_training_to_employees__c ,Direct_Indirect_ownership_in_Company__c , STREET_ADDRESS_1_CHQ__c , POSTAL_CODE_CHQ__c , PHONE_NO_CHQ__c , EMAIL_DOMAINS_CHQ__c, STREET_ADDRESS_2_CHQ__c , STREET_ADDRESS_3_CHQ__c , Company_website_CHQ__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,PRM_Is_former_Nokia__c,PRM_Last_Title__c,PRM_Year_of_Departure__c FROM case WHERE CaseNumber =: loginCaseNumber and status='Draft'];
  if(!caseList.IsEmpty()){
	retObj.CaseObj = caseList[0];
	List<Case> childCases = [SELECT  Country__c,Primary_Interest_CP__c,Postal_Code_per_country__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_countries__c,Which_Sales_Territory_are_You__c,id,Affiliates_Subsidiary_Name__c,Company_Registration_Number__c,Street_Address_1__c,Street_Address_2__c,Company_s_Website__c,Street_Address_3__c,Email_Domain__c,Phone_No__c,Fax_per_country__c,City_per_country__c,First_Name_Sales__c,Last_Name_Sales__c,Email_Sales__c,Primary_Phone_Sales__c,First_Name_Marketing__c,Last_Name_Marketing__c,Email_Marketing__c,Primary_Phone_Marketing__c,First_Name_Service__c,Last_Name_Service__c,Email_Service__c,Primary_Phone_Service__c,Distributor_with_whom_transact_business__c,State_Province_per_country__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c from case where ParentId=:caseList[0].Id AND Country__c!=null];

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
	  if(caseIns.Fax_per_country__c != null){
  countryDetails.put('fax',caseIns.Fax_per_country__c);
	  }else{
  countryDetails.put('fax','');
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
	  if(caseIns.First_Name_Marketing__c != null){
  countryDetails.put('markfname',caseIns.First_Name_Marketing__c);
	  }else{
  countryDetails.put('markfname','');
	  }
	  if(caseIns.Last_Name_Marketing__c != null){
  countryDetails.put('marklname',caseIns.Last_Name_Marketing__c);
	  }else{
  countryDetails.put('marklname','');
	  }
	  if(caseIns.Email_Marketing__c != null){
  countryDetails.put('markemail',caseIns.Email_Marketing__c);
	  }else{
  countryDetails.put('markemail','');
	  }
	  if(caseIns.Primary_Phone_Marketing__c != null){
  countryDetails.put('markphone',caseIns.Primary_Phone_Marketing__c);
	  }else{
  countryDetails.put('markphone','');
	  }
	  if(caseIns.First_Name_Service__c != null){
  countryDetails.put('servfname',caseIns.First_Name_Service__c);
	  }else{
  countryDetails.put('servfname','');
	  }
	  if(caseIns.Last_Name_Service__c != null){
  countryDetails.put('servlname',caseIns.Last_Name_Service__c);
	  }
	  else{
  countryDetails.put('servlname','');
	  }
	  if(caseIns.Email_Service__c != null){
  countryDetails.put('servemail',caseIns.Email_Service__c);
	  }
	  else{
  countryDetails.put('servemail','');
	  }
	  if(caseIns.Primary_Phone_Service__c != null){
  countryDetails.put('servphone',caseIns.Primary_Phone_Service__c);
	  }else{
  countryDetails.put('servphone','');
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
	  retObj.CaseMap.put(caseIns.Country__c,countryDetails);	
	}
	//system.debug('>>>>'+retObj.CaseMap);
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
	  //String message=e.getMessage();//unused variable
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.getDistributor);}
	return options;	
  }
  
  
  @auraEnabled
  public static case saveAndReturn(string details){
   List<RecordType> recordTypeID_case = [Select Id FROM RecordType 
  WHERE SobjectType =: PRMGlobalConstants.CaseName and DeveloperName =: PRMGlobalConstants.recordType_case LIMIT 1] ;
	List<String> detailsList = (List<String>)JSON.deserialize(details,List<String>.class);
	Case obj=new Case();
	obj.RecordTypeId = recordTypeID_case[0].Id;
	obj.Status=PRMGlobalConstants.CaseStatus;
	obj.Subject='IR Application – ['+detailsList[4]+']';
	obj.Description='IR Application – ['+detailsList[4]+']';
	//obj.Select_Your_Market__c = detailsList[0];
	obj.STREET_ADDRESS_1_CHQ__c = detailsList[1];
	obj.City__c = detailsList[0];
	obj.POSTAL_CODE_CHQ__c = detailsList[2];
	obj.Country__c = detailsList[14];
	obj.PHONE_NO_CHQ__c = detailsList[3];
	//obj.State__c = detailsList[7];
	obj.EMAIL_DOMAINS_CHQ__c = detailsList[4];
	obj.Full_Legal_Name_of_Your_Organization_CP__c = detailsList[13];
	obj.Company_type_CP__c = detailsList[7];
	
	insert obj;
	return obj;
	
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
	  //String message=e.getMessage();//unused variable
	}
	return TermValue;
  }
  
   private static Attachment createChildAttachment(map<String,Object> childFileData, Id ccId)
   {
  Attachment att = new Attachment();
  try
  {
	  String base64Data = String.valueOf(childFileData.get('base64Data'));
	  String base64Data1 = EncodingUtil.urlDecode(base64Data, PRMGlobalConstants.FileUTF);
	  att.parentId = ccId;
	  att.Body = EncodingUtil.base64Decode(base64Data1);
	  att.Name = String.valueOf(childFileData.get('fileName'));
	  att.ContentType = String.valueOf(childFileData.get('contentType'));
	}
	catch(dmlexception e)
	{
	  ExceptionHandler.addException(e,PRMGlobalConstants.IRApplicationCase,PRMGlobalConstants.saveTheFile);
	 // String message=e.getMessage();//unused variable
	}
	return att;
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