/***********************************************************************************************************
* Company Name          : NTTData
* Name                  : RelateTaskToContract
* Description           : Trigger is to Relate Task to Contract if it is created from Entitlement.
* Created For           : Certido Ticket:346140.
***********/
trigger RelateTaskToContract on Task (before insert) {
    List<Task> TaskList = new List<Task>();
    Map<Id, Task> mapTasks = new Map<Id, Task>();
    Set<Id> tIds = new Set<Id>();
    for(Task t : Trigger.new){
        if (t.WhatId != null){
            if( string.valueOf(t.WhatId).startsWith('a1M') ){
                //Add the task to the Map and Set
                mapTasks.put(t.WhatId, t);
                tIds.add(t.WhatId);
            }
            else if(string.valueOf(t.WhatId).startsWith('800')){
                if(t.Status=='Completed')
                t.Completed_Date__c=System.today();
            }
        }
    }    
    if(tIds.size()>0)
   {
        List<Entitlement__c> aList = [Select Id, Contract_Number__c,Entitlement_Type__c From Entitlement__c Where Id IN : tIds];    
        Map<Id, Entitlement__c> opMap = new Map<Id, Entitlement__c>();        
        for(Entitlement__c a : aList){
            opMap.put(a.Id,a);
            system.debug('OPMAP'+opMap);
            Task t = mapTasks.get(a.Id);
            t.WhatId = a.Contract_Number__c;
            t.Type = a.Entitlement_Type__c;
            System.debug('TaskWahtID'+t.WhatId);
            System.debug('TaskType'+t.Type);
        }
        for(Task t : Trigger.new){
            Task tmap = mapTasks.get(t.WhatId);           
            if (tmap != null){
                t.WhatId = tmap.WhatId;
                System.debug('TaskWahtID'+t.WhatId);                
                Entitlement__c thisOp = opMap.get(t.WhatId);
                System.debug('thisOp '+thisOp );
                if(thisOp!=null){
                    t.Type = thisOp.Entitlement_Type__c;
                    System.debug('Entitlement_Type__c'+t.Type);
                }                
            }
        }
    }
}