trigger UpdateCaseMatrix on Case_Matrix__c (before insert, before update) {

List<String> OwnerName= new List<String> ();
List<String> RecordName= new List<String> ();
for( Case_Matrix__c caseMatrix:Trigger.new){
  if(  (Trigger.IsInsert)  ||
  
  ( (Trigger.IsUpdate)  
  && (System.Trigger.OldMap.get(caseMatrix.Id).Owner__c  !=System.Trigger.NewMap.get(caseMatrix.Id).Owner__c)
  
  )
)
   {
           integer flag=0;
           for(integer i=0;i<OwnerName.size();i++){
             if(OwnerName[i]==caseMatrix.Owner__c)
             flag=1;
           }
           if(flag==0)
           OwnerName.add(caseMatrix.Owner__c);



    }
    
    if(  (Trigger.IsInsert)  ||
  
  ( (Trigger.IsUpdate)  
  && (System.Trigger.OldMap.get(caseMatrix.Id).Record_Type__c  !=System.Trigger.NewMap.get(caseMatrix.Id).Record_Type__c)
  
  )
)
   {
           integer flag1=0;
           for(integer i=0;i<RecordName.size();i++){
             if(RecordName[i]==caseMatrix.Record_Type__c)
             flag1=1;
           }
           if(flag1==0)
           RecordName.add(caseMatrix.Record_Type__c);



    }
}
if(OwnerName.size()>0){
List<QueueSobject> compArray=[Select QueueId,Id,Queue.email,Queue.name from QueueSobject
 where  (Queue.name in :OwnerName) ];
 
 
 for( Case_Matrix__c caseMatrix:Trigger.new){
  if(  (Trigger.IsInsert)  ||
  
  ( (Trigger.IsUpdate) 
  && (System.Trigger.OldMap.get(caseMatrix.Id).Owner__c  !=System.Trigger.NewMap.get(caseMatrix.Id).Owner__c)
   )
)
   {
      
    for(integer j=0;j<compArray.size();j++){
      if(compArray[j].Queue.name== caseMatrix.Owner__c)
      caseMatrix.OwnerId__c=compArray[j].QueueId;
    }

    }
}
 

}


if(RecordName.size()>0){
List<RecordType> recArray=[Select Id, Name, DeveloperName from RecordType where RecordType.Name in :RecordName ];

 for( Case_Matrix__c caseMatrix:Trigger.new){
  if(  (Trigger.IsInsert)  ||
  
  ( (Trigger.IsUpdate) 
  && (System.Trigger.OldMap.get(caseMatrix.Id).Record_Type__c  !=System.Trigger.NewMap.get(caseMatrix.Id).Record_Type__c)
   )
)
   {
      
    for(integer j=0;j<recArray.size();j++){
      if(recArray[j].name== caseMatrix.Record_Type__c)
       {
       system.debug('$$$$$$$$$$$$$$$$$' + recArray[j].Id);
       system.debug('$$$$$$$$$$$$$$$$$' + recArray[j].name);
      caseMatrix.RecordTypeId__c=recArray[j].Id;
      system.debug('$$$$$$$$$$$$$$$$$' + caseMatrix.RecordTypeId__c);
      }
    }

    }
}
 

}

}