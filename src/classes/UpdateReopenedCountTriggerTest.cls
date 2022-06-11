@isTest
public class UpdateReopenedCountTriggerTest {
	
	 public static List<User> userCreation(integer size,string profileName){
		List<User> userList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].id;
		//Id role = [select userroleid from User where UserRole.name =: roleName limit 1].id;
		for (integer i = 0; i < size; i++){
			User user = new User(alias = 'abc', email = 'Email' + Math.floor(Math.random()*1000) + '@test.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = 'User' + Math.floor(Math.random()*1000) + '@test.com',Restriction_Level__c = 'Confidential' );
			userList.add(user);
		}
		return userList;
	}
		
	static testmethod void UpdateReopenedCountTestMethod1(){
		Defect__c newDef = new Defect__c(Status__c = 'Failed Retest', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Times_Reopened__c=0,Team__c='Sales Process',Root_Cause_Details__c='Test',Root_Cause__c='Design');
		insert(newDef);
		newDef.Status__c = 'Expected Behaviour';
		update newDef;
	}
	
	static testmethod void UpdateReopenedCountTestMethod2(){
		Defect__c newDef2 = new Defect__c(Status__c = 'Closed', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Team__c='Sales Process',Root_Cause_Details__c='Test',Root_Cause__c='Design');
		insert(newDef2);
		newDef2.Status__c = 'Resolved';
		update newDef2;
	}

	static testmethod void UpdateReopenedCountTestMethod3(){
		Defect__c newDef2 = new Defect__c(Status__c = 'In Progress', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Team__c='Sales Process');
		insert(newDef2);
		newDef2.Status__c = 'RE-OPENED';
		newDef2.Retest_Status__c='Open';
		newDef2.Retesting_Comments__c = 'XYZ';
		update newDef2;
	}
}