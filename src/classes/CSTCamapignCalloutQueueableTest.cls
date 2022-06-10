@isTest
public class CSTCamapignCalloutQueueableTest {
	  static testMethod void testQueueable() {
		 System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock());
		List<Campaign> conList = new List<Campaign>(); 
		Campaign c1=new Campaign(Name='18-Sirius UAT-M005G3',Campaign_ID__c='M005G3',Description='Sirius UAT',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c1);
		Campaign c2=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-C002L1',Campaign_ID__c='C002L1',ParentId=c1.id,Description='Sirius Program UAT',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c2);
		Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',ParentId=c2.id,Description='Sirius UAT PS',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;
		SearchAndUpdateCampaign obj = new SearchAndUpdateCampaign();
		Test.startTest();		 
		obj.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'M%\' limit 200';
		Id batchInstanceId = Database.executeBatch(obj,50);				 
		System.enqueueJob(new CSTCamapignCalloutQueueable());
		Test.stopTest();
	}
}