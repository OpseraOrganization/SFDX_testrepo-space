trigger Task_updateowner on Task (before insert,before update) {

    String str;
    Map<Id,User> userlist=new Map<Id,User>();
    //List<User> userlist = new List<User>();
    List<Id> idlist = new List<Id>();
    List<task> tlist = new List<task>();
    Map<Id,Contact> conlist=new Map<Id,Contact>();
    List<Id> idlist1 = new List<Id>();
    
    for(Task tasklist:Trigger.new)
    {
        if(Trigger.isInsert || (Trigger.isUpdate && (Trigger.oldMap.get(tasklist.id).ownerid != tasklist.ownerid)))
        {
            idlist.add(tasklist.ownerid);
        }
        if (tasklist.Whoid != null && string.valueOf(tasklist.whoId).startsWith('003') && tasklist.recordtypeid==label.RecordTypeRelationshipBuilding)
        {        
            idlist1.add(tasklist.WhoID);
             tlist.add(tasklist);
        }       
        
    }
    if(idlist.size()>0)
    {
        userlist = new Map<Id,User>([select id,name,Firstname,lastname,UserRoleId,UserRole.Name,Manager.Name, ManagerId from user where id in :idlist]);
    }
    
    if(userlist .size()>0)
    {
        for(Task tasklist:Trigger.new)
        {
             system.debug('Task owner---->'+tasklist.ownerid);
             system.debug('Task owner---->'+userlist.get(tasklist.ownerid).id);
             if(tasklist.ownerid == userlist.get(tasklist.ownerid).id)
             {
                 str= userlist.get(tasklist.ownerid).Firstname + ' ' + userlist.get(tasklist.ownerid).lastname;
                 tasklist.Owner_Name__c  = str;
                 
                system.debug('test owner manager name---->'+tasklist.owner.UserRole.Name);
                
                if(tasklist.recordtypeid!= label.General_Task )
                {               
                    tasklist.Assigned_Manager__c = userlist.get(tasklist.ownerid).Manager.Name;
                    tasklist.Assigned_Role__c = userlist.get(tasklist.ownerid).UserRole.Name;
                }
             }
        }
    }
    
    if(idlist1.size()>0)
    {
        conlist = new Map<Id,Contact>([select Id, Account.Id from contact where Id in :idlist1]);
    }
    
    if (conlist.size()>0)
    {
        for (Task tasklist:tlist)
        {
            if(tasklist.WhoId == conlist.get(tasklist.WhoId).Id)
            {
                tasklist.Whatid = conlist.get(tasklist.WhoId).Account.ID;                
            }
        }
    }
}