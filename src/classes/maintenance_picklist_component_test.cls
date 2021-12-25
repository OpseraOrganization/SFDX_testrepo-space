/****************************************
 * Name : maintenance_picklist_component_test
 * Author : Piyush
 * Description : Test class for quote_Maintenance_Picklist_handler & lightning component
 *****************************************/
 
@istest
public class maintenance_picklist_component_test {
	
	/***********************
	* Method Name: maintenanceTypeTest
	* Description: To cover the method updateMaintenanceTypeValue from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void maintenanceTypeTest(){
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
   /*	 //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
	 */
		 //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.updateMaintenanceTypeValue(proposals[0].id);
		test.stopTest();			  
	}
	
	/***********************
	* Method Name: maintenanceTypeTestCatchBlock
	* Description: To cover the catch block of method updateMaintenanceTypeValue from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void maintenanceTypeTestCatchBlock(){
		
		test.startTest();
		quote_Maintenance_Picklist_handler.updateMaintenanceTypeValue(null);
		test.stopTest();			  
	}
	
	/***********************
	* Method Name: picklistValueRetrieveTestString1
	* Description: To cover the method updateExistingMaintContract from class quote_Maintenance_Picklist_handler 
					for NokiaCPQ_Existing_IONMaint_Contract__c field.
	* Parameters: NA
	************************/
	static testmethod void picklistValueRetrieveTestString1(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.updateExistingMaintContract(proposals[0].id,Nokia_CPQ_Constants.STRING_EXISTING_MAINT_CNT);
		test.stopTest(); 
		
	}
	
	/***********************
	* Method Name: picklistValueRetrieveTestString2
	* Description: To cover the method updateExistingMaintContract from class quote_Maintenance_Picklist_handler 
					for NokiaCPQ_SSP_Level__c field.
	* Parameters: NA
	************************/
	static testmethod void picklistValueRetrieveTestString2(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.updateExistingMaintContract(proposals[0].id,Nokia_CPQ_Constants.STRING_SSP_API_NAME);
		test.stopTest(); 
		
	}
	
	 /***********************
	* Method Name: picklistValueRetrieveTestString3
	* Description: To cover the method updateExistingMaintContract from class quote_Maintenance_Picklist_handler 
					for NokiaCPQ_SRS_Level__c field.
	* Parameters: NA
	************************/
	static testmethod void picklistValueRetrieveTestString3(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.updateExistingMaintContract(proposals[0].id,Nokia_CPQ_Constants.STRING_SRS_API_NAME);
		test.stopTest(); 
		
	}
	
	 /***********************
	* Method Name: picklistValueRetrieveTestString4
	* Description: To cover the method updateExistingMaintContract from class quote_Maintenance_Picklist_handler 
					for NokiaCPQ_No_of_Years__c field.
	* Parameters: NA
	************************/
	static testmethod void picklistValueRetrieveTestString4(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = Nokia_CPQ_Constants.YES_STRING;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.updateExistingMaintContract(proposals[0].id,Nokia_CPQ_Constants.STRING_NO_OF_YEARS);
		test.stopTest(); 
		
	}
	
	/***********************
	* Method Name: updateExistingMaintContractCatchBlock
	* Description: To cover the catch block of method updateExistingMaintContract from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void updateExistingMaintContractCatchBlock(){
		
		test.startTest();
		quote_Maintenance_Picklist_handler.updateExistingMaintContract(null,Nokia_CPQ_Constants.STRING_NO_OF_YEARS);
		test.stopTest();			  
	}
	
	/***********************
	* Method Name: saveMethodTest
	* Description: To cover the method saveRecord from class quote_Maintenance_Picklist_handler 
	* Parameters: NA
	************************/
	static testmethod void saveMethodTest(){
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
  /*	  //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
	*/
		   //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		insert proposals;
		
		quote_Maintenance_Picklist_handler.saveRecord(proposals[0].id,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING);
		test.stopTest();			  
	}
	
	/***********************
	* Method Name: saveMethodTest2
	* Description: To cover the method saveRecord from class quote_Maintenance_Picklist_handler 
	* Parameters: NA
	************************/
	static testmethod void saveMethodTest2(){
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
   /*	 //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
	 */
		
		   //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalWithNull(1);
		proposals[0].NokiaCPQ_Portfolio__c =  'IP Routing';
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		
		insert proposals;
		
		quote_Maintenance_Picklist_handler.saveRecord(proposals[0].id,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.BLANK_STRING);
		test.stopTest();			  
	}
	
	/***********************
	* Method Name: saveMethodTest3
	* Description: To cover the method saveRecord from class quote_Maintenance_Picklist_handler 
	* Parameters: NA
	************************/
	static testmethod void saveMethodTest3(){
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
  /*	  //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
	*/
		
		   //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalWithNull(1);
		proposals[0].NokiaCPQ_Portfolio__c =  'IP Routing';
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = Nokia_CPQ_Constants.YES_STRING;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.saveRecord(proposals[0].id,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.NO_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.BLANK_STRING);
		test.stopTest();			  
	}

	/***********************
	* Method Name: saveMethodTest3
	* Description: To cover the method saveRecord from class quote_Maintenance_Picklist_handler 
	* Parameters: NA
	************************/
	static testmethod void saveMethodTest4(){
		
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
  /*	  //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
	*/
		   //create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalWithNull(1);
		proposals[0].NokiaCPQ_Portfolio__c =  'IP Routing';
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c = Nokia_CPQ_Constants.NO_STRING;
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.saveRecord(proposals[0].id,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.YES_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.BLANK_STRING);
		test.stopTest();			  
	}
	
	/***********************
	* Method Name: saveRecordCatchBlock
	* Description: To cover the catch block of method saveRecord from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void saveRecordCatchBlock(){
		 test.startTest();
		 quote_Maintenance_Picklist_handler.saveRecord(null,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.YES_STRING,Nokia_CPQ_Constants.BLANK_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.NONE_STRING,Nokia_CPQ_Constants.BLANK_STRING);
		 test.stopTest();
	}
	
	/***********************
	* Method Name: getPortfolioTest
	* Description: To cover the method getportfolio from class quote_Maintenance_Picklist_handler.
	* Parameters: NA
	************************/
	static testmethod void getPortfolioTest(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();
		proposals[0].NokiaCPQ_Maintenance_Type__c = ''; 
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.getportfolioSSP(proposals[0].id);
		quote_Maintenance_Picklist_handler.getportfolioSRS(proposals[0].id);
		test.stopTest(); 
		
	}
	
	/***********************
	* Method Name: getportfolioCatchBlock
	* Description: To cover the catch block of method getportfolio from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void getportfolioCatchBlock(){
		 test.startTest();
		 quote_Maintenance_Picklist_handler.getportfolioSSP(null);
		 quote_Maintenance_Picklist_handler.getportfolioSRS(null);
		 test.stopTest();
	}
	
	 /***********************
	* Method Name: approvalStageValueReturnTest
	* Description: To cover the method approvalStageValueReturn from class quote_Maintenance_Picklist_handler.
	* Parameters: NA
	************************/
	static testmethod void approvalStageValueReturnTest(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].Reprice_In_Progress__c = true;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		insert proposals;
		
		
		quote_Maintenance_Picklist_handler.approvalStageValueReturn(proposals[0].id);
		test.stopTest(); 
		
	}
	
	/***********************
	* Method Name: approvalStageValueReturnCatchBlock
	* Description: To cover the catch block of method approvalStageValueReturn from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void approvalStageValueReturnCatchBlock(){
		 test.startTest();
		 quote_Maintenance_Picklist_handler.approvalStageValueReturn(null);
		 test.stopTest();
	}
	
	/***********************
	* Method Name: defaultValueReturnTest
	* Description: To cover the method approvalStageValueReturn from class quote_Maintenance_Picklist_handler.
	* Parameters: NA
	************************/
	static testmethod void defaultValueReturnTest(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		insert opportunities;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
		accreditations[0].partner__c = accounts[0].Id;
		
		List<Accreditation__c > accreditationsMaint = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
		accreditationsMaint[0].partner__c = accounts[0].Id;
		 
		insert accreditations;
		insert accreditationsMaint;
		
		test.startTest();		
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();
		proposals[0].NokiaCPQ_Maintenance_Type__c = ''; 
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
		proposals[0].NokiaCPQ_No_of_Years__c = '1';
		insert proposals;
		
		quote_Maintenance_Picklist_handler.defaultValueReturn(proposals[0].id);
		test.stopTest(); 
		
	}
	
	/***********************
	* Method Name: defaultValueReturnCatchBlock
	* Description: To cover the catch block of method defaultValueReturn from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void defaultValueReturnCatchBlock(){
		 test.startTest();
		 quote_Maintenance_Picklist_handler.defaultValueReturn(null);
		 test.stopTest();
	}
	
	/***********************
	* Method Name: sspsrsValueReturnTest
	* Description: To cover the sspsrsValueReturn method from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void sspsrsValueReturnTest(){
		test.startTest();
		quote_Maintenance_Picklist_handler.sspsrsValueReturn('Optics',Nokia_CPQ_Constants.NOKIA_SSP);
		test.stopTest();
	}
	
	/***********************
	* Method Name: sspsrsValueReturnCatchblockTest
	* Description: To cover the sspsrsValueReturn method from class quote_Maintenance_Picklist_handler
	* Parameters: NA
	************************/
	static testmethod void sspsrsValueReturnCatchblockTest(){
		test.startTest();
		quote_Maintenance_Picklist_handler.sspsrsValueReturn(null,Nokia_CPQ_Constants.NOKIA_SSP);
		test.stopTest();
	}
}