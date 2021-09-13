public class NOKIA_CPQ_TestDataFactory_MPW {
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
		StageName = 'Develop Opportunity',
		Phase_Status__c = 'Opportunity in Progress',
		CloseDate = Date.Today() ,
		G2_Planned_Date__c = Date.today(),
		G3_Planned_Date__c = Date.today(),
		G4_Planned_Date__c = Date.today(),
		G5_Planned_Date__c = Date.today(),
		G6_Planned_Date__c = Date.today(),
		Amount = 100+i, 
		Lead_BG__c='MN',
					Lead_BU__c='MN',
		Business_Type__c = 'Standard Opportunity',
		Unweighted_Amount_EUR__c =200+i,
		Account_Role__c = 'Alliance Partner'
	)
			);
		}
		return results;
	}
	 /************************************************************************************
  * Method Name: createAccreditationMPW
  * Description: Create Accreditation of Product Type for MPW Portfolio__c
  * Parameters: NA
  * Author: Monika
  **************************************************************************************/
  public static List<Accreditation__c > createAccreditationMPW(Integer size){
	List<Accreditation__c > accrdList = new List<Accreditation__c >();
	for (integer i = 0; i < size; i++){
	  Accreditation__c accred = new Accreditation__c(
	  Accreditation_Type__c = 'Product',
	  Portfolio__c = 'Modular Private Wireless Solution', 
	 // Pricing_Cluster__c = 'GLOBAL MPW 2',
	  Pricing_Cluster__c = 'MPW Cluster 2',
	  Accreditation_Level__c = 'Base',
	  Pricing_Level_Override__c = 'Interim',
	  Accreditation_Date__c = date.today() + 9, 
	  Pricing_Override_Expiration__c = date.today() + 9, 
	  Actual_pricing_level__c = 'Base'
	);
	  accrdList.add(accred);
	} 
	return accrdList;
  }
}