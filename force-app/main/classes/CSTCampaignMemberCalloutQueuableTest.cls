@isTest
public class CSTCampaignMemberCalloutQueuableTest {
 static testMethod void testQueueable() {
	 Campaign_Mem_Status_Date__c cmd = new Campaign_Mem_Status_Date__c();
		cmd.Name = 'Date';
		DateTime dateValue = date.today();
		cmd.batchdate__c = '2019-10-10';
		insert cmd;
	 
		
		List<CampaignMemberStatus> cmsList = new List<CampaignMemberStatus>();
	 	List<Campaign> conList = new List<Campaign>(); 
		Campaign c1=new Campaign(Name='18-Sirius UAT-M005G3',Campaign_ID__c='M005G3',Description='Sirius UAT',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c1);
		Campaign c2=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-C002L1',Campaign_ID__c='C002L1',ParentId=c1.id,Description='Sirius Program UAT',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c2);	
	 	Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',ParentId=c2.id,Description='Sirius UAT PS',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;   
	 	CampaignMemberStatus cms1=new CampaignMemberStatus(Label = 'Sent1', CampaignId=c3.Id,HasResponded=false,IsDefault=true,SortOrder = 3);
		cmslist.add(cms1);	 
		insert cmslist;
		SearchAndUpdateCampaignMember obj = new SearchAndUpdateCampaignMember();
		Test.startTest();		 
		 System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMemberStatusMock());
	 	obj.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'T%\' limit 200';
		Id batchInstanceId = Database.executeBatch(obj,50);				 
		System.enqueueJob(new CSTCampaignMemberCalloutQueuable());
		Test.stopTest();
	}
}