/**
 * Created by Satya Mohanty on 9/25/2020.
 * OWNED BY THE CRM SALES TEAM.
 */
global class BatchBGAOpptyUpdate implements Database.Batchable<sObject>,Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,LastModifiedDate, PWin__c, CloseDate, Probability__c FROM Opportunity WHERE LastModifiedDate != LAST_N_DAYS:30 AND (Recordtype.Name = \'BGA Operator\' OR Recordtype.Name  = \'BGA AM\' Or Recordtype.Name = \'BGA AM Short Cycle\') AND IsClosed = false AND CloseDate = NEXT_90_DAYS AND owner.cbt__c != \'Advanced Technology\' AND SC1__C != \'Adv Tech\' And (StageName =\'Prospecting\' OR StageName =\'Cultivate\') AND pwin__c IN (\'0.20\',\'.20\',\'.10\',\'0.10\',\'.1\',\'.05\',\'.010\',\'.01\',\'0 \')';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<opportunity> aOppList){
        try{
            opportunity oppObj;
            List<Opportunity> updateList = new List<Opportunity>();
            for(opportunity opp : aOppList){
                oppObj = new opportunity();oppObj.Id = opp.Id;oppObj.CloseDate = opp.CloseDate.addDays(30);updateList.add(oppObj);
            }
            if(updateList.size() > 0){
                update updateList;
            }
        }catch(Exception e){
            System.debug('Error : '+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){

    }

    global void execute(SchedulableContext sc){
        BatchBGAOpptyUpdate bgaOpptyUpdate = new BatchBGAOpptyUpdate();
        Database.executeBatch(bgaOpptyUpdate,2);
    }
}