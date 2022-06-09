@isTest
public class FileFieldDocStrategyTest {
	static testMethod void convertLeadTest()
	{   
		user userList = new User();		
		userList = CustomLeadConversionTest.createSystemAdminUser();
		System.runAs(userList){			
			List<Lead> leadList = new  List<Lead>();
			leadList = TestDataFactory.createLead(1);
			leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Reseller Deal Registration').getRecordTypeId();
			leadList[0].Customer_Type__c = 'Existing customer';
			leadList[0].Company = 'Test';
			insert leadList; 
			//creating content version
				ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,'N/A')[0];
				conVersionVar.RecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get('Unrestricted File to Other').getRecordTypeId();
			   
				insert conVersionVar;
				
				List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
												   where ID =: conVersionVar.Id LIMIT 1];			
				//creating contentDocumentLink
				list<ContentDocumentLink> contentDocumentLinkList = new list<ContentDocumentLink>();
				contentDocumentLinkList = TestDataFactory.createContentDocumentLink_New(1,leadList[0].Id,conVersion[0].ContentDocumentId);
				insert contentDocumentLinkList; 
				Test.starttest();
			FileFieldDocStrategy.getFileData(conVersion[0].ContentDocumentId);
				FileFieldDocStrategy.getFileReportData(conVersion[0].ContentDocumentId);
				Test.stoptest();
		}  
	}
}