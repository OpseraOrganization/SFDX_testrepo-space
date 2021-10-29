trigger DeliverableItem_Duplicate_Check on Deliverable_Item__c (Before Insert, Before Update){

List<ID> greenlist = new List<ID>();
List<ID> dellist = new List<ID>();
Map<ID,ID> dupcheckmap = new Map<ID,ID>();
List<Deliverable_Item__c> dupcheck = new List<Deliverable_Item__c>();

    for(Deliverable_Item__c item : trigger.new){
        if(item.Go_Green_Plan__c != null && item.SR_Number__c != null){
            greenlist.add(item.Go_Green_Plan__c);
            dellist.add(item.SR_Number__c);
   //         mapcheck.put(voc.Feedback_Number__c,voc.Go_Green_Plan__c);            
        }
    }
    
    
    dupcheck = [select id, SR_Number__c, Go_Green_Plan__c
     from Deliverable_Item__c where Go_Green_Plan__c in : greenlist and SR_Number__c in: dellist];
    if(dupcheck.size()>0){
        for(Deliverable_Item__c tm : dupcheck){
            dupcheckmap.put(tm.SR_Number__c, tm.Go_Green_Plan__c);
        }
    }

    if(Trigger.isInsert){
        if(dupcheckmap.size()>0){
            for(Deliverable_Item__c team : trigger.new){
                if(dupcheckmap.containsKey(team.SR_Number__c))
                team.adderror('Go Green Plan already exists for the Service Request !');
            }
        }
    }
    
    if(Trigger.isUpdate){
        if(dupcheckmap.size()>0){
            for(Deliverable_Item__c team : trigger.new){
                if((System.Trigger.OldMap.get(team.Id).SR_Number__c != System.Trigger.NewMap.get(team.Id).SR_Number__c) || (System.Trigger.OldMap.get(team.Id).Go_Green_Plan__c != System.Trigger.NewMap.get(team.Id).Go_Green_Plan__c)){
                    if(dupcheckmap.containsKey(team.SR_Number__c))
                    team.adderror('Go Green Plan already exists for the Service Request !');
                }    
            }
        }
    }
}