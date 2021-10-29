/*******************************************************************************
Name         : MainEmailMessageTrigger  
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : Fix for SOQL 101 Error 
Created Date : 22 December 2014
Usages       : This Trigger is to replace the set of Email Message Triggers split across 
into single trigger call. 
*******************************************************************************/
trigger MainEmailMessageTrigger  on EmailMessage (before insert,after insert,before delete) {    
    if(userinfo.getProfileId()!=Label.API_Data_load_profile_Id)
    {    try
    {
        if(Trigger.isBefore && Trigger.isInsert){ 
            
            EMBeforeInsertHelperClass.emBeforeInsertMethod(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isAfter && Trigger.isInsert){ 
            
            EMAfterInsertHelperClass.emAfterInsertMethod(Trigger.new,Trigger.oldMap); 
        }        
        if(Trigger.isBefore && Trigger.isDelete){        
            
            EMBeforeDeleteHelperClass.emBeforeDeleteMethod(Trigger.oldMap);
        }                
    }catch(Exception e)
    {
        MainCaseTriggerUtility.handleEmailMessageException(e);
    }
    }
         if(Trigger.isAfter && Trigger.isinsert){ 
        set<Id>CaseIdSet = new set<Id>();
        set<Id> CaseIdSets=new set<Id>();
       
        
        
        for(EmailMessage em :trigger.new)
        {
            if(em.fromaddress=='myaerospace@honeywell.com' && em.subject.startswith('WebOrder; AOG SPEX;'))
            {
                CaseIdSet.add(em.ParentId);
            }else{
                CaseIdSets.add(em.parentId);
            }
            
        }
        
        List<Case>updateCaseList =new List<case>();
        if(CaseIdSet != null){ // added by kayal for 101 if condition
        for(case emCase :[select id,subject,Resolution__c from case where Id=:CaseIdSet and subject like 'MyAerospace AOG Order%'])
        {
          
            // system.debug('emCase'+emCase);
            if((emCase.Resolution__c == ''&& emCase.subject.startswith('MyAerospace AOG Order')) || (emCase.Resolution__c == null && emCase.subject.startswith('MyAerospace AOG Order')) ){
                emCase.Resolution__c = emCase.Resolution__c;
                updateCaseList.add(emCase);   
            } else if(emCase.Resolution__c != null && !emCase.Resolution__c.contains('Relay Email Sent: N') && !emCase.Resolution__c.contains('Relay Email Sent: Y') && emCase.subject.startswith('MyAerospace AOG Order') ){
             emCase.Resolution__c = emCase.Resolution__c ;
              updateCaseList.add(emCase); 
            }
            else if(!emCase.Resolution__c.contains('Relay Email Sent: Y') && emCase.subject.startswith('MyAerospace AOG Order')){
                // system.debug('emCase.Resolution__c'+emCase.Resolution__c);
                emCase.Resolution__c = emCase.Resolution__c.Replace('Relay Email Sent: N','Relay Email Sent: Y');
                updateCaseList.add(emCase);
            }
           
        }
        } // ended by kayal for 101 if condition
        if(CaseIdSets != null){ // added by kayal for 101 if condition
        for(case emCases :[select id,subject,Resolution__c ,RecordType.Name from case where Id=:CaseIdSets AND RecordType.Name = 'AOG'])
        {
            if(emCases!=null){
            if((emCases.Resolution__c == '' && emCases.subject.startswith('MyAerospace AOG Order')) || (emCases.Resolution__c == null && emCases.subject.startswith('MyAerospace AOG Order'))){
                emCases.Resolution__c = emCases.Resolution__c;
                updateCaseList.add(emCases);   
            }
            }
            
        }
        } // ended by kayal for 101 if condition
        if(updateCaseList.size()>0)
            update updateCaseList;
    }
}