global class RefreshContent_Webservice 
{
	 webService static void refresh(Id oppid)
	 {
	 	try{
	 	list<Content_Delivery__c> cd= new list<Content_Delivery__c>();
	 	set<id>cid= new set<id>();
	 	list<Opportunity>opp= new list<Opportunity>();
	 	cd=[select id,CreatedDate,Id_Value__c from Content_Delivery__c where Opportunity__c=:oppid ORDER BY CreatedDate DESC  NULLS LAST];
	 	for(Content_Delivery__c c: cd)
	 	{
	 		cid.add(c.Id_Value__c);
	 	}
	 	opp=[select id,SBU__c,Related_Content_count__c,Campaign_Name__c,Name,Content_Product_Name__c,Content_Platform_Name__c from opportunity where id=:oppid];
	 	if(cid.size()>0)
	 	ATROpp_ContentDeliveries_Automation.CreateContentDeliveries(opp, Null, cd[0].CreatedDate,cid,Null);
	 	else
	 	 ATROpp_ContentDeliveries_Automation.CreateContentDeliveries(opp, Null, Null,Null,Null);
	 	system.debug('cd**************'+cd);
	 	}
	 	catch(Exception e)
	 	{
	 		
	 	}
	 	
	 }
	 webService static void Deeprefresh(Id oppid)
	 {
	   try{
	 	list<Content_Delivery__c> cd= new list<Content_Delivery__c>();
	 	set<id>cid= new set<id>();
	 	set<Content_Delivery__c>deleteid= new set<Content_Delivery__c>();
	 	list<Content_Delivery__c>deletelist= new list<Content_Delivery__c>();
	 	list<Opportunity>opp= new list<Opportunity>();
	 	cd=[select id,CreatedDate,Id_Value__c from Content_Delivery__c where Opportunity__c=:oppid ORDER BY CreatedDate DESC NULLS LAST];
	 	for(Content_Delivery__c c: cd)
	 	{
	 		cid.add(c.Id_Value__c);
	 		deleteid.add(c);
	 	}
	 	deletelist.addall(deleteid);
	 	if(deletelist.size()>0)
	 	 delete cd;
	 	
	 	opp=[select id,SBU__c,Related_Content_count__c,Campaign_Name__c,Name,Content_Product_Name__c,Content_Platform_Name__c from opportunity where id=:oppid];
	 	ATROpp_ContentDeliveries_Automation.CreateContentDeliveries(opp, Null, Null,Null,Null);
	 	
	 	}
	 	catch(Exception e)
	 	{
	 		
	 	}
	 
	 }
}