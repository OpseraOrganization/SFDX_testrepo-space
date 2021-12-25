@isTest
private class CSTCampaignMemberStatusInterfaceTest {
	static testMethod void testGetMethod()
	{   
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
	 	Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T0047J',ParentId=c2.id,Description='Sirius UAT PS',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;	
		CampaignMemberStatus cms3=new CampaignMemberStatus(Label = 'Test1', CampaignId=c3.Id,HasResponded=true,IsDefault=true,SortOrder = 3);
		cmslist.add(cms3); 
		insert cms3;
		test.startTest();
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMemberStatusMock());
	 //   DateTime dateValue = date.today();
	  //  string batchdate = ((DateTime)dateValue).format('YYYY-MM-dd');
		CSTCampaignMemberStatusInterface c = new CSTCampaignMemberStatusInterface(cmd.batchdate__c);
		test.stoptest();
	}
}