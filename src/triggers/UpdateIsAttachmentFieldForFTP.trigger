trigger UpdateIsAttachmentFieldForFTP on ENZ__FTPAttachment__c (after insert,after delete) {
if(Trigger.isInsert){
    Set<Id> inIdsSet=new Set<Id>();
    List<ENZ__FTPAttachment__c> ftpAttachments=Trigger.New;
    for(ENZ__FTPAttachment__c a:ftpAttachments){
        if(a.ENZ__Case__c!=null){
            inIdsSet.add(a.ENZ__Case__c);
        }
        if(a.Planned_Meeting__c!=null){
            inIdsSet.add(a.Planned_Meeting__c);
        }
        if(a.Event__c!=null){
            inIdsSet.add(a.Event__c);
        }
        if(a.Field_Event__c!=null){
            inIdsSet.add(a.Field_Event__c);
        }
        if(a.Service_Request__c!=null){
            inIdsSet.add(a.Service_Request__c);
        }
        if(a.ENZ__Solution__c!=null){
            inIdsSet.add(a.ENZ__Solution__c);
        }
        if(a.Service_Recovery_Report__c!=null){
            inIdsSet.add(a.Service_Recovery_Report__c);
        }
    }
    System.debug('inIdsSet Insert Block == '+inIdsSet);
    List<Case> caseList=[select subject,IsAttachment__c from Case where id in :inIdsSet];
    List<Event__c> eventList=[select name,IsAttachment__c from Event__c where id in :inIdsSet];
    List<Planned_Meeting__c> pmList=[select name,IsAttachment__c from Planned_Meeting__c where id in :inIdsSet];
    List<Service_Recovery_Report__c> srrList=[select name,IsAttachment__c from Service_Recovery_Report__c where id in :inIdsSet];
    List<Solution> solList=[select Id,IsAttachment__c from Solution where id in :inIdsSet];
    List<Service_Request__c> srList=[select name,IsAttachment__c from Service_Request__c where id in :inIdsSet];
    List<Field_Event__c> feList=[select name,IsAttachment__c from Field_Event__c where id in :inIdsSet];
    
    //Case
    if(caseList!=null && caseList.size()>0){
        for(Case c:caseList){
           c.IsAttachment__c=true;
        }
        update caseList;
    }
    
    //Event
    if(eventList!=null && eventList.size()>0){
        for(Event__c e:eventList){
           e.IsAttachment__c=true;
        }
        update eventList;
    }
    
    //Planned Meeting
    if(pmList!=null && pmList.size()>0){
        for(Planned_Meeting__c pm:pmList){
           pm.IsAttachment__c=true;
        }
        update pmList;
    }
    
    //Service Recovery Report
    if(srrList!=null && srrList.size()>0){
        for(Service_Recovery_Report__c srr:srrList){
           srr.IsAttachment__c=true;
        }
        update srrList;
    }
    
    //Solution
    if(solList!=null && solList.size()>0){
        for(Solution sol:solList){
           sol.IsAttachment__c=true;
        }
        update solList;
    }
    
    //Service Request
    if(srList!=null && srList.size()>0){
        for(Service_Request__c sr:srList){
           sr.IsAttachment__c=true;
        }
        update srList;
    }
    
    //Field Event
    if(feList!=null && feList.size()>0){
        for(Field_Event__c fe:feList){
           fe.IsAttachment__c=true;
        }
        update feList;
    }
}else if(Trigger.isDelete){
    Set<Id> delIdSet=new Set<Id>();
    List<Id> IdsList=new List<Id>();
           
    List<ENZ__FTPAttachment__c> dAttachments=Trigger.old;
    for(ENZ__FTPAttachment__c a:dAttachments){
        if(a.ENZ__Case__c!=null){
            delIdSet.add(a.ENZ__Case__c);
            IdsList.add(a.ENZ__Case__c);
        }
        if(a.Planned_Meeting__c!=null){
            delIdSet.add(a.Planned_Meeting__c);
            IdsList.add(a.Planned_Meeting__c);    
        }
        if(a.Event__c!=null){
            delIdSet.add(a.Event__c);
            IdsList.add(a.Event__c);
        }
        if(a.Field_Event__c!=null){
            delIdSet.add(a.Field_Event__c);
            IdsList.add(a.Field_Event__c);
        }
        if(a.Service_Request__c!=null){
            delIdSet.add(a.Service_Request__c);
            IdsList.add(a.Service_Request__c);            
        }
        if(a.ENZ__Solution__c!=null){
            delIdSet.add(a.ENZ__Solution__c);
            IdsList.add(a.ENZ__Solution__c);
        }
        if(a.Service_Recovery_Report__c!=null){
            delIdSet.add(a.Service_Recovery_Report__c);
            IdsList.add(a.Service_Recovery_Report__c);
        }
    }
    System.debug('delIdSet Delete Block == '+delIdSet);
    List<Attachment> attachmentsList=[select id,ParentId from Attachment where ParentId in :delIdSet];
    List<ENZ__FTPAttachment__c> ftpCaseAttachmentsList=[select id,ENZ__Case__c from ENZ__FTPAttachment__c where ENZ__Case__c in :delIdSet ];
    List<ENZ__FTPAttachment__c> ftpPMAttachmentsList=[select id,Planned_Meeting__c from ENZ__FTPAttachment__c where Planned_Meeting__c in :delIdSet ];
    List<ENZ__FTPAttachment__c> ftpEvntAttachmentsList=[select id,Event__c from ENZ__FTPAttachment__c where Event__c in :delIdSet ];
    List<ENZ__FTPAttachment__c> ftpFEAttachmentsList=[select id,Field_Event__c from ENZ__FTPAttachment__c where Field_Event__c in :delIdSet ];
    List<ENZ__FTPAttachment__c> ftpSRAttachmentsList=[select id,Service_Request__c from ENZ__FTPAttachment__c where Service_Request__c in :delIdSet ];
    List<ENZ__FTPAttachment__c> ftpSolAttachmentsList=[select id,ENZ__Solution__c from ENZ__FTPAttachment__c where ENZ__Solution__c in :delIdSet];
    List<ENZ__FTPAttachment__c> ftpSRRAttachmentsList=[select id,Service_Recovery_Report__c from ENZ__FTPAttachment__c where Service_Recovery_Report__c in :delIdSet];
    
    //attachments
    Map<Id,List<Id>> mapAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        List<Id> attachmentIds=new List<Id>();
        for(Attachment att:attachmentsList){
            if(IdsList.get(i)==att.ParentId){
                attachmentIds.add(att.Id);
            }
        }
        mapAttachments.put(IdsList.get(i),attachmentIds);
    }
    
    //FTP Attachments
    Map<Id,List<Id>> mapCaseFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        List<Id> ftpCaseAttachmentIds=new List<Id>();
        for(ENZ__FTPAttachment__c att:ftpCaseAttachmentsList){
            if(IdsList.get(i)==att.ENZ__Case__c){
                ftpCaseAttachmentIds.add(att.Id);
            }
            
        }
        mapCaseFTPAttachments.put(IdsList.get(i),ftpCaseAttachmentIds);
    }
    
    Map<Id,List<Id>> mapPMFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        List<Id> ftpPMAttachmentIds=new List<Id>();
        
        for(ENZ__FTPAttachment__c att:ftpPMAttachmentsList){
            
            if(IdsList.get(i)==att.Planned_Meeting__c){
                ftpPMAttachmentIds.add(att.Id);
            }
        }
        
        mapPMFTPAttachments.put(IdsList.get(i),ftpPMAttachmentIds);
        
    }
    Map<Id,List<Id>> mapEvntFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        
        List<Id> ftpEvntAttachmentIds=new List<Id>();
        
        for(ENZ__FTPAttachment__c att:ftpEvntAttachmentsList){
            
            if(IdsList.get(i)==att.Event__c){
                ftpEvntAttachmentIds.add(att.Id);
            }
            
        }
        
        mapEvntFTPAttachments.put(IdsList.get(i),ftpEvntAttachmentIds);
        
    }
    Map<Id,List<Id>> mapFeFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        
        List<Id> ftpFeAttachmentIds=new List<Id>();
        
        for(ENZ__FTPAttachment__c att:ftpFEAttachmentsList){
            
            if(IdsList.get(i)==att.Field_Event__c){
                ftpFeAttachmentIds.add(att.Id);
            }
            
        }
        
        mapFeFTPAttachments.put(IdsList.get(i),ftpFeAttachmentIds);
        
    }
    Map<Id,List<Id>> mapSrFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        
        List<Id> ftpSrAttachmentIds=new List<Id>();
        
        for(ENZ__FTPAttachment__c att:ftpSRAttachmentsList){
            
            if(IdsList.get(i)==att.Service_Request__c){
                ftpSrAttachmentIds.add(att.Id);
            }
            
        }
        
        mapSrFTPAttachments.put(IdsList.get(i),ftpSrAttachmentIds);
        
    }
    Map<Id,List<Id>> mapSolFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        
        List<Id> ftpSolAttachmentIds=new List<Id>();
        
        for(ENZ__FTPAttachment__c att:ftpSolAttachmentsList){
            
            if(IdsList.get(i)==att.ENZ__Solution__c){
                ftpSolAttachmentIds.add(att.Id);
            }
            
        }
        
        mapSolFTPAttachments.put(IdsList.get(i),ftpSolAttachmentIds);
        
    }
    Map<Id,List<Id>> mapSrrFTPAttachments=new Map<Id,List<Id>>();
    for(integer i=0;i<IdsList.size();i++){
        
        List<Id> ftpSrrAttachmentIds=new List<Id>();
        for(ENZ__FTPAttachment__c att:ftpSRRAttachmentsList){
            
            if(IdsList.get(i)==att.Service_Recovery_Report__c){
                ftpSrrAttachmentIds.add(att.Id);
            }
        }
        
        mapSrrFTPAttachments.put(IdsList.get(i),ftpSrrAttachmentIds);
    }
    
    List<Case> delCaseList=[select id,subject,IsAttachment__c from Case where id in :delIdSet];
    List<Event__c> delEventList=[select id,name,IsAttachment__c from Event__c where id in :delIdSet];
    List<Planned_Meeting__c> delPmList=[select id,name,IsAttachment__c from Planned_Meeting__c where id in :delIdSet];
    List<Service_Recovery_Report__c> delSrrList=[select name,IsAttachment__c from Service_Recovery_Report__c where id in :delIdSet];
    List<Solution> delSolList=[select Id,IsAttachment__c from Solution where id in :delIdSet];
    List<Service_Request__c> delSrList=[select name,IsAttachment__c from Service_Request__c where id in :delIdSet];
    List<Field_Event__c> delFeList=[select name,IsAttachment__c from Field_Event__c where id in :delIdSet];
    
    //Case
    if(delCaseList!=null && delCaseList.size()>0){
        for(Case c:delCaseList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(c.id)!=null && mapAttachments.get(c.id).size()==0 && mapCaseFTPAttachments!=null && mapCaseFTPAttachments.size()>0 && mapCaseFTPAttachments.get(c.Id)!=null && mapCaseFTPAttachments.get(c.Id).size()==0){
                c.IsAttachment__c=false;
            }
        }
        update delCaseList;                     
    }           
    
    //Event
    if(delEventList!=null && delEventList.size()>0){
        for(Event__c e:delEventList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(e.id)!=null && mapAttachments.get(e.id).size()==0 && mapEvntFTPAttachments!=null && mapEvntFTPAttachments.size()>0 && mapEvntFTPAttachments.get(e.Id)!=null && mapEvntFTPAttachments.get(e.Id).size()==0){
                e.IsAttachment__c=false;
            }
        }
        update delEventList;                        
    }           
    
    //Planned Meeting
    if(delPmList!=null && delPmList.size()>0){
        for(Planned_Meeting__c pm:delPmList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(pm.id)!=null && mapAttachments.get(pm.id).size()==0 && mapPMFTPAttachments!=null && mapPMFTPAttachments.size()>0 && mapPMFTPAttachments.get(pm.Id)!=null && mapPMFTPAttachments.get(pm.Id).size()==0){ 
                pm.IsAttachment__c=false;
            }
        }
        update delPmList;                       
    } 
    
    //Field Event
    if(delFeList!=null && delFeList.size()>0){
        for(Field_Event__c fe:delFeList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(fe.id)!=null && mapAttachments.get(fe.id).size()==0 && mapFeFTPAttachments!=null && mapFeFTPAttachments.size()>0 && mapFeFTPAttachments.get(fe.Id)!=null && mapFeFTPAttachments.get(fe.Id).size()==0){ 
                fe.IsAttachment__c=false;
            }
        }
        update delFeList;                       
    } 
    
    //Service Request
    if(delSrList!=null && delSrList.size()>0){
        for(Service_Request__c sr:delSrList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(sr.id)!=null && mapAttachments.get(sr.id).size()==0 && mapSrFTPAttachments!=null && mapSrFTPAttachments.size()>0 && mapSrFTPAttachments.get(sr.Id)!=null && mapSrFTPAttachments.get(sr.Id).size()==0){ 
                sr.IsAttachment__c=false;
            }
        }
        update delSrList;                       
    }
    
    //Solution
    if(delSolList!=null && delSolList.size()>0){
        for(Solution sol:delSolList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(sol.id)!=null && mapAttachments.get(sol.id).size()==0 && mapSolFTPAttachments!=null && mapSolFTPAttachments.size()>0 && mapSolFTPAttachments.get(sol.Id)!=null && mapSolFTPAttachments.get(sol.Id).size()==0){ 
                sol.IsAttachment__c=false;
            }
        }
        update delSolList;                       
    }
    
    //Service Recovery Report
    if(delSrrList!=null && delSrrList.size()>0){
        for(Service_Recovery_Report__c srr:delSrrList){
            if(mapAttachments!=null && mapAttachments.size()>0 && mapAttachments.get(srr.id)!=null && mapAttachments.get(srr.id).size()==0 && mapSrrFTPAttachments!=null && mapSrrFTPAttachments.size()>0 && mapSrrFTPAttachments.get(srr.Id)!=null && mapSrrFTPAttachments.get(srr.Id).size()==0){ 
                srr.IsAttachment__c=false;
            }
        }
        update delSrrList;                       
    }          

    

}
}