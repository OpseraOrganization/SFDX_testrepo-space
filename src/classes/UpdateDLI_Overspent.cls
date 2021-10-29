global class UpdateDLI_Overspent implements Database.Batchable<Sobject>, Schedulable 
{ 
List<Discretionary__c> Disc = new list<Discretionary__c>();
List<Discretionary_Line_Item__c> dli = new list<Discretionary_Line_Item__c>();
List<Discretionary_Line_Item__c> dlist = new list<Discretionary_Line_Item__c>();
set<id> discid = new set<id>();
DateTime dt = system.now()-7;
    global Database.QueryLocator start(Database.BatchableContext BC) 
    { 
        return Database.getQueryLocator([SELECT Funding_amount__c,Spend_Amount__c,Approval_Status__c,Discretionary_Request__r.id,Discretionary_Request__r.SBU__c,Discretionary_Request__r.CBT__c,Discretionary_Request__r.Fiscal_Year__c,Discretionary_Request__r.Approval_Status__c,Discretionary_Request__r.Total_Approved_Amount__c,Discretionary_Request__r.Total_Spent_Amount__c from Discretionary_Line_Item__c where (CreatedDate >: dt or LastModifiedDate >: dt)]); 
    } 
     
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {  
        //dli= [SELECT Funding_amount__c,Spend_Amount__c,Approval_Status__c,Discretionary_Request__r.id,Discretionary_Request__r.SBU__c,Discretionary_Request__r.CBT__c,Discretionary_Request__r.Fiscal_Year__c,Discretionary_Request__r.Approval_Status__c,Discretionary_Request__r.Total_Approved_Amount__c,Discretionary_Request__r.Total_Spent_Amount__c from Discretionary_Line_Item__c where (CreatedDate >: dt or LastModifiedDate >: dt)];
         List<Discretionary_Line_Item__c> dli = (List<Discretionary_Line_Item__c>) scope;
        for(Discretionary_Line_Item__c dli1 : dli)
        {
            if((dli1.Discretionary_Request__r.SBU__C != 'ATR') && (dli1.Discretionary_Request__r.CBT__c != 'Advanced Technology' && dli1.Discretionary_Request__r.CBT__c != 'Sales Ops Adj') && dli1.Discretionary_Request__r.Fiscal_Year__c > '2012' && (dli1.Discretionary_Request__r.Approval_status__c != 'Pending Approval' && dli1.Discretionary_Request__r.Approval_Status__c != 'Closed') && (dli1.Funding_Amount__c * .95 < dli1.Spend_Amount__c || dli1.Discretionary_Request__r.Total_Approved_Amount__c * .95 < dli1.Discretionary_Request__r.Total_Spent_Amount__c))            {
                dli1.Approval_Status__c='Pending Close';
                dlist.add(dli1);
                system.debug('*********Approval Status********'+dli1.Approval_Status__c);
            }
        } 
        update dlist;
        system.debug('dlistttt'+dlist);
    }
    global void finish(Database.BatchableContext BC){} 
    //global class scheduledBatchable implements Schedulable {
    global void execute(SchedulableContext sc)
    { 
      // Below Lines Should be there to call the batchablecontext execute method
       UpdateDLI_Overspent approvalstat = new UpdateDLI_Overspent();
       Database.executeBatch(approvalstat);
      }
      //}

}