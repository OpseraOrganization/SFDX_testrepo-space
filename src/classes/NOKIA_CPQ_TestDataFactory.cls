/************************************************************************************
*Class Name: NOKIA_CPQ_TestDataFactory
*Author: Accenture
*Description: Data creation
*************************************************************************************/

public without sharing class NOKIA_CPQ_TestDataFactory {
	
	/************************************************************************************
	* Method Name: userCreation
	* Description: To create user
	* Parameters: NA
	**************************************************************************************/
	public static List<User> userCreation(integer size,string profileName) 
	{
		List<User> userList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].id;
		for (integer i = 0; i < size; i++)
		{
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName = /* orgId + */ dateString + randomInt;
			User user = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',NSA_Compliant__c=False,
		 timezonesidkey = 'America/Los_Angeles',  Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
	 
			userList.add(user);
		}
		return userList;
	}
	
	public static User createSystemAdminUser(){
		UserRole userRole_1 = [SELECT Id FROM UserRole  where PortalType = 'None' LIMIT 1 ];
		Profile pf= [Select Id from profile where Name='System Administrator']; 
		String orgId=UserInfo.getOrganizationId(); 
		String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		
		Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
		String uniqueName=orgId+dateString+RandomId; 
		
		User uu=new User(firstname = 'Alan', 
		lastName = 'McCarthy', 
		email = uniqueName + '@test' + orgId + '.org', 
		Username = uniqueName + '@test' + orgId + '.org', 
		EmailEncodingKey = 'ISO-8859-1', 
		Alias = uniqueName.substring(18, 23), 
		TimeZoneSidKey = 'America/Los_Angeles', 
		LocaleSidKey = 'en_US', 
		LanguageLocaleKey = 'en_US', 
		ProfileId = pf.Id,
		UserRoleId = userRole_1.Id,
		CompanyName = 'Accenture',
		//Nokia_ID__c = RandomId + '0');
		Nokia_ID__c = String.valueOf(RandomId + 'a'));
		return uu;
	}
	
	
	
	/************************************************************************************
	* Method Name: getAccounts
	* Description: Account creation
	* Parameters: NA
	**************************************************************************************/
	public static list<Account> getAccounts(Integer nb) {
		list<Account> results = new list<Account>();
		for (integer i = 0; i < nb; i++) {
			results.add(
	new Account(   
		Acc_No__c = 'Testing'+i,
		Active__c = true,
		Name = 'Test Account -' + i + Utils.generateRandomInteger(2)+Utils.generateRandomString(2),
		BillingStreet = '1660 International Dr',
		BillingCity = 'McLean',
		BillingState = 'Nunavut',
		BillingPostalCode = '22102',
		BillingCountry = 'Canada',
		AccountStatusInCRMOM__c = 'Active',
		Industry='Applications Partner',
		Market__c='Market North America',
		L4Name__c='Market North America',
		Country__c='Canada',
		CBT_CT_Code__c='NAM US Regionals',
		Partner_Type__c = 'Distributor',
		Partner_Program__c = 'GPP 3.0',
		RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId()
			));
		}
		return results;
	}
	
	/************************************************************************************
	* Method Name: getOpportunities
	* Description: opportunity creation
	* Parameters: NA
	**************************************************************************************/
	
	public static list<Opportunity> getOpportunities(Integer nb, list<Account> accounts) {
		list<Opportunity> results = new list<Opportunity>();

		for (integer i = 0; i < nb; i++) {
			results.add(
	new Opportunity(   
		Name = 'Test'+i,
		AccountId = accounts[Math.mod(i, accounts.size())].id,
		StageName = 'Create Offer (Bid)',
		Phase_Status__c = 'Offer in Progress',
		CloseDate = Date.Today() ,
		G2_Planned_Date__c = Date.today(),
		G3_Planned_Date__c = Date.today(),
		G4_Planned_Date__c = Date.today(),
		G5_Planned_Date__c = Date.today(),
		///G6_Planned_Date__c = Date.today(),
		Amount = 100+i, 
		Lead_BG__c='MN',
Lead_BU__c = 'MN',
		Business_Type__c = 'Standard Opportunity',
		 Account_Role__c  = 'GPP Distributor Partner',
		Unweighted_Amount_EUR__c =200+i
	)
			);
		}
		return results;
	}
	
	/************************************************************************************
	* Method Name: getOpportunitieswithoutG6
	* Description: opportunity creation
	* Parameters: NA
	**************************************************************************************/
	
	public static list<Opportunity> getOpportunitieswithoutG6(Integer nb, list<Account> accounts) {
		list<Opportunity> results = new list<Opportunity>();

		for (integer i = 0; i < nb; i++) {
			results.add(
	new Opportunity(   
		Name = 'Test'+i,
		AccountId = accounts[Math.mod(i, accounts.size())].id,
		StageName = 'Develop Opportunity',
		Phase_Status__c = 'Opportunity in Progress',
		CloseDate = Date.Today() ,
		G2_Planned_Date__c = Date.today(),
		G3_Planned_Date__c = Date.today(),
		G4_Planned_Date__c = Date.today(),
		G5_Planned_Date__c = Date.today(),
		Amount = 100+i, 
		Lead_BG__c='MN',
Lead_BU__c = 'MN',
		Business_Type__c = 'Standard Opportunity',
		Unweighted_Amount_EUR__c =200+i,
		Account_Role__c = 'GPP Distributor Partner'
	)
			);
		}
		return results;
	}
	
	/************************************************************************************
	* Method Name: productCreation
	* Description: product creation
	* Parameters: NA
	**************************************************************************************/
	 public static List<product2> productCreation(Integer size){
		List<product2> productList = new List<product2>();
		for (integer i = 0; i < size; i++){
			product2 prod = new product2();
			prod.name = '5G';
			prod.CurrencyIsoCode = 'USD';
			//prod.Business_Group__c='AA';
			prod.Family= 'A&A-CEM';
			prod.IsActive=True;
			prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
			productList.add(prod);
			
		}
		return productList;
	}
	
	/************************************************************************************
	* Method Name: createProposal
	* Description: proposal creation
	* Parameters: NA
	**************************************************************************************/
	
	  public static List<Apttus_Proposal__Proposal__c> createProposal(Integer size){
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		for (integer i = 0; i < size; i++){
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
			proposalObj.NokiaCPQ_Existing_IONMaint_Contract__c  = 'No';
			proposalObj.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
			proposalObj.NokiaCPQ_Existing_FN_Maint_Contract__c  = 'No';
			proposalObj.NokiaCPQ_FN_Maintenance_Type__c= 'Gold';
			proposalObj.NokiaCPQ_SSP_Level__c = 'Unlimited';
			proposalObj.NokiaCPQ_SRS_Level__c = 'Unlimited';
			proposalObj.CurrencyIsoCode ='EUR';
			proposalObj.NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
			proposalObj.NokiaCPQ_No_of_Years__c = '1';
			proposalObj.Apttus_Proposal__Approval_Stage__c = 'Draft';
			proposalObj.Creation_Date__c = system.today();
			proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test Quote';
			proposalObj.NokiaCPQ_Portfolio__c = 'IP Routing';
			proposalList.add(proposalObj);
		}		
		return proposalList ;
	}
	 /************************************************************************************
	* Method Name: createDirectProposal
	* Description: proposal creation.
	* Parameters: NA
	**************************************************************************************/
	public static List<Apttus_Proposal__Proposal__c> createProposalDirect(Integer size){
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		for (integer i = 0; i < size; i++){
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
	proposalObj.NokiaCPQ_Portfolio__c = 'Nokia Software';
	proposalObj.Creation_Date__c = system.today();
	proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test Quote1';
	proposalObj.Apttus_Proposal__Approval_Stage__c = 'Draft';
	proposalObj.NokiaCPQ_No_of_Years__c = '1';
			// proposalObj.NokiaCPQ_Maintenance_Type__c = 'Gold (24x7)';
	proposalList.add(proposalObj);
		}
		 return proposalList ;
	}
	
	 /************************************************************************************
	* Method Name: createProposalWithNull
	* Description: proposal creation with maintenance and ssp section values null.
	* Parameters: NA
	**************************************************************************************/
	
	  public static List<Apttus_Proposal__Proposal__c> createProposalWithNull(Integer size){
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		for (integer i = 0; i < size; i++){
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
			proposalObj.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
			proposalObj.NokiaCPQ_Existing_FN_Maint_Contract__c  = 'No';
			proposalObj.NokiaCPQ_FN_Maintenance_Type__c= 'Gold';
			proposalObj.CurrencyIsoCode ='EUR';
			proposalObj.Apttus_Proposal__Approval_Stage__c = 'Draft';
			proposalObj.Creation_Date__c = system.today();
			proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test Quote';
			//Modified for FN restructuring changes by Christie JJ
			//proposalObj.NokiaCPQ_Portfolio__c = 'Fixed Access - POL';
			proposalObj.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_INDIRECT_FN;
			proposalObj.CPQ_SubPortfolio__c = Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL;
			proposalList.add(proposalObj);
		}		
		return proposalList ;
	}
	
	/************************************************************************************
	* Method Name: createAccreditationforProd
	* Description: Create Accreditation of Product Type
	* Parameters: NA
	**************************************************************************************/
	public static List<Accreditation__c > createAccreditationforProd(Integer size){
		List<Accreditation__c > accrdList = new List<Accreditation__c >();
		for (integer i = 0; i < size; i++){
			Accreditation__c accred = new Accreditation__c(
	Accreditation_Type__c = 'Product',
	Portfolio__c = 'IP Routing',
	Pricing_Cluster__c = 'NAM',
	Accreditation_Level__c = 'Premier', 
	Accreditation_Date__c = date.today() + 9, 
	Pricing_Override_Expiration__c = date.today() + 9, 
	Reason_for_Level_Change__c = 'Change in Partner Program',
	RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Distributor_GPP_3_0').getRecordTypeId()
			);
			accrdList.add(accred);
		} 
		return accrdList;
	}
	
	
	/************************************************************************************
	* Method Name: createAccreditation
	* Description: Create Accreditation of Product Type
	* Parameters: NA
	**************************************************************************************/
	public static List<Accreditation__c > createAccreditation(Integer size){
		List<Accreditation__c > accrdList = new List<Accreditation__c >();
		for (integer i = 0; i < size; i++){
			Accreditation__c accred = new Accreditation__c(
			Accreditation_Type__c = 'Product',
			Portfolio__c = 'IP Routing',
			Pricing_Cluster__c = 'NAM',
			Accreditation_Level__c = 'Advanced', 
			Pricing_Level_Override__c = 'Advanced',
			Accreditation_Date__c = date.today() + 9, 
			Pricing_Override_Expiration__c = date.today() + 9, 
			Actual_pricing_level__c = 'Advanced'
		);
			accrdList.add(accred);
		} 
		return accrdList;
	}
	
	/************************************************************************************
	* Method Name: createAccreditationMaintenance
	* Description: Create Accreditation of Maintenance Type
	* Parameters: NA
	**************************************************************************************/
	public static List<Accreditation__c > createAccreditationMaintenance(Integer size){
		List<Accreditation__c > accrdList = new List<Accreditation__c >();
		for (integer i = 0; i < size; i++){
			Accreditation__c accred = new Accreditation__c(
			Accreditation_Type__c = 'Maintenance',
			Portfolio__c = 'IP Routing',
			Pricing_Cluster__c = 'NAM',
			Accreditation_Level__c = 'Premium', 
			Pricing_Level_Override__c = 'Premium',
			Accreditation_Date__c = date.today() + 9, 
			Pricing_Override_Expiration__c = date.today() + 9, 
			Actual_pricing_level__c = 'Advanced'
		);
			accrdList.add(accred);
		} 
		return accrdList;
	}
	
	/************************************************************************************
	* Method Name: createProdConfig
	* Description: Create Product Configuration
	* Parameters: NA
	**************************************************************************************/
	public static List<Apttus_Config2__ProductConfiguration__c> createProdConfig(Integer size){
		List<Apttus_Config2__ProductConfiguration__c > prodConfigList = new List<Apttus_Config2__ProductConfiguration__c >();
		for (integer i = 0; i < size; i++){
	Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(
	Apttus_Config2__Status__c = 'Finalized',
	Apttus_Config2__BusinessObjectType__c = 'Proposal'
			);
			prodConfigList.add(prodConfig);
		}
		return prodConfigList;
	}
	
	/************************************************************************************
	* Method Name: createLineItem
	* Description: Create Line Item 
	* Parameters: NA
	**************************************************************************************/
	public static List<Apttus_Config2__LineItem__c> createLineItem(Integer size){
		List<Apttus_Config2__LineItem__c> lineItemList= new List<Apttus_Config2__LineItem__c>();
		for(integer i = 0; i < size; i++){
			Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
	Apttus_Config2__LineNumber__c = i+1,
	Apttus_Config2__ItemSequence__c = i+1,
	Apttus_Config2__Quantity__c = 1,
	Apttus_Config2__TotalQuantity__c = 1
			);
			lineItemList.add(lineItem);
		}
		
		return lineItemList;
	}
	
	/************************************************************************************
	* Method Name: createProposalLineItem
	* Description: Create Line Item 
	* Parameters: NA
	**************************************************************************************/
	public static List<Apttus_Proposal__Proposal_Line_Item__c> createProposalLineItem(Integer size){
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= new List<Apttus_Proposal__Proposal_Line_Item__c>();
		for(integer i = 0; i < size; i++){
			Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
	Apttus_QPConfig__ChargeType__c = 'Standard Price',
	Apttus_QPConfig__Quantity2__c = i+1,
	Apttus_QPConfig__LineType__c = 'Product/Service',
	Apttus_QPConfig__NetPrice__c = 100.30,
	Apttus_QPConfig__BasePrice__c = 12.50,
	Apttus_QPConfig__ListPrice__c = 12.50
			);
			proposalLineItemList.add(proposalLineItem);
		}
		
		return proposalLineItemList;
	}
	
	 /************************************************************************************
	* Method Name: productCreation
	* Description: product creation for Nokia Portfolio
	* Parameters: size 
	**************************************************************************************/
	 public static List<product2> productCreationDirect(Integer size){
		List<product2> productList = new List<product2>();
		for (integer i = 0; i < size; i++){
			product2 prod = new product2();
			prod.name = 'Comptel SRS';
			prod.CurrencyIsoCode = 'USD';
			prod.Business_Group__c='MN';
			prod.Family= 'A&A-CEM';
			prod.Portfolio__c = 'Nokia Software';
			prod.ProductCode = 'COMP-1234';
			prod.Apttus_Config2__ConfigurationType__c = 'Option';
			prod.IsActive=True;
			prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
			productList.add(prod);
			
		}
		return productList;
	}
}