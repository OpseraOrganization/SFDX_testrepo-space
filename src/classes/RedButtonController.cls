public class RedButtonController {
    
    @AuraEnabled
    public static List <Case> fetchCases(string searchOption,string searchText) {
        List<case> casList = new List<case>();
        Set<Id> setRecTypeIds = null;
        string tempInput;
        try{
            setRecTypeIds = new Set<Id>{Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AOG').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Exchange').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Core_Recovery').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('General').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Internal_Escalations').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orders').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('OEM_Spares').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('OEM_Quotes_Orders').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quotes').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Returns').getRecordTypeId(),
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ReturnsPRO').getRecordTypeId()};
            
            if(searchOption=='Case Number' && searchText!=null && searchText!=''){
                tempInput = '%' + searchText + '%';
                system.debug('tempInput'+tempInput);
                casList = [SELECT Id, CaseNumber, Status, Type,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,Subject,Account_Name__c,owner.name FROM Case where CaseNumber like :tempInput and RecordTypeId IN :setRecTypeIds];
            }   
            else if(searchOption=='Sales Order Number' && searchText!=null && searchText!=''){
                tempInput = '%' + searchText + '%';
                casList = [SELECT Id, CaseNumber, Status, Type,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,Subject,Account_Name__c,owner.name FROM Case where Sales_Order_Number__c like :tempInput and RecordTypeId IN :setRecTypeIds];
            }   
            else if(searchOption=='Cust PO Number' && searchText!=null && searchText!=''){
                tempInput = '%' + searchText + '%';
                casList = [SELECT Id, CaseNumber, Status, Type,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,Subject,Account_Name__c,owner.name FROM Case where Customer_PO_RO_WONumber__c like :tempInput and RecordTypeId IN :setRecTypeIds];
            }   
            else if(searchOption=='Quote Number' && searchText!=null && searchText!=''){
                tempInput = '%' + searchText + '%';
                casList = [SELECT Id, CaseNumber, Status, Type,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,Subject,Account_Name__c,owner.name FROM Case where Quote_Number__c like :tempInput and RecordTypeId IN :setRecTypeIds];
            }   
            else if(searchOption=='Repair Notification Number' && searchText!=null && searchText!=''){
                tempInput = '%' + searchText + '%';
                casList = [SELECT Id, CaseNumber, Status, Type,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,Subject,Account_Name__c,owner.name FROM Case where Repair_Notification_Number__c like :tempInput and RecordTypeId IN :setRecTypeIds];
            }
            else if(searchOption=='Subject' && searchText!=null && searchText!=''){
                tempInput = '%' + searchText + '%';
                casList = [SELECT Id, CaseNumber, Status, Type,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,Subject,Account_Name__c,owner.name FROM Case where Subject like :tempInput and RecordTypeId IN :setRecTypeIds];
            }
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException('Exception in fetchCases method: '+ex.getMessage());
        }
        return casList;      
    }
    
    @AuraEnabled
    public static string fetchAccts(string searchOption,string searchText) {
        String response = '';
        try{
            response = RedButtonContentCreation.fetchAcctsDetails(searchOption,searchText);            
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException('Exception in fetchAccts method: '+ex.getMessage());
        }
        return response;        
    }   
    
    
    @AuraEnabled
    public static String fetchCaseInfo(string casId) {
        Map<String,String> casInfomap = new Map<String,String>();
        List<string> lstCasComm = new List<string>();
        String response = '';
        CasInfoWrapper casWrapper = new CasInfoWrapper();
        System.debug('Init => '+Limits.getHeapSize());
        Integer maxHeap = Limits.getLimitHeapSize();
        System.debug('maxHeap => '+maxHeap);
        try{
            Case cas = [SELECT Id, CaseNumber, Status, Subject,Account_Name__c,Sub_Status__c,Reason_for_hold__c,Internal_HW_Action__c,Notes__c,IsClosed,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Quote_Number__c,CreatedDate,ClosedDate,Owner.Name,Case_Ref_ID__c FROM Case where Id =: casId limit 1];
            List<CaseComment> casComm = [select id,CommentBody,CreatedDate, CreatedBy.name, ParentId from CaseComment where ParentId =: casId order by CreatedDate desc limit 5];
            if(cas!=null){
                casInfomap.put('CaseId',cas.Id);
                casInfomap.put('CaseNumber',cas.CaseNumber);
                casInfomap.put('Status',cas.Status);
                casInfomap.put('Subject',cas.Subject);
                casInfomap.put('AccountName',cas.Account_Name__c);
                casInfomap.put('Sub_Class',cas.Sub_Status__c);
                casInfomap.put('ReasonforHold',cas.Reason_for_hold__c);
                casInfomap.put('InternalHWAction',cas.Internal_HW_Action__c);
                casInfomap.put('Notes',cas.Notes__c);
                casInfomap.put('IsClosed',String.valueOf(cas.IsClosed));
                casInfomap.put('SalesOrderNumber',cas.Sales_Order_Number__c);
                casInfomap.put('CustPoNumber',cas.Customer_PO_RO_WONumber__c);
                casInfomap.put('RepairNumber',cas.Repair_Notification_Number__c);
                casInfomap.put('QuoteNumber',cas.Quote_Number__c);
                casInfomap.put('DateTimeOpened',cas.CreatedDate.format('MM/dd/yyyy hh:mm a'));
                casInfomap.put('DateTimeClosed',cas.ClosedDate!=null? cas.ClosedDate.format('MM/dd/yyyy hh:mm a') : null);
                casInfomap.put('CasOwner',cas.Owner.Name);
                casInfomap.put('CasRefId',cas.Case_Ref_ID__c);
                casWrapper.casInfomap = casInfomap;
            }
            else{
                casWrapper.casInfomap = null;
            }
                
            if(casComm.size()>0)                
                casWrapper.casCommList = casComm;            
            else
                casWrapper.casCommList = null;
            
            response = JSON.serialize(casWrapper, true);
            
            System.debug('Final when 3 string declared => '+Limits.getHeapSize());
            if(Limits.getHeapSize() >= maxHeap) throw new AuraHandledException('Max heap size reached');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException('Exception in fetchCaseInfo method: '+ex.getMessage());
        }
        return response;
        
    }
    
     @AuraEnabled
    public static string updateCaseInfo(list<Object> filesToInsert, map<String,String> casInfoHelpNeededMap) {
        string casNumber;
        List<ContentVersion> lstConVer = new List<ContentVersion>();
        List<Attachment> lstAttach = new List<Attachment>();
        try{
            if(casInfoHelpNeededMap!=null && casInfoHelpNeededMap.get('casId')!=null){
                if(casInfoHelpNeededMap.get('Comments')!=null){
                    CaseComment newCom = new CaseComment();
                    newCom.CommentBody = 'From: '+casInfoHelpNeededMap.get('EmailId') +'\n'+ casInfoHelpNeededMap.get('Comments');            
                    newCom.ParentId = casInfoHelpNeededMap.get('casId');
                    insert newCom;
                }  
                casNumber = RedButtonContentCreation.creationAttContent(filesToInsert,casInfoHelpNeededMap);
            }
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException('Exception in updateCaseInfo method: '+ex.getMessage());
        }
        return casNumber;
    }
    
    @AuraEnabled
    public static string createCaseInfo(list<Object> filesToInsert, map<String,String> casInfoInactiveMap, boolean isNewCase) {        
        string casNumber;
        string accId = casInfoInactiveMap.get('AccountId');
        try{
            if(accId != null && accId != '')
                casNumber = RedButtonContentCreation.caseCreationWithAttContent(filesToInsert,casInfoInactiveMap);
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException('Exception in createCaseInfo method: '+ex.getMessage());
        }
        return casNumber;
    }
    
    @AuraEnabled
    public static string createChildCaseAndUpdateCaseInfo(list<Object> filesToInsert, map<String,String> casInfoInactiveMap) {        
        string casNumber;
        string casId = casInfoInactiveMap.get('casId');
        try{
            if(casId != null && casId != ''){
                Case cas = [select Id,isclosed,closeddate  from Case where id=: casId];
                if(cas.isclosed == True && cas.closeddate.date() >=system.today().addDays(-7))
                    casNumber = RedButtonContentCreation.caseReOpen(filesToInsert,casInfoInactiveMap);
                else
                    casNumber = RedButtonContentCreation.createChildCase(filesToInsert,casInfoInactiveMap);
            }            
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException('Exception in createChildCaseAndUpdateCaseInfo method: '+ex.getMessage());
        }
        return casNumber;
    }
    
    public class CasInfoWrapper {
        @AuraEnabled
        public Map<String,String> casInfomap {get;set;}
        @AuraEnabled
        public List<CaseComment> casCommList {get;set;}
    }    
}