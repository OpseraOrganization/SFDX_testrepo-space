/****************************************
* Class Name : OrderIntakeAllocationCreationTest
* Created Date: 12 Jan 2021
* Created By : HCL
* Last Modified by: HCL
* Last Modified Date:12 Jan 2021
* Description : Test Class for OrderIntakeAllocationCreation 
*****************************************/

@isTest
private class OrderIntakeAllocationCreationTest {
	
	@testSetup static void testDataSetup() {
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			
			List<Account> accountList =TestDataFactory.createAccount(1);
			database.insert(accountList);
			List<Opportunity> opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList);   
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			
			List<product2> productList= productCreation(4);
			database.insert(productList);
			productList[1].Allocated_BL_1__c=productList[0].id;
			productList[2].Allocated_BL_2__c=productList[0].id;
			productList[3].Allocated_BL_3__c=productList[0].id;
			Database.update(productList);
			
			List<Order_Intake_Forecast__c> OIFlines = new List<Order_Intake_Forecast__c>();
			OIFlines.add(orderIntakeCreation(opportunityList[0],productList[1],nokiaFinCal));
			OIFlines.add(orderIntakeCreation(opportunityList[0],productList[2],nokiaFinCal));
			OIFlines.add(orderIntakeCreation(opportunityList[0],productList[3],nokiaFinCal));
			database.insert(OIFlines);
	 }
	}
	static testMethod void OrderIntakeAllocation(){
		
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			Set<Id> oppId=new Set<Id>();
			List<Opportunity> oppDetails=[Select id from Opportunity Limit 1];
			oppId.add(oppDetails[0].id);
			Test.startTest();
			OrderIntakeAllocationCreation.OIFAlloctionCreate(oppId);
			Test.stopTest();
		}
	}
	
	public static List<product2> productCreation(Integer size) {
		List<product2> productList = new List<product2>();
		for (integer i = 0; i < size; i++) {
			product2 prod = new product2();
			prod.name = 'MN - Small Cells 5G (PL)';
			prod.CurrencyIsoCode = 'USD';
			prod.Business_Line2__c= '5G';
			prod.Business_Group__c = 'MN';
			prod.Family = 'MNRAN';
			
			prod.Post_Allocation_1__c=5;
			prod.Post_Allocation_2__c=5;
			prod.Post_Allocation_3__c=5;
			
			prod.IsActive = True;
			prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Business Line').getRecordTypeId();
			productList.add(prod);
			
		}
		return productList;
	}
	
	public static Order_Intake_Forecast__c orderIntakeCreation(Opportunity oppty, Product2 prod, Nokia_Financial_Calendar__c nokiaFinCal) {
		Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c();
			orderIntake.BusinessLine__c = prod.id;
			orderIntake.Opportunity__c = oppty.id;
			orderIntake.Software__c = 22;
			orderIntake.OIF_Value__c = 100;
			orderIntake.Forecast_Category__c = 'Risk';
			orderIntake.POPlanReceipt__c = nokiaFinCal.id;
			orderIntake.Rev_RecPlan_Receipt__c=nokiaFinCal.id;
			orderIntake.Close_Date__c = system.today();
		return orderIntake;
	}
}