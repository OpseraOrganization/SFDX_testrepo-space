trigger VariousAccountsRestrict1 on Event (before insert,before update){
Set<Id> accIds=new Set<Id>();
for(Event event:Trigger.new){
    accIds.add(event.whatId);
}
Map<Id,String> accMap=new Map<Id,String>();
for(Account acc:[select name,Id from Account where id in :accIds]){
   accMap.put(acc.Id,acc.name); 
}

for(Event event:Trigger.new){
  if(event.recordtypeid != label.BGA_Event){
    if(accMap!=null && accMap.get(event.whatId)!=null && accMap.get(event.whatId).toUpperCase().contains('VARIOUS')){
        event.whatId.addError('Account Name should not contain Various');
    }
  }  
}
}