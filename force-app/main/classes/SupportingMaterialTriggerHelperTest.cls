/****************************************
* Name : SupportingMaterialTriggerHelperTest
* Author : Accenture

*****************************************/
@isTest
Private class SupportingMaterialTriggerHelperTest{
	
	public testmethod static void validateDuplicateSupportingMaterialRecordTest(){
		try{	   
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
			   
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c () ;
			agreement.Apttus__Account__c = accountCreationDP.Id;
			database.insert(agreement);
			   
			Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
			cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
			cpoTest.Apttus_CMConfig__AgreementId__c = agreement.id;
			database.insert(cpoTest);				  
		
			File_Upload__c suppmaterial = new File_Upload__c();
			suppmaterial.Account__c = accountCreationDP.Id;
			suppmaterial.Frame_Contract_Reference__c = agreement.id;
			suppmaterial.Purchase_Order__c = cpoTest.id;
			database.insert(suppmaterial);
			
			File_Upload__c suppmaterial_dup = new File_Upload__c();
			suppmaterial_dup.Account__c = accountCreationDP.Id;
			suppmaterial_dup.Frame_Contract_Reference__c = agreement.id;
			suppmaterial_dup.Purchase_Order__c = cpoTest.id;
			database.insert(suppmaterial_dup);
			}
		
		catch (Exception ex) {
			 ExceptionHandler.addException(ex,'SupportingMaterialTriggerHelperTest','validateDuplicateSupportingMaterialRecordTest');
							   
		} 
	 }
	 }