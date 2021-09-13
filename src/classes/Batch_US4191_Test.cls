@isTest
public class Batch_US4191_Test {
	
	static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	static Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.DIRECT_OPPTY).getRecordTypeId();
	
	static testMethod void testBatchUpdateOpps() {
		
		Account customerAcc = new Account(
			name='Batch test' + Utils.generateRandomInteger(4), 
			RecordTypeId=accRecordTypeId,
			Active__c = true,
			AccountStatusInCRMOM__c = 'Active'
		);
		
		insert customerAcc;
		
		List<Opportunity> opportunities = new List<Opportunity>();
		for(Integer i = 0 ; i < 10 ; i++) {
			opportunities.add(
				new Opportunity(
					Name='Batch oppty ' + i + '-' + Utils.generateRandomInteger(2), 
					AccountId = customerAcc.Id,
					StageName = GlobalConstants.IDENTIFY_OPPORTUNITY,
					Phase_Status__c = GlobalConstants.PLANNED,
					RecordTypeId = oppRecordTypeId,
					Lead_BG__c = 'ION',
					Lead_BU__c = 'ION IPR',
					Unweighted_Amount_EUR__c =10000,
					Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY,
					Contract_Signing_Entity__c = 'fALU',
				 	G3_Planned_Date__c = System.today(),
					G4_Planned_Date__c = System.today().addMonths(1),
					G5_Planned_Date__c = System.today().addMonths(3),
					G6_Planned_Date__c = System.today().addMonths(4),
					CloseDate = System.today().addMonths(5)
					)
			);			
		}
		
		insert opportunities;
		
		List<Offer__c> offers = new List<Offer__c>();
		for(Opportunity opportunity : opportunities){
			offers.add(
				new Offer__c(
					Name = opportunity.Name + '-Offer',
					Opportunity__c = opportunity.Id,
					G4_Approval_Date__c = System.today().addMonths(1),
					Expected_LoA_G4_Approval_Level__c = 'A',
					Customer_and_Competitive_Situation__c='Test Customer and Competitive Situation'
				)
			);
		}
		
		insert offers;
		
		Test.startTest();

			Batch_US4191 obj = new Batch_US4191();
			DataBase.executeBatch(obj); 
			
		Test.stopTest();
	}
	
}