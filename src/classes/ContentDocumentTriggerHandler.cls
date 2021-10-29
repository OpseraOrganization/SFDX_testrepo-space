public class ContentDocumentTriggerHandler {
    
    public static void AfterTriggerMethod(List<Id> relatedRecordIds){
        List<SRD_Customer_Communication__c> srdCommList=[SELECT id,attachment_last_Modified__c FROM SRD_Customer_Communication__c WHERE Id IN :relatedRecordIds];
        if(srdCommList.size()>0){
            for(SRD_Customer_Communication__c srdCom:srdCommList){
                srdCom.attachment_last_Modified__c=system.now();
            }
            database.update(srdCommList);            
        }        
    }
     //Agreement Attachment Functionality (From Attachment to Conent File)	
    public static void conDocLinkAfterInsert(list<ContentDocumentLink> lstCntLinks) {	
        String strObjPrefix;	
        Set<Id> setCntDocIds = new set<Id>();	
        set<Id> setCaseIds = new set<Id>();	
        	
        for(ContentDocumentLink clIterator : lstCntLinks) {	
            strObjPrefix = String.valueOf(clIterator.LinkedEntityId).substring(0, 3);	
            if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {	
                setCaseIds.add(clIterator.LinkedEntityId);	
            }	
        }	
        if(setCaseIds!=null && setCaseIds.size()>0){	
            onCaseContent(setCaseIds);	
        }	
    }	
    	
    public static void conDocBeforeDelete(list<ContentDocument> lstCntDocs) {	
        String strObjPrefix;	
        Set<Id> setCntDocIds = new set<Id>();	
        set<Id> setCaseIds = new set<Id>();	
        set<Id> setOppIds = new set<Id>();	
        set<Id> setEventIds = new set<Id>();	
        set<Id> setPmIds = new set<Id>();	
        List<Case> caseList =null;	
        List<Event__c> eventList =null;	
        List<Opportunity> oppList =null;	
        List<Planned_Meeting__c> pmList =null;	
        system.debug('Before delete');	
        for(ContentDocument clIterator : lstCntDocs) {	
            setCntDocIds.add(clIterator.Id);	
        }	
        for(ContentDocumentLink cl : [select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :setCntDocIds]){	
            strObjPrefix = String.valueOf(cl.LinkedEntityId).substring(0, 3);	
            if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {	
                setCaseIds.add(cl.LinkedEntityId);	
            }	
            else if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {	
                setOppIds.add(cl.LinkedEntityId);	
            }	
            else if(strObjPrefix == Event__c.sObjectType.getDescribe().getKeyPrefix()) {	
                setEventIds.add(cl.LinkedEntityId);	
            }	
            else if(strObjPrefix == Planned_Meeting__c.sObjectType.getDescribe().getKeyPrefix()) {	
                setPmIds.add(cl.LinkedEntityId);	
            }	
        }	
        if(setCaseIds!=null && setCaseIds.size()>0){	
            caseList = new List<Case>();	
            Map<String,Integer> ftpAttachmentCaseMap = new Map<String,Integer>();	
            AggregateResult[] groupedResults = [SELECT ENZ__Case__c, count(id) FROM ENZ__FTPAttachment__c where ENZ__Case__c IN :setCaseIds GROUP BY ENZ__Case__c];	
            for (AggregateResult ar : groupedResults)  {	
                ftpAttachmentCaseMap.put(String.valueOf(ar.get('ENZ__Case__c')), Integer.valueOf(ar.get('expr0')));	
                System.debug('FTP Case ParentId: ' + ar.get('ENZ__Case__c'));	
                System.debug('FTP Case File count: ' + ar.get('expr0'));	
            }	
            for(Case cas:[select id,IsAttachment__c,(select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLinks) from Case where id IN :setCaseIds]){	
                // existing count	
                integer exsiz = cas.ContentDocumentLinks.size();	
                integer totalFileCount = exsiz > 0 ? exsiz-1 : 0;	
                System.debug('Case File count: ' + totalFileCount);	
                system.debug('ftpAttachmentCaseMap: '+ftpAttachmentCaseMap.get(cas.Id));	
                if(totalFileCount==0 && (ftpAttachmentCaseMap.get(cas.Id)==null || (ftpAttachmentCaseMap.get(cas.Id)!=null && ftpAttachmentCaseMap.get(cas.Id)==0))){	
                    if(cas.IsAttachment__c!=false){	
                        Case attUpdate = new Case(Id = cas.ID);	
                        attUpdate.IsAttachment__c=false;	
                        caseList.add(attUpdate);	
                    }	
                }	
            }	
            system.debug('caseList IsAttachmentField====='+caseList.size());	
            if(caseList!=null && caseList.size()>0)	
                update caseList;	
        }	
        	
        if(setEventIds!=null && setEventIds.size()>0){	
            eventList = new List<Event__c>();	
            Map<String,Integer> ftpAttachmentEventMap = new Map<String,Integer>();	
            AggregateResult[] groupedResults = [SELECT Event__c, count(id) FROM ENZ__FTPAttachment__c where Event__c IN :setEventIds GROUP BY Event__c];	
            for (AggregateResult ar : groupedResults)  {	
                ftpAttachmentEventMap.put(String.valueOf(ar.get('Event__c')), Integer.valueOf(ar.get('expr0')));	
                System.debug('FTP Event ParentId: ' + ar.get('Event__c'));	
                System.debug('FTP Event File count: ' + ar.get('expr0'));	
            }	
            for(Event__c eve:[select id,IsAttachment__c,(select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLinks) from Event__c where id IN :setEventIds]){	
                // existing count	
                integer exsiz = eve.ContentDocumentLinks.size();	
                integer totalFileCount = exsiz > 0 ? exsiz-1 : 0;	
                System.debug('Event File count: ' + totalFileCount);	
                system.debug('ftpAttachmentEventMap: '+ftpAttachmentEventMap.get(eve.Id));	
                if(totalFileCount==0 && (ftpAttachmentEventMap.get(eve.Id)==null || (ftpAttachmentEventMap.get(eve.Id)!=null && ftpAttachmentEventMap.get(eve.Id)==0))){	
                    if(eve.IsAttachment__c!=false){	
                        Event__c attUpdate = new Event__c(Id = eve.ID);	
                        attUpdate.IsAttachment__c=false;	
                        eventList.add(attUpdate);	
                    }	
                    	
                }	
            }	
            system.debug('eventList IsAttachmentField====='+eventList.size());	
            if(eventList!=null && eventList.size()>0)	
                update eventList;	
        }	
        	
        if(setPmIds!=null && setPmIds.size()>0){	
            pmList = new List<Planned_Meeting__c>();	
            Map<String,Integer> ftpAttachmentPmMap = new Map<String,Integer>();	
            AggregateResult[] groupedResults = [SELECT Planned_Meeting__c, count(id) FROM ENZ__FTPAttachment__c where Planned_Meeting__c IN :setPmIds GROUP BY Planned_Meeting__c];	
            for (AggregateResult ar : groupedResults)  {	
                ftpAttachmentPmMap.put(String.valueOf(ar.get('Planned_Meeting__c')), Integer.valueOf(ar.get('expr0')));	
                System.debug('FTP PM ParentId: ' + ar.get('Planned_Meeting__c'));	
                System.debug('FTP PM File count: ' + ar.get('expr0'));	
            }	
            for(Planned_Meeting__c pm:[select id,IsAttachment__c,(select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLinks) from Planned_Meeting__c where id IN :setPmIds]){	
                // existing count	
                integer exsiz = pm.ContentDocumentLinks.size();	
                integer totalFileCount = exsiz > 0 ? exsiz-1 : 0;	
                System.debug('PM File count: ' + totalFileCount);	
                system.debug('ftpAttachmentPmMap: '+ftpAttachmentPmMap.get(pm.Id));	
                if(totalFileCount==0 && (ftpAttachmentPmMap.get(pm.Id)==null || (ftpAttachmentPmMap.get(pm.Id)!=null && ftpAttachmentPmMap.get(pm.Id)==0))){	
                    if(pm.IsAttachment__c!=false){	
                        Planned_Meeting__c attUpdate = new Planned_Meeting__c(Id = pm.ID);	
                        attUpdate.IsAttachment__c=false;	
                        pmList.add(attUpdate);	
                    }	
                }	
            }	
            system.debug('pmList IsAttachmentField====='+pmList.size());	
            if(pmList!=null && pmList.size()>0)	
                update pmList;	
        }	
        	
        if(setOppIds!=null && setOppIds.size()>0){	
            oppList = new List<Opportunity>();	
            for(Opportunity opp:[select id,IsAttachment__c,(select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLinks) from Opportunity where id IN :setOppIds]){	
                // existing count	
                integer exsiz = opp.ContentDocumentLinks.size();	
                integer totalFileCount = exsiz > 0 ? exsiz-1 : 0;	
                System.debug('Opportunity File count: ' + totalFileCount);	
                if(totalFileCount==0){	
                    if(opp.IsAttachment__c!=false){	
                        Opportunity attUpdate = new Opportunity(Id = opp.ID);	
                        attUpdate.IsAttachment__c=false;	
                        oppList.add(attUpdate);	
                    }	
                }	
            }	
            system.debug('oppList IsAttachmentField====='+oppList.size());	
            if(oppList!=null && oppList.size()>0)	
                update oppList;	
        }	
    }	
    	
    	
    	
    public static void onCaseContent(Set<Id> setCaseIds) {	
        List<case> caselist = new List<case>();	
        List<Case_Extension__c> PPOcasexlist=new List<Case_Extension__c>();	
        system.debug('Agreement Attachment begin:');	
        system.debug('userinfo Agreement Attachment begin:'+userinfo.getuserid());	
        system.debug('Denied party screening User:'+Label.DeniedPartyScreening_APIUser_ID);	
        system.debug('Agreement Attachment Limit class start:'+ Limits.getQueries());	
        if(setCaseIds.size()>0 && userinfo.getuserid()!=Label.DeniedPartyScreening_APIUser_ID)	
        {	
            caselist=[select id,IsAttachment__c,Description,CreatedByid,LastModifiedDate,Status,Quote_Number__c,UFR_Standard_Price_Amount__c,Case_Record_Type__c,Type,Sales_Order_Number__c,OwnerId,AccountId,SBU__c,CaseOwnerChanged__c,Account.R_O_Do_Not_Send_to_Portal__c,Requestor_Email__c,SuppliedEmail,Subject,Case_Ref_Id__c,CaseNumber,Origin,RecordtypeId,(select id,Name,Manual_Intervention_Last_Modified_Date__c,UFR_SBU__c,SAP_SalesOrder_Status__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c,Date_Time_Stamp_of_SBU_Determined__c from CASE.Case_Extensions__r) from Case where id in :setCaseIds];	
           	
        }	
        if(caselist!=null && caselist.size()>0)	
        {	
            for (Case cs:caselist)	
            {	
                system.debug('Agreement Attachment begin1:');	
                if((cs.RecordtypeId == Label.OEM_Spares || cs.RecordtypeId == Label.RnO_Automation_Record_Type) && cs.Status == 'Open' && (cs.OwnerId ==  Label.CSO_OEM_Spares || cs.OwnerId == Label.CSO_R_O_Team))	
                {	
                    system.debug('PPO inside if Attachment trigger---------->');	
                    Case_Extension__c CasEx = new Case_Extension__c();	
                    if(cs.Case_Extensions__r!=null && cs.Case_Extensions__r.size()>0){	
                        system.debug('---->If');	
                        CasEx = cs.Case_Extensions__r;	
                    }else{	
                        system.debug('---->else');	
                        	
                        CasEx.Case_object__c = cs.id;	
                    }	
                    if(CasEx.SAP_SalesOrder_Status__c=='ZRPR'||CasEx.SAP_SalesOrder_Status__c=='ZRA'){	
                        system.debug('---->SAP_SalesOrder_Status__c'+CasEx.SAP_SalesOrder_Status__c);	
                        system.debug('---->Manual'+CasEx.Manual_Intervention_Last_Modified_Date__c);	
                        CasEx.Manual_Intervention_Last_Modified_Date__c = Date.valueOf(cs.LastModifiedDate);	
                        system.debug('---->Manual1'+CasEx.Manual_Intervention_Last_Modified_Date__c);	
                        PPOcasexlist.add(CasEx);	
                        	
                        PPO_EmailSending.EmailSend(cs.id);	
                    }	
                    	
                }	
                system.debug('Agreement Attachment end1:');	
            }	
            List<case> isAttachmentFieldUpdateList = new List<case>();	
            for(Case c:caselist){	
                /* commented  by pragadeesh - Previously, the update happen in class level. Now we are doing	
                the same in trigger which avoids calling @ future.*/	
                // Case c1=new Case(id=c.Id,IsAttachment__c=true,ownerId=c.ownerId);	
                //c.ownerId=	
                //c.IsAttachment__c=true;	
                if(c.IsAttachment__c!=true)	
                {	
                    Case c1 = new Case(Id = c.ID);//changes by pragadeesh	
                    c1.IsAttachment__c=true;//changes by pragadeesh	
                    isAttachmentFieldUpdateList.add(c1);	
                }	
            }	
            system.debug('isAttachmentFieldUpdateList: '+isAttachmentFieldUpdateList.size());	
            if(isAttachmentFieldUpdateList!=null && isAttachmentFieldUpdateList.size() > 0)	
            {	
                update isAttachmentFieldUpdateList; //changes by pragadeesh	
            }	
        }	
        system.debug('Agreement Attachment Limit class End:'+ Limits.getQueries());	
        if(!PPOcasexlist.isEmpty()){ 	
            System.debug('CaseExt Creation'+PPOcasexlist.size());	
            try{	
                System.debug('CaseExt:'+PPOcasexlist.size());	
                update PPOcasexlist;	
            }catch(DMLException e1){}	
        }	
    }	
    public static void AfterTriggerAttachment(List<ContentDocumentLink> contents){	
     Set<ID> parentIds = new Set<ID>();	

    for ( ContentDocumentLink cdl : contents ) {	
        parentIds.add( cdl.LinkedEntityId );	
       }	

    List<Case> cases = [ SELECT Id, ( SELECT Id FROM ContentDocumentLinks LIMIT 1 ) FROM Case WHERE Id IN :parentIds ];	
        	
        for ( Case c : cases ) {	
            c.IsAttachment__c = ( c.ContentDocumentLinks.size() > 0 );	
        }	

        update cases;    	
    }
    //This method is used to update the Content Document URL field in Channel Partner Nomination object
    //whenever the file is created. This method is called from ContentDocumentTrigger.
    //RAPD - 7779
    //Test Class - ChannelPartnerNominationTest
    public static void updateChannelPartnerNomination(List<contentDocumentLink> TriggerRec){
        //Stores the Channel partner nomination record Id and Content Document Link record
        map<Id,contentDocumentLink> mapCpnCdl = new map<Id,contentDocumentLink>();
        //Stores the Channel partner nomination record Id and Content Document URL
        map<Id,string> mapCpnCD = new map<Id,string>();
        //Stores the Channel Partner Nomination Ids
        set<id> CPNIds = new set<id>();
        //Stores the list of Channel Partner Nomination records
        List<Channel_partner_nomination__c> CPNList = new List<Channel_partner_nomination__c>();
        //Gets the base URL(https://instance.salesforce.com)
        string baseurl = URL.getSalesforceBaseUrl().toExternalForm();
        //loops through individual record
        for(contentDocumentLink CDL:TriggerRec){
            if((CDL.LinkedEntityId.getSObjectType().getDescribe().getName()) == 'channel_partner_nomination__c'){
                string ConDocurl = '';
                if(!Trigger.isDelete){
                    ConDocurl = baseurl+'/'+CDL.ContentDocumentId;
                }
                mapCpnCdl.put(CDL.LinkedEntityId,CDL);
                mapCpnCD.put(CDL.LinkedEntityId,ConDocurl);
            }
        }
        if(mapCpnCD.size()>0){
            CPNIds.addAll(mapCpnCD.keyset());
            for(AggregateResult ar:[Select LinkedEntityId,count(id) from contentDocumentLink where LinkedEntityId in: CPNIds group by LinkedEntityId having count(id)>1]){
                CPNIds.remove(string.valueof(ar.get('LinkedEntityId')));
                //Throw error if there are more than 1 file for the same channel partner nomination record
                mapCpnCdl.get(string.valueof(ar.get('LinkedEntityId'))).addError(label.CPN_File_Error_Msg_1_file);
            }            
            for(Channel_partner_nomination__c CPN:[Select id,Approval_status__c,Name from Channel_partner_nomination__c where id in: mapCpnCD.keyset()]){
                system.debug(CPN.approval_status__c);
                if(CPN.approval_status__c!='Pending' && CPN.approval_status__c!='Approved'){
                    CPN.Content_Document_url__c = mapCpnCD.get(CPN.Id);
                    CPNList.add(CPN);
                }
                else{
                    //Throw error if the file is uploaded/deleted when the status is pending or Approved
                    (mapCpnCdl.get(CPN.id)).addError(label.CPN_File_Error_Msg + ' for the record ' + CPN.Name);
                }
            }
            if(CPNList.size()>0){
                update CPNList;
            }
        }
        
    }
    //This method is used to clear the Content Document URL field in Channel Partner Nomination object
    //whenever the file is deleted. This method is called from DContentDocumentTrigger.
    //RAPD - 7779
    //Test Class - ChannelPartnerNominationTest
    public static void updateCPNdocUrl(Map<id,contentDocument> oldTriggerMap){
        List<Channel_partner_nomination__c> CPNList = new List<Channel_partner_nomination__c>();
        map<id,id> CPNIds = new map<id,id>();
        for(contentDocumentLink CDL:[Select LinkedEntityId,contentdocumentId 
                                     from contentdocumentlink where contentdocumentId in: oldTriggerMap.keyset()]){
                                         if((CDL.LinkedEntityId.getSObjectType().getDescribe().getName()) == 'channel_partner_nomination__c'){
                                             CPNIds.put(CDL.LinkedEntityId,CDL.ContentDocumentId);
                                             /*Channel_partner_nomination__c CPN = new Channel_partner_nomination__c(Id=CDL.LinkedEntityId
                                                                                                                   ,Content_Document_url__c='');
                                             CPNList.add(CPN);*/
                                         }
                                         
                                     }
        for(Channel_Partner_nomination__c CPN : [Select id,approval_status__c,Name from Channel_partner_nomination__c where id in:CPNIds.keyset()]){            
            if(CPN.Approval_Status__c != 'Pending' && CPN.Approval_Status__c != 'Approved'){
                CPN.Content_Document_url__c='';
                CPNList.add(CPN);
            }
            else{
                oldTriggerMap.get(CPNIds.get(CPN.Id)).addError(label.CPN_File_Error_Msg + ' for the record ' + CPN.Name);
            }
        }
        if(CPNList.size()>0){
            update CPNList;
        }
    }
}