/****************************************
 * Class Name : AnnouncementController
 * Created Date: 1 May 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 1 May 2017
 * Description : Fetch Published Announcements
			  
 * Test Class: 
 *****************************************/
public with sharing class AnnouncementController {
	/********************
	*Method Name: getAnnouncements
	*Parameter: 
	*Description: Fetch Published Announcements
	*******************/
	//commented on 2018-07-04 for enable lighting  knowledge article, will fix it after enable lighting  knowledge article
	@AuraEnabled	 
	public static List<Knowledge__kav> getAnnouncements() {
		List<Knowledge__kav> announcementsList = new List<Knowledge__kav>();
		//Fetch Announcements
		try{
			announcementsList = [SELECT Id, Title, Details__c, Display_Start_Date__c, 
								 	Display_End_Date__c, Priority__c, LastModifiedDate 
								 FROM Knowledge__kav 
								 WHERE Language ='en_US' 
								 	AND PublishStatus ='Online' 
								 	AND Display_Start_Date__c <= Today 
								 	AND Display_End_Date__c >= Today 
								 	AND RecordType.DeveloperName = 'Announcement'
								 	Order By Priority__c desc, LastModifiedDate desc 
								 LIMIT : PRMGlobalConstants.ANNOUNCEMENT_LIMIT];
		}catch(Exception e) {ExceptionHandler.addException(e,PRMGlobalConstants.ANNOUNCEMENT_CONTROLLER ,PRMGlobalConstants.GET_ANNOUNCEMENT);}
		
		return announcementsList;
	}
	
}