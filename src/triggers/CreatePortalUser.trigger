trigger CreatePortalUser on Contact_Tool_Access__c (after insert,after update,after delete)
{
    set<Id> conid=new set<Id>();
    set<Id> coniddenied=new set<Id>();
    set<Id> wctaid=new set<Id>();
    
    List <Case> caselistDenied = new   List <Case>();
    ContactToolAccessTriggerHelperClass  helper = new ContactToolAccessTriggerHelperClass();
    
    //check for isinsert/isupdate
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contact_Tool_Access__c cta:Trigger.new)
        {
            if((cta.Name=='Honeywell Training' && cta.Request_Status__c=='Approved') || (cta.Name=='Technical Knowledge Center' && cta.Request_Status__c=='Approved')){              
                if(Trigger.isInsert   ||( Trigger.isUpdate &&                    
                                         (System.Trigger.OldMap.get(cta.Id).Request_Status__c !=System.Trigger.NewMap.get(cta.Id).Request_Status__c  ))){
                                             if(cta.CRM_Contact_ID__c!= null)
                                             {
                                                 conid.add(cta.CRM_Contact_ID__c);
                                             }
                                             wctaid.add(cta.id);
                                         }        
            }
            
            if((cta.Name=='Honeywell Training' && cta.Request_Status__c=='Denied') ||(cta.Name=='Technical Knowledge Center' && cta.Request_Status__c=='Denied')){              
                if(Trigger.isInsert   ||( Trigger.isUpdate &&                    
                                         (System.Trigger.OldMap.get(cta.Id).Request_Status__c !=System.Trigger.NewMap.get(cta.Id).Request_Status__c  ))){
                                             if(cta.CRM_Contact_ID__c!= null)
                                             {
                                                 coniddenied.add(cta.CRM_Contact_ID__c);
                                             }
                                             
                                         }        
            }
            
            
            
        }
        
        system.debug('wctaid****:'+wctaid);
        if(wctaid.size()>0)
            FutureMethodForCreatingUser.createuser(conid,wctaid);
        system.debug('Con-Id'+conid);
        /* wctaid.add('a0Tm000000847E4');
conid.add('003m000001ArBtc'); 
FutureMethodForCreatingUser.createuser(conid,wctaid);*/
        
        
        if( coniddenied.size()>0){
            
            try{
                caselistDenied=[select id , Subject,Resolution__c,isclosed,Sub_Class__c from case where
                                subject='MyAerospace Registration Request – Honeywell Training'
                                and 
                                Contactid in:coniddenied];
                for(integer i=0;i<caselistDenied.size();i++){
                    // cas.subject='MyAerospace Registration Request – Honeywell Training';
                    caselistDenied[i].Resolution__c='None';
                    caselistDenied[i].status='Denied';
                    caselistDenied[i].Sub_Class__c='';
                    caselistDenied[i].Export_Compliance_Content_ITAR_EAR__c='No';
                    caselistDenied[i].Government_Compliance_SM_M_Content__c='No';
                    
                }
                update caselistDenied;
            }
            catch(Exception e){}
        }
        
    }  
    
    //Admin removes: TTS or TKC Contact Tool Access (Record Deleted or Status Changed Approved to Denied/Pending)
    if(Trigger.isDelete){
        try{
            Set<Id> contactIdSet =new Set<Id>();
            Set<Id> contactIdUserDeactivateSet = new Set<Id>();
            for(Contact_Tool_Access__c ctac:Trigger.old) {
                if(ctac.Name=='Honeywell Training' || ctac.Name=='Technical Knowledge Center'){
                    contactIdSet.add(ctac.CRM_Contact_ID__c);
                }
            }
            if(!contactIdSet.isEmpty()){
                 system.debug('contactIdSet*****'+contactIdSet);
           		 ContactToolAccessTriggerHelperClass.AfterDelete(contactIdSet);  
            }
        }Catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
    
    //When Status Changed Approved to Denied/Pending
    if(Trigger.isUpdate){
        Set<Id> contactIdSet =new Set<Id>();
        try{
            for(Contact_Tool_Access__c ctac: Trigger.new) {
                Contact_Tool_Access__c conToolOld = Trigger.oldMap.get(ctac.Id);
                Contact_Tool_Access__c conToolNew = Trigger.newMap.get(ctac.Id);
                if(conToolNew.Name ==  'Honeywell Training' || conToolNew.Name ==  'Technical Knowledge Center'){
                    if(conToolOld.Request_Status__c != conToolNew.Request_Status__c && conToolNew.Request_Status__c != 'Approved'){
                        contactIdSet.add(ctac.CRM_Contact_ID__c);
                    }
                }
            }
            ContactToolAccessTriggerHelperClass.AfterUpdate(contactIdSet); 
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
}