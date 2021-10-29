/** * File Name: Task_UpdateActivityType
* Description :Trigger on Tasks
* Copyright : Wipro Technologies Limited Copyright (c) 2001 
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger Task_UpdateActivityType on Task (before insert,before update) {
    //variable declaration
    //List<Task> taskIds=Trigger.new;
    List<Task> taskIds=new List<Task>();
    for(Task tsk : trigger.new){
        if(tsk.recordtypeid!= label.General_Task ){
            taskIds.add(tsk);
        }
    }
    
    List<Id> updateTaskIds=new List<Id>();
    List<Id> updateTaskIds1=new List<Id>();
    List<Entitlement__c> entl=new List<Entitlement__c>();
    List<Contract> contracts=new List<Contract>();
    List<Case> cases=new List<Case>();
    List<Case> casesUpdate=new List<Case>();
    List<Case> casesUpdateClose=new List<Case>();
    List<Case> casesUpdateClose1=new List<Case>();
    List<Id> casesUpdateId=new List<Id>();
    List<Id> casesUpdateIdClose=new List<Id>();
    
    for(Integer i=0;i<taskIds.size();i++)
    {
        if(taskIds[i].Status!='EmailTask' && (taskIds[i].whatId != null && !(string.valueOf(taskIds[i].whatId).startsWith('500'))))
        updateTaskIds.add(taskIds[i].whatId);
        
        if(Trigger.isInsert)
        {
          if(taskIds[i].Status=='EmailTask')
          updateTaskIds1.add(taskIds[i].whatId);
        }
        // if task is closed send mail to Case owner
        if(Trigger.isUpdate)
        {
            if(taskIds[i].subject !=null)
            {
               if( (System.Trigger.OldMap.get(taskIds[i].Id).IsClosed != System.Trigger.NewMap.get(taskIds[i].Id).IsClosed)  &&
                    taskIds[i].IsClosed==true && (!taskIds[i].subject.contains('Email')) )
                {
                    String parent=taskIds[i].whatId;  
                    if(parent!=null)
                        parent=parent.substring(0,3);
                        if(parent=='500')
                        {     
                            casesUpdateIdClose.add(taskIds[i].whatId);
                        }
                }
            }     
        }           
        if(Trigger.isUpdate)
        {
            if(taskIds[i].IsClosed!=true)
            {
                String parent=taskIds[i].whatId;
                if(parent !=null)
                parent=parent.substring(0,3);
                if(parent=='500')
                {
                   if((System.Trigger.OldMap.get(taskIds[i].Id).Resolution__c != System.Trigger.NewMap.get(taskIds[i].Id).Resolution__c ))
                        casesUpdateId.add(taskIds[i].whatId);
                }
            }
        }
    }//end of for
    // for the Cases  Related to closed tasks
    if(casesUpdateIdClose.size()>0)
    {
        casesUpdateClose=[Select Id,IsTaskClosed__c,OwnerId from Case where Id in:casesUpdateIdClose];
        for(integer i=0;i<casesUpdateClose.size();i++)
        {
            for(integer k=0;k<taskIds.size();k++)
            {
                if(casesUpdateClose[i].OwnerId!=taskIds[k].OwnerId)
                {               
                    String par=casesUpdateClose[i].OwnerId;
                    if(par !=null)
                    par=par.substring(0,3);
                    if(par=='005')
                    casesUpdateClose1.add(casesUpdateClose[i]);
                }    
            }
        }// end of for

        if(casesUpdateClose1.size()>0)
        {
            for(integer i1=0;i1<casesUpdateClose1.size();i1++)
            {
                casesUpdateClose1[i1].IsTaskClosed__c=true;
            }
            try
            {
                update  casesUpdateClose1;
            }catch(Exception ex)
            {
                //return null;
            }
        }
    }

    if(casesUpdateId.size()>0)
    {
        casesUpdate=[Select Id,OpenTaskUpdate__c from Case where Id in:casesUpdateId];
        for(integer i=0;i<casesUpdate.size();i++)
        {
            casesUpdate[i].OpenTaskUpdate__c=true;
        }
        try
        {
            update casesUpdate;  
        }
        catch(Exception ex)
        {
            //return null;
        }
    }

    List<Case> casetoUpdate= new List<Case>();
    if(updateTaskIds1.size()>0)
    {
        cases=[Select Id,OwnerId,status ,OpenTask__c from case where Id in:updateTaskIds1];
        if(cases.size()>0)
        {
            for(integer i=0;i<cases.size();i++)
            {
                String owner=cases[i].OwnerId;
                owner=owner.substring(0,3);
                if(owner !='00G')
                {
                    cases[i].OpenTask__c=true;
                    casetoUpdate.add(cases[i]);
                }
            }
        }
        if(casetoUpdate.size()>0)
        try
        {
        }
        catch(Exception e)
        {
            //return null;
        }
        for(Integer i=0;i<taskIds.size();i++)
        {
            if(Trigger.isInsert)
            {
                if(taskIds[i].Status=='EmailTask')
                {
                    for(integer k=0;k<cases.size();k++)
                    {
                        if(taskIds[i].whatId==cases[k].Id)
                        {
                            String owner=cases[k].OwnerId;
                            owner=owner.substring(0,3);
                            if(owner !='00G')
                            taskIds[i].OwnerId=cases[k].OwnerId;
                            taskIds[i].Status='Open';
                        }// end of if
                    }// end of for
                }
            }
        }// end of for
    }// end of if
    
    //if tasks are present  
    if(updateTaskIds.size()>0)
    {
    //get selected contracts and entitlement
        try
        {
            contracts=[Select Name from Contract where Id in: UpdatetaskIds and Name!=''];
        }
        catch(Exception e){}
        try
        {
            entl=[Select Entitlement_Type__c,Id from Entitlement__c where Id in:UpdatetaskIds and Entitlement_Type__c!=''];
        }
        catch(Exception e){}
    }
    //for entitlements
    for(Integer k=0;k<entl.size();k++)
    {
        for(Integer j=0;j<TaskIds.size();j++)
        {
            if(taskIds[j].whatId==entl[k].Id)
                taskIds[j].type=entl[k].Entitlement_Type__c;    
        }
    }
    //for Contracts
    for(Integer k=0;k<contracts.size();k++)
    {
        for(Integer j=0;j<TaskIds.size();j++)
        {
            if(taskIds[j].whatId==contracts[k].Id){
                taskIds[j].Description=contracts[k].Name;    
                
            }
        }
    }
}