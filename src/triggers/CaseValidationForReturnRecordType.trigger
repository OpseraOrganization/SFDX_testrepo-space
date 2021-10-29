trigger CaseValidationForReturnRecordType on Case (before update) {
//getting the returns Id
/*Id returnTeamObj=[Select QueueId, Queue.Name from QueueSobject
where Queue.Name='Returns Team'].QueueId;
String returnsId=returnTeamObj;
      returnsId=returnsId.substring(0,15);   */
      /*commenting inactive trigger code to improve code coverage-----
     list<QueueId__c> QueueId = new list<QueueId__c>();
     QueueId = QueueId__c.getall().values(); 
  String returnsId, returnsId2;
  if(QueueId.size()>1){    
  returnsId  = QueueId[0].Queue_Id__c;  
  returnsId2 = QueueId[1].Queue_Id__c;
  System.debug('RETURNS ID  : '+returnsId);
  System.debug('RETURNS ID2 : '+returnsId2);
  }
  for( Case cases:Trigger.new){ 
    if(cases.Case_Record_Type__c =='Returns'){                 
        String owner=cases.OwnerId;
        System.debug('CaseValidationForReturnRecordType : '+owner);
        String ownerId=cases.OwnerId;
            IF(owner !=null){
            owner=owner.substring(0,3);   
            ownerId=ownerId.substring(0,15); 
            }
          // if owner is changed           
    if(  (System.Trigger.NewMap.get(cases.Id).OwnerId != 
           System.Trigger.OldMap.get(cases.Id).OwnerId)   &&
           cases.Export_Compliance_Content_ITAR_EAR__c!='Yes' && 
           cases.Government_Compliance_SM_M_Content__c!='Yes') {         
                 if(owner=='00G'){
                 System.debug('CaseValidationForReturnRecordType : '+owner);
                    if(cases.ownerId != returnsId && cases.ownerId != returnsId2)
                    cases.addError('Case Owner should be either Return Team or PRO Team or an individual');          
                 }
       }          
               
     } //end of if             
  }//end of for*/
}// end of trigger