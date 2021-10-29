public without sharing class RedButtonContentCreation {
    
    public static string creationAttContent(list<Object> filesToInsert,map<String,String> casInfoHelpNeededMap){        
        string casNumber;
        string[] toAddresses = new List<String>();
        string casId = casInfoHelpNeededMap.get('casId');
        string recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
        if(filesToInsert.size()>0)
            casContentCreation(filesToInsert,casId);
        
        Case roiCaseDetail = [Select Id,OwnerId,RecordTypeId,casenumber from Case where Id=:casId];
        
        Case updateCas = new Case();
        updateCas.Id=casId;
        updateCas.Status='Open-Comment-Attachment';
        if(roiCaseDetail!=null && roiCaseDetail.RecordTypeId==recTypeId && roiCaseDetail.OwnerId==label.aero_default_user_id){
            updateCas.OwnerId= label.CSO_R_O_Team;
        }
        update updateCas;    
        
        toAddresses.add(casInfoHelpNeededMap.get('EmailId'));
        sendMailForGceConnect(casInfoHelpNeededMap.get('casId'),toAddresses);
        
        casNumber = roiCaseDetail.casenumber;
        return casNumber;
    }
    
    public static void sendMailForGceConnect(string casId,string[] toAddresses) { 
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(label.Internal_Escalations_Case, null, casId);
        mail.setToAddresses(toAddresses);
        mail.setOrgWideEmailAddressId('0D2300000008P9eCAE');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    public static string caseCreationWithAttContent(list<Object> filesToInsert,map<String,String> casInfoInactiveMap){
        string casNumber;
        string accId = casInfoInactiveMap.get('AccountId');
        string emailId = casInfoInactiveMap.get('EmailId');
        string complexity = casInfoInactiveMap.get('Complexity');
        string workstreamOption = casInfoInactiveMap.get('WorkstreamOption');
        string workstream = casInfoInactiveMap.get('Workstream');
        
        Case newCase = new Case();
        newCase.AccountId = accId;
        newCase.Sales_Order_Number__c = casInfoInactiveMap.get('SalesOrderNumber');
        newCase.Customer_PO_RO_WONumber__c = casInfoInactiveMap.get('CustPoNumber');
        newCase.Repair_Notification_Number__c = casInfoInactiveMap.get('RepairNotificationNumber');
        newCase.Quote_Number__c = casInfoInactiveMap.get('QuoteNumber');
        newCase.Requestor_Email__c = emailId;
        newCase.Type = casInfoInactiveMap.get('Workstream');
        newCase.Description = casInfoInactiveMap.get('Comments');
        newCase.Status ='Open';
        
        if(workstream.contains('GoDirect Trade FGI'))
            newCase.Subject = 'GoDirect FGI '+casInfoInactiveMap.get('Subject');
        else if(workstream.contains('GoDirect Trade Place Order'))
            newCase.Subject = 'GoDirect Trade '+casInfoInactiveMap.get('Subject');
        else if(workstream.contains('FGI Orders'))
            newCase.Subject = 'FGI '+casInfoInactiveMap.get('Subject');
        else
            newCase.Subject = casInfoInactiveMap.get('Subject');
        
        if(workstreamOption=='ROI'){            
            newCase.Workstrem__c= 'Repair and Overhaul';
        }
        else if(workstreamOption=='Spares'){            
            newCase.Workstrem__c= 'Spares';
        }
        else if(workstreamOption=='OEM'){            
            newCase.Workstrem__c= 'OEM';
        }
        
        if(workstreamOption=='ROI'){            
            newCase.ownerid= label.CSO_R_O_Team;
        }         
        else if(workstreamOption=='OEM' || workstreamOption=='Spares'){
            newCase.ownerid=label.CSO_OEM_Spares;
        }
        
        if(emailId!=null && emailId!=''){
            List<contact> conlist=[select id,email from contact where Email=:emailId];            
            if(conlist.size()>0){
                newCase.contactid=conlist[0].id;                
            }       
        }
        
        newCase.recordtypeId=label.Internal_Escalations;
        newCase.Origin='Web';
        
        if(complexity == 'No')            
            newCase.Case_Complexity__c = 'OMS';
        else if(complexity == 'Yes')            
            newCase.Case_Complexity__c = 'CSS';
        else
            newCase.Case_Complexity__c = 'OMS';
            
        system.debug('newCase: '+newCase);
        if(newCase!=null)
            insert newCase;        
        
        if(filesToInsert.size()>0) 
            casContentCreation(filesToInsert,newCase.Id);
        
        case cas=[select id,casenumber from case where id =: newCase.Id];
        casNumber = cas.casenumber;
        return casNumber;
    }
    
    public static string createChildCase(list<Object> filesToInsert,map<String,String> casInfoInactiveMap){
        string casNumber;
        string casId = casInfoInactiveMap.get('casId');
        string emailId = casInfoInactiveMap.get('EmailId');
        string recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
        Case newCase = new Case();
        Case cas = [select Id, AccountId,contactid,RecordTypeId,Type,Subject,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,Customer_Support_Focal__c,Business_Focal__c,Classification__c,Description,Additional_Web_Form_Info__c from Case where id=: casId];
        newCase.AccountId = cas.AccountId;
        newCase.Type = cas.Type;
        newCase.Subject = cas.Subject;
        newCase.Sales_Order_Number__c = cas.Sales_Order_Number__c;
        newCase.Customer_PO_RO_WONumber__c = cas.Customer_PO_RO_WONumber__c;
        newCase.Repair_Notification_Number__c = cas.Repair_Notification_Number__c;
        newCase.Quote_Number__c = cas.Quote_Number__c;
        newCase.Description = cas.Description;
        newCase.Classification__c = cas.Classification__c;
        newCase.Additional_Web_Form_Info__c = cas.Additional_Web_Form_Info__c;
        newCase.Customer_Support_Focal__c = cas.Customer_Support_Focal__c;
        newCase.Business_Focal__c = cas.Business_Focal__c;
        newCase.ParentId = casId;        
        newCase.Requestor_Email__c = emailId;
        if(cas.RecordTypeId == recTypeId){            
            newCase.ownerid= label.CSO_R_O_Team;
        }         
        else {
            newCase.ownerid=label.CSO_OEM_Spares;
        }
        
        if(emailId!=null && emailId!=''){
            List<contact> conlist=[select id,email from contact where Email=:emailId];            
            if(conlist.size()>0){
                newCase.contactid=conlist[0].id;                
                newCase.Requested_By_HON_Internal__c=conlist[0].id;
            }       
        }        
        newCase.recordtypeId=label.Internal_Escalations;
        newCase.Origin='Web';
        newCase.Status ='Open';
        system.debug('newCase: '+newCase);
            
        if(newCase!=null)
            insert newCase;        
        
        if(filesToInsert.size()>0) 
            casContentCreation(filesToInsert,newCase.Id);
        
        if(casInfoInactiveMap.get('Comments')!=null){
            CaseComment newCom = new CaseComment();
            newCom.CommentBody = 'From: '+emailId +'\n'+ casInfoInactiveMap.get('Comments');            
            newCom.ParentId = newCase.Id;
            insert newCom;
        }
        
        case casNew=[select id,casenumber from case where id =: newCase.Id];
        casNumber = casNew.casenumber;
        return casNumber;
    }
    
    public static string caseReOpen(list<Object> filesToInsert,map<String,String> casInfoInactiveMap){
        string casNumber;
        string[] toAddresses = new List<String>();
        string casId = casInfoInactiveMap.get('casId');
        string emailId = casInfoInactiveMap.get('EmailId');
        string recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
        
        Case roiCaseDetail = [select Id,OwnerId,RecordTypeId from Case where id=: casId];
        Case newCase = new Case();
        newCase.Requestor_Email__c = emailId;
        newCase.Status='Re-Open';
        newCase.Id = casId;
        if(roiCaseDetail!=null && roiCaseDetail.RecordTypeId==recTypeId){
            newCase.Status='Open-Comment-Attachment';
        }
        if(roiCaseDetail!=null && roiCaseDetail.RecordTypeId==recTypeId && roiCaseDetail.OwnerId==label.aero_default_user_id){
            newCase.OwnerId= label.CSO_R_O_Team;
        }
        
        if(emailId!=null && emailId!=''){
            List<contact> conlist=[select id,email from contact where Email=:emailId];
            if(conlist.size()>0){
                newCase.contactid=conlist[0].id;                
                //newCase.Requested_By_HON_Internal__c=conlist[0].id;
            }       
        }        
        
        system.debug('newCase: '+newCase);
        if(newCase!=null)
            update newCase;        
        
        if(filesToInsert.size()>0) 
            casContentCreation(filesToInsert,casId);
        
        if(casInfoInactiveMap.get('Comments')!=null){
            CaseComment newCom = new CaseComment();
            newCom.CommentBody = 'From: '+emailId +'\n'+ casInfoInactiveMap.get('Comments');            
            newCom.ParentId = casId;
            insert newCom;
        }
        
        toAddresses.add(casInfoInactiveMap.get('EmailId'));
        sendMailForGceConnect(casInfoInactiveMap.get('casId'),toAddresses);
        
        case casNew=[select id,casenumber from case where id =: casId];
        casNumber = casNew.casenumber;        
        return casNumber;
    }
    
    public static void casContentCreation(list<Object> filesToInsert,String casId){
        List<ContentVersion> lstConVer = new List<ContentVersion>();
        for (Object file : filesToInsert) {
            FileInfo fileData = (FileInfo)JSON.deserialize(JSON.serialize(file), FileInfo.class);
            system.debug('fileData.Title: '+fileData.Title);
            system.debug('fileData.VersionData: '+fileData.VersionData);
            ContentVersion objCntVersion = new ContentVersion();
            objCntVersion.PathOnClient = fileData.Title;
            objCntVersion.Title = fileData.Title;
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
                objCDL.linkedentityId = casId;
                objCDL.Sharetype = 'I';
                lstConDoclink.add(objCDL);
                
            }
        }
        if(lstConDoclink != null && lstConDoclink.size()>0){
            Insert lstConDoclink;  
            system.debug('check::::::'+lstConDoclink);
        }
    }
    
    public static string fetchAcctsDetails(string searchOption,string searchText){
        string tempInput;
        List<AccListWrapper> accWrapList = new List<AccListWrapper>();
        String response = '';
        
        if(searchOption=='Account Name' && searchText!=null && searchText!=''){
            tempInput = '%' + searchText + '%';
            system.debug('tempInput'+tempInput);
            List<account> accList = [SELECT Id,Name,SAP_Sold_To__c,CBT_Team__c,Customer_Support_Focal_Name__c,Customer_Support_Escalation__r.Name,Business_Focal_Name__c,Business_Escalation__r.Name FROM Account where Name like :tempInput];
            if(accList.size()>0){
                for(Account acc : accList){
                    AccListWrapper accWrap = new AccListWrapper();
                    accWrap.Id = acc.Id;
                    accWrap.Name = acc.Name;
                    accWrap.SapSoldTo = acc.SAP_Sold_To__c;
                    accWrap.CbtTeam = acc.CBT_Team__c;
                    accWrap.CustSupFocal = acc.Customer_Support_Focal_Name__c;
                    accWrap.CustSupEsc = acc.Customer_Support_Escalation__r.Name;
                    accWrap.BusinessFocal = acc.Business_Focal_Name__c;
                    accWrap.BusinessEsc = acc.Business_Escalation__r.Name;
                    accWrapList.add(accWrap);
                }
            }
        }   
        else if(searchOption=='SAP Sold To Number' && searchText!=null && searchText!=''){
            tempInput = '%' + searchText + '%';
            List<Account_Cross_Ref__c> accRefList = [select Account_Name__c, Account_Name__r.name,External_Account_ID__c,Account_Name__r.CBT_Team__c, Account_Name__r.Customer_Support_Focal_Name__c, Account_Name__r.Customer_Support_Escalation__r.Name, Account_Name__r.Business_Focal_Name__c, Account_Name__r.Business_Escalation__r.Name from Account_Cross_Ref__c where XREF_Type__c ='SAP_SOLD_TO' and External_Account_ID__c like :tempInput];
            if(accRefList.size()>0){
                for(Account_Cross_Ref__c accRef : accRefList){
                    AccListWrapper accWrap = new AccListWrapper();
                    accWrap.Id = accRef.Account_Name__c;
                    accWrap.Name = accRef.Account_Name__r.name;
                    accWrap.SapSoldTo = accRef.External_Account_ID__c;
                    accWrap.CbtTeam = accRef.Account_Name__r.CBT_Team__c;
                    accWrap.CustSupFocal = accRef.Account_Name__r.Customer_Support_Focal_Name__c;
                    accWrap.CustSupEsc = accRef.Account_Name__r.Customer_Support_Escalation__r.Name;
                    accWrap.BusinessFocal = accRef.Account_Name__r.Business_Focal_Name__c;
                    accWrap.BusinessEsc = accRef.Account_Name__r.Business_Escalation__r.Name;
                    accWrapList.add(accWrap);
                }
            }
        }
        system.debug('accWrapList: '+accWrapList);
        response = JSON.serialize(accWrapList, true);
        
        return response;  
    }
    
    public class FileInfo {
        @AuraEnabled
        public String Title {get;set;}
        @AuraEnabled
        public Blob VersionData {get;set;}
    }
    
    public class AccListWrapper {
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String SapSoldTo {get;set;}
        @AuraEnabled
        public String CbtTeam {get;set;}
        @AuraEnabled
        public String CustSupFocal {get;set;}
        @AuraEnabled
        public String CustSupEsc {get;set;}
        @AuraEnabled
        public String BusinessFocal {get;set;}
        @AuraEnabled
        public String BusinessEsc {get;set;}
    }

}