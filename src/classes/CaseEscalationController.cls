/*****************************************************
Name         : CaseEscalationController
Test Class	 : CaseEscalationController_Test
Created By   : Mahesh M
Created Date : 05-03-2021
Usages       : This Class is used for Case Escalation Component.  
*****************************************************/
public class CaseEscalationController {
 @AuraEnabled
     public static Boolean returnvalue(id coid, string substatus, string reasonhold, list<Object> filesToInsert){     
        Case cse = new case(); 
        Boolean istrue = false;
        list<Escalations_and_Holds__c> tsk = new list<Escalations_and_Holds__c>();
        list<Escalations_and_Holds__c> tsks = new list<Escalations_and_Holds__c>();
        String escrecordtype;
        cse = [select id,Customer_PO_RO_WONumber__c, OwnerId,Status,Sub_Status__c,VN_Name__c, Reason_for_hold__c,Case_Record_Type__c from case where id =: coid limit 1];
            system.debug('case cse== ' + cse);
         	System.debug('VN_Name__c=='+cse.VN_Name__c);
         if(cse.VN_Name__c == null){
             throw new AuraHandledException('Please enter value for Escalated To (Contact)');
         }
         String csownid = cse.OwnerId;
         System.debug('csownid::'+csownid);
         if(csownid.startsWith('00G')){
                throw new AuraHandledException('Case Owner Cannot be Queue. It should be User for auto escalations');
         }
            escrecordtype = cse.Case_Record_Type__c;
        
        tsk = [select id,Sub_Status__c,Automate__c,Case_Type__c,Reason_for_Hold__c from Escalations_and_Holds__c where Sub_Status__c =:substatus AND Reason_for_Hold__c =:reasonhold AND Case_Type__c =:escrecordtype];
        //tsks = [select id,Sub_Status__c,Automate__c,Case_Type__c,Reason_for_Hold__c from Escalations_and_Holds__c where Sub_Status__c =:substatus AND Reason_for_Hold__c =:reasonhold AND Case_Type__c =:escrecordtype AND Automate__c ='No'];
        system.debug(tsk);
        system.debug(tsk.size());        
        if(tsk.size() == 0){
            istrue = true;
        }
        
       else if(tsk.size() != 0){
           for(Escalations_and_Holds__c esh: tsk){
               if(esh.Automate__c == 'No'){
                   istrue = true;
               }
           }
        }
        system.debug(istrue);
        List<ContentVersion> lstConVer = new List<ContentVersion>();
        if(filesToInsert != null){
        for (Object file : filesToInsert) {
            FileInfo fileData = (FileInfo)JSON.deserialize(JSON.serialize(file), FileInfo.class);
            system.debug('fileData.Title: '+fileData.Title);
            system.debug('fileData.VersionData: '+fileData.VersionData);
            ContentVersion objCntVersion = new ContentVersion();
            objCntVersion.PathOnClient = fileData.Title;
            objCntVersion.Title = reasonhold+'-'+fileData.Title;
            objCntVersion.VersionData = fileData.VersionData;
            lstConVer.add(objCntVersion);
         }
        
        system.debug('lstConVer : '+lstConVer.size());
        if(lstConVer != null && lstConVer.size()>0){
            system.debug('content Version bef insert::'+lstConVer);
            insert lstConVer;
            system.debug('Content Version aft insert'+lstConVer);
        }
        set<id> setConvID = new set<id>();
        for(ContentVersion objCon1 : lstConVer){
            if(objCon1 != null){
                setConvID.add(objCon1.Id);
            }
        }
        system.debug('setConvID: '+setConvID);
        List<ContentDocumentlink> lstConDoclink = new List<ContentDocumentLink>();
        
        if(setConvID != null && setConvID.size()>0){
            for(ContentVersion objCon : [SELECT Id,Title,ContentDocumentId from ContentVersion where Id IN: setConvID AND IsLatest = true]){
                ContentDocumentlink objCDL = new ContentDocumentlink();
                objCDL.ContentDocumentId = objCon.ContentDocumentId;
                objCDL.linkedentityId = coid;
                objCDL.Sharetype = 'I';
                lstConDoclink.add(objCDL);
           }
        }
        if(lstConDoclink != null && lstConDoclink.size()>0){
            Insert lstConDoclink;  
            system.debug('check::::::'+lstConDoclink);
        }
        }
        CaseEscalationForHolds.sendescalatedemailFirstEscalation(coid);
        return istrue;

    }
    public class FileInfo {
        @AuraEnabled
        public String Title {get;set;}
        @AuraEnabled
        public Blob VersionData {get;set;}
    }
}