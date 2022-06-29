@isTest
public class PreApprovedProductsJobScheduler_Test {
	@isTest static void test_scheduler(){ 
		 
		Test.StartTest();
		User userRecord =  [Select id from User where Id = :UserInfo.getUserId()];


		List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		account3[1].Partner_Type__c = '';
		account3[1].Partner_Program__c = '';
		account3[0].Pre_Approved_Product_Notification_Date__c = Date.today().addDays(-100);
		account3[0].Country__c = 'Japan';
		insert account3;

		List<Pre_Approved_Custom_Products__c> preApprovedProducts = new List<Pre_Approved_Custom_Products__c>();
		Pre_Approved_Custom_Products__c preApprovedProductsRecord1 = new Pre_Approved_Custom_Products__c(Account__c=account3[0].Id,Expiration_Date__c=System.Today(),Is_NSP__c=true,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='IP Routing',Product_Code__c='PROD1',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);
		Pre_Approved_Custom_Products__c preApprovedProductsRecord2 = new Pre_Approved_Custom_Products__c(Account__c=account3[0].Id,Expiration_Date__c=Date.today().addDays(100),Is_NSP__c=true,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='IP Routing',Product_Code__c='PROD2',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);
		Pre_Approved_Custom_Products__c preApprovedProductsRecord3 = new Pre_Approved_Custom_Products__c(Account__c=account3[0].Id,Expiration_Date__c=Date.today().addDays(100),Is_NSP__c=false,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='IP Routing',Product_Code__c='PROD3',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);
		Pre_Approved_Custom_Products__c preApprovedProductsRecord4 = new Pre_Approved_Custom_Products__c(Account__c=account3[0].Id,Expiration_Date__c=Date.today().addDays(-100),Is_NSP__c=false,List_Price__c=5.0,Maintenance_Beyond_Warranty_Rate__c=1.0,Maintenance_Type__c='Gold (Return for Exchange)',Maintenance_Under_Warranty_Rate__c=2.0,Portfolio__c='IP Routing',Product_Code__c='PROD3',Product_Discount_Rate__c=3.0,SSP_Rate__c=4.0);

		preApprovedProducts.add(preApprovedProductsRecord1);
		preApprovedProducts.add(preApprovedProductsRecord2);
		preApprovedProducts.add(preApprovedProductsRecord3);
		preApprovedProducts.add(preApprovedProductsRecord4);
		insert preApprovedProducts;

		

		CPQ_Approver__c cpqApproverRecord = new CPQ_Approver__c(User__c=userRecord.Id,BG__c='ION',Seq__c='1',P__c='IP Routing',O__c='Japan');
		insert cpqApproverRecord;

		PreApprovedProductsJobScheduler batchJob = new PreApprovedProductsJobScheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Pre-Approved Products Daily Run', sch, batchJob);
		Test.stopTest(); 
	
	}}