trigger VariousAccountsRestrict on Task (before insert,before update){
Set<Id> accIds=new Set<Id>();
for(Task task:Trigger.new){
    if (task.WhatId != null){
            if( string.valueOf(task.WhatId).startsWith('001') ){
                accIds.add(task.whatId);
            } 
    } 
}
Map<Id,String> accMap=new Map<Id,String>();
if(accIds.size()>0){
for(Account acc:[select name,Id from Account where id in :accIds]){
   accMap.put(acc.Id,acc.name); 
}
}

for(Task task:Trigger.new){
  if(task.recordtypeid!= label.General_Task){
    if(accMap!=null && accMap.get(task.whatId)!=null && (accMap.get(task.whatId).toUpperCase().contains('VARIOUS')  || accMap.get(task.whatId).toUpperCase().contains('AERO LEVEL ADJUST'))){
        task.whatId.addError('Account Name should not contain Various or AERO LEVEL ADJUST');
    }
  }  
}
/*
code added
INC number  :INC000006439279
created by  :krishna billakurthy
Date        :8/25/2014
Description : Please make account field visible on General, Service, and Sales Activity Types.  
             It should be populated based on the Contact selection.

*/
set<id> tid =new set<id>();
map<id,task> maptask = new map<id,task>();
map<id,id> maptaskcon = new map<id,id>();
map<id,contact> con;
   for(task tak:trigger.new){
       system.debug('what id'+tak.whatid);
       if(tak.RecordTypeid!=null && (tak.whoid!=null && string.valueOf(tak.WhoId).startsWith('003'))&& (tak.RecordTypeid==label.General_Task_RT_ID || tak.RecordTypeid==label.Sales_Task_RT_ID || tak.RecordTypeid==label.Service_Task_RT_ID))    {
        tid.add(tak.whoid);
        maptask.put(tak.id,tak);       
        maptaskcon.put(tak.id,tak.whoid);
    }
          }
          
          if(maptask!= null && maptask.size()>0)
        {
        
          con =new Map<ID, Contact>([select account.name from contact where id in:tid]);
            for(task tak:maptask.values()){
                
                    tak.account_name__c=con.get(maptaskcon.get(tak.id)).account.name;
                }
        }
    


}