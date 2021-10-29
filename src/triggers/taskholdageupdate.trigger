trigger taskholdageupdate on Task (before insert,before update) 
{   
    /*commenting trigger code for coverga
    Set<id> casid = new Set<id>(); 
    Map<ID,String> Taskmap =  new Map<ID,String>();
    List<Task> newtask = new List<Task>();
    List<Case> caslist = new List<Case>();
    for(task tasks: trigger.new)
    {   
        if(tasks.status == 'On Hold' && (Trigger.isinsert || (Trigger.isupdate && (Trigger.OldMap.get(tasks.Id).status != tasks.status))))
        {
            tasks.On_Hold_start_time__c = System.now();
        } 
        else if(Trigger.isupdate && tasks.status != 'On Hold' && Trigger.OldMap.get(tasks.Id).status != tasks.status && Trigger.OldMap.get(tasks.Id).status == 'On Hold')
        {
           tasks.On_Hold_time_temp__c = Trigger.OldMap.get(tasks.Id).Total_Cumulative_OnHold_Time__c;           
           tasks.On_Hold_start_time__c = null;
        }
        
       if (Trigger.IsInsert){
           String parent=tasks.whatId;  
           if (parent!=null)
              parent=parent.substring(0,3);
              if (parent=='500'){  
                 system.debug('##case1');
                 casid.add(tasks.Whatid);
                 newtask.add(tasks);
              } 
       }
    }
    if(casid.size()>0){
         system.debug('##case2');
         caslist = [select id,Origin from Case where id IN :casid];
    }   
    
    if(caslist.size()>0){
         for(Case cas:caslist){  
            taskmap.put(cas.id,cas.Origin);     
            system.debug('##case3'+cas.Origin);
        } 
    } 
            
    If(newtask.size()>0){        
         for(Task tasklist : Newtask){
              tasklist.Case_Origin__c = taskmap.get(tasklist.whatid);
              system.debug('##task'+ tasklist.Case_Origin__c);
         }  
    }*/
 }