@isTest 
public class SearchAndUpdateCampaignTest 
{
	static testMethod void testBatchExecute() 
	{
		Test.startTest(); 
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock()); 
		List<Campaign> conList = new List<Campaign>(); 
		Campaign c1=new Campaign(Name='18-Sirius UAT-M005G3',Campaign_ID__c='M005G3',Description='Sirius UAT',Campaign_Manager_Email__c ='gernot.kohler.ext@nokia.com');
		conlist.add(c1);
		Campaign c2=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-C002L1',Campaign_ID__c='C002L1',ParentId=c1.id,Description='Sirius Program UAT',Campaign_Manager_Email__c   ='gernot.kohler.ext@nokia.com');
		conlist.add(c2);
		Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',ParentId=c2.id,Description='Sirius UAT PS',Campaign_Manager_Email__c  ='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;
		SearchAndUpdateCampaign obj = new SearchAndUpdateCampaign();
		obj.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'M%\'';
		Id batchInstanceId = Database.executeBatch(obj, 50); 
		Test.stopTest();
		
	}
	static testMethod void testQueueable() {
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock());
		List<Campaign> conList = new List<Campaign>(); 
		Campaign c1=new Campaign(Name='18-Sirius UAT-M005G3',Campaign_ID__c='M005G3',Description='Sirius UAT',Campaign_Manager_Email__c ='gernot.kohler.ext@nokia.com');
		conlist.add(c1);
		Campaign c2=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-C002L1',Campaign_ID__c='C002L1',ParentId=c1.id,Description='Sirius Program UAT',Campaign_Manager_Email__c   ='gernot.kohler.ext@nokia.com');
		conlist.add(c2);
		Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',ParentId=c2.id,Description='Sirius UAT PS',Campaign_Manager_Email__c  ='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;
		SearchAndUpdateCampaign obj = new SearchAndUpdateCampaign();
		Test.startTest();	 
		obj.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'M%\' limit 200';
		Id batchInstanceId = Database.executeBatch(obj,50);	 
		System.enqueueJob(new CSTCamapignCalloutQueueable());
		Test.stopTest();
	}
	
	static testMethod void bulkCampaignInterface()
	{
		
		List<Campaign> conList = new List<Campaign>(); 
		Campaign c1=new Campaign(Name='18-Sirius UAT-M005G3',Campaign_ID__c='M005G3',Description='Sirius UAT',Campaign_Manager_Email__c ='gernot.kohler.ext@nokia.com');
		conlist.add(c1);
		Campaign c2=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-C002L1',Campaign_ID__c='C002L1',ParentId=c1.id,Description='Sirius Program UAT',Campaign_Manager_Email__c   ='gernot.kohler.ext@nokia.com');
		conlist.add(c2);
		Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',ParentId=c2.id,Description='Sirius UAT PS',Campaign_Manager_Email__c  ='gernot.kohler.ext@nokia.com');
		conlist.add(c3);
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock());		
		/*String date1 ='01 Jan 2018';
		String date2 ='01 Feb 2018';
		String date3 ='01 Mar 2018';
		String date4 ='01 Apr 2018';
		String date5 ='01 May 2018';
		String date6 ='01 Jun 2018';
		String date7 ='31 Jul 2018';
		String date8 ='01 Aug 2018';
		String date9 ='01 Sep 2018';
		String date10 ='01 Oct 2018';
		String date11 ='01 Nov 2018';
		String date12 ='01 Dec 2018';*/
		
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock());
		String id1 ='M005G3';	
		CSTBulkCampaignInterface callbulk = new CSTBulkCampaignInterface(id1);
		callbulk.fetchBulkCampaignData();
		CSTBulkCampaignInterface.upsertCampaigns(conList);
		callbulk.CSTtoCampaignConvert();
		
	/* callbulk.dateUtility(date1);
		callbulk.dateUtility(date2);
		callbulk.dateUtility(date3);
		callbulk.dateUtility(date4);		
		callbulk.dateUtility(date5);
		callbulk.dateUtility(date6);
		callbulk.dateUtility(date8);
		callbulk.dateUtility(date9);
		callbulk.dateUtility(date10);
		callbulk.dateUtility(date11);
		callbulk.dateUtility(date12);
		
		*/
		
		string cname='18-Sirius UAT-M005G3';
		string cId='M005G3';
		string convention='Sirius UAT';
		string emailstr='gernot.kohler.ext@nokia.com';
		string description='Sirius UAT';
		string startdate='2017-10-01T00:00:00';
		string endDate='2018-10-01T00:00:00';
		callbulk.createCampaign(cname, cId, convention, emailstr, description, startdate, endDate);		
		
	}	  
	
	
}