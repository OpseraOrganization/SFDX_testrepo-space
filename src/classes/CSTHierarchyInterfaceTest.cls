@isTest
private class CSTHierarchyInterfaceTest {
	
	static testMethod void testGetMethod()
	{	 
		List<Campaign> conList = new List<Campaign>(); 
		Campaign c1=new Campaign(Name='17-Nokia-Jul-3-M0036K',Campaign_ID__c='M005G3');
		conlist.add(c1);
		Campaign c2=new Campaign(Name='17-Nokia-Jul-3-Nokia-Jul-3-Sub-BGLED-C002DX',Campaign_ID__c='C002DX',ParentId=c1.id);
		conlist.add(c2);
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock());
		CSTHierarchyInterface c = new CSTHierarchyInterface();
		c.upsertCampaigns(conList);
		c.dataManipulate();
		c.populateHierarchy();
		
	}
}