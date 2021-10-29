/*This trigger sends an email notification to the Case creater when Classification of case object
    equals 'GTO Product Support' and when Service Request record is created from the case object.*/
trigger emailNotificationSR on Service_Request__c(before insert,before update,after delete,after insert, after update){
    
    set<id> srId = new set<id>();
    List<ID> SerReqID = new List<ID>();    
    List<Discretionary__c> DRList = new List<Discretionary__c>();
    List<Discretionary_Line_Item__c> DLIList= new List<Discretionary_Line_Item__c>();
    List<Discretionary__c> DList = new List<Discretionary__c>();
    List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> BulkEmails = new List<Messaging.SingleEmailMessage>();
    Boolean DLIStatus=False;
    string msgbody,sub;
    String[] toaddress= new String[]{};
    String[] ccaddress= new String[]{};  
    
    // QFD Fields Auto Population
    List<ID> QFDSRIds = new List<ID>();
    
  if(trigger.isbefore && trigger.isinsert){  
    for(Service_Request__c sr : trigger.new)
    {
        if(sr.Case_Number__c !=null){
           srId.add(sr.Case_Number__c);
        }
        if(srid.size()>0){
            Case cas=[select id,CreatedById, Classification__c from case where id IN: srId];
            if(cas.Classification__c == 'GTO Product Support'){
                User usr = [select id, Email from user where id =:cas.CreatedById];
                sr.EmailId__c = usr.Email;
            }
        }
    }
   }    
   
 /*SCTASK0445262
  Functionality : This trigger will send the email notification to PP&C persons to close the charge numbers when the SR status is changed to closed, where its corresponding DR and DLI should be in open state.
                  The status of the DR,DLI'S associated with this SR will also be changed as closed.
   Test class : Testcls_Apextrgr_emailNotificationSR
*/ 
  
  
   if(trigger.isafter && trigger.isupdate)
   {
     for(Service_Request__c ser : trigger.new){
     System.debug('PPC Trigger:##');
      if(ser.Status__c!=Trigger.oldMap.get(ser.Id).Status__c && ser.Status__c == 'Closed')
       {
        System.debug('PPC Trigger:###');
        SerReqID.add(ser.id);
        System.debug('PPC Trigger:###'+SerReqID);
       }
     }
    
    DRList = [Select id,Approval_Status__c, CBT__c,Ownerid,Owner__c,Owner_Manager__c,Service_Request__c,Service_Request__r.Owner_Manager__c,(Select id,Approval_Status__c,Discretionary_Request__r.Owner_Manager__c,Discretionary_Request__r.Service_Request__r.Owner.Email from Discretionary_Line_Items__r) from Discretionary__c where Service_Request__c in : SerReqID ];
    
    System.debug('PPC Trigger:###:'+DRList);
    
    for(Discretionary__c Dis:DRList)
    {
    System.debug('PPC Trigger @:'+Dis.Approval_Status__c );
            if(Dis.Approval_Status__c == 'Open')
            {
                //String toad=Dis.Owner__r.Manager.Email;
                
                DLIStatus=True;
                Dis.Approval_Status__c='Closed';
            
            for(Discretionary_Line_Item__c DL: Dis.Discretionary_Line_Items__r){
                              
                  
                 if(DL.Approval_Status__c == 'Open')
                 {
                    /*    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        toaddress.add(DL.Discretionary_Request__r.Owner_Manager__c);
                        system.debug('ToAddress$$$:'+toaddress);
                        ccaddress.add(DL.Discretionary_Request__r.Service_Request__r.Owner.Email);
                        system.debug('CCaddress$$$:'+ccaddress);
                        
                        if(toaddress!=null && ccaddress!=null ){
                                        system.debug('toadd and ccaddress----------->');
                                        msg.setToAddresses(toaddress);
                                        msg.setCcAddresses(ccaddress);
                                    }
                        msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                        msg.setTemplateId(label.Discretionary_PPC_Notif);
                        Id whatid = DL.id;
                        Contact cnt = new Contact(id=Label.UFR_Cont_Id);
                        msg.setWhatId(whatid);
                        msg.setTargetObjectId(cnt.id);
                        msg.setTreatTargetObjectAsRecipient(false);
                        msg.setSaveAsActivity(false);
                        msgList.add(msg);
                        system.debug(msgList);
                        system.debug('toadd and ccaddress----------->'+msgList); */
                      
                     DLIStatus=True;
                     DL.Approval_Status__c='Close';
                     DLIList.add(DL);  
                
                 } 
                  //DLIList.add(DL);            
            }
            DList.add(Dis);
            }
            //DList.add(Dis);
    }
    if(DList.size()>0)
    {
     system.debug('PPC DList Mail Sending Invalid------>'+DList);
        update DList;
    }
    if(DLIList.size()>0)
    {
    system.debug('PPC DLIList Mail Sending Invalid------>'+DLIList);
        update DLIList;
    }
  /*  if(msgList.size()>0)
    {
     system.debug('PPC BulkEmails Mail Sending Invalid------>'+msgList);
        Messaging.sendEmail(msgList);
    } */    
   }
   
 // QFD formule fields population  
 Boolean isRunningUser = AvoidTriggerExecution.whitelistedUsers(); // Returns FALSE if user present in Label
  
 if((trigger.isBefore && trigger.isUpdate) || (trigger.isAfter && trigger.isInsert) && isRunningUser)
  {  
    for(Service_Request__c sr : trigger.new)
    {        
        QFDSRIds.add(sr.Id);
        system.debug('QFDSRIds 3------>'+QFDSRIds);
    }
      
    if(!QFDSRIds.isEmpty()) //QFDRecursiveTriggerHandler.isFirstTime  
    {
      system.debug('Testing in QFD');
      Boolean isBeforeExecute = false;
      Boolean isAfterExecute = false;
      
      if(trigger.isBefore && trigger.isUpdate)
      {
        isBeforeExecute = true;
      }
      if(trigger.isAfter && trigger.isInsert)
      {
        isAfterExecute  = true;
      }
      //QFDRecursiveTriggerHandler.isFirstTime = false;     
      QFDFieldsAutoPopulation.populateQFDFieldsData(trigger.new,isBeforeExecute,isAfterExecute);
    }
   }  
   
   if(trigger.isAfter && trigger.isDelete && isRunningUser )
   {
     QFDFieldsAutoPopulation.populateQFDFieldsData(trigger.old,false,false);
   }
}