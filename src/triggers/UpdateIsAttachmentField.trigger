trigger UpdateIsAttachmentField on Attachment (after delete, after insert) {
 if(Trigger.isInsert){
        //String parentId=Trigger.new[0].ParentId;
        //Set<Id> idSet=new Set<Id>();
        Set<Id> setInsCaseId=new Set<Id>();
        Set<Id> setInsOppId=new Set<Id>();
        Set<Id> setInsPMId=new Set<Id>();
        Set<Id> setInsEventId=new Set<Id>();
        String strParentObj;
        List<Attachment> iAttachments=Trigger.new;
        for(Attachment a:iAttachments){
            strParentObj = a.ParentId;
            ID idParentObj = a.ParentId;
            if(strParentObj.substring(0,3) == '500')
            {
                setInsCaseId.add(idParentObj);
            }else if(strParentObj.substring(0,3) == '006')
            {
                setInsOppId.add(idParentObj);
            }else if(strParentObj.substring(0,3) == 'a0W')
            {
                setInsEventId.add(idParentObj);
            }else if(strParentObj.substring(0,3) == 'a0Y')
            {
                setInsPMId.add(idParentObj);
            }
            //idSet.add(a.ParentId);
        }
        List<Case> caseList;
        List<Event__c> eventList;
        List<Event__c> lstEventAtt = new List<Event__c>();
        List<Planned_Meeting__c> pmList;
        List<Planned_Meeting__c> lstPMAtt = new List<Planned_Meeting__c>();
        List<Opportunity> opList;
        List<Opportunity> lstOppAtt = new List<Opportunity>();
        
        if(setInsCaseId!=null && setInsCaseId.size()>0)
        {
        caseList=[select id,ownerId,subject,IsAttachment__c from Case where id in :setInsCaseId];
        }
     //   List<Case> caseList=[select id,ownerId,subject,IsAttachment__c from Case where id in :idSet and IsAttachment__c = false];
         if(setInsEventId!=null && setInsEventId.size()>0)
        {
        eventList=[select name,IsAttachment__c from Event__c where id in :setInsEventId];
        }
        if(setInsPMId!=null && setInsPMId.size()>0)
        {
        pmList=[select name,IsAttachment__c from Planned_Meeting__c where id in :setInsPMId];
        }
        if(setInsOppId!=null && setInsOppId.size()>0)
        {
        opList=[select name,IsAttachment__c from Opportunity where id in :setInsOppId];
        }
        List<Case> testCase=new List<Case>();
        if(caseList!=null && caseList.size()>0){
            for(Case c:caseList){
                /* commented  by pragadeesh - Previously, the update happen in class level. Now we are doing
                the same in trigger which avoids calling @ future.*/
               // Case c1=new Case(id=c.Id,IsAttachment__c=true,ownerId=c.ownerId);
                //c.ownerId=
                //c.IsAttachment__c=true;
                if(c.IsAttachment__c!=true)
                {
                Case c1 = new Case(Id = c.ID);//changes by pragadeesh
                c1.IsAttachment__c=true;//changes by pragadeesh
                testCase.add(c1);
                }
            }
            if(testCase!=null && testCase.size() > 0)
            {
            update testCase; //changes by pragadeesh
            }
            //update caseList; 
            // UpdateCaseList.updateCase(caseIds); //changes by pragadeesh
        }
        if(eventList!=null && eventList.size()>0){
            for(Event__c c:eventList){
            if(c.IsAttachment__c!=true)
            {
            Event__c c1 = new Event__c(Id = c.ID);
                c1.IsAttachment__c=true;
                lstEventAtt.add(c1);
            }
            }
            if(lstEventAtt!=null && lstEventAtt.size() > 0)
            {
            update lstEventAtt;
            }
        }
        if(pmList!=null && pmList.size()>0){
            for(Planned_Meeting__c c:pmList){
            if(c.IsAttachment__c!=true)
            {
            Planned_Meeting__c c1 = new Planned_Meeting__c(Id = c.ID);
                c1.IsAttachment__c=true;
                lstPMAtt.add(c1);
            }
            }
            if(lstPMAtt!=null && lstPMAtt.size() > 0)
            {
            update lstPMAtt;
            }
        }
        if(opList!=null && opList.size()>0){
            for(Opportunity c:opList){
            if(c.IsAttachment__c!=true)
            {
            Opportunity c1 = new Opportunity(Id = c.ID);
                c1.IsAttachment__c=true;
                lstOppAtt.add(c1);
            }
            }
            if(lstOppAtt!=null && lstOppAtt.size() > 0)
            {
            update lstOppAtt;
            }
        }
    }else if(Trigger.isDelete){
        
        Set<Id> setDelCaseId=new Set<Id>();
        Set<Id> setDelOppId=new Set<Id>();
        Set<Id> setDelPMId=new Set<Id>();
        Set<Id> setDelEventId=new Set<Id>();
        
        List<Attachment> attachmentsList;
        List<ENZ__FTPAttachment__c> caseFTPAttachmentsList;
        List<ENZ__FTPAttachment__c> eventFTPAttachmentsList;
        List<ENZ__FTPAttachment__c> pmFTPAttachmentsList;
        List<Case> delCaseList;
        List<Event__c> delEventList;
        List<Planned_Meeting__c> delPmList;
        List<Opportunity> deloPList;
        
        List<Case> lstDelCaseAtt = new List<Case>();
        List<Event__c> lstDelEventAtt = new List<Event__c>();
        List<Planned_Meeting__c> lstDelPMAtt = new List<Planned_Meeting__c>();
        List<Opportunity> lstDelOppAtt =new List<Opportunity>();
        
        String strDelParentObj;
        ID idDelParentObj;
        
        //String delParentId=Trigger.old[0].ParentId;
        Set<Id> setAttDelId=new Set<Id>();
        
        List<Id> idList=new List<Id>();
        List<Attachment> dAttachments=Trigger.old;
        for(Attachment a:dAttachments){
            setAttDelId.add(a.ParentId);
            strDelParentObj = a.ParentId;
            idDelParentObj = a.ParentId;
            
            if(strDelParentObj.substring(0,3) == '500')
            {
                setDelCaseId.add(idDelParentObj);
            }else if(strDelParentObj.substring(0,3) == '006')
            {
                setDelOppId.add(idDelParentObj);
            }else if(strDelParentObj.substring(0,3) == 'a0W')
            {
                setDelEventId.add(idDelParentObj);
            }else if(strDelParentObj.substring(0,3) == 'a0Y')
            {
                setDelPMId.add(idDelParentObj);
            }           
            idList.add(a.ParentId);
        }
        attachmentsList=[select id,ParentId from Attachment where ParentId in :setAttDelId];
        
        if(setDelCaseId!=null && setDelCaseId.size()>0)
        {
        delCaseList=[select id,subject,IsAttachment__c from Case where id in :setDelCaseId];
        caseFTPAttachmentsList=[select id,ENZ__Case__c from ENZ__FTPAttachment__c where ENZ__Case__c in :setDelCaseId];
        }
        if(setDelEventId!=null && setDelEventId.size()>0)
        {
        delEventList=[select id,name,IsAttachment__c from Event__c where id in :setDelEventId];
        eventFTPAttachmentsList=[select id,Event__c from ENZ__FTPAttachment__c where Event__c in :setDelEventId];
        }
        if(setDelPMId!=null && setDelPMId.size()>0)
        {
        delPmList=[select id,name,IsAttachment__c from Planned_Meeting__c where id in :setDelPMId];
        pmFTPAttachmentsList=[select id,Planned_Meeting__c from ENZ__FTPAttachment__c where Planned_Meeting__c in :setDelPMId];
        }
        if(setDelOppId!=null && setDelOppId.size()>0)
        {
        deloPList=[select id,name,IsAttachment__c from Opportunity where id in :setDelOppId];
        }
        
        //attachments
        Map<Id,List<Id>> mapAttachments=new Map<Id,List<Id>>();
        if(attachmentsList!=null && attachmentsList.size()>0)
        {
        for(integer i=0;i<idList.size();i++){
            List<Id> attachmentIds=new List<Id>();
            for(Attachment att:attachmentsList){
                if(idList.get(i)==att.ParentId){
                    attachmentIds.add(att.Id);
                }
            }
            mapAttachments.put(idList.get(i),attachmentIds);
        }
        }
        
        //Case FTP Attachments
        Map<Id,List<Id>> mapCaseFTPAttachments=new Map<Id,List<Id>>();
        if(caseFTPAttachmentsList!=null && caseFTPAttachmentsList.size()>0)
        {
        for(integer i=0;i<idList.size();i++){
            List<Id> ftpAttachmentIds=new List<Id>();
            for(ENZ__FTPAttachment__c att:caseFTPAttachmentsList){
                if(idList.get(i)==att.ENZ__Case__c){
                    ftpAttachmentIds.add(att.Id);
                }
            }
            mapCaseFTPAttachments.put(idList.get(i),ftpAttachmentIds);
        }
        }
        
        //Event FTP Attachments
        Map<Id,List<Id>> mapEventFTPAttachments=new Map<Id,List<Id>>();
        if(eventFTPAttachmentsList!=null && eventFTPAttachmentsList.size()>0)
        {
        for(integer i=0;i<idList.size();i++){
            List<Id> ftpAttachmentIds=new List<Id>();
            for(ENZ__FTPAttachment__c att:eventFTPAttachmentsList){
                if(idList.get(i)==att.Event__c){
                    ftpAttachmentIds.add(att.Id);
                }
            }
            mapEventFTPAttachments.put(idList.get(i),ftpAttachmentIds);
        }
        }
        
        //Planned Meeting FTP Attachments
        Map<Id,List<Id>> mapPmFTPAttachments=new Map<Id,List<Id>>();
        if(pmFTPAttachmentsList!=null && pmFTPAttachmentsList.size()>0)
        {
        for(integer i=0;i<idList.size();i++){
            List<Id> ftpAttachmentIds=new List<Id>();
            for(ENZ__FTPAttachment__c att:pmFTPAttachmentsList){
                if(idList.get(i)==att.Planned_Meeting__c){
                    ftpAttachmentIds.add(att.Id);
                }
            }
            mapPmFTPAttachments.put(idList.get(i),ftpAttachmentIds);
        }
        }
        
        //Case
        
            if(delCaseList!=null && delCaseList.size()>0){
                for(Case c:delCaseList){
                    if(mapAttachments!=null && (mapAttachments.size()==0 || mapAttachments.get(c.id)==null ) && mapCaseFTPAttachments!=null && (mapCaseFTPAttachments.size()==0 || mapCaseFTPAttachments.get(c.Id)==null)){
                        Case c1 = new Case(Id = c.ID);
                c1.IsAttachment__c=false;
                lstDelCaseAtt.add(c1);
                
                    }
                }
                if(lstDelCaseAtt!=null && lstDelCaseAtt.size() > 0)
            {
            update lstDelCaseAtt;
            }                     
            }           
        
        //Event
        
            if(delEventList!=null && delEventList.size()>0){
                for(Event__c e:delEventList){                   
                    if(mapAttachments!=null && (mapAttachments.size()==0 || mapAttachments.get(e.id)!=null ) && mapEventFTPAttachments!=null && (mapEventFTPAttachments.size()==0 || mapEventFTPAttachments.get(e.Id)==null)){
                        Event__c c1 = new Event__c(Id = e.ID);
                c1.IsAttachment__c=false;
                lstDelEventAtt.add(c1);
                    }
                }
                if(lstDelEventAtt!=null && lstDelEventAtt.size() > 0)
            {
            update lstDelEventAtt;
            }                  
            }           
        
        //Planned Meeting
        
            if(delPmList!=null && delPmList.size()>0){
                for(Planned_Meeting__c pm:delPmList){                   
                    if(mapAttachments!=null && (mapAttachments.size()==0 || mapAttachments.get(pm.id)==null) && mapPmFTPAttachments!=null && (mapPmFTPAttachments.size()==0 || mapPmFTPAttachments.get(pm.Id)==null)){ 
                        Planned_Meeting__c c1 = new Planned_Meeting__c(Id = pm.ID);
                c1.IsAttachment__c=false;
                lstDelPMAtt.add(c1);
                    }
                }
                if(lstDelPMAtt!=null && lstDelPMAtt.size() > 0)
            {
            update lstDelPMAtt;
            }                 
            }           
        
        //Opportunity
        
            if(deloPList!=null && deloPList.size()>0){
                for(Opportunity op:deloPList){                  
                    if(mapAttachments!=null && (mapAttachments.size()==0 || mapAttachments.get(op.id)==null)){
                        Opportunity c1 = new Opportunity(Id = op.ID);
                c1.IsAttachment__c=false;
                lstDelOppAtt.add(c1);
                    }
                }
                if(lstDelOppAtt!=null && lstDelOppAtt.size() > 0)
            {
            update lstDelOppAtt;
            }
            }
        
            
    }

}