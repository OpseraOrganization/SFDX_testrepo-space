/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:		   VARApplicationForm
Description:	 VARApplicationForm class to get values and perform DML operations on Case object
Date		Version   Author		Summary of Changes 
-----------   ----------	  ----------------- ---------------------------------------------------------------------------------------------------
01/08/2016	1.0	   Anukriti			Initial Release for VAR application Form
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class VARApplicationForm {
	public static id pageid {get; set;}
	public static case caseDetails{get;set;}
	
	/**
	* Description : blank constructor 
	* @param NA
	* @return User
	* @throws NA
	**/
	public VARApplicationForm(ApexPages.StandardController controller) {
		pageid = ApexPages.currentPage().getParameters().get('Id');
		caseDetails =  [Select caseNumber from Case where id=:pageid Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		Apexpages.currentPage().getHeaders().put(PRMGlobalConstants.contentdisposition, PRMGlobalConstants.attachment_PDF);
	}
	
	/**
	* Description : Method to fetch current user's details for Lightning Components
	* @param NA
	* @return User
	* @throws NA
	**/
	@AuraEnabled
	public static User getCurrentUser() {
		User user1 = new User();
		try{
			user1 = [SELECT Id, ContactId, Contact.FirstName, Contact.LastName, Contact.Email,
					 Contact.Title, Contact.Phone, Contact.MobilePhone 
					 FROM User 
					 WHERE Id = :UserInfo.getUserId() LIMIT 1];
			if(user1.Contact.FirstName == null) {
				user1.Contact.FirstName = PRMGlobalConstants.EMPTY_STRING;
			}
			if(user1.Contact.Title == null) {
				user1.Contact.Title = PRMGlobalConstants.EMPTY_STRING;
			}
			if(user1.Contact.Phone == null) {
				user1.Contact.Phone = PRMGlobalConstants.EMPTY_STRING;
			}
			if(user1.Contact.MobilePhone == null) {
				user1.Contact.MobilePhone = PRMGlobalConstants.EMPTY_STRING;
			}
		}Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCurrentUser);
		}
		return user1;
	}
	
	/**
	* Description : Method to create case and contact
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> mGetCaseDetails(String details,Id parentId,String[] CountryToSell,
											   String[] vertical,String[] ManufactureRep,String[] PrimaryInterest,
											   String fileName,String base64Data,String contentType,String fileId, 
											   String[] SalesTerritory, String CountryData, String[] terrSelected) 
	{
		List<String> idwithCaseNumber = new List<String>();
		String success_Message;
		String errorMsg;
		String recordType_case = PRMGlobalConstants.CASE_VAR_RECORDTYPE;
		String vertic = GlobalConstants.BLANK_VALUE;
		String manufact = GlobalConstants.BLANK_VALUE;
		String primaryInt = GlobalConstants.BLANK_VALUE;
		String distribut = GlobalConstants.BLANK_VALUE;
		String countrySell = GlobalConstants.BLANK_VALUE;
		String SalesTerr = GlobalConstants.BLANK_VALUE;
		
		Case obj=new Case();
		Case casenum;
		//boolean val;
		List<RecordType> recordTypeID_case = [Select Id FROM RecordType WHERE SobjectType =: PRMGlobalConstants.CaseName 
											  and DeveloperName =: recordType_case LIMIT 1] ;
		try{
			//String[] Distributor = new  List<String>();
			System.debug('CountryData::'+CountryData);
			Map<String, Object> countryDataMap = (Map<String, Object>)JSON.deserializeUntyped(CountryData);
			System.debug('countryDataMap::'+countryDataMap);
			List<String> detailsList = (List<String>)JSON.deserialize(details,List<String>.class);
			RecordType recordTypeID_caseobj=recordTypeID_case.get(0);
			obj.RecordTypeId = recordTypeID_caseobj.Id;
			obj.Status=PRMGlobalConstants.CaseStatus;
			obj.Subject='VAR Application – ['+detailsList[9]+']';
			obj.Description='VAR Application – ['+detailsList[9]+']';
			//obj.Select_Your_Market__c = detailsList[0];
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
			obj.MC_First_Name__c = detailsList[29];
			obj.MC_Last_Name__c = detailsList[30];
			obj.MC_Email__c = detailsList[31];
			obj.SC_First_Name__c = detailsList[32];
			obj.SC_Last_Name__c = detailsList[33];
			obj.SC_Email__c = detailsList[34];
			obj.SC_Primary_Phone__c = detailsList[35];
			obj.MC_Primary_Phone__c = detailsList[36];
			obj.SEC_First_Name__c = detailsList[37];
			obj.SEC_Last_Name__c = detailsList[38];
			obj.SEC_Email__c = detailsList[39];
			obj.SEC_Primary_Phone__c = detailsList[40];
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
			obj.VAT_Number__c = detailsList[83];
			obj.AccountId = detailsList[84];
			for(String s:vertical){
				vertic+=s+';';
			}
			for(String s:SalesTerritory){
				SalesTerr+=s+';';
			}
			for(String s:PrimaryInterest){
				primaryInt+=s+';';
			}
			
			for(String s:CountryToSell){
				countrySell+=s+';';
			}
			System.debug('SalesTerr::'+SalesTerr);
			obj.Which_countries__c = countrySell;
			List<Case> childCases = new List<Case>();
			Id childCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE).getRecordTypeId();
			Database.DMLOptions dmo = new Database.DMLOptions();
			dmo.AssignmentRuleHeader.useDefaultRule = true;
			System.debug('childCases::'+childCases);
			Set<String> distName = new Set<String>();
			for(String countryKey : countryDataMap.keySet() ){
				System.debug('Country'+countryKey);
				if(!terrSelected.contains(countryKey)) {
					continue;
				}
				Case cc = new Case();
				cc.Subject = 'IR Application – ['+detailsList[9]+'] - ['+countryKey+']' ;
				cc.Description = 'IR Application – ['+detailsList[9]+'] - ['+countryKey+']' ;
				//cc.Sales_to_Country__c = countryKey;
				cc.Country__c = countryKey;
				cc.RecordTypeId = childCaseRecordTypeId;
				cc.Full_Legal_Name_of_Your_Organization_CP__c = detailsList[9];
				cc.PB_First_Name__c = detailsList[21];
				cc.PB_Last_Name__c = detailsList[22];
				cc.PB_Email__c = detailsList[24];
				cc.Which_Sales_Territory_are_You__c = salesTerr;
				obj.Which_countries__c = countrySell;
				cc.setOptions(dmo);
				map<String,Object> valueKey = (map<String,Object>) countryDataMap.get(countryKey);  
				for(String fieldKey : valueKey.keySet()) {
					System.debug(fieldKey +' values :'+valueKey.get(fieldKey));
					if(Country_To_Market__c.getValues(countryKey) != null) {
						cc.Select_Your_Market__c = Country_To_Market__c.getValues(countryKey).Market__c;
					} 
					// cc.Select_Your_Market__c = detailsList[0];
					cc.Primary_Interest_CP__c = primaryInt;
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
					}
				}
				childCases.add(cc);   
			} 
			for(String s:ManufactureRep){
				manufact+=s+';';
			}
			
			
			//Start Modification By Priyanka , Date:05/12/2017 , Req#3731
			/*List<String> distName = new List<String>();
			for(String s:Distributor){
			List<String> dist = s.split('\\s\\-\\s');
			s = dist[0];
			distName.add(s);
			
			}
			
			for(String s:Distributor){
			distribut+=s+';';
			}*/
			//Integer i = distribut.lastIndexOf(';');
			//system.debug('Integer'+i);
			//distribut = distribut.substring(0,i);
			//End Modification By Priyanka
			obj.Which_countries__c = countrySell;
			//obj.Distributor_with_whom_transact_business__c = distribut;
			obj.Top_3_Targeted_Vertical_focus_Industries__c = vertic;
			obj.Current_Manufacturers_CP__c = manufact;
			obj.Primary_Interest_CP__c = primaryInt;
			obj.FAX__c = detailsList[43];
			obj.Which_Sales_Territory_are_You__c = SalesTerr;
			if(detailsList[45]!= ' '){
				obj.Number_of_Branch_locations_CHQ__c = Integer.valueof(detailsList[45]); 
			}
			obj.Dun_Bradstreet_D_U_N_S_Number_CP__c = detailsList[48]; 
			
			if(detailsList[51]!= ' '){
				obj.Number_of_years_in_business_CP__c = Integer.valueof(detailsList[51]); 
			}
			Boolean onlyParentRequired = false;
			System.debug('Dataset Size'+countryDataMap.size());
			System.debug('Dataset'+detailsList[5]);
			if(terrSelected.size() == 1 && terrSelected.contains(detailsList[5])) {
				obj.Is_Headquater__c = true;
				obj.Distributor_with_whom_transact_business__c = distribut;
				dmo.AssignmentRuleHeader.useDefaultRule = true;
				obj.setOptions(dmo);
				onlyParentRequired = true;
			}
			insert obj;
			
			if(!onlyParentRequired) {
				for(Case c : childCases) {
					c.ParentId = obj.Id;
				}
				try{
					insert childCases;
				}catch(Exception e) {
					System.debug('message :::'+e.getMessage());
				}
			}
			
			
			List<junction__c> lstJun = new List<junction__c>();
			List<Partner_Company__c> lstPartner = [select id, Name from Partner_Company__c where Partner_Type__c=:distName and Partner_Name__r.Name in : distName Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('hello'+lstPartner);
			if(onlyParentRequired) {
				for(Partner_Company__c pc : lstPartner){
					junction__c jun = new junction__c();
					jun.Case__c = obj.id;
					jun.Partner_Company__c = pc.id;
					lstJun.add(jun);
				}
			}else {
				for(Partner_Company__c pc : lstPartner) {
					for(Case c : childCases) {
						if(c.Distributor_with_whom_transact_business__c.contains(pc.Name)) {
							junction__c jun = new junction__c();
							jun.Case__c = c.id;
							jun.Partner_Company__c = pc.id;
							lstJun.add(jun);
						}
					}
				}
			}
			/*for(Partner_Company__c pc : lstPartner){
			junction__c jun = new junction__c();
			jun.Case__c = obj.id;
			jun.Partner_Company__c = pc.id;
			lstJun.add(jun);
			}*/
			if(lstJun.size()>0){
				insert lstJun;
			}
			
			casenum = [select id,CaseNumber from Case where id =:Obj.Id Limit 1];
			String CaseNumber = casenum.CaseNumber;
			parentId = Obj.Id;
			idwithCaseNumber.add(parentId);
			success_Message= System.Label.PS_SelfService_SuccessMessage+' '+CaseNumber+'.';
			idwithCaseNumber.add(success_Message);
		} 
		catch(dmlexception e) {ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.mGetCaseDetails);
							   errorMsg = e.getMessage();
							   if(String.ISBLANK(errorMsg)){
								   success_Message =   System.label.PS_SelfService_ErrorMessage;
								   idwithCaseNumber.add(success_Message);
							   } 
							  }  
		return idwithCaseNumber;
	}
	
	
	/**
	* Description : Method to get case market
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseMarket() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Select_Your_Market__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseMarket);
			//String message=e.getMessage();
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
	public static List<String> getCaseCompanytype() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Company_type_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseCompanytype);
			//String message=e.getMessage();
			
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
	public static List<String> getCaseAnnualRevenue() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Annual_revenues_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) { 
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseAnnualRevenue);
			//String message=e.getMessage();
			
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
	public static List<String> getCaseRevServices() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Percentage_revenues_through_Services_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseRevServices);
			//String message=e.getMessage();
			
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
	public static List<String> getCaseNumOfEmployees() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Total_Number_of_employees_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseNumOfEmployees);
			//String message=e.getMessage();
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
	public static List<String> getCaseTechProfessional() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Percentage_of_Technical_Professionals_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseTechProfessional);
		}
		return options;
	}
	
	/**
	* Description : Method to getCaseEmpInSales 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseEmpInSales() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Percentage_of_Total_EmployeesIn_Sales_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseEmpInSales);
		}
		return options;
	}
	/**
	* Description : Method to getCaseEmpInService 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseEmpInService() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Percentage_of_Total_Employees_in_Serv_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		} Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseEmpInService);
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
	public static List<String> getCaseEmpInMarketing() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.of_Total_Employees_in_Marketing_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseEmpInMarketing);
		}
		return options;
	}
	/**
	* Description : Method to getCaseRepNokia 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseRepNokia() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.of_Employees_to_represent_Nokia_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		} Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseRepNokia);
		}
		return options;
	}   
	
	/**
	* Description : Method to getCaseVerticalFocus 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseVerticalFocus() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Top_3_Targeted_Vertical_focus_Industries__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseVerticalFocus);
		}
		return options;
	}   
	
	/**
	* Description : Method to getCaseManufacture 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseManufacture() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Current_Manufacturers_CP__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseManufacture);
		}
		return options;
	}   
	
	/**
	* Description : Method to getCaseMaintenanceSupport 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseMaintenanceSupport() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Offer_your_own_Maintenance_and_Support__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseMaintenanceSupport);
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
	public static List<String> getCaseCountry() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Country__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) { 
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseCountry);
		}
		return options;
	} 
	
	/**
	* Description : Method to getCaseState 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseState() {
		try{
			List<String> options = new List<String>();
			Schema.DescribeFieldResult fieldResult = case.State__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
			return options;
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseState);
			return null;
		}
	}   
	
	/**
	* Description : Method to getCaseSellNokia 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseSellNokia() {
		List<String> options = new List<String>();
		try
		{
			Schema.DescribeFieldResult fieldResult = case.Which_countries__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseSellNokia);
		}
		return options;
	}
	
	/**
	* Description : Method to getDistributor 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getDistributor(String market) {
		String Distributor=PRMGlobalConstants.Distr;
		List<String> options = new List<String>();
		try{
			if(String.isNotBlank(market) || market != null) {
				for(Partner_Company__c c : [SELECT Partner_Name__r.name,Country_Headquarters__c 
											FROM Partner_Company__c 
											WHERE Market__c=:market AND Partner_Type__c=:Distributor 
											order by Partner_Name__r.name Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
												options.add(c.Partner_Name__r.name + PRMGlobalConstants.dash + c.Country_Headquarters__c);
											}
			}
		}Catch(System.Exception e) {
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getDistributor);
		}
		return options;
	}
	
	/**
	* Description : Method to getStateValues 
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getStateValues(String country) {
		List<String> options = new List<String>();
		try{   
			List<Country_State_Dependency__c> lstState = [SELECT name,state__c,country__c 
														  FROM Country_State_Dependency__c 
														  order by state__c 
														  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(lstState.size()>0){
				for(Country_State_Dependency__c c:lstState) {
					if(c.Country__c == country){
						options.add(c.State__c);
					}
				}
			}
		}Catch(System.Exception e) { 
			//String message=e.getMessage();
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getDistributor);
		}
		return options;
	}
	
	/**
	* Description : Method to get case market
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static List<String> getCaseSalesTerr() {
		List<String> options = new List<String>();
		try{
			Schema.DescribeFieldResult fieldResult = case.Which_Sales_Territory_Country_Are_You__c.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			
			for (Schema.PicklistEntry f: ple) {
				options.add(f.getLabel());
			}	 
		} Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getCaseSalesTerr);
			//String message=e.getMessage();
		}
		return options;
	}
	
	/**
	* Description : Method to get acount information
	* @param Strings to stamp values to case object
	* @return String to with case number
	* @throws NA
	**/
	@AuraEnabled
	public static Account getValuesFromAccount(Id accId) {
		Account acc = new Account();
		try{
			acc = [SELECT Id, Name, Email_Domain__c, Website, Phone, BillingStreet, BillingCity, BillingPostalCode,
				   BillingCountry, BillingState, Market__c
				   FROM Account
				   WHERE ID = : accId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(acc.Website == null) {
				acc.Website = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.Email_Domain__c == null) {
				acc.Email_Domain__c = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.Phone == null) {
				acc.Phone = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.BillingStreet == null) {
				acc.BillingStreet = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.BillingCity == null) {
				acc.BillingCity = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.BillingPostalCode == null) {
				acc.BillingPostalCode = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.BillingCountry == null) {
				acc.BillingCountry = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.BillingState == null) {
				acc.BillingState = PRMGlobalConstants.EMPTY_STRING;
			}
			if(acc.Market__c == null) {
				acc.Market__c = PRMGlobalConstants.EMPTY_STRING;
			}
		} Catch(System.Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.VARApplicationCase,PRMGlobalConstants.getValuesFromAccount);
		}
		return acc;
	}
	
}