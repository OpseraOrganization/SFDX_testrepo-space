@isTest
/** 
*  Author : Accenture 
*  Description : Test Class for Controller class for SaaSUtility
*  Created Date : 05\06\2015
* 
*  Version History :
*  Date  Changes 
*  09\06\2015	   created 
*
*/
public class SaaSUtilityTest
{
	static testMethod void validateSaaSUtility() 
	{
		List<Question_Log__c> Quest = new List<Question_Log__c>();
		SaaSUtility ctrlObj = new SaaSUtility();
		SaaSUtility.getCreatableFieldsSOQL('', '');
		SaaSUtility.getRecordTypeID('Question_Log__c','SaaS_Delivery_Question_Log');
		SaaSUtility.displayErrMsg('Error');
		SaaSUtility.displaySuccessMsg('Success');
		SaaSUtility.isAccentureRepresentative();
		SaaSUtility.getURLParameter('key');
		SaaSUtility.deleteSobject(Quest);
		SaaSUtility.insertSobject(Quest);
		
		SaaSUtility.getCreatableFieldsSOQL('Question_Log__c', 'Name');
		SaaSUtility.getRecordTypeID('Question_Log__c','SaaS_Delivery_Question_Log');
		SaaSUtility.displayErrMsg('Error');
		SaaSUtility.displaySuccessMsg('Success');
		SaaSUtility.isAccentureRepresentative();
		SaaSUtility.getURLParameter('key');
		SaaSUtility.deleteSobject(Quest);
		SaaSUtility.insertSobject(Quest);
		SaaSUtility.generateHash(10);
		SaaSUtility.getRecordTypeDeveloperName('SaaS_Delivery_Question_Log');
		SaaSUtility.getDelieverySetup('01I58000000nuXP','test','test');
		SaaSUtility.getDelieveryObjectives('01I58000000nuXP','test');
		SaaSUtility.getLoggedInValueSession('test');
		SaaSUtility.getValueSessionProjectName();
		SaaSUtility.clearPageErrMsg();
	}   
	
	static testMethod void validateSaaSPageTemplateCtrl()
	{
		SaaSPageTemplateCtrl  ctrlObj = new SaaSPageTemplateCtrl();
		ctrlObj.getUserPhotoUrl();
		ctrlObj.getDesginSessionOutcomes();
		ctrlObj.getBuildSessionOutcomes();
		ctrlObj.getInitiateSessionOutcomes();
	}
	
	
	static testMethod void validateSaaSPageMessage()
	{
		SaaSPageMessages.getMessages();
		SasSCustomPageMessages customMsg = new SasSCustomPageMessages();
		customMsg.getPageMessages();
		String s = customMsg.CustomPageMessages_ClosableErrorsRenderPlaceHolder;
	}
	static testMethod void validateDocumentDownload()
	{
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		database.insert(userList);
		System.runAs(userList[0]){		  
			Document document = new Document();
			document.Body = Blob.valueOf('Some Text');
			document.ContentType = 'application/pdf';
			document.DeveloperName = 'my_document';
			document.IsPublic = true;
			document.Name = 'My Document';
			document.FolderId = [select id from folder where name = 'Shared Documents' Limit 1].id;
			insert document;
			SaaSDocumentDownload ctrlObj = new SaaSDocumentDownload();
			List<Schema.Document> docObj = [SELECT DeveloperName FROM Document WHERE IsDeleted = false LIMIT 1];			
			String docID = docObj[0].DeveloperName;
			ctrlObj.docDeveloperName = docID;
			ctrlObj.getDocumentID();
			
			SaaSDocumentDownload ctrlObj2 = new SaaSDocumentDownload();
			ctrlObj2.docDeveloperName = 'my_document';
			ctrlObj2.getDocumentID();		   
		}
	}
	static testMethod void validateDocumentDownloadNull()
	{
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		database.insert(userList);
		System.runAs(userList[0]){		  
			Document document = new Document();
			document.Body = Blob.valueOf('Some Text');
			document.ContentType = 'application/pdf';
			document.DeveloperName = 'my_document';
			document.IsPublic = true;
			document.Name = 'My Document';
			document.FolderId = [select id from folder where name = 'Shared Documents' Limit 1].id;
			insert document;
			SaaSDocumentDownload ctrlObj = new SaaSDocumentDownload();
			List<Schema.Document> docObj = [SELECT DeveloperName FROM Document WHERE IsDeleted = false LIMIT 1];			
			String docID = docObj[0].DeveloperName;
			ctrlObj.docDeveloperName = docID;
			ctrlObj.getDocumentID();
			
			SaaSDocumentDownload ctrlObj2 = new SaaSDocumentDownload();
			ctrlObj2.docDeveloperName = null ;
			//ctrlObj2.getDocumentID();		   
			system.assertequals(null, ctrlObj2.getDocumentID() );
		}
	}
}