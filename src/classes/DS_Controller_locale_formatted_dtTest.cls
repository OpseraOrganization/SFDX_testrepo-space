/******************************************************************************************************
Name : DS_Controller_locale_formatted_dtTest
Created Date: 2 August 2019
Created by: Accenture
Description : This class is test class for CustomerDocumentTrigger
*********************************************************************************************************/
@isTest
public class DS_Controller_locale_formatted_dtTest {
	
	/***********************************************
Name : testgetTimeZoneValue
Descritpion: testing lightningcomponentmethod
*************************************************/
	static testmethod void testgetTimeZoneValue(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		Test.startTest();
		System.RunAs(userCreation){
		DS_Controller_locale_formatted_datetime.getTimeZoneValue(system.now());
		}
		Test.stopTest();
	}

}