@isTest
public class DefectAgeTest {
  
	Static testmethod void defectcreation(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
			test.startTest();
			//Release Creation
			Release__c release = new Release__c();
			release.Name = 'Test Release';
			release.CurrencyIsoCode = 'EUR';
			database.insert(release);
			
			//Feature creation
			Capability__c feature = new Capability__c();
			feature.Name = 'Test Feature';
			feature.Release__c = release.id;
			feature.Feature_Category__c = 'Quote Management';
			feature.Workstream__c = 'CPQ - Main';
			feature.Team__c = 'CPQ - QTC Quoting';
			database.insert(feature);
			
			
			//UserStory creation
			User_Story__c userStory = new User_Story__c();
			userStory.Name = 'Test Story';
			userStory.Capability__c = feature.id;
			database.insert(userStory);
			
			//Request creation
			Request__c req = new Request__c();
			req.Request_Type__c = 'Functional';
			req.Request_Title__c = 'Test Req';
			req.Request_Description__c = 'Test Purpose';
			req.Status__c = 'Identify: New Requirement';
			req.User_Story__c = userStory.id;
			database.insert(req);
			
			
			
			Defect__c def1 = new Defect__c();
			def1.Related_Request__c = req.id;
			def1.Subject__c = 'Test Defect 1';
			def1.Application__c = 'SFDC';
			def1.Severity__c = 'Low';
			def1.Priority__c = 'Low Priority';
			def1.Team__c = 'CPQ - QTC Quoting';
			def1.Detailed_Description__c = 'Test Purpose 1';
			def1.Defect_Type__c = 'Defect';
			def1.Status__c = 'New';
			def1.Identifying_Team__c = 'Test';
			def1.Stage_Found__c = 'Unit Test';  
			def1.Owning_Group__c = 'Accenture';
			def1.Status_Start_Date__c = system.now();
			
			database.insert(def1);
						
			def1.Status__c = 'Assigned'; 
			database.update(def1);
			
			test.stopTest();
		}
		
	}
}