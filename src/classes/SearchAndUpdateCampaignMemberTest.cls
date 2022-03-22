@isTest 
public class SearchAndUpdateCampaignMemberTest 
{
	static testMethod void testBatchExecute() 
	{
		Campaign_Mem_Status_Date__c cmd = new Campaign_Mem_Status_Date__c();
		cmd.Name = 'Date';
		DateTime dateValue = date.today();
		insert cmd;
		Test.startTest(); 
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMemberStatusMock()); 
		List<CampaignMemberStatus> cmsList = new List<CampaignMemberStatus>();
	 	List<Campaign> conList = new List<Campaign>(); 

	 	Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',Description='Sirius UAT PS',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');	   
		insert c3; 
	 	CampaignMemberStatus cms1=new CampaignMemberStatus(Label = 'Engaged', CampaignId=c3.Id,HasResponded=false,IsDefault=true,SortOrder = 3);
		cmslist.add(cms1);	
	 	CampaignMemberStatus cms2=new CampaignMemberStatus(Label = 'Viewed Page', CampaignId=c3.Id,HasResponded=true,IsDefault=false,SortOrder = 4);
		cmslist.add(cms2); 
		system.debug('cmsList:'+cmsList);
		insert cmslist;
			   
		SearchAndUpdateCampaignMember obj = new SearchAndUpdateCampaignMember();
		  
	 	obj.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'T%\' limit 200';
		system.debug('Query:'+obj.query);
		Id batchInstanceId = Database.executeBatch(obj,50);				 
		System.enqueueJob(new CSTCampaignMemberCalloutQueuable());
		Test.stopTest();
		
	}
   /* static testMethod void testQueueable() {
				 Campaign_Mem_Status_Date__c cmd = new Campaign_Mem_Status_Date__c();
		cmd.Name = 'Date';
		cmd.batchdate__c = '2019-10-10';
		insert cmd;
		
		List<CampaignMemberStatus> cmsList = new List<CampaignMemberStatus>();
	 	List<Campaign> conList = new List<Campaign>(); 

	 	Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T0047J',Description='Sirius UAT PS',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;	
		CampaignMemberStatus cms3=new CampaignMemberStatus(Label = 'Test1', CampaignId=c3.Id,HasResponded=true,IsDefault=true,SortOrder = 3);
		cmslist.add(cms3); 
		insert cms3;
		SearchAndUpdateCampaignMember obj = new SearchAndUpdateCampaignMember();
		test.starttest();
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMemberStatusMock());		 
		obj.Query = 'SELECT ID,name,Campaign_ID__c from campaign where Campaign_ID__c like \'T%\' limit 200';
		Id batchInstanceId = Database.executeBatch(obj,50);				 
		System.enqueueJob(new CSTCampaignMemberCalloutQueuable());
		Test.stopTest();
	}*/
	
	static testMethod void bulkCampaignMemberInterface()
	{

		List<CampaignMemberStatus> cmsList = new List<CampaignMemberStatus>();
	 	List<Campaign> conList = new List<Campaign>(); 
	 	Campaign c3=new Campaign(Name='18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6',Campaign_ID__c='T001U6',Description='Sirius UAT PS',Campaign_Manager_Email__c	='gernot.kohler.ext@nokia.com');
		conlist.add(c3);		
		insert conlist;   
	 	CampaignMemberStatus cms1=new CampaignMemberStatus(Label = 'Sent1', CampaignId=c3.Id,HasResponded=false,IsDefault=true,SortOrder = 3);
		cmslist.add(cms1);	
	 	CampaignMemberStatus cms2=new CampaignMemberStatus(Label = 'Responded1', CampaignId=c3.Id,HasResponded=true,IsDefault=false,SortOrder = 4);
		cmslist.add(cms2); 
		insert cmslist;
		Test.startTest();
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMemberStatusMock());		
		String id1 ='T001U6';	   
		CSTBulkCampaignMemberInterface callbulk = new CSTBulkCampaignMemberInterface(id1,c3,cmslist);
		callbulk.getresponse();
		callbulk.dataManipulate();
	  //  CSTBulkCampaignMemberInterface.upsertCampaigns(cmslist);
		
	   /*  string cms_Label = 'Test_del';
		 string cms_HasResponded = 'false';
		 string cms_isdefault = 'false';
		 Integer cms_sortorder = 4;
		 callbulk.createcmpStatus(cms_label, cms_isdefault, cms_hasresponded, cms_sortorder);  */	
		test.stopTest();
	}	  
	
	
}