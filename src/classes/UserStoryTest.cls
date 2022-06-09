@isTest
private class UserStoryTest{
	public static testMethod void testCountRequests(){
	
	List<Capability__c> featureList = new List<Capability__c>();
	Capability__c feature1 = new Capability__c();
	feature1.Name = 'Test Feature1';
	feature1.Feature_Category__c = 'Account Management & Planning';
	featureList.add(feature1);
	
	Capability__c feature2 = new Capability__c();
	feature2.Name = 'Test Feature2';
	feature2.Feature_Category__c = 'Sales Efficiency Management, Process Management & Compliance, Sales KPI';
	featureList.add(feature2);
	
	insert featureList;
	
	User_Story__c usObj1 = new User_Story__c();
	usObj1.Name = 'Test US1';
	usObj1.Capability__c = featureList[0].Id;
	insert usObj1;
	
	User_Story__c usObj2 = new User_Story__c();
	usObj2.Name = 'Test US2';
	usObj2.Capability__c = featureList[1].Id;
	insert usObj2;
	
	usObj1.Capability__c = featureList[1].Id;
	update usObj1;
	
	
	delete usObj2;
	
	
	}

}