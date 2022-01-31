@isTest
private class RequirementTest{
	public static testMethod void testCountRequests(){
	
	
	Capability__c feature1 = new Capability__c();
	feature1.Name = 'Test Feature1';
	feature1.Feature_Category__c = 'Account Management & Planning';
	insert feature1;
	
	List<User_Story__c> usList = new List<User_Story__c>();
	User_Story__c us1 = new User_Story__c();
	us1.Name = 'Test US1';
	us1.Capability__c  = feature1.Id;
	usList.add(us1);
	
	User_Story__c us2 = new User_Story__c();
	us2.Name = 'Test US2';
	us2.Capability__c  = feature1.Id;
	usList.add(us2);
	
	insert usList;
	
	Request__c req1 = new Request__c();
	req1.Request_Description__c = 'Test Req1';
	req1.Request_Title__c = 'Test Req1';
	req1.User_Story__c = usList[0].Id;
	insert req1;
	
	Request__c req2 = new Request__c();
	req2.Request_Description__c = 'Test Req2';
	req2.Request_Title__c = 'Test Req2';
	req2.User_Story__c = usList[1].Id;
	insert req2;
	
	req1.User_Story__c = usList[1].Id;
	update req1;
	
	
	delete req2;
	
	
	}

}