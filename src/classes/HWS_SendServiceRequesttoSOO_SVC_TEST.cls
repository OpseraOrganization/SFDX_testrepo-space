/********************************************************************************
* Name : HWS_SendServiceRequesttoSOO_SVC_TEST
* Description : Test class for HWS_SendServiceRequesttoSOO_SVC
********************************************************************************/
@isTest
Public class HWS_SendServiceRequesttoSOO_SVC_TEST{ 
	static final string FAILINFO = 'Failure Info';
	@testSetup 
	static void setuptestdata(){
		Id CustomerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id LegalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Account customeracc = HWS_DataFactory_TEST.insertAccount(); 
		customeracc.RecordTypeId =  CustomerAccountType;
		customeracc.Customer_Compliance__c = 'US_AT&T';
		insert customeracc;
		Account leagalacc = HWS_DataFactory_TEST.insertAccount(); 
		leagalacc.RecordTypeId =  LegalEntityAccountType; 
		leagalacc.ParentId= customeracc.Id;
		leagalacc.Customer_Compliance__c = 'US_AT&T';
		insert leagalacc;
		Account resellerAcc = HWS_DataFactory_TEST.insertAccount();	
		resellerAcc.RecordTypeId =  LegalEntityAccountType;	
		resellerAcc.Name ='Reseller Acc';	
		resellerAcc.AccountNumber ='23456789';	
		resellerAcc.NCP_P20_ID__c ='56565656';	
		resellerAcc.ParentId= customeracc.Id;	
		resellerAcc.Customer_Compliance__c = 'US_AT&T';	
		insert resellerAcc;
		ServiceContract serContr =  HWS_DataFactory_TEST.insertServiceContract(leagalacc);
		serContr.CH_ERPSystem__c = 'P20';
		insert serContr;
		product2 prdtest=HWS_DataFactory_TEST.insertproduct2();
		insert prdtest;	
		Id parentRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);	
		Case parentCase = new Case();
		parentCase=HWS_DataFactory_TEST.createCase(parentRecordType);
		parentCase.AccountId=leagalacc.Id;
		insert parentCase;
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId=leagalacc.Id;
		childCase.NCP_Service_Contract__c = serContr.Id;
		childCase.Status ='Draft';
		insert childCase;
	}
		Public Static testMethod void bulkParentCasesWrapperTest(){	
		Id parentRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);	
		Case parentCase = new Case();	
		parentCase = HWS_DataFactory_TEST.createCase(parentRecordType);	
		parentCase.HWS_Delivery_TimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';	
		account acct = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];	
		parentCase.AccountId = acct.Id;	
		test.startTest();	
		insert parentCase;	
		HWS_BulkParentCases_WRAPPER bulkParentCasesWrapper = new HWS_BulkParentCases_WRAPPER(parentCase.CaseNumber, 'Bulk');	
		try{	
		Test.setMock(HttpCalloutMock.class, new HWS_SendWarrantyCheckRequesttoSOO_Test(true, ''));	
		HWS_SendServiceRequesttoSOO_SVC.sendBulkToSOO(parentCase.Id);	
		}	
		catch(Exception e){	
		//This is empty	
		}	
		test.stopTest();	
		}
			Public Static testMethod void parentCaseWrapperTest(){
		Id parentRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Case parentCase = new Case();
		parentCase=HWS_DataFactory_TEST.createCase(parentRecordType);
		parentCase.HWS_Delivery_TimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
		account acct = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];	
		parentCase.AccountId=acct.Id;
		Datetime dt = system.now();
		Date d = system.Today();
		
		test.startTest();
		insert parentCase;
		HWS_ParentCase_WRAPPER parentCaseWrapper = new HWS_ParentCase_WRAPPER(parentCase,'P20','52130','','',false,'');
		HWS_ParentCase_WRAPPER.convetDateTime(dt);
		HWS_ParentCase_WRAPPER.convetDate(d);
		HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormat(dT);
		HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormatGMT(dT);   
	
		try{
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(true));	 
		HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCase.Id,'');
		}
		catch(Exception e){		 
			String testException = e.getMessage();
		}
		test.stopTest();		
	}
	//added for NOKIASC-35934
	Public Static testMethod void testPurchaserTypeScenario(){
		Id parentRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		Case childCase = [SELECT Id FROM Case WHERE RecordTypeId =: exchangeInDays LIMIT 1];
		ServiceContract servContract = [SELECT Id,HWS_PurchaserType__c,CH_InvoiceReferentialId__c FROM ServiceContract LIMIT 1];
		servContract.HWS_PurchaserType__c = 'Customer via Partner';
		servContract.CH_InvoiceReferentialId__c = '23456789';
		update servContract;
		Case parentCase = new Case();
		parentCase=HWS_DataFactory_TEST.createCase(parentRecordType);
		parentCase.HWS_Delivery_TimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
		account acct = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];  
		parentCase.AccountId=acct.Id;
		Datetime dt = system.now();
		Date d = system.Today();
		
		test.startTest();
		insert parentCase;
		childCase.ParentId = parentCase.Id;
		HWS_ParentCase_WRAPPER parentCaseWrapper = new HWS_ParentCase_WRAPPER(parentCase,'P20','52130','Customer via Partner','23456789',true,'');		
		HWS_ParentCase_WRAPPER.convetDateTime(dt);
		HWS_ParentCase_WRAPPER.convetDate(d);
		HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormat(dT);
		HWS_ParentCase_WRAPPER.convetDateTimetoSOOFormatGMT(dT);   
		
		try{
			Test.setMock(HttpCalloutMock.class, new HWS_SendWarrantyCheckRequesttoSOO_Test(true, ''));  
			HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCase.Id, '');
		}
		catch(Exception e){	  
			//This is empty
		}
		test.stopTest();		
	}
	Public Static testMethod void sendtoSOOTestFailure(){
		product2 prdtest=[SELECT Id FROM product2 WHERE IsActive=true LIMIT 1];
		account acco = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];
		Case parentCase = [SELECT Id FROM Case WHERE Subject='Test Subject' LIMIT 1]; 
		Case childCase = [SELECT Id,HWS_Sellable_Product__r.HWS_Unit_of_Measure__c,HWS_RequestHWRCAFMA__c,HWS_Quantity__c,HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c,HWS_Site_ID__c,HWS_Site_Information__c,HWS_Failure_Description_Server_ID__c,HWS_Replacement_Unit_Serial_Number__c,HWS_Fault_Reported_By_Email__c,HWS_Fault_Reported_By_Phone__c,HWS_Fault_Reported_By_Name__c,HWS_Faulty_Serial_Number__c,HWS_Failure_Detection_Date__c,HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Sellable_Product__r.ProductCode,Asset.HWS_ContractLeadTimeUnit__c, Asset.HWS_ContractLeadTimeDuration__c,Parent.HWS_Customer_PO__c,NCP_Service_Contract__r.CH_ERPSystem__c,NCP_Service_Contract__r.HWS_Currency__c,NCP_Service_Contract__r.HWS_SalesOrganisation__c, NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,HWS_RMA_Number__c,HWS_Planned_Delivery_Date__c,HWS_Requested_Delivery_Date_Time__c,Status, NCP_Service_Contract__r.CH_SAP_ContractNumber__c,NCP_Service_Contract__r.HWS_Combined_Ordering__c,HWS_Customer_Reference_Number__c,HWS_ServiceType__c FROM Case WHERE HWS_Faulty_Serial_Number__c='test1234' LIMIT 1];	
		
		ServiceContract serContr = [SELECT Id FROM ServiceContract WHERE name='test' LIMIT 1];
		serContr.CH_ERPSystem__c = '';	
		update serContr;
		childCase.ParentId=parentCase.Id;
		childCase.NCP_Service_Contract__c = serContr.Id;
		childCase.AccountId=acco.Id;
		childCase.HWS_Sellable_Product__c=prdtest.Id;
		
		hws_versionitem__c vitem =  HWS_DataFactory_TEST.insertHwsversionitem();
		vitem.HWS_Version_Code__c='ANY';
		insert vitem;
		childCase.HWS_Stockable_Product__c=vitem.Id;
		childcase.HWS_Faulty_Serial_Number__c='123456';
	
		childcase.HWS_Customer_Part_Revision__c='12345';
		childcase.HWS_Failure_Occurance__c='In normal use';
		childcase.HWS_Failure_Detection__c='Start reset loop';
		childcase.HWS_Failure_Description__c='Unit/module not recognized';
		update childcase;
		
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(false));
		HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCase.Id,'');
		HWS_SendServiceRequesttoSOO_SVC.createCalloutErrorLog(FAILINFO);	 
		test.stopTest();
	}
	Public Static testMethod void sendtoSOOTestFailureOccurance2(){
		product2 product=[SELECT Id FROM product2 WHERE IsActive=true LIMIT 1];
		account acc = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];
		Case parentCases = [SELECT Id FROM Case WHERE Subject='Test Subject' LIMIT 1]; 
		Case childCases = [SELECT Id,HWS_Quantity__c,HWS_Sellable_Product__r.HWS_Unit_of_Measure__c,HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c,HWS_Site_ID__c,HWS_Site_Information__c,HWS_Failure_Description_Server_ID__c,HWS_Replacement_Unit_Serial_Number__c,HWS_Fault_Reported_By_Email__c,HWS_Fault_Reported_By_Phone__c,HWS_Fault_Reported_By_Name__c,HWS_Faulty_Serial_Number__c,HWS_Failure_Detection_Date__c,HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Sellable_Product__r.ProductCode,Asset.HWS_ContractLeadTimeUnit__c, Asset.HWS_ContractLeadTimeDuration__c,Parent.HWS_Customer_PO__c,NCP_Service_Contract__r.CH_ERPSystem__c,NCP_Service_Contract__r.HWS_Currency__c,NCP_Service_Contract__r.HWS_SalesOrganisation__c, NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,HWS_RMA_Number__c,HWS_Planned_Delivery_Date__c,HWS_Requested_Delivery_Date_Time__c,Status, NCP_Service_Contract__r.CH_SAP_ContractNumber__c,HWS_Customer_Reference_Number__c,HWS_ServiceType__c FROM Case WHERE HWS_Faulty_Serial_Number__c='test1234' LIMIT 1];	
		
		ServiceContract servContr = [SELECT Id FROM ServiceContract WHERE name='test' LIMIT 1];
	
		childCases.ParentId=parentCases.Id;
		childCases.NCP_Service_Contract__c = servContr.Id;
		childCases.AccountId=acc.Id;
		childCases.HWS_Sellable_Product__c=product.Id;
		childCases.HWS_Failure_Occurance__c='Permanent';
		childCases.HWS_Failure_Detection__c='Reboot module';
		childCases.HWS_Failure_Description__c='No TX power';
		update childcases;
			
		test.startTest();	  
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(false));
		HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCases.Id,'');
		HWS_SendServiceRequesttoSOO_SVC.createCalloutErrorLog(FAILINFO);	 
		test.stopTest();
	}
	 Public Static testMethod void sendtoSOOTestFailureOccurance3(){
		product2 prod=[SELECT Id FROM product2 WHERE IsActive=true LIMIT 1];
		account accn = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];
		Case parentcse = [SELECT Id FROM Case WHERE Subject='Test Subject' LIMIT 1]; 
		Case childcse = [SELECT Id,HWS_Sellable_Product__r.HWS_Unit_of_Measure__c,HWS_Quantity__c,HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c,HWS_Site_ID__c,HWS_Site_Information__c,
		HWS_Failure_Description_Server_ID__c,HWS_Replacement_Unit_Serial_Number__c,HWS_Fault_Reported_By_Email__c,HWS_Fault_Reported_By_Phone__c,HWS_Fault_Reported_By_Name__c,
		HWS_Faulty_Serial_Number__c,HWS_Failure_Detection_Date__c,HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Sellable_Product__r.ProductCode,Asset.HWS_ContractLeadTimeUnit__c,
		Asset.HWS_ContractLeadTimeDuration__c,Parent.HWS_Customer_PO__c,NCP_Service_Contract__r.CH_ERPSystem__c,NCP_Service_Contract__r.HWS_Currency__c,NCP_Service_Contract__r.HWS_SalesOrganisation__c,
		NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,HWS_RMA_Number__c,HWS_Planned_Delivery_Date__c,HWS_Requested_Delivery_Date_Time__c,Status,
		NCP_Service_Contract__r.CH_SAP_ContractNumber__c,HWS_Customer_Reference_Number__c,HWS_ServiceType__c FROM Case WHERE HWS_Faulty_Serial_Number__c='test1234' LIMIT 1];	
		
		ServiceContract serCont = [SELECT Id FROM ServiceContract WHERE name='test' LIMIT 1];
	
		childcse.ParentId=parentcse.Id;
		childcse.NCP_Service_Contract__c = serCont.Id;
		childcse.AccountId=accn.Id;
		childcse.HWS_Sellable_Product__c=prod.Id;
		childcse.HWS_Failure_Occurance__c='During installation / commissioning / Dead On Arrival';
		childcse.HWS_Failure_Detection__c='Fails on diagnostics';
		childcse.HWS_Failure_Description__c='Fan defect';
		update childcse;
			
		test.startTest();	  
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(false));
		HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentcse.Id,'');
		HWS_SendServiceRequesttoSOO_SVC.createCalloutErrorLog(FAILINFO);	 
		test.stopTest();
	}
	Public Static testMethod void sendtoSOOTestFailureOccurance4(){
		product2 prodctest=[SELECT Id FROM product2 WHERE IsActive=true LIMIT 1];
		account acct = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];
		Case parentCs = [SELECT Id FROM Case WHERE Subject='Test Subject' LIMIT 1]; 
		Case childCs = [SELECT Id,HWS_ServiceType__c,HWS_Sellable_Product__r.HWS_Unit_of_Measure__c,HWS_Quantity__c,HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c,HWS_Site_ID__c,HWS_Site_Information__c,HWS_Failure_Description_Server_ID__c,HWS_Replacement_Unit_Serial_Number__c,HWS_Fault_Reported_By_Email__c,HWS_Fault_Reported_By_Phone__c,HWS_Fault_Reported_By_Name__c,HWS_Faulty_Serial_Number__c,HWS_Failure_Detection_Date__c,HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Sellable_Product__r.ProductCode,Asset.HWS_ContractLeadTimeUnit__c, Asset.HWS_ContractLeadTimeDuration__c,Parent.HWS_Customer_PO__c,NCP_Service_Contract__r.CH_ERPSystem__c,NCP_Service_Contract__r.HWS_Currency__c,NCP_Service_Contract__r.HWS_SalesOrganisation__c, NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,HWS_RMA_Number__c,HWS_Planned_Delivery_Date__c,HWS_Requested_Delivery_Date_Time__c,Status, NCP_Service_Contract__r.CH_SAP_ContractNumber__c,HWS_Customer_Reference_Number__c FROM Case WHERE HWS_Faulty_Serial_Number__c='test1234' LIMIT 1];		
		ServiceContract serContr = [SELECT Id FROM ServiceContract WHERE name='test' LIMIT 1];
	
		childCs.ParentId=parentCs.Id;
		childCs.NCP_Service_Contract__c = serContr.Id;
		childCs.AccountId=acct.Id;
		childCs.HWS_Sellable_Product__c=prodctest.Id;
		childCs.HWS_Failure_Occurance__c='During or after lightning / severe weather conditions';
		childCs.HWS_Failure_Detection__c='Other';
		childCs.HWS_Failure_Description__c='LED indicates alarm';
		update childCs;
			
		test.startTest();	  
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(false));
		HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCs.Id,'');
		HWS_SendServiceRequesttoSOO_SVC.createCalloutErrorLog(FAILINFO);	 
		test.stopTest();
	}
	 Public Static testMethod void sendtoSOOTestFailureOccurance5(){
		product2 prduct=[SELECT Id FROM product2 WHERE IsActive=true LIMIT 1];
		account acnt = [SELECT Id FROM Account WHERE Name='test' LIMIT 1];
		Case prntCase = [SELECT Id FROM Case WHERE Subject='Test Subject' LIMIT 1]; 
		Case chldCase = [SELECT Id,HWS_Customer_Reference_Number__c,HWS_Sellable_Product__r.HWS_Unit_of_Measure__c,HWS_Quantity__c,HWS_Stockable_Product__r.HWS_Serial_Number_Traceable__c,HWS_Site_ID__c,HWS_Site_Information__c,HWS_Failure_Description_Server_ID__c,HWS_Replacement_Unit_Serial_Number__c,HWS_Fault_Reported_By_Email__c,HWS_Fault_Reported_By_Phone__c,HWS_Fault_Reported_By_Name__c,HWS_Faulty_Serial_Number__c,HWS_Failure_Detection_Date__c,HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Sellable_Product__r.ProductCode,Asset.HWS_ContractLeadTimeUnit__c, Asset.HWS_ContractLeadTimeDuration__c,Parent.HWS_Customer_PO__c,NCP_Service_Contract__r.CH_ERPSystem__c,NCP_Service_Contract__r.HWS_Currency__c,NCP_Service_Contract__r.HWS_SalesOrganisation__c, NCP_Service_Contract__r.HWS_CaresRepairServiceBillToCode__c,HWS_Contract_Line_Item__r.CH_ServiceType__c,HWS_RMA_Number__c,HWS_Planned_Delivery_Date__c,HWS_Requested_Delivery_Date_Time__c,Status, NCP_Service_Contract__r.CH_SAP_ContractNumber__c,HWS_ServiceType__c FROM Case WHERE HWS_Faulty_Serial_Number__c='test1234' LIMIT 1]	;
		
		ServiceContract serContract = [SELECT Id FROM ServiceContract WHERE name='test' LIMIT 1];
	
		chldCase.ParentId=prntCase.Id;
		chldCase.NCP_Service_Contract__c = serContract.Id;
		chldCase.AccountId=acnt.Id;
		chldCase.HWS_Sellable_Product__c=prduct.Id;
		chldCase.HWS_Failure_Occurance__c='During or after SW or HW upgrade / modifications';
		chldCase.HWS_Failure_Detection__c='Non-reproducible';
		chldCase.HWS_Failure_Description__c='Unit alarm';
		update chldCase;
			
		test.startTest();	  
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(false));
		HWS_SendServiceRequesttoSOO_SVC.sendToSOO(prntCase.Id,'');
		HWS_SendServiceRequesttoSOO_SVC.createCalloutErrorLog(FAILINFO);	 
		test.stopTest();
	}
	 
}