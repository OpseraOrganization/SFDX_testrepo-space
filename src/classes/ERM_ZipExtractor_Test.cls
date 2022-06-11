/**
About
-----
Description: This Class is used as Test Class for ERM_ZipExtractor.

Created for: Nokia Portugal COE (ERM)
Created: 12 20 2018

Update History
--------------
Created: 12 20 2018 – christine.blakemore@nokia.com
-------------
**/
@isTest//(SeeAllData=true)
private class ERM_ZipExtractor_Test {

	static testMethod void testInitClass() {
		
			List<Session__c> oSessionsList = new List<Session__c>();
			Time startHour = Time.newInstance(10, 0, 0, 0);
			Time endHour = Time.newInstance(11, 0, 0, 0);
			ContentVersion contentVersionObj = new ContentVersion();
			List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
			
			Venue__c ven = new Venue__c(
					Name = 'ROOM NUMBER 1', //Text 80
					Street_Address_1__c = 'ROOM ON STREET NUMBER', //Text 80
					Postal_Code_Zip__c = '1234', //Text 80
					Country__c = 'PORTUGAL', //Text 80
					Venue_Capacity__c = '' , //Text Area 255
					Venue_Details__c = 'TEST CLASS FOR VENUE', //Rich Text Area(32768)
					Venue_Type__c = 'Other', //Picklist
					City__c = 'LISBON' //Text 80
				);
			 insert ven;
				
			Event__c evnt = new Event__c(
						Name = 'EVENT NUMBER' , //Text 80
						Venue__c = ven.Id, //Lookup
						Kick_off_call_date__c = System.today().addDays(5), //Date
						Event_Start_Date__c = System.today().addDays(5), //Date
						Event_End_Date__c = System.today().addDays(15), //Date
						De_briefing_call_date__c = System.today().addDays(5), //Date
						RecordTypeId = Schema.SObjectType.Event__c.getRecordTypeInfosByDeveloperName().get('ERM').getRecordTypeId() //Loopup
						);
			insert evnt;
						
			Session__c sess = new Session__c();
			sess.Name = 'SESSION NUMBER 1'; //Text 80
			sess.Event__c = evnt.Id; //Lookup
			sess.Send_Individual_Notification__c = true; //Checkbox
			sess.Session_Notes__c = 'SESSION NOTES' ; //Long Text Area(32000),
			sess.Start_time__c = System.today().addDays(5);
			sess.End_time__c = System.today().addDays(5);
			insert sess;
			
			List<ContentVersion> contentVersionList = new list <ContentVersion>();
			contentVersionList = TestDataFactory.createContentVersion(1);
			Database.insert(contentVersionList);
			
			contentVersionObj =[select ContentDocumentId from ContentVersion where Id =: contentVersionList[0].Id];		  
			Id contentDocumentId = contentVersionObj.ContentDocumentId; 
								   
		   Test.startTest();
		   
			ContentDocumentLink contentlink=new ContentDocumentLink();
			contentlink.LinkedEntityId=sess.id;
			contentlink.contentdocumentid  = contentDocumentId;
			contentlink.ShareType = GlobalConstants.FILE_SHARE_TYPE_I;
			contentlink.Visibility = GlobalConstants.ALL_USERS;
			insert contentlink;
			
			if(contentlink != null)
			{
				System.debug('Entra no IF -->');
				ERM_ZipExtractor.initClass(evnt.Id);
			} 
			
			 Test.stopTest();	  
	}
}