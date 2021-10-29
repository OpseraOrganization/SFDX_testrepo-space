trigger PoTrackerEntryUpdate on BGA_PO_Tracker_Entry__c (before insert, before update) {

//This trigger to update Po tracker record aircraft ref to this , this is done to display these records under aircraft as related list.

try{
	
	// Prepare list of Parent PO Tracker record Ids	
	List<Id> listParentPOTrackerId = new List<Id>();
	for(BGA_PO_Tracker_Entry__c rec : Trigger.new){
		listParentPOTrackerId.add(rec.BGA_Purchase_Order__c);
	}
	
	//For prepared PO Tracker Ids list query all aircraft ref and prepare MAP on parent PO record Id
	Map<Id,BGA_PO_Tracker__c> mapParentPoTracker = new Map<Id,BGA_PO_Tracker__c>
																				(
																					[	Select Id, Fleet_Asset_Aircraft__c from  
																						BGA_PO_Tracker__c 
																						where Id in :listParentPOTrackerId
																					]
																				);
	//if Map has records																
	if(mapParentPoTracker.size() > 0){
		//For each record assign parent aircraft reference		
		for(BGA_PO_Tracker_Entry__c rec : Trigger.new){
			if(mapParentPoTracker.containsKey(rec.BGA_Purchase_Order__c)){
				rec.Fleet_Asset_Aircraft__c = mapParentPoTracker.get(rec.BGA_Purchase_Order__c).Fleet_Asset_Aircraft__c;	
			}
			
		}
		
	}
	
}	
catch(Exception e){
}

}