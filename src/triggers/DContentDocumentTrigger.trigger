trigger DContentDocumentTrigger on ContentDocument (before delete) {
    List<ID> pmidlist =new List<ID>();
    List<Id> cDocId = new List<Id>();
    String attname='';
    List<Planned_Meeting__c> newpmlist = new List<Planned_Meeting__c>();
    List<Planned_Meeting__c> pmlist = new List<Planned_Meeting__c>();
    
        for(ContentDocument cdoc:trigger.Old){
            cDocId.add(cdoc.Id);            
        }
        if(cDocId.size()>0){
            for(ContentDocumentLink cdIds : [SELECT Id, Visibility, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : cDocId]){
                if(cdIds.Visibility=='InternalUsers'){
                    pmidlist.add(cdIds.LinkedEntityId);
                }
            }
        }
        
        System.debug('the LinkedEntityId id are ===='+pmidlist);
        //Querying related Planned Meeting 
        if(pmidlist.size()>0){
            pmlist=[select id, name, Attachment_Name__c from Planned_Meeting__c where id IN :pmidlist];
        }
        System.debug('the meeting are ===='+pmlist);
        if(pmlist.size()>0){
            for(ContentDocument cdocl:trigger.Old){
                for(Planned_Meeting__c pms : pmlist){                    
                    System.debug('name from mee ----'+pms.Attachment_Name__c);
                    System.debug('name from cdoc ----'+cdocl.Title+'.'+cdocl.FileExtension); 
                    String fileName = pms.Attachment_Name__c;
                    String contName = cdocl.Title;                                       
                    List<String> parts =fileName.split(',');                    
                    for(String st: parts){
                        System.debug(contName+'the parts ==='+st);
                        if(!st.contains(contName)){
                            System.debug(contName+'=======>the parts contains==='+st);
                            //attname = contName.remove(st);
                            //attname = attname.remove(',');
                            if(attname == ''){
                                attname = st;
                                System.debug('if the value is===='+attname);
                            }else{
                                attname = attname+','+st;
                                System.debug('else the value is===='+attname);
                            }                            
                        }
                    }
                    pms.Attachment_Name__c = attname;
                    newpmlist.add(pms);
                }
            }
        }
        System.debug('the file is ===='+newpmlist);
        //Updating Planned Meeting records
        if(newpmlist.size()>0){
            update newpmlist;
        }
     if(trigger.isBefore) {
        if(trigger.isDelete) {
            system.debug('Before delete calling from ConDoc Trigger');
            ContentDocumentTriggerHandler.conDocBeforeDelete(trigger.Old);
        }
    }
    //RAPD - 7999 Content Document trigger for channel partner nomination
    //Test Class - ChannelParnterNominationTest
    if(Trigger.isBefore && Trigger.isDelete){
        ContentDocumentTriggerHandler.updateCPNdocUrl(trigger.oldMap);
    }
}