public class CaseEscalationForHolds_Batch implements Database.Batchable<sObject>, schedulable{
	Public String query;
    Public Database.QueryLocator start(Database.BatchableContext BC){
        String stod = String.valueOf(system.today()); 
        Date todayDate = Date.today();
        System.debug('todayDate::'+todayDate);
        query = 'select id, Status, RecordTypeid, ContactId, Pega_Reason_for_Hold__c,Case_Ref_ID__c,CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c, Case_Comments__c, Product_Number__c, Product_Number__r.Name, Part_Number__c, Accountid, Hon_Plant_Code_del__c, Sub_Status__c, Reason_for_hold__c,OwnerId, Max_Escalation_Level_Reach__c,Escalation_Level__c,Due_Date__c,Escalated__c,VN_Name__c,Escalated_On__c,To_addresses__c from Case where Status = \'On Hold\' AND Due_Date__c=:todayDate AND Escalation_Level__c IN(\'Escalation 1\',\'Escalation 2\',\'Escalation 3\')';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<Case> scope){
        System.debug('scope::'+scope);
        list<case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        for(Case cs: scope){
        if((cs.Status == 'On Hold') && (cs.Escalated__c == true || cs.Pega_Reason_for_Hold__c == 'yes') && cs.Due_Date__c == System.today()){
           if(cs.Escalation_Level__c == 'Escalation 1'){
               cs.Escalation_Level__c = 'Escalation 2';
               //cs.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
           }
           else if(cs.Escalation_Level__c == 'Escalation 2'){
               cs.Escalation_Level__c = 'Escalation 3';
               //cs.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
           }
           else if(cs.Escalation_Level__c == 'Escalation 3'){
               cs.Escalation_Level__c = 'Escalation 4';
               //cs.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 4';
           }
            cs.Escalated__c = false;
            cslst.add(cs);
            System.debug('cslst::'+cslst);
       }
       }
       database.update(cslst, true);
        System.debug('cslst::'+cslst);
        System.debug('scope::'+scope);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
    }
    Public void finish(Database.BatchableContext BC){}
    Public void execute(SchedulableContext sc){
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,5);
    }
}