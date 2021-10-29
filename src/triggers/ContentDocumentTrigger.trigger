trigger ContentDocumentTrigger on ContentDocumentLink (before insert,after update,after Insert,after delete,before delete,after undelete) {
    if((trigger.isInsert && (trigger.isAfter || trigger.isBefore)) || (trigger.isUpdate && trigger.isAfter) || (trigger.isAfter && trigger.isDelete)){
        List<ID> pmidlist =new List<ID>();
        List<ID> cdllist =new List<ID>();
        List<Planned_Meeting__c> newpmlist = new List<Planned_Meeting__c>();
        List<ContentDocumentLink> cdlists = new List<ContentDocumentLink>();
        List<Planned_Meeting__c> pmlist = new List<Planned_Meeting__c>();
        String attname='';
        System.debug('docLink value is======'+trigger.new);
        if(Trigger.isInsert || Trigger.isUpdate){
            for(ContentDocumentLink docLink:trigger.new){        
                pmidlist.add(docLink.LinkedEntityId);
                
                system.debug('pmlist is'+pmidlist);
                system.debug('doc link visib' +docLink.Visibility);
                if(docLink.Visibility=='InternalUsers'){
                    cdllist.add(docLink.ContentDocumentId);
                }
            }
        }	
        if((RecursiveTriggerHandler.isFirstTime  || Test.isRunningTest()) && (Trigger.isInsert || Trigger.isUpdate)){	
        
            RecursiveTriggerHandler.isFirstTime = false;	
            System.debug('docLink value is======'+trigger.new);	
            System.debug('docLink value is======'+trigger.new.size());
        
            //Querying related Planned Meeting 
            if(pmidlist.size()>0){
                pmlist=[select id, name,Attachment_Name__c from Planned_Meeting__c where id in :pmidlist];
            }
            System.debug('the pmlist size=='+pmlist.size());
            System.debug('the cdllist size=='+cdllist.size());
            if(cdllist.size()>0){          
                for(Planned_Meeting__c pms : pmlist){
                    
                    for(ContentDocument cdoc : [SELECT FileExtension, Title FROM ContentDocument WHERE Id IN : cdllist]) {                   
                        System.debug('the cdoc value ----'+cdoc+'.'+cdoc.FileExtension);
                        
                        if(pms.Attachment_Name__c !='' && pms.Attachment_Name__c != null){
                            attname= pms.Attachment_Name__c +','+ cdoc.Title+'.'+cdoc.FileExtension;
                        }
                        
                        if(pms.Attachment_Name__c =='' || pms.Attachment_Name__c == null){
                            attname= cdoc.Title+'.'+cdoc.FileExtension;
                            system.debug('attachment name1'+attname);
                        }
                        
                        pms.Attachment_Name__c = attname;   
                        // system.debug('attachment name2'+attname);             
                    }
                    
                    newpmlist.add(pms);
                }
            }
            
            
            System.debug('the file is ===='+newpmlist);
            //Updating Planned Meeting records
            if(newpmlist.size()>0){
                update newpmlist;
            }
        
        }
        if(trigger.isAfter){
            if(trigger.isInsert || trigger.isUpdate){
                ContentDocumentTriggerHandler.AfterTriggerMethod(pmIdList);
            }
            // Added for Quote Automation Project	
            if(trigger.isInsert){	
                Map<String,String> listdocs = new Map<String,String>();	
                for(ContentDocumentLink each : trigger.new){	
                    if((String.valueOf(each.LinkedEntityId)).subString(0,3) == '500' && each.ShareType == 'I' && each.ContentDocumentId != null){	
                        listdocs.put(each.ContentDocumentId,each.LinkedEntityId);
                    }
                }	
                if(listdocs.size()>0){	
                    QA_EmailNotificationHandler.snedEmailNotification(listdocs);	
                }	
            }// End.	
        }	
        if(trigger.isAfter) {	
            if(trigger.isInsert) {	
                ContentDocumentTriggerHandler.conDocLinkAfterInsert(trigger.new);
            }	
        }	
        if((Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete) && trigger.isAfter){	
            List<ContentDocumentLink> cdls = ( Trigger.new == null ? Trigger.old : Trigger.new );	
            ContentDocumentTriggerHandler.AfterTriggerAttachment(cdls);	
        }
    }
    
    //RAPD - 7999 - Calls updateChannelPartnerNomination
    //Test Class - ChannelPartnerNominationTest
    if((trigger.isDelete && trigger.isbefore)||(trigger.isundelete)||(trigger.isAfter && trigger.isInsert)){
        if(trigger.isDelete && trigger.isbefore){
            ContentDocumentTriggerHandler.updateChannelPartnerNomination(trigger.old);
        }
        else{
            ContentDocumentTriggerHandler.updateChannelPartnerNomination(trigger.new);
        }
    }
    //RAPD - 7999 - Calls updateChannelPartnerNomination
}