@isTest
public class IRApplicationCaseTest {
	static Id accRectype = Schema.describeSObjects(new List<String>{'Account'})[0].getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
	static Id childCaseRectype = Schema.describeSObjects(new List<String>{'Case'})[0].getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE).getRecordTypeId();
	static Id parentCaseRectype = Schema.describeSObjects(new List<String>{'Case'})[0].getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
	
	@testSetup
	static void testDataSetup(){
		Map<String,String> ctmMap = new Map<String,String>{'Afghanistan'=>'Market Middle East and Africa',
			'Aland Islands'=>'Market Europe',
			'Albania'=>'Market Europe',
			'Bulgaria'=>'Market Europe'
			};
	
	List<Country_To_Market__c> ctmLst = new List<Country_To_Market__c>();
		for(String cntry : ctmMap.keyset()){
			ctmLst.add( new Country_To_Market__c(Name= cntry, Market__c= ctmMap.get(cntry)) );   
		}
		
		if(ctmLst.size()>0)
			insert ctmLst;
		
		
		
		Account acct = new Account(name='PRM Test Account NIRA',recordtypeid=accRectype);
		insert acct;
		
		Map<String,String> partnerCmpMap = new Map<String,String>{'Market Europe'=>'Åland Islands;Albania;Bulgaria',
			'Market Middle East and Africa'=>'Afghanistan'};
	
	List<Partner_Company__c> pcLst = new List<Partner_Company__c>();
		
		for(String market : partnerCmpMap.keySet()){
			pcLst.add(new Partner_Company__c(
	Partner_Name__c = acct.id,
	Country_Headquarters__c = partnerCmpMap.get(market),
	Market__c = market,
	Partner_Type__c = 'Distributor'
			));
		}
		
		if(pcLst.size()>0)
			insert pcLst;
		
		Map<String, String> stateMap = new Map<String,String>{'Karnataka'=>'India'};
			List<Country_State_Dependency__c> cstMap = new List<Country_State_Dependency__c>();
		
		for(String state:stateMap.keySet())
			cstMap.add(new Country_State_Dependency__c(State__c=state, Country__c=stateMap.get(state),Name=state));
		
		if(cstMap.size()>0)
			insert cstMap;
		
		Multi_Language_Terms__c MultiLang = new Multi_Language_Terms__c(Language__c='English', Terms__c='Test Terms');
		insert MultiLang;
		
		ContentVersion content=new ContentVersion(); 
		content.Title='NIRA_TEST_DOC'; 
		content.PathOnClient='/' + content.Title + '.pdf'; 
		Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
		content.VersionData=bodyBlob; 
		content.origin = 'H';
		insert content;
		
		
		Case parentCase = new Case();
		parentCase.Subject='IR Application – []';
		parentCase.Description='IR Application – []';
		parentCase.RecordTypeId = parentCaseRectype;
		parentCase.First_Name__c= 'TestName1';
		parentCase.Last_Name__c= 'Lastname1';
		parentCase.Title__c= 'Mr';
		parentCase.Email__c= 'test@test.com';
		parentCase.Office_Phone__c= '123123123123';
		parentCase.PB_First_Name__c= 'TestName1';
		parentCase.PB_Last_Name__c= 'Lastname1';
		parentCase.PB_Title__c= 'Mr';
		parentCase.PB_Email__c= 'test@test.com';
		parentCase.PB_Office_Phone__c= '123123123123';
		parentCase.H_First_Name__c= 'TestHName';
		parentCase.H_Last_Name__c= 'TestLname';
		parentCase.PRM_H_Title__c= 'Mr';
		parentCase.STREET_ADDRESS_1_CHQ__c= 'Addressline1';
		parentCase.STREET_ADDRESS_2_CHQ__c= 'addressline2';
		parentCase.STREET_ADDRESS_3_CHQ__c= 'addressline3';
		parentCase.City__c= 'TestCity';
		parentCase.POSTAL_CODE_CHQ__c= '530442';
		parentCase.Country__c= 'Afghanistan';
		parentCase.PHONE_NO_CHQ__c= '1123123';
		parentCase.State__c= '';
		parentCase.Company_website_CHQ__c= 'test.com';
		parentCase.EMAIL_DOMAINS_CHQ__c= '@test.com;@test1.com';
		parentCase.Full_Legal_Name_of_Your_Organization_CP__c= 'TestLegalName';
		parentCase.VAT_Number__c= '1321313';
		parentCase.Dun_Bradstreet_D_U_N_S_Number_CP__c= '123123';
		parentCase.Company_type_CP__c= 'Publicly Traded';
		parentCase.Annual_revenues_CP__c= '10ME -50 ME';
		parentCase.Total_Number_of_employees_CP__c= '51-100';
		parentCase.Which_Sales_Territory_are_You__c= 'Afghanistan;Åland Islands;Albania';
		parentCase.Willing_to_resell_to_USA_Federal_CP__c= 'Yes';
		parentCase.Primary_Interest_CP__c= 'Vital Products;Video Analytics';
		parentCase.List_Ref_and_4G_5G_Experience__c= '';
		parentCase.Radio_Frequency_Expirience__c= '';
		parentCase.Radio_Networks_Installation_Experience__c= '';
		parentCase.Tier1_Tier2_Support_Level__c= '';
		parentCase.Describe_your_current_business_activity__c= '';
		parentCase.Describe_the_expereince_or_relationships__c= '';
		parentCase.PRM_NIRAAdditionalInfo__c= '';
		parentCase.Bribery_or_corruption__c= '';
		parentCase.Code_of_Conduct_Compliance_program__c= '';
		parentCase.Current_criminal_investigation_pending__c= '';
		parentCase.Anti_corruption_training_to_employees__c= '';
		parentCase.Provide_a_detailed_expelanation__c= '';
		parentCase.Guideline_URL__c= '';
		parentCase.PRM_Is_former_Nokia__c= '';
		parentCase.PRM_Last_Title__c= '';
		parentCase.PRM_Year_of_Departure__c= '';
		parentCase.Direct_Indirect_ownership_in_Company__c= '';
		parentCase.Describe__c= '';
		parentCase.Status= 'Draft';
		
		insert parentCase;
		
		
		List<Case> childCases = new List<Case>();
		List<ContentDocumentLink> contentDocLinks = new List<ContentDocumentLink>();
		
		for(String country : parentCase.Which_Sales_Territory_are_You__c.split(';')){
			
			Case c = new Case();
	c.Subject = 'IR Application – []';
	c.Description='IR Application – []';
	c.RecordTypeId = childCaseRectype;
	c.Affiliates_Subsidiary_Name__c= 'TestCompany '+country;
	c.Company_Registration_Number__c= '12313123 '+country;
	c.Street_Address_1__c= 'Addressline1';
	c.Street_Address_2__c= 'Addressline2';
	c.Company_s_Website__c= 'TestWebsite';
	c.Street_Address_3__c= 'Addresslin3';
	c.Email_Domain__c= 'test.com';
	c.Phone_No__c= '12312313';
	c.Country__c= country;
	c.State_Province_per_country__c= 'TestState';
	c.City_per_country__c= 'TestCountry';
	c.Postal_Code_per_country__c= '123123';
	c.First_Name_Sales__c= 'TestName';
	c.Last_Name_Sales__c= 'TestLastname';
	c.Email_Sales__c= 'Test@test.com';
	c.Primary_Phone_Sales__c= '123123123';
	c.Distributor_with_whom_transact_business__c= 'PRM Test Account NIRA';
	c.ParentId= parentCase.Id;
	c.Status= 'Draft';
			childCases.add(c);
		}
		
		insert childCases;
		
		content = [SELECT contentdocumentid FROM ContentVersion];
		for(Case c : childCases)
			contentDocLinks.add(new ContentDocumentLink(LinkedEntityId=c.id, contentdocumentid=content.contentdocumentid,ShareType = 'I',Visibility = 'AllUsers'));
		
		insert contentDocLinks;
	}
	
	@isTest
	static void createCaseWithBasicInfoTestMethod(){
		Case parentCase = new Case();
		parentCase.First_Name__c = 'Test';
		parentCase.Last_Name__c = 'TestLname';
		parentCase.Title__c='Mr';
		parentCase.Email__c='test@t.cd';
		parentCase.Office_Phone__c='1234322';
		
		String retVal = IRApplicationCase.createCaseWithBasicInfo(parentCase);
		
		Case childCase = new Case();
		childCase.First_Name__c = 'Test';
		childCase.Last_Name__c = 'TestLname';
		childCase.Title__c='Mr';
		childCase.Email__c='test@t.cd';
		childCase.Office_Phone__c='1234322';
		if(retVal!=null)
			childCase.parentId = retVal.split(':')[0];
		
		IRApplicationCase.createCaseWithBasicInfo(childCase);
	}
	
	@isTest
	static void saveAndReturnTestMethod(){
		List<case> parentCase = [Select Id,CaseNumber, PB_Email__c, Provide_a_detailed_expelanation__c,Postal_Code_per_country__c, Guideline_URL__c, Describe__c, Organizations_which_your_company_belong__c, Annual_industry_conferences_you_attend__c, Persons_responsible_for_work__c, Describe_your_current_business_activity__c, Describe_the_expereince_or_relationships__c, H_First_Name__c, H_Last_Name__c, PRM_H_Title__c, State__c, First_Name__c, PB_First_Name__c, PB_Last_Name__c, PB_Mobile_Phone__c, PB_Office_Phone__c, Pri_Retype_Email__c, PB_Title__c, Last_Name__c, Email__c, Mobile_Phone__c, Office_Phone__c, CRetype_Email__c, Title__c, Offer_your_own_Maintenance_and_Support__c, Current_Manufacturers_CP__c, Who_are_your_leading_competitors__c, Which_countries__c,Primary_Interest_CP__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_Sales_Territory_are_You__c,Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,Country__c,Phone_No__c,State_Province_per_country__c,FAX__c,Company_s_Website__c,Number_of_Branch_locations_CHQ__c,Branch_Offices__c,Full_Legal_Name_of_Your_Organization_CP__c,VAT_Number__c,Dun_Bradstreet_D_U_N_S_Number_CP__c,Company_type_CP__c,Number_of_years_in_business_CP__c,Annual_revenues_CP__c,Percentage_revenues_through_Services_CP__c,Total_Number_of_employees_CP__c,Percentage_of_Technical_Professionals_CP__c,Percentage_of_Total_Employees_in_Serv_CP__c,Percentage_of_Total_EmployeesIn_Sales_CP__c,of_Total_Employees_in_Marketing_CP__c,of_Employees_to_represent_Nokia_CP__c,Are_you_already_a_Nokia_Direct_Reseller__c,Willing_to_resell_to_USA_Federal_CP__c ,Willing_to_sell_to_non_USA_Govt_CP__c ,Bribery_or_corruption__c ,Current_criminal_investigation_pending__c ,Code_of_Conduct_Compliance_program__c , Anti_corruption_training_to_employees__c ,Direct_Indirect_ownership_in_Company__c , STREET_ADDRESS_1_CHQ__c , POSTAL_CODE_CHQ__c , PHONE_NO_CHQ__c , EMAIL_DOMAINS_CHQ__c, STREET_ADDRESS_2_CHQ__c , STREET_ADDRESS_3_CHQ__c , Company_website_CHQ__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,PRM_Is_former_Nokia__c,PRM_Last_Title__c,PRM_Year_of_Departure__c,PRM_NIRAAdditionalInfo__c,CH_Article_Attached__c FROM Case WHERE RecordTypeId = :parentCaseRectype];
		Map<Id, Case> childCaseMap = new Map<Id, Case>([SELECT  Country__c,Primary_Interest_CP__c,Postal_Code_per_country__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_countries__c,Which_Sales_Territory_are_You__c,id,Affiliates_Subsidiary_Name__c,Company_Registration_Number__c,Street_Address_1__c,Street_Address_2__c,Company_s_Website__c,Street_Address_3__c,Email_Domain__c,Phone_No__c,Fax_per_country__c,City_per_country__c,First_Name_Sales__c,Last_Name_Sales__c,Email_Sales__c,Primary_Phone_Sales__c,First_Name_Marketing__c,Last_Name_Marketing__c,Email_Marketing__c,Primary_Phone_Marketing__c,First_Name_Service__c,Last_Name_Service__c,Email_Service__c,Primary_Phone_Service__c,Distributor_with_whom_transact_business__c,State_Province_per_country__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,(Select id from ContentDocumentlinks Limit 2) from Case WHERE RecordTypeId =:childCaseRectype]);
		
		IRApplicationCase.saveAndReturn(parentCase[0], childCaseMap);
		
	}
	
	@isTest
	static void saveAndReturnWithAllDifferentChildCasesTestMethod(){
		List<case> parentCase = [Select Id,CaseNumber, PB_Email__c, Provide_a_detailed_expelanation__c,Postal_Code_per_country__c, Guideline_URL__c, Describe__c, Organizations_which_your_company_belong__c, Annual_industry_conferences_you_attend__c, Persons_responsible_for_work__c, Describe_your_current_business_activity__c, Describe_the_expereince_or_relationships__c, H_First_Name__c, H_Last_Name__c, PRM_H_Title__c, State__c, First_Name__c, PB_First_Name__c, PB_Last_Name__c, PB_Mobile_Phone__c, PB_Office_Phone__c, Pri_Retype_Email__c, PB_Title__c, Last_Name__c, Email__c, Mobile_Phone__c, Office_Phone__c, CRetype_Email__c, Title__c, Offer_your_own_Maintenance_and_Support__c, Current_Manufacturers_CP__c, Who_are_your_leading_competitors__c, Which_countries__c,Primary_Interest_CP__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_Sales_Territory_are_You__c,Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,Country__c,Phone_No__c,State_Province_per_country__c,FAX__c,Company_s_Website__c,Number_of_Branch_locations_CHQ__c,Branch_Offices__c,Full_Legal_Name_of_Your_Organization_CP__c,VAT_Number__c,Dun_Bradstreet_D_U_N_S_Number_CP__c,Company_type_CP__c,Number_of_years_in_business_CP__c,Annual_revenues_CP__c,Percentage_revenues_through_Services_CP__c,Total_Number_of_employees_CP__c,Percentage_of_Technical_Professionals_CP__c,Percentage_of_Total_Employees_in_Serv_CP__c,Percentage_of_Total_EmployeesIn_Sales_CP__c,of_Total_Employees_in_Marketing_CP__c,of_Employees_to_represent_Nokia_CP__c,Are_you_already_a_Nokia_Direct_Reseller__c,Willing_to_resell_to_USA_Federal_CP__c ,Willing_to_sell_to_non_USA_Govt_CP__c ,Bribery_or_corruption__c ,Current_criminal_investigation_pending__c ,Code_of_Conduct_Compliance_program__c , Anti_corruption_training_to_employees__c ,Direct_Indirect_ownership_in_Company__c , STREET_ADDRESS_1_CHQ__c , POSTAL_CODE_CHQ__c , PHONE_NO_CHQ__c , EMAIL_DOMAINS_CHQ__c, STREET_ADDRESS_2_CHQ__c , STREET_ADDRESS_3_CHQ__c , Company_website_CHQ__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,PRM_Is_former_Nokia__c,PRM_Last_Title__c,PRM_Year_of_Departure__c,PRM_NIRAAdditionalInfo__c,CH_Article_Attached__c FROM Case WHERE RecordTypeId = :parentCaseRectype];
		
		//to cover the scenario when all the child cases are changed from previoud selection
		IRApplicationCase.saveAndReturn(parentCase[0], new Map<Id, Case>());
		
	}
	
	@isTest
	static void saveAndReturnWithOneDifferentChildCaseTestMethod(){
		List<case> parentCase = [Select Id,CaseNumber, PB_Email__c, Provide_a_detailed_expelanation__c,Postal_Code_per_country__c, Guideline_URL__c, Describe__c, Organizations_which_your_company_belong__c, Annual_industry_conferences_you_attend__c, Persons_responsible_for_work__c, Describe_your_current_business_activity__c, Describe_the_expereince_or_relationships__c, H_First_Name__c, H_Last_Name__c, PRM_H_Title__c, State__c, First_Name__c, PB_First_Name__c, PB_Last_Name__c, PB_Mobile_Phone__c, PB_Office_Phone__c, Pri_Retype_Email__c, PB_Title__c, Last_Name__c, Email__c, Mobile_Phone__c, Office_Phone__c, CRetype_Email__c, Title__c, Offer_your_own_Maintenance_and_Support__c, Current_Manufacturers_CP__c, Who_are_your_leading_competitors__c, Which_countries__c,Primary_Interest_CP__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_Sales_Territory_are_You__c,Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,Country__c,Phone_No__c,State_Province_per_country__c,FAX__c,Company_s_Website__c,Number_of_Branch_locations_CHQ__c,Branch_Offices__c,Full_Legal_Name_of_Your_Organization_CP__c,VAT_Number__c,Dun_Bradstreet_D_U_N_S_Number_CP__c,Company_type_CP__c,Number_of_years_in_business_CP__c,Annual_revenues_CP__c,Percentage_revenues_through_Services_CP__c,Total_Number_of_employees_CP__c,Percentage_of_Technical_Professionals_CP__c,Percentage_of_Total_Employees_in_Serv_CP__c,Percentage_of_Total_EmployeesIn_Sales_CP__c,of_Total_Employees_in_Marketing_CP__c,of_Employees_to_represent_Nokia_CP__c,Are_you_already_a_Nokia_Direct_Reseller__c,Willing_to_resell_to_USA_Federal_CP__c ,Willing_to_sell_to_non_USA_Govt_CP__c ,Bribery_or_corruption__c ,Current_criminal_investigation_pending__c ,Code_of_Conduct_Compliance_program__c , Anti_corruption_training_to_employees__c ,Direct_Indirect_ownership_in_Company__c , STREET_ADDRESS_1_CHQ__c , POSTAL_CODE_CHQ__c , PHONE_NO_CHQ__c , EMAIL_DOMAINS_CHQ__c, STREET_ADDRESS_2_CHQ__c , STREET_ADDRESS_3_CHQ__c , Company_website_CHQ__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,PRM_Is_former_Nokia__c,PRM_Last_Title__c,PRM_Year_of_Departure__c,PRM_NIRAAdditionalInfo__c,CH_Article_Attached__c FROM Case WHERE RecordTypeId = :parentCaseRectype];
		Map<Id, Case> childCaseMap = new Map<Id, Case>([SELECT  Country__c,Primary_Interest_CP__c,Postal_Code_per_country__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_countries__c,Which_Sales_Territory_are_You__c,id,Affiliates_Subsidiary_Name__c,Company_Registration_Number__c,Street_Address_1__c,Street_Address_2__c,Company_s_Website__c,Street_Address_3__c,Email_Domain__c,Phone_No__c,Fax_per_country__c,City_per_country__c,First_Name_Sales__c,Last_Name_Sales__c,Email_Sales__c,Primary_Phone_Sales__c,First_Name_Marketing__c,Last_Name_Marketing__c,Email_Marketing__c,Primary_Phone_Marketing__c,First_Name_Service__c,Last_Name_Service__c,Email_Service__c,Primary_Phone_Service__c,Distributor_with_whom_transact_business__c,State_Province_per_country__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,(Select id from ContentDocumentlinks Limit 2) from Case WHERE RecordTypeId =:childCaseRectype]);
		
		//to cover scenario when saved and selected countries dont match
		 Case c = new Case();
	c.Subject = 'IR Application – []';
	c.Description='IR Application – []';
	c.RecordTypeId = childCaseRectype;
	c.Affiliates_Subsidiary_Name__c= '';
	c.Company_Registration_Number__c= '';
	c.Street_Address_1__c= '';
	c.Street_Address_2__c= '';
	c.Company_s_Website__c= '';
	c.Street_Address_3__c= '';
	c.Email_Domain__c= '';
	c.Phone_No__c= '';
	c.Country__c= 'India';
	c.State_Province_per_country__c= '';
	c.City_per_country__c= '';
	c.Postal_Code_per_country__c= '';
	c.First_Name_Sales__c= '';
	c.Last_Name_Sales__c= '';
	c.Email_Sales__c= '';
	c.Primary_Phone_Sales__c= '';
	c.Distributor_with_whom_transact_business__c= '';
	c.ParentId= parentCase[0].Id;
	c.Status= 'Draft';
			insert c;
		List<Id> childIdLst = new List<Id>(childCaseMap.keySet());
		childCaseMap.remove(childIdLst[0]);
		childCaseMap.put(c.id, c);
		
		IRApplicationCase.saveAndReturn(parentCase[0], childCaseMap);
	}
	
	@isTest
	static void caseFromCaseNoTestMethod(){
		List<Case> parentCase = [SELECT Id, Casenumber from Case WHERE RecordTypeId = :parentCaseRectype];
		
		//Added a child case with empty values for covering lines in else block for blank values in main class
		if(!parentCase.isEmpty()){
		Case c = new Case();
	c.Subject = 'IR Application – []';
	c.Description='IR Application – []';
	c.RecordTypeId = childCaseRectype;
	c.Affiliates_Subsidiary_Name__c= '';
	c.Company_Registration_Number__c= '';
	c.Street_Address_1__c= '';
	c.Street_Address_2__c= '';
	c.Company_s_Website__c= '';
	c.Street_Address_3__c= '';
	c.Email_Domain__c= '';
	c.Phone_No__c= '';
	c.Country__c= 'India';
	c.State_Province_per_country__c= '';
	c.City_per_country__c= '';
	c.Postal_Code_per_country__c= '';
	c.First_Name_Sales__c= '';
	c.Last_Name_Sales__c= '';
	c.Email_Sales__c= '';
	c.Primary_Phone_Sales__c= '';
	c.Distributor_with_whom_transact_business__c= '';
	c.ParentId= parentCase[0].Id;
	c.Status= 'Draft';
			insert c;
		}
		
		IRApplicationCase.caseFromCaseNo(parentCase[0].Casenumber);
		
		//Handle when case number doesnt exist
		IRApplicationCase.caseFromCaseNo('');
		
	}
	
	@isTest
	static void allUtilityMethodsTest(){
		IRApplicationCase.getMaintenanceStatus();
		IRApplicationCase.getLanguageTerm('English');
		IRApplicationCase.getDistributors('Afghanistan');
		IRApplicationCase.getPickListValues();
		IRApplicationCase.getStateValues('India');
		
		PageReference pageRef = new PageReference('');
		Test.setCurrentPage(pageRef);
		
		ApexPages.currentPage().getParameters().put('id', [SELECT Id FROM Case][0].Id);
		IRApplicationCase irClone = new IRApplicationCase(new ApexPages.StandardController(new Case()));
		
		// handle exception conditions
	}
	
	@isTest
	static void submitCaseDetailsTestMethod(){
		
		List<case> parentCase = [Select Id,CaseNumber, PB_Email__c, Provide_a_detailed_expelanation__c, PRM_NoandScopeOfPotentialNDACDeploy__c, Postal_Code_per_country__c, Guideline_URL__c, Describe__c, Organizations_which_your_company_belong__c, Annual_industry_conferences_you_attend__c, Persons_responsible_for_work__c, Describe_your_current_business_activity__c, Describe_the_expereince_or_relationships__c, H_First_Name__c, H_Last_Name__c, PRM_H_Title__c, State__c, First_Name__c, PB_First_Name__c, PB_Last_Name__c, PB_Mobile_Phone__c, PB_Office_Phone__c, Pri_Retype_Email__c, PB_Title__c, Last_Name__c, Email__c, Mobile_Phone__c, Office_Phone__c, CRetype_Email__c, Title__c, Offer_your_own_Maintenance_and_Support__c, Current_Manufacturers_CP__c, Who_are_your_leading_competitors__c, Which_countries__c,Primary_Interest_CP__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_Sales_Territory_are_You__c,Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,Country__c,Phone_No__c,State_Province_per_country__c,FAX__c,Company_s_Website__c,Number_of_Branch_locations_CHQ__c,Branch_Offices__c,Full_Legal_Name_of_Your_Organization_CP__c,VAT_Number__c,Dun_Bradstreet_D_U_N_S_Number_CP__c,Company_type_CP__c,Number_of_years_in_business_CP__c,Annual_revenues_CP__c,Percentage_revenues_through_Services_CP__c,Total_Number_of_employees_CP__c,Percentage_of_Technical_Professionals_CP__c,Percentage_of_Total_Employees_in_Serv_CP__c,Percentage_of_Total_EmployeesIn_Sales_CP__c,of_Total_Employees_in_Marketing_CP__c,of_Employees_to_represent_Nokia_CP__c,Are_you_already_a_Nokia_Direct_Reseller__c,Willing_to_resell_to_USA_Federal_CP__c ,Willing_to_sell_to_non_USA_Govt_CP__c ,Bribery_or_corruption__c ,Current_criminal_investigation_pending__c ,Code_of_Conduct_Compliance_program__c , Anti_corruption_training_to_employees__c ,Direct_Indirect_ownership_in_Company__c , STREET_ADDRESS_1_CHQ__c , POSTAL_CODE_CHQ__c , PHONE_NO_CHQ__c , EMAIL_DOMAINS_CHQ__c, STREET_ADDRESS_2_CHQ__c , STREET_ADDRESS_3_CHQ__c , Company_website_CHQ__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,PRM_Is_former_Nokia__c,PRM_Last_Title__c,PRM_Year_of_Departure__c,PRM_NIRAAdditionalInfo__c,CH_Article_Attached__c FROM Case WHERE RecordTypeId = :parentCaseRectype];
		Map<Id, Case> childCaseMap = new Map<Id, Case>([SELECT  Country__c,Primary_Interest_CP__c,Postal_Code_per_country__c,Top_3_Targeted_Vertical_focus_Industries__c,Which_countries__c,Which_Sales_Territory_are_You__c,id,Affiliates_Subsidiary_Name__c,Company_Registration_Number__c,Street_Address_1__c,Street_Address_2__c,Company_s_Website__c,Street_Address_3__c,Email_Domain__c,Phone_No__c,Fax_per_country__c,City_per_country__c,First_Name_Sales__c,Last_Name_Sales__c,Email_Sales__c,Primary_Phone_Sales__c,First_Name_Marketing__c,Last_Name_Marketing__c,Email_Marketing__c,Primary_Phone_Marketing__c,First_Name_Service__c,Last_Name_Service__c,Email_Service__c,Primary_Phone_Service__c,Distributor_with_whom_transact_business__c,State_Province_per_country__c, List_Ref_and_4G_5G_Experience__c, Radio_Networks_Installation_Experience__c, Radio_Frequency_Expirience__c, Tier1_Tier2_Support_Level__c,(Select id from ContentDocumentlinks Limit 2) from Case WHERE RecordTypeId =:childCaseRectype]);
	 
		IRApplicationCase.submitCaseDetails(parentCase[0], childCaseMap);
		
		
	}
	
	@isTest
	static void submitCaseDetailsOnlyOneHQChildCountryTestMethod() {
		
		Case parentCase = new Case();
		
		parentCase.Subject='IR Application – []';
		parentCase.Description='IR Application – []';
		parentCase.RecordTypeId = parentCaseRectype;
		parentCase.First_Name__c= 'TestName1';
		parentCase.Last_Name__c= 'Lastname1';
		parentCase.Title__c= 'Mr';
		parentCase.Email__c= 'test@test.com';
		parentCase.Office_Phone__c= '123123123123';
		parentCase.PB_First_Name__c= 'TestName1';
		parentCase.PB_Last_Name__c= 'Lastname1';
		parentCase.PB_Title__c= 'Mr';
		parentCase.PB_Email__c= 'test@test.com';
		parentCase.PB_Office_Phone__c= '123123123123';
		parentCase.H_First_Name__c= 'TestHName';
		parentCase.H_Last_Name__c= 'TestLname';
		parentCase.PRM_H_Title__c= 'Mr';
		parentCase.STREET_ADDRESS_1_CHQ__c= 'Addressline1';
		parentCase.STREET_ADDRESS_2_CHQ__c= 'addressline2';
		parentCase.STREET_ADDRESS_3_CHQ__c= 'addressline3';
		parentCase.City__c= 'TestCity';
		parentCase.POSTAL_CODE_CHQ__c= '530442';
		parentCase.Country__c= 'Afghanistan';
		parentCase.PHONE_NO_CHQ__c= '1123123';
		parentCase.State__c= '';
		parentCase.Company_website_CHQ__c= 'test.com';
		parentCase.EMAIL_DOMAINS_CHQ__c= '@test.com;@test1.com';
		parentCase.Full_Legal_Name_of_Your_Organization_CP__c= 'TestLegalName';
		parentCase.VAT_Number__c= '1321313';
		parentCase.Dun_Bradstreet_D_U_N_S_Number_CP__c= '123123';
		parentCase.Company_type_CP__c= 'Publicly Traded';
		parentCase.Annual_revenues_CP__c= '10ME -50 ME';
		parentCase.Total_Number_of_employees_CP__c= '51-100';
		parentCase.Which_Sales_Territory_are_You__c= 'Afghanistan';
		parentCase.Willing_to_resell_to_USA_Federal_CP__c= 'Yes';
		parentCase.Primary_Interest_CP__c= 'Vital Products;Video Analytics';
		parentCase.List_Ref_and_4G_5G_Experience__c= '';
		parentCase.Radio_Frequency_Expirience__c= '';
		parentCase.Radio_Networks_Installation_Experience__c= '';
		parentCase.Tier1_Tier2_Support_Level__c= '';
		parentCase.Describe_your_current_business_activity__c= '';
		parentCase.Describe_the_expereince_or_relationships__c= '';
		parentCase.PRM_NIRAAdditionalInfo__c= '';
		parentCase.Bribery_or_corruption__c= '';
		parentCase.Code_of_Conduct_Compliance_program__c= '';
		parentCase.Current_criminal_investigation_pending__c= '';
		parentCase.Anti_corruption_training_to_employees__c= '';
		parentCase.Provide_a_detailed_expelanation__c= '';
		parentCase.Guideline_URL__c= '';
		parentCase.PRM_Is_former_Nokia__c= '';
		parentCase.PRM_Last_Title__c= '';
		parentCase.PRM_Year_of_Departure__c= '';
		parentCase.Direct_Indirect_ownership_in_Company__c= '';
		parentCase.Describe__c= '';
		parentCase.Status= 'Draft';
		
		insert parentCase;
		
		Case c = new Case();
		c.Subject = 'IR Application – []';
		c.Description='IR Application – []';
		c.RecordTypeId = childCaseRectype;
		c.Affiliates_Subsidiary_Name__c= 'TestCompany123';
		c.Company_Registration_Number__c= '12313123Test';
		c.Street_Address_1__c= 'Addressline1';
		c.Street_Address_2__c= 'Addressline2';
		c.Company_s_Website__c= 'TestWebsite';
		c.Street_Address_3__c= 'Addresslin3';
		c.Email_Domain__c= 'test.com';
		c.Phone_No__c= '12312313';
		c.Country__c= 'Afghanistan';
		c.State_Province_per_country__c= 'TestState';
		c.City_per_country__c= 'TestCountry';
		c.Postal_Code_per_country__c= '123123';
		c.First_Name_Sales__c= 'TestName';
		c.Last_Name_Sales__c= 'TestLastname';
		c.Email_Sales__c= 'Test@test.com';
		c.Primary_Phone_Sales__c= '123123123';
		c.Distributor_with_whom_transact_business__c= 'PRM Test Account NIRA';
		c.ParentId= parentCase.Id;
		c.Status= 'Draft';
		
		insert c;
		
		ContentVersion content=new ContentVersion(); 
		content.Title='NIRA_TEST_DOC'; 
		content.PathOnClient='/' + content.Title + '.pdf'; 
		Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
		content.VersionData=bodyBlob; 
		content.origin = 'H';
		insert content;
		
		ContentVersion content1 = [select contentdocumentid from contentversion where id =: content.id];
		ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.LinkedEntityId=c.id;
		contentlink.contentdocumentid=content1.contentdocumentid;
		contentlink.ShareType = 'I';
		contentlink.Visibility = 'AllUsers'; 
		
		
		insert contentlink;
		
		
		Map<Id,Case> childCaseMap = new Map<Id,Case>();
		childCaseMap.put(c.Id, c);
		
		IRApplicationCase.submitCaseDetails(parentCase, childCaseMap);
		
	}
	
}