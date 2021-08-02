/****************************************
* Name : OpportunityTriggerHelper_PreSalesTest 
* Author : Accenture
* Description : Test class for OpportunityTriggerHelper_PreSales
*****************************************/
@istest
private class OpportunityTriggerHelper_PreSalesTest {
	private static ID leId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
  
 
  private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY).getRecordTypeId();

  private static List<Opportunity> preSalesOpportunity = new List<Opportunity>();
	
	
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY_READONLY).getRecordTypeId();	
	
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY).getRecordTypeId();

	static NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();

	static testMethod void updatePreSalesRiskType() {

		Id recordType1,recordType2 ;
		//Creating User
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			
			//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			//database.insert(fileSharingCustomSettingList);
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			test.startTest();
			//Creating Indirect-Oppty
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			//changing oppty's stage Name and phase status
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			//Creating Presales Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation)[0];
			
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest.CurrencyIsoCode = 'USD';
			database.insert(preSalesTest);
			
			System.debug('The record Type is >>>>>>'+ PreSalesTest.RecordTypeId);
			recordType1 = PreSalesTest.RecordTypeId;
			System.debug('The record type of the current PreSales>>>>>>>>>>>'+ recordType1);
			
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Trial';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'No possibility to sell';
			
			recordType2 = PreSalesTest.RecordTypeId; 
			System.debug('The record type of the current PreSales>>>>>>>>>>>'+ recordType2);
			test.stopTest();
			if(recordType1 == recordType2){
	System.debug('not working');
			}
			else{
	System.debug('working!! The record type changed');
			}
		}
		
	}
	
	static testMethod void convertionUpdatePreSalesConvertTest() {
	
		
		Id recordType1,recordType2 ;
		//Creating User
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			
			//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			//database.insert(fileSharingCustomSettingList);
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			test.startTest();
			//Creating Indirect-Oppty
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			//changing oppty's stage Name and phase status
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			//Creating Presales Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest.CurrencyIsoCode = 'USD';
			preSalesTest.PSR_Cost_Business_Group_AA__c = 250;
			preSalesTest.PSR_Cost_Business_Group_FN__c = 250;
			preSalesTest.PSR_Cost_Business_Group_MN__c = 250;
			preSalesTest.PSR_Cost_Business_Group_GS__c = 250;
			preSalesTest.PSR_Cost_Business_Unit_ION_Optics__c = 366;
			preSalesTest.PSR_Cost_Business_Unit_ION_VIdeo__c = 450;
			preSalesTest.PSR_Cost_Business_Unit_ION_IPR__c = 788;
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c = false;
			database.insert(preSalesTest);
			//database.update(preSalesTest);
			test.stopTest();
		}
		
	}
	
	 static testmethod void psrGateClassificationAllocationTest(){
		 
		 cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		 
		Id recordType1,recordType2 ;
		
		 PSR_Gate_Classification_Logic__c psr1 = new PSR_Gate_Classification_Logic__c();
		psr1.name= '1';
		psr1.BG_Value__c= 'NSW';
		psr1.Gate_Classification__c= 'R1';
		psr1.Max_Value__c= 0;
		psr1.Min_Value__c= 200000;
		psr1.Opportunity_Sub_Type__c= 'Risk Order Only';
		psr1.Opportunity_Type__c= 'Risk Order';
		
		insert psr1;
		
		
		//Creating User
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234';
			//accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			//database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(new List<Account>{accountCreation,sonAccount});
			sonAccount.ParentId = accountCreation.Id;
			update sonAccount;
			//Creating Indirect-Oppty
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
	 // optyCreation.G6_Planned_Date__c = Date.today();
	  insert optyCreation;
	  Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(2, accountCreation, optyCreation)[0];
			
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			//preSalesTest.CurrencyIsoCode = 'EUR';
			preSalesTest.RecordTypeId= PSR_EditRecordTypeID ;
			Test.startTest();
			database.insert(new List<Opportunity>{preSalesTest});
			//database.insert(optyCreation);
			//String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			//changing oppty's stage Name and phase status
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			//Creating Presales Oppty
			
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;
			
			preSalesTest.PSR_Cost_Business_Group_AA__c = 100000;

			List<PSR_Gate_Classification_Logic__c> objList = PSR_Gate_Classification_Logic__c.getall().values();
			//preSalesTest.RecordTypeId= PSR_ReadOnlyRecordTypeID ;
			
			preSalesTest.PSR_GateClass__c = psr1.Gate_Classification__c;
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c = false;
			database.update(preSalesTest);
			
		 //OpportunityTriggerHelper_PreSales.psrGateClassificationAllocation(preSalesOptyList, null);
		 try
			{
	OpportunityTriggerHelper_PreSales.psrGateClassificationAllocation(null,null);
			}
			catch(Exception ex){
	system.debug('Exception Occurred:'+ex);
			}
			try
			{
	OpportunityTriggerHelper_PreSales.updateProbabiltyOfPSROptysBeforeInsertFeature(null);
			}
			catch(Exception ex){
	system.debug('Exception Occurred:'+ex);
			}
			
	
	 }
}
	
	
	static testMethod void NokiaPeriodName() {
	
		
		//test.startTest();
		Id recordType1,recordType2 ;
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			//creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1235';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			//creating Indirect oppty
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			// optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			Test.startTest();
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			//changing oppty's phase status and stage name
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			//Adding entries to Nokia Calender
			Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaCalender.Start_Date__c = System.today();
			nokiaCalender.End_Date__c = System.today();
			database.insert(nokiaCalender);
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			database.insert(exchangeRate);
			//Creating Presales Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation)[0];
			
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest.CurrencyIsoCode = 'USD';
			database.insert(preSalesTest);
	//  OpportunityTriggerHelper_PreSales.getNokiaPeriodName(null,null);
			Test.stopTest();
		}		
	}
	
	
	static testMethod void inExecutionStage(){

		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			//creating Account
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.AccountNumber = '1234';
			database.insert(accountCreation1);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation1.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			//Creating Oppty
			Opportunity optyCreation2 = TestDataFactory.OpportunityCreation(3,accountCreation1)[0];
			optyCreation2.StageName = 'Develop Opportunity';
			optyCreation2.Phase_Status__c = 'Opportunity in Progress';
			optyCreation2.Legal_Entity__c = sonAccount.Id;
			optyCreation2.G2_Planned_Date__c = Date.today();
			optyCreation2.G3_Planned_Date__c = Date.today();
			optyCreation2.G4_Planned_Date__c = Date.today();
			optyCreation2.G5_Planned_Date__c = Date.today();
	 // optyCreation2.G6_Planned_Date__c = Date.today();
			optyCreation2.End_Customer_LE__c = null;
				test.startTest();
			database.insert(optyCreation2);
			String oppId = optyCreation2.Id;
			optyCreation2 = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation2.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation2.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation2.Phase_Status__c = 'Opportunity in Progress';
		
			database.update(optyCreation2);
			system.debug('optyCreation2>>>'+optyCreation2);			
			//creating Presales Oppty
			Opportunity PreSalesTest2 = TestDataFactory.preSalesOpportunityCreation(3, accountCreation1, optyCreation2)[0];
			//Opportunity PreSalesTest3 = TestDataFactory.preSalesOpportunityCreation(3, accountCreation1, optyCreation2)[0]
			PreSalesTest2.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			PreSalesTest2.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			PreSalesTest2.CloseDate = System.Today();
			PreSalesTest2.StageName = 'Preparation';
			database.insert(PreSalesTest2);			
		}
		test.stopTest();
		
	}
	
	static testMethod void updateRecordTypeWhenPreSaleTypeIsOtherThanRSRO() {
		
		//Creating User
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			//Creating Account
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.AccountNumber = '1234'; 
			//database.insert(accountCreation1);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1235';
			
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			List<Account> accountsTobeInsert = new List<Account>{accountCreation1,sonAccount};
			database.insert(accountsTobeInsert);
			sonAccount.ParentId = accountCreation1.Id;
			update sonAccount;
			//database.insert(sonAccount);
			
			//Creating Oppty
			Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(1,accountCreation1)[0];	
			system.debug('optyCreation1>>>'+optyCreation1);
			optyCreation1.RecordTypeId = oppIndirectRecordTypeId;
			optyCreation1.StageName = 'Develop Opportunity';
			optyCreation1.Phase_Status__c = 'Opportunity in Progress';
			optyCreation1.Legal_Entity__c = sonAccount.Id;
			OptyCreation1.End_Customer_LE__c = sonAccount.Id;
			optyCreation1.G2_Planned_Date__c = Date.today();
			optyCreation1.G3_Planned_Date__c = Date.today();
			optyCreation1.G4_Planned_Date__c = Date.today();
			optyCreation1.G5_Planned_Date__c = Date.today();
			//optyCreation1.G6_Planned_Date__c = Date.today();
			//Creating PreSales Trial Oppty
			insert optyCreation1;
			Opportunity updateRecordType = TestDataFactory.preSalesOpportunityCreation(1, accountCreation1, optyCreation1)[0];
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Trial';
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Commercial Trial';
			updateRecordType.CloseDate = System.Today();
			//system.debug('before insert updateRecordType>>>'+updateRecordType);
			//database.insert(updateRecordType); 
			//system.debug('after insert updateRecordType>>>'+updateRecordType);
			Test.startTest();
			database.insert(updateRecordType);
			//database.insert(optyCreation1);
			String oppId = optyCreation1.Id;
			//optyCreation1 = [select Id From Opportunity Where Id =: oppId limit 1];
			//System.debug('Opp>>'+[select id,StageName from opportunity where id =: optyCreation1.id]);
			//system.debug('after insert optyCreation1>>>'+optyCreation1);
			//Updating Oppty with stage name and phase status
			optyCreation1.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation1.StageName = 'Develop Opportunity';
			optyCreation1.Phase_Status__c = 'Opportunity in Progress';
			Database.update(optyCreation1);
			
			//Creating PreSales Demo Oppty
			Opportunity updateRecordTypeDemo = TestDataFactory.preSalesOpportunityCreation(1, accountCreation1, optyCreation1)[0];
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			updateRecordType.CloseDate = System.Today();
			//database.insert(updateRecordTypeDemo); 
			//Creating Risk Trial Oppty
			Opportunity updateRecordTypeRisk = TestDataFactory.preSalesOpportunityCreation(1, accountCreation1, optyCreation1)[0];
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			updateRecordType.CloseDate = System.Today();
			//database.insert(updateRecordTypeRisk); 
			//Creating FoC Trial Oppty
			Opportunity updateRecordTypeFoC = TestDataFactory.preSalesOpportunityCreation(1, accountCreation1, optyCreation1)[0];
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Free of Charge';
			updateRecordType.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Good Will';
			updateRecordType.CloseDate = System.Today();
			// database.insert(updateRecordTypeFoC); 
			test.stopTest();
			
		}
	}

		static testMethod void populateParentAccountOnPreSalesAndSetDefaultStage() {
		
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
			//test.startTest();
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
	  OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			Test.stopTest();
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[2].Opportunity_ID__c = '123456';
			// preSalesOpportunity.add(preSalesTest);
			database.insert(preSalesTest); 
			//Creating Oppty Team Member
			list<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(3,userCreation,preSalesTest[0]);
			database.insert(opptyTeamMemberList);
			preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 1000;
			preSalesTest[0].PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Description_Justification__c = 'Test';
			database.update(preSalesTest[0]);
			preSalesTest[0].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[1].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[2].Apttus_Approval__Approval_Status__c = 'Rejected';
			system.debug('befoe update');
			database.update(preSalesTest[0]);
			system.debug('preSalesTest[0]'+preSalesTest[0]);
			//test.startTest();
			preSalesTest[0].closeDate = System.Today();
			//preSalesTest[1].closeDate = System.Today();
			//preSalesTest[2].closeDate = System.Today();
			database.update(preSalesTest[0]);
			OpportunityTriggerHelper_PreSales.populateParentAccountOnPreSalesAndSetDefaultStage(null,null);
			//test.stopTest();
		}	 
	}
	
	
	
	static testMethod void populateParentCurrencyOnPreSales() {
	
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			//Test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			test.startTest();
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[2].Opportunity_ID__c = '123456';
			// preSalesOpportunity.add(preSalesTest);
			database.insert(preSalesTest); 
			//Creating Oppty Team Member
			list<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(3,userCreation,preSalesTest[0]);
			database.insert(opptyTeamMemberList);
			preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 1000;
			preSalesTest[0].PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Description_Justification__c = 'Test';
			//database.update(preSalesTest[0]);
			preSalesTest[0].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[1].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[2].Apttus_Approval__Approval_Status__c = 'Rejected';
			system.debug('befoe update');
			//database.update(preSalesTest[0]);
			system.debug('preSalesTest[0]'+preSalesTest[0]);
			
			preSalesTest[0].closeDate = System.Today();
			//preSalesTest[1].closeDate = System.Today();
			//preSalesTest[2].closeDate = System.Today();
			
			database.update(preSalesTest[0]);
			Test.stopTest();
			OpportunityTriggerHelper_PreSales.populateParentCurrencyOnPreSales(null,null);
			
		}   
		
	} 
		
		
	static testMethod void populatePreSalesOpportunityNumber() {
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			
			//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			//database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			Test.startTest();
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[2].Opportunity_ID__c = '123456';
			// preSalesOpportunity.add(preSalesTest);
			database.insert(preSalesTest);
			Test.stopTest();
			//Creating Oppty Team Member
			list<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(3,userCreation,preSalesTest[0]);
			database.insert(opptyTeamMemberList);
			preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 1000;
			//preSalesTest[0].PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			//preSalesTest[0].PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Description_Justification__c = 'Test';
			database.update(preSalesTest[0]);
			preSalesTest[0].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[1].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[2].Apttus_Approval__Approval_Status__c = 'Rejected';
			system.debug('befoe update');
			database.update(preSalesTest[0]);
			system.debug('preSalesTest[0]'+preSalesTest[0]);
			//test.startTest();
			preSalesTest[0].closeDate = System.Today();
			//preSalesTest[1].closeDate = System.Today();
			//preSalesTest[2].closeDate = System.Today();
			database.update(preSalesTest[0]);
			
		}	 
		
	}
	
	static testMethod void populatePreSalesOpportunityNumber_Demo() {
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			
			//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			//database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1235';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			Test.startTest();
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(3, accountCreation, optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			//preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			//preSalesTest[1].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Demo';
			//preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			//preSalesTest[2].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			preSalesTest[0].Opportunity_ID__c = '123456';
			database.insert(preSalesTest[0]);
			Test.stopTest();
			//Creating Oppty Team Member
			list<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(3,userCreation,preSalesTest[0]);
			database.insert(opptyTeamMemberList);
			preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 1000;
			//preSalesTest[0].PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			//preSalesTest[0].PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Description_Justification__c = 'Test';
			database.update(preSalesTest[0]);
			preSalesTest[0].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[1].Apttus_Approval__Approval_Status__c = 'Approved';
			//preSalesTest[2].Apttus_Approval__Approval_Status__c = 'Rejected';
			system.debug('befoe update');
			database.update(preSalesTest[0]);
			system.debug('preSalesTest[0]'+preSalesTest[0]);
			//test.startTest();
			preSalesTest[0].closeDate = System.Today();
			//preSalesTest[1].closeDate = System.Today();
			//preSalesTest[2].closeDate = System.Today();
			database.update(preSalesTest[0]);
			
		}  
		
	}

	
   static testMethod void NotifyOpportunityTeamMembers() {
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
	//Creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;
			//Creating account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation.Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			
			//Creating Indirect Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;

			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;
	  Test.stopTest();
			
			//Creating PreSales Risk Oppty
			List<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation);
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest[0].RecordTypeId = PSR_EditRecordTypeID;
			database.insert(preSalesTest); 
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;
			//Creating Oppty Team Member
			list<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(3,userCreation,preSalesTest[0]);
			database.insert(opptyTeamMemberList);
		
			//Updating Oppty with field required to chnage stage to 'Submitted for Approval'
			preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 10;
			preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 10;
			preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 10;
			preSalesTest[0].PSR_Cost_Business_Unit_ION_IPR__c = 10;
			preSalesTest[0].PSR_Cost_Business_Unit_ION_Optics__c = 11;
			preSalesTest[0].PSR_Cost_Business_Unit_ION_Video__c = 12;
			//preSalesTest[0].PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			//preSalesTest[0].PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest[0].PSR_Description_Justification__c = 'Test';
			preSalesTest[0].NF_PRE_Tech_Field__c = 'Gate Submitted';
			preSalesTest[0].PSR_Is_BOM_BOQ_Document_Attached__c = true;
	 
			preSalesTest[0].RecordTypeId = PSR_ReadOnlyRecordTypeID;
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;
			//database.update(preSalesTest);
		
			Map<Id, Opportunity> oldMap  = new  Map<Id, Opportunity>();
			oldMap.put(optyCreation.Id, preSalesTest[0]);
			
			preSalesTest[0].StageName = 'Submitted For Approval';			
			//Updating Presales Oppty
			preSalesTest[0].Apttus_Approval__Approval_Status__c = 'Approved';
			preSalesTest[0].PSR_Automatically_Calc_Estimated_Cost__c = false;
			database.update(preSalesTest);
	 // OpportunityTriggerHelper_PreSales.NotifyOpportunityTeamMembers( presalesTest, oldMap );
			//OpportunityTriggerHelper_PreSales.NotifyOpportunityTeamMembers( null, null );
		}  
		
	} 
	
	static testMethod void IsApplicableForPreSalesMap() {
		
		Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		//Creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			//Creating account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '11111';
			//accountCreation.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			//database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '11112';
			
		sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(new List<Account>{accountCreation,sonAccount});
			sonAccount.ParentId = accountCreation.Id;
			update sonAccount;
			//Creating Indirect Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			OptyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			//Insert optyCreation;
			//Creating PreSales Risk Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest.RecordTypeId = PSR_EditRecordTypeID;
			//Creating PreSales Risk Oppty
			Opportunity preSalesTest1 = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest1.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest1.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest1.RecordTypeId = PSR_EditRecordTypeID;
			System.debug('BP --> accountCreation.Id: '+sonAccount.Id);
			System.debug('BP --> sonAccount.Id: '+sonAccount.Id);
			Test.startTest();
			database.insert(new List<Opportunity>{preSalesTest,preSalesTest1}); 
			String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			update optyCreation;			
			//database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);			
			
			//Updating Oppty with field required to chnage stage to 'Submitted for Approval'
			preSalesTest.PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest.PSR_Sales_Value_Business_Group_FN__c = 10;
			preSalesTest.PSR_Sales_Value_Business_Group_GS__c = 10;
			preSalesTest.PSR_Sales_Value_Business_Group_MN__c = 10;
			preSalesTest.PSR_Cost_Business_Unit_ION_IPR__c = 10;
			preSalesTest.PSR_Cost_Business_Unit_ION_Optics__c = 11;
			preSalesTest.PSR_Cost_Business_Unit_ION_Video__c = 12;
			preSalesTest.PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Description_Justification__c = 'Test';
			presalesTest.NF_PRE_Tech_Field__c = 'Gate Submitted';
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c = false;
			//database.update(preSalesTest);
			//Updating Oppty with field required to chnage stage to 'Submitted for Approval'
			preSalesTest1.PSR_Sales_Value_Business_Group_AA__c = 1000;
			preSalesTest1.PSR_Sales_Value_Business_Group_FN__c = 10;
			preSalesTest1.PSR_Sales_Value_Business_Group_GS__c = 10;
			preSalesTest1.PSR_Sales_Value_Business_Group_MN__c = 10;
			preSalesTest1.PSR_Cost_Business_Unit_ION_IPR__c = 10;
			preSalesTest1.PSR_Cost_Business_Unit_ION_Optics__c = 11;
			preSalesTest1.PSR_Cost_Business_Unit_ION_Video__c = 12;
			preSalesTest1.PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest1.PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest1.PSR_Description_Justification__c = 'Test';
			presalesTest1.NF_PRE_Tech_Field__c = 'Gate Submitted';
			preSalesTest1.PSR_Automatically_Calc_Estimated_Cost__c = false;
			database.update(new List<Opportunity>{preSalesTest,preSalesTest1});
			preSalesTest.StageName = 'Submitted For Approval';
			preSalesTest.RecordTypeId = PSR_ReadOnlyRecordTypeID;
			//Updating Presales Oppty
			//database.update(preSalesTest);
			preSalesTest1.StageName = 'Submitted For Approval';
			preSalesTest1.RecordTypeId = PSR_ReadOnlyRecordTypeID;
			database.update(new List<Opportunity>{preSalesTest,preSalesTest1});
			system.debug('preSalesTest>>>>>>>>>>>>'+preSalesTest);
			preSalesTest.Apttus_Approval__Approval_Status__c = 'Approved';
			system.debug('before update');
			//database.update(preSalesTest);			
			system.debug('preSalesTest>>>>>>>>>>>>'+preSalesTest);
			preSalesTest1.Apttus_Approval__Approval_Status__c = 'Rejected';
			database.update(new List<Opportunity>{preSalesTest,preSalesTest1});
			system.debug('preSalesTest'+preSalesTest);
			list<Opportunity> preSalesList = new list<opportunity>();
			preSalesList.add(preSalesTest); 
			preSalesList.add(preSalesTest1);	
			OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesMap(preSalesList,null);
			OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesList(preSalesList);
			//covering all exceptions
			OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesListWithReadOnly(null);
			OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesList(null);
	 try
			{
	OpportunityTriggerHelper_PreSales.getNokiaPeriodName(null,null);
			}
			catch(Exception ex){
	system.debug('Exception Occurred:'+ex);
			}
			//OpportunityTriggerHelper_PreSales.convertionUpdatePreSales(null,null);

		} Test.stopTest();
		}
   /* 
	static testMethod void convertVRPSR_validationRuleTest(){
		
	Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			accountCreation[1].AccountNumber = '2000';
			database.insert(accountCreation);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyCreation);
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			database.insert(preSalesTest[0]);
			
			System.debug('Hi, THe Current Currency for the PreSales Is >>>>>>>'+ preSalesTest[0].CurrencyIsoCode);
			//Trying to change the Currency
			
			preSalesTest[0].currencyISOCode ='INR';			
			
			database.update(preSalesTest[0]);  
			List<Opportunity> opportunityList = new List<Opportunity>();
			Map<ID, Opportunity> opportunityOldMap = new Map<ID, Opportunity>();	
			OpportunityTriggerHelper_PreSales.convertVRPSR_validationRule(preSalesTest,opportunityOldMap);
			//database.update(preSalesTest); 
			//System.debug('Now The Currency code should be changed to INR>>>>>' + preSalesTest.CurrencyIsoCode);  
		 
	}   
		
 }*/
	 static testMethod void accountUpdateonChildTest() {
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			accountCreation[1].AccountNumber = '2000';
Test.startTest();
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation[0].Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(sonAccount);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			String oppId = optyCreation.Id;
			optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			database.insert(preSalesTest[0]);
			
			Id getAccount;
			getAccount = accountCreation[1].Id;
			
			OptyCreation.AccountId = getAccount;
			//database.update(optyCreation);
			
			List<Opportunity> sampleopportunityList = new List<Opportunity>();
			Map<ID, Opportunity> sampleopportunityOldMap = new Map<ID, Opportunity>();
			
			sampleopportunityList.add(optyCreation);
			
			//OpportunityTriggerHelper_PreSales.populateParentAccount(preSalesTest,sampleopportunityOldMap);
			System.debug('The PSRO>>>>>'+ preSalesTest[0].Account.name);
Test.stopTest();
		}
		 
	 }
	
	static testMethod void parentCurrencyUpdateTest() {
		
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			//accountCreation[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accountCreation[1].AccountNumber = '2000';
			accountCreation[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			System.debug('BP - '+accountCreation[0].RecordTypeId);
			System.debug('BP - '+accountCreation[1].RecordTypeId);
			//database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1235';			
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accountCreation.add(sonAccount);
			database.insert(accountCreation);
			sonAccount.ParentId = accountCreation[0].Id;
			update sonAccount;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
	 // optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			test.startTest();
			database.insert(new List<Opportunity>{preSalesTest[0]});
			//String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			//database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			
			System.debug('PreSales Currency before updation of is' + preSalesTest[0].CurrencyIsoCode);
			optyCreation.CurrencyIsoCode = 'USD';
			database.update(optyCreation);
			
			List<Opportunity> sampleopportunityList = new List<Opportunity>();
			Map<ID, Opportunity> sampleopportunityOldMap = new Map<ID, Opportunity>();
			
			
			sampleopportunityList.add(optyCreation);
			
			OpportunityTriggerHelper_PreSales.populateParentCurrency(sampleopportunityList,sampleopportunityOldMap);
			
	System.debug('PreSales Currency before updation of is' + preSalesTest[0].CurrencyIsoCode); 
			// Now printing the currency after update of the opportunity.
	 
		}
		Test.stopTest();
	 }
	
	
	static testmethod void NotifyOTMsAndApprovalContributorsWhenClosedTest()
	{
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			accountCreation[1].AccountNumber = '2000';
			//accountCreation[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accountCreation[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			//database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1235';
			
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accountCreation.add(sonAccount);
			database.insert(accountCreation);
			sonAccount.ParentId = accountCreation[0].Id;
			update sonAccount;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			insert optyCreation;
			//optyCreation.G6_Planned_Date__c = Date.today();
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			Test.startTest();
			database.insert(new List<Opportunity>{preSalesTest[0]});
			//String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			//database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			
			//database.insert(preSalesTest[0]);
			
			System.debug('The current Stagename is>>>>>>>>>>>'+ preSalesTest[0].stagename);
			preSalesTest[0].stagename = 'Cancelled';
			database.update(preSalesTest[0]);
			
			map<Id, Opportunity> map_oppId_Opp = new map<Id, Opportunity>();
			map_oppId_Opp.put(preSalesTest[0].Id, preSalesTest[0]);
			//List<Opportunity> opptyList = new List<Opportunity>();
			OpportunityTriggerHelper_PreSales.NotifyOTMsAndApprovalContributorsWhenClosed(preSalesTest, map_oppId_Opp, map_oppId_Opp);
			try
			{
	OpportunityTriggerHelper_PreSales.NotifyOTMsAndApprovalContributorsWhenClosed(null,null,null);
			}
			catch(Exception ex){
	system.debug('Exception Occurred:'+ex);
			}
			//OpportunityTriggerHelper_PreSales.NotifyOpportunityTeamMembers(preSalesTest);
			
			
	}
	
 }

   
	static testmethod void NotifyOTMsAndApprovalContributorsWhenResetTest()
	{
		
		Id recordType1,recordType2 ;
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			//accountCreation[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accountCreation[1].AccountNumber = '2000';
			accountCreation[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			sonAccount.ParentId = accountCreation[0].Id;
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();			
			database.insert(sonAccount);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			//optyCreation.G6_Planned_Date__c = Date.today();
			database.insert(optyCreation);
			list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation);
			//Opportunity preSalesTest = preSalesOppty[0];
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
			Test.startTest();	
			database.insert(new List<Opportunity>{preSalesTest[0]});
			//String oppId = optyCreation.Id;
			//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			//database.update(optyCreation);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);			
			System.debug('The current Stagename is>>>>>>>>>>>'+ preSalesTest[0].stagename);
			preSalesTest[0].PSR_Reset_PSRO__c = True;
			preSalesTest[0].PSR_Reason_for_Reset__c = 'ADSADS';
			database.update(new List<Opportunity>{optyCreation,preSalesTest[0]});
			
			List<Opportunity> sampleopportunityList = new List<Opportunity>();
			Map<ID, Opportunity> sampleopportunityOldMap = new Map<ID, Opportunity>();
			sampleopportunityList.add(preSalesTest[0]);
			
			Map<id, Opportunity> oldMap  = new Map<id, Opportunity>();
			Opportunity oldOpt = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];
			oldOpt.StageName = GlobalConstants.IN_EXECUTION;
			
			oldMap.put(sampleopportunityList[0].Id, oldOpt);
			
			sampleopportunityList[0].stagename =  GlobalConstants.IN_EXECUTION;
			sampleopportunityList[0].PSR_Reset_PSRO__c = true;
			
			OpportunityTriggerHelper_PreSales.NotifyOTMsAndApprovalContributorsWhenReset(sampleopportunityList, oldMap);
			//OpportunityTriggerHelper_PreSales.NotifyOpportunityTeamMembers(sampleopportunityList);		
	}
	Test.stopTest();
 }

	
	
	static testmethod void costCalculationWhenEstimatedCostCheckedTest(){
			
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		
			Id recordType1,recordType2 ;
			user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
			insert userCreation;
			system.runAs(userCreation){
	List<Account> accountCreation = TestDataFactory.createAccount(2);
	accountCreation[0].AccountNumber = '1234';
	accountCreation[1].AccountNumber = '2000';
	database.insert(accountCreation);
	Account sonAccount = TestDataFactory.createAccount(1)[0];
	sonAccount.AccountNumber = '1235';
	sonAccount.ParentId = accountCreation[0].Id;
	sonAccount.Active__c = true;
	sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	database.insert(sonAccount);
	Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];			
	optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
	optyCreation.Country__c = 'India';
	optyCreation.G3_Approval_Date__c = system.now();
	optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
	optyCreation.Phase_Status__c = 'Opportunity in Progress';
	optyCreation.Legal_Entity__c = sonAccount.Id;
	OptyCreation.End_Customer_LE__c = sonAccount.Id;
	optyCreation.G2_Planned_Date__c = Date.today();
	optyCreation.G3_Planned_Date__c = Date.today();
	optyCreation.G4_Planned_Date__c = Date.today();
	optyCreation.G5_Planned_Date__c = Date.today();
	//optyCreation.G6_Planned_Date__c = Date.today();
	database.insert(optyCreation);
	String oppId = optyCreation.Id;
	//optyCreation = [select Id From Opportunity Where Id =: oppId limit 1];
	optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
	optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
	optyCreation.Phase_Status__c = 'Opportunity in Progress';
	database.update(optyCreation);
	Test.startTest();
	system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
	list<Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation);
	//Opportunity preSalesTest = preSalesOppty[0];
	
	preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Demo';
	preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'CT Customer';
	
	preSalesTest[0].RecordTypeId= PSR_EditRecordTypeID ;
	  
	preSalesTest[0].PSR_Automatically_Calc_Estimated_Cost__c = False;  
	preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 90;
	preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 300;
	preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 34;
	preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 67;
	preSalesTest[0].PSR_Sales_Value_Business_Unit_ION_Optics__c = 789;
	preSalesTest[0].PSR_Sales_Value_Business_Unit_ION_Video__c = 23;
	preSalesTest[0].PSR_Sales_Value_Business_Unit_ION_IPR__c = 69; 
	database.insert(preSalesTest);	 
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false ;
	
	  preSalesTest[0].PSR_Automatically_Calc_Estimated_Cost__c = true;
	preSalesTest[0].PSR_Sales_Value_Business_Group_AA__c = 10;
	preSalesTest[0].PSR_Sales_Value_Business_Group_FN__c = 100;
	preSalesTest[0].PSR_Sales_Value_Business_Group_GS__c = 14;
	preSalesTest[0].PSR_Sales_Value_Business_Group_MN__c = 17;
	preSalesTest[0].PSR_Sales_Value_Business_Unit_ION_Optics__c = 789;
	preSalesTest[0].PSR_Sales_Value_Business_Unit_ION_Video__c = 23;
	preSalesTest[0].PSR_Sales_Value_Business_Unit_ION_IPR__c = 69; 
	Database.update(preSalesTest);
	//OpportunityTriggerHelper_PreSales.costCalculationWhenEstimatedCostChecked(preSalesTest, oldMap); 
	OpportunityTriggerHelper_PreSales.costCalculationWhenEstimatedCostChecked(null, null);	
	Test.stopTest();
			} 
		
		}	
 
	
	static testmethod void convertionUpdatePreSalesTest(){
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		OpportunityTriggerHelper_PreSales.convertionUpdatePreSales(listOpty, idOpportunityMap);
	}
	  
	static testmethod void updateRecordTypeWhenPreSaleTypeIsOtherThanRSROTest() {
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		OpportunityTriggerHelper_PreSales.updateRecordTypeWhenPreSaleTypeIsOtherThanRSRO(listOpty, idOpportunityMap);
	}
	
	static testmethod void populateParentCurrencyOnPreSalesTest() {
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		OpportunityTriggerHelper_PreSales.populateParentCurrencyOnPreSales(listOpty, idOpportunityMap);
		
	}
	
	static testmethod void populateParentAccountOnPreSalesAndSetDefaultStageTest(){   
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		OpportunityTriggerHelper_PreSales.populateParentAccountOnPreSalesAndSetDefaultStage(listOpty, idOpportunityMap);
	}
	
	static testmethod void costCalculationWhenEstimatedCostCheckedTest1(){
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		idOpportunityMap.put(listOpty[0].id, listOpty[0] );
		OpportunityTriggerHelper_PreSales.costCalculationWhenEstimatedCostChecked( listOpty, idOpportunityMap);
		
	}
	
	static testmethod void convertVRPSR_validationRuleTest(){
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		idOpportunityMap.put(listOpty[0].id, listOpty[0] );
		OpportunityTriggerHelper_PreSales.convertVRPSR_validationRule( listOpty, idOpportunityMap);
		
	}
	
	static testmethod void NotifyOTMsAndApprovalContributorsWhenResetTest1(){
		Account acc = new Account( Name = 'Test Account' );
		list<Opportunity> listOpty = TestDataFactory.OpportunityCreation(2, acc );
		listOpty[0].stagename = GlobalConstants.IN_EXECUTION;
		listOpty[0].PSR_Reset_PSRO__c = true;
		Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();
		idOpportunityMap.put(listOpty[0].id, listOpty[0] );
		OpportunityTriggerHelper_PreSales.NotifyOTMsAndApprovalContributorsWhenReset( listOpty, idOpportunityMap);
		//OpportunityTriggerHelper_PreSales.NotifyOpportunityTeamMembers( listOpty, idOpportunityMap );
		
	}
	
	static testmethod void populatePreSalesOpportunityNumberTest(){
		OpportunityTriggerHelper_PreSales.populatePreSalesOpportunityNumber(null);
		//OpportunityTriggerHelper_PreSales.notifyOpportunityTeamMembers(null,null);
		OpportunityTriggerHelper_PreSales.convertVRPSR_valIdationRule(null,null);
	}
	static testmethod void updateThreshold(){
		
		Nokia_Financial_Calendar__c nokiaCalender = TestDataFactory.nokiaFinCalCreation(1)[0];
		nokiaCalender.Start_Date__c = System.today();
		nokiaCalender.End_Date__c = System.today();
		database.insert(nokiaCalender);
		Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
		database.insert(exchangeRate);
	
		 
		Id recordType1,recordType2 ;
		
		List<PSRO_Market_Threshold__c> THList = new List<PSRO_Market_Threshold__c>();
		PSRO_Market_Threshold__c OpenVal = new PSRO_Market_Threshold__c();
		OpenVal.Market__c = 'Market India';
		OpenVal.Business_group__c = 'NSW';
		OpenVal.Threshold_Value__c = 20000.00;
		OpenVal.Current_value__c = 10000.00;
	 	OpenVal.value_exceeded__c = false;
	 	THList.add(OpenVal);
		PSRO_Market_Threshold__c OpenVal1 = new PSRO_Market_Threshold__c();
		OpenVal1.Market__c = 'Market India';
		OpenVal1.Business_group__c = 'MN';
		OpenVal1.Threshold_Value__c = 2000.00;
		OpenVal1.Current_value__c = 10000.00;
	 	OpenVal1.value_exceeded__c = true;
		THList.add(OpenVal1);
		PSRO_Market_Threshold__c OpenVal2 = new PSRO_Market_Threshold__c();
		OpenVal2.Market__c = 'Market India';
		OpenVal2.Business_group__c = 'GS';
		OpenVal2.Threshold_Value__c = 200000.00;
		OpenVal2.Current_value__c = 10000.00;
	 	OpenVal2.value_exceeded__c = false;
		THList.add(OpenVal2);
		PSRO_Market_Threshold__c OpenVal3 = new PSRO_Market_Threshold__c();
		OpenVal3.Market__c = 'Market India';

		OpenVal3.Threshold_Value__c = 200000.00;
		OpenVal3.Current_value__c = 10000.00;
	 	OpenVal3.value_exceeded__c = false;
		THList.add(OpenVal3);
		PSRO_Market_Threshold__c OpenVal4 = new PSRO_Market_Threshold__c();
		OpenVal4.Market__c = 'Market India';
		OpenVal4.Business_group__c = 'FN';
		OpenVal4.Threshold_Value__c = 200000.00;
		OpenVal4.Current_value__c = 10000.00;
	 	OpenVal4.value_exceeded__c = false;
		THList.add(OpenVal4);
		PSRO_Market_Threshold__c OpenVal5 = new PSRO_Market_Threshold__c();
		OpenVal5.Market__c = 'Market India';
		OpenVal5.Business_group__c = 'NEN';
		OpenVal5.Threshold_Value__c = 200000.00;
		OpenVal5.Current_value__c = 10000.00;
	 	OpenVal5.value_exceeded__c = false;
		THList.add(OpenVal5);
		insert THList;
		
		Map_Enterprise_MUs_and_Market__c MU = new Map_Enterprise_MUs_and_Market__c();
		MU.Enterprise_MU__c = 'BWTX Market Unit INDIA';
		MU.MArket__C = 'Market India';
		MU.NAme = 'Test';
		insert MU;

		
		
		//Creating User
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){

			Sales_Role__c SR = NF_TestDataFactory.createSalesRole(usercreation,'NSNA_BGFPA','Market India','BG Finance PSRO Validator');
			SR.BG__c = 'NSW';
			//insert SR;			
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			accountCreation.L3Name__c = 'Nokia Enterprise';
			accountcreation.l4Name__c = 'Market India';
			accountCreation.L5Name__c = 'BWTX Market Unit INDIA';
			//database.insert(accountCreation);
			Account sonAccount = TestDataFactory.createAccount(1)[0];
			sonAccount.AccountNumber = '1234';
			
			sonAccount.Active__c = true;
			sonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			List<Account> accountsTobeInsert = new List<Account>{accountCreation,sonAccount};
			database.insert(accountsTobeInsert);
			sonAccount.ParentId = accountCreation.Id;
			update sonAccount;
			//database.insert(sonAccount);
			
	 
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
			optyCreation.RecordTypeId= oppIndirectRecordTypeId ;
			optyCreation.Country__c = 'India';
			optyCreation.CurrencyIsoCode = 'USD';
			optyCreation.G3_Approval_Date__c = system.now();
			optyCreation.G4_Approval_Date__c = system.now();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = 'Opportunity in Progress';
			optyCreation.Legal_Entity__c = sonAccount.Id;
			OptyCreation.End_Customer_LE__c = sonAccount.Id;
			optyCreation.G2_Planned_Date__c = Date.today();
			optyCreation.G3_Planned_Date__c = Date.today();
			optyCreation.G4_Planned_Date__c = Date.today();
			optyCreation.G5_Planned_Date__c = Date.today();
			insert optyCreation;
	 // optyCreation.G6_Planned_Date__c = Date.today();
			//database.insert(optyCreation);

			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+optyCreation);
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest.CurrencyIsoCode = 'USD';
			preSalesTest.RecordTypeId= PSR_EditRecordTypeID ;
			preSalesTest.PSR_Cost_Business_Group_AA__c = 40000;
			preSalesTest.PSR_Cost_Business_Group_FN__c = 2000;
			preSalesTest.PSR_Cost_Business_unit_ION_IPR__c = 300;
			preSalesTest.PSR_Cost_Business_Group_MN__c = 20000;
			preSalesTest.PSR_Cost_BU_NE_DAaaS__c = 2300;
			preSalesTest.PSR_Sales_Value_Business_Group_AA__c = 1000;

			preSalesTest.PSR_Is_Cost_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Is_Rv_Reflected_In_Latest_Estimate__c = 'Yes';
			preSalesTest.PSR_Description_Justification__c = 'Test';
			presalesTest.NF_PRE_Tech_Field__c = 'Gate Submitted';
			Test.startTest();
			List<Opportunity> opportunitiesToBeInsert = new List<Opportunity>{presalesTest};
			insert opportunitiesToBeInsert;
			//database.insert(preSalesTest);
			preSalesTest.StageName = 'Submitted For Approval';
			preSalesTest.RecordTypeId = PSR_ReadOnlyRecordTypeID;
			preSalesTest.PSR_Automatically_Calc_Estimated_Cost__c = false;
			//Updating Presales Oppty
			//database.update(preSalesTest);
			Map<Id, Opportunity> idOpportunityMap = new  Map<Id, Opportunity>();

			system.debug('preSalesTest>>>>>>>>>>>>'+preSalesTest);
			preSalesTest.Apttus_Approval__Approval_Status__c = 'Approved';
			presalesTest.NF_PRE_Tech_Field__c = 'Gate Submitted';
			presalesTest.StageName = 'In Execution';
			system.debug('preSalesTest>>>>>>>>>>>>'+preSalesTest);
			database.update(preSalesTest);
			List<Opportunity> psro = [Select Id,PSR_Pre_Sales_Risk_Opportunity_Type__c,CurrencyIsoCode,PSR_Cost_Business_Group_AA__c,
		 PSR_Cost_Business_Group_FN__c,stagename,PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c,G4_Approval_Date__c,Org_L4__c, Org_L3__c, Org_L5__c,PSR_Cost_Business_Group_ION__c,
		 // Commentd by HCL
		 PSR_Cost_Business_Group_MN__c,PSR_LoA_Level__c,PSR_Cost_BG_NEN__c,PSR_Reference_Opportunity__c,recordTypeId,PSR_Cost_Business_Group_GS__c,PSR_Lead_Business_Group__c,PSR_Total_Cost_In_Euro__c
		 //End

	from opportunity where ID =:presalesTest.Id limit 1 ];
			system.debug('psro>>>>>>>>>>>>'+psro);
	OpportunityTriggerHelper_Presales.psroUpdateThreshold(psro,idOpportunityMap);
	 }
}	 
 
}