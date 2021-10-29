public with sharing class BGAPoTrackerHomePageLinks {

	public Map<String,String> links {get;set;}
	public List<String> lstLnk {get;set;}
	public BGAPoTrackerHomePageLinks(){
		fetchLinks();
	}
	
	void fetchLinks(){
		trY{
				List<BGA_PO_Tracker_Links__c> linkRecords = 
									[	select
										Link_Label__c,Link_URL__c 
										from BGA_PO_Tracker_Links__c 
										where Is_Active__c = true 
										order by Order_By__c];
										
				links = new Map<String,String>();
				lstLnk = new List<String>();
				if(linkRecords!= null)
				for(BGA_PO_Tracker_Links__c rec: linkRecords ){
					lstLnk.add(rec.Link_Label__c);
					links.put(rec.Link_Label__c,rec.Link_URL__c);
				}
		}	
		catch(Exception e){
			// None;
		}					
	}

 @isTest(SeeAllData=true)
    public  static void testCoverage(){
      BGAPoTrackerHomePageLinks btpl = new BGAPoTrackerHomePageLinks();
    }
}