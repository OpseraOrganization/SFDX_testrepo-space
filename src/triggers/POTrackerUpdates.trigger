trigger POTrackerUpdates on BGA_PO_Tracker__c (before insert, before update, after update) {

try{
	
    // Block to formulate PO Tracker record name. 
    
    if(System.trigger.isBefore){
            for(BGA_PO_Tracker__c rec : trigger.new){
            
	            rec.Name = 
	                        (rec.Make_Model__c != null ?            rec.Make_Model__c  : '')    +
	                        (rec.SN__c   != null       ? ' - ' +    rec.SN__c      : '');                   
        
                        
            }
    }
    
    // Code Block to update aircraft reference in PO RMU options records
    
    if(System.trigger.isAfter){
    	
            List<Id> poTrackerRecordIds = new List<Id>();
           
            for(Integer i=0;i <trigger.new.size() ;i++ ){
                if(trigger.new[i].Fleet_Asset_Aircraft__c != trigger.old[i].Fleet_Asset_Aircraft__c){
                	poTrackerRecordIds.add(trigger.new[i].Id);
                }
            }
            
            if(poTrackerRecordIds.size() > 0){
                    update    [
                                	select Id
                                	from BGA_PO_Tracker_Entry__c 
                                	where BGA_Purchase_Order__c = :poTrackerRecordIds
                              ];
            }
    }
    
}
catch(Exception e){
	//throw e;
}

}