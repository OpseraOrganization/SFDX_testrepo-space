public class CloneOpportunityProducts {

    @AuraEnabled
    public static String getCloneOpp(String oldId) {
        system.debug('oldId ' + oldId);

        // Initialize setup variables
        String objectName = 'Opportunity';  // modify as needed
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ', ';
        }

        // Manually add related object's fields that are needed.
        query += 'Account.Name '; // modify as needed

        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }

        // Add FROM statement
        query += ' FROM ' + objectName;

        // Add on a WHERE/ORDER/LIMIT statement as needed
        query += ' WHERE Id =  \''+ oldId +'\'  LIMIT 1'; // modify as needed   WHERE Id = \'test\' AND HasOpportunityLineItem = true LIMIT 1';
        system.debug(query);

        Opportunity opp = database.query(query);
        system.debug(opp);
        Opportunity newOpp = opp.clone(false, false, false, false);
        newOpp.Reason_For_Not_Sending_Survey_Picklist__c = null;
        newOpp.Campaignid= null;
        newOpp.Win_Loss_Reason_Secondary__c = null;
        newOpp.OwnerId = UserInfo.getUserId();
        //Wipe out Tact.AI related fields
        newOpp.Status__c = null;
        newOpp.Next_Step__c = null;
        newOpp.Next_Step_Date__c = null;
        newOpp.Log_Virtual_Meeting__c = null;
        newOpp.Log_Virtual_Meeting_Date__c =null;
        newOpp.Log_F2F_Meeting__c = null;
        newOpp.Log_F2F_Meeting_Date__c = null;

        //Wipe out Lead reference
        newOpp.Lead_ID__c = null;
        insert newOpp;

        /*
if (opp.HasOpportunityLineItem == true) {
objectName ='OpportunityLineITem';
String queryPrdt='Select';
String oppId =opp.Id;
Map<String, Schema.SObjectField> objectAFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

// Grab the fields from the describe method and append them to the queryString one by one.
for(String s : objectAFields.keySet()) {
queryPrdt += ' ' + s + ', ';
}
queryPrdt += 'Opportunity.Name From OpportunityLineITem Where OpportunityId =:oppId';
List<OpportunityLineItem> products =Database.query(queryPrdt);
List<OpportunityLineItem> newProdList = new List<OpportunityLineItem>();

for (OpportunityLineItem prod:products)
{
OpportunityLineItem newProd = prod.clone(false, false, false, false);
newProd.OpportunityId = newOpp.id;
newProd.TotalPrice =null;
newProdList.add(newProd);
}
insert(newProdList);
Map<String,String> lineItemIdMap = new Map<String,String>();
Integer count =0;
for(OpportunityLineItem oppLine :products)
{
lineItemIdMap.put(oppLine.Id, newProdList[count].id);
count++;
}
System.debug('@@@@lineItemIdMap'+lineItemIdMap);
List<OpportunityLineItemSchedule> sourceOppScheduleList = new List<OpportunityLineItemSchedule>();
String schduleQry ='Select';
for(String s :  Schema.getGlobalDescribe().get('OpportunityLineItemSchedule').getDescribe().fields.getMap().keySet()) {
schduleQry += ' ' + s + ', ';
}
Set<String> lineItemIdSet = new Set<String>();
lineItemIdSet =lineItemIdMap.keySet();
schduleQry +='OpportunityLineItem.Name From OpportunityLineItemSchedule Where OpportunityLineItemId In :lineItemIdSet';
sourceOppScheduleList =Database.query(schduleQry);
List<OpportunityLineItemSchedule> newOppLineItemScheduleList = new List<OpportunityLineItemSchedule>();
for(OpportunityLineItemSchedule sched : sourceOppScheduleList)
{
OpportunityLineItemSchedule newsched = sched.clone(false, false, false, false);
newsched.OpportunityLineItemId =lineItemIdMap.get(sched.OpportunityLineItemId);
newOppLineItemScheduleList.add(newsched);
}
System.debug('@@@@@newOppLineItemScheduleList'+newOppLineItemScheduleList);
insert newOppLineItemScheduleList;
} // end if
*/
        return newOpp.Id;


    }
    @AuraEnabled
    public static String deleteOpp(String newClonedId) {
        system.debug('newClonedId ' + newClonedId);
        List<Opportunity> opp =[Select id From Opportunity Where id=:newClonedId ];
        if(!opp.isEmpty())
        {
            delete opp[0];
            return 'Success';
        }

        return null;
    }

    @AuraEnabled
    public static String createChilds(String newClonedId,String oldId) {
        system.debug('newClonedId ' + newClonedId);
        system.debug('@@@@oldId'+oldId);
        if(oldId !=null && newClonedId !=null )
        {
            Opportunity opp =[Select id,HasOpportunityLineItem From Opportunity Where id=:oldId ];
            if (opp.HasOpportunityLineItem == true )
            {
                String objectName ='OpportunityLineITem';
                String queryPrdt='Select';
                String oppId =opp.Id;
                Map<String, Schema.SObjectField> objectAFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

                // Grab the fields from the describe method and append them to the queryString one by one.
                for(String s : objectAFields.keySet()) {
                    queryPrdt += ' ' + s + ', ';
                }
                queryPrdt += 'Opportunity.Name From OpportunityLineITem Where OpportunityId =:oppId';
                List<OpportunityLineItem> products =Database.query(queryPrdt);
                List<OpportunityLineItem> newProdList = new List<OpportunityLineItem>();

                for (OpportunityLineItem prod:products)
                {
                    OpportunityLineItem newProd = prod.clone(false, false, false, false);
                    newProd.OpportunityId = newClonedId;
                    newProd.TotalPrice =null;
                    newProdList.add(newProd);
                }
                insert(newProdList);
                Map<String,String> lineItemIdMap = new Map<String,String>();
                Integer count =0;
                for(OpportunityLineItem oppLine :products)
                {
                    lineItemIdMap.put(oppLine.Id, newProdList[count].id);
                    count++;
                }

                System.debug('4@@@@lineItemIdMap'+lineItemIdMap);
                List<OpportunityLineItemSchedule> sourceOppScheduleList = new List<OpportunityLineItemSchedule>();
                String schduleQry ='Select';
                for(String s :  Schema.getGlobalDescribe().get('OpportunityLineItemSchedule').getDescribe().fields.getMap().keySet()) {
                    schduleQry += ' ' + s + ', ';
                }
                Set<String> lineItemIdSet = new Set<String>();
                lineItemIdSet =lineItemIdMap.keySet();
                schduleQry +='OpportunityLineItem.Name From OpportunityLineItemSchedule Where OpportunityLineItemId In :lineItemIdSet';
                sourceOppScheduleList =Database.query(schduleQry);
                List<OpportunityLineItemSchedule> newOppLineItemScheduleList = new List<OpportunityLineItemSchedule>();
                for(OpportunityLineItemSchedule sched : sourceOppScheduleList)
                {
                    OpportunityLineItemSchedule newsched = sched.clone(false, false, false, false);
                    newsched.OpportunityLineItemId =lineItemIdMap.get(sched.OpportunityLineItemId);
                    newOppLineItemScheduleList.add(newsched);
                }
                System.debug('@@@@@newOppLineItemScheduleList'+newOppLineItemScheduleList);
                insert newOppLineItemScheduleList;
            }
        }
        return null;
    }

    @AuraEnabled
    public static List<Discretionary__c> fetchDRRecords(String oppId)
    {
        List<Discretionary__c> drlist = new List<Discretionary__c>();
        drlist =[Select id,Name ,Fiscal_Year__c,Approval_Status__c,Total_Request_Amount_rollup__c,CreatedDate From Discretionary__c Where Opportunity__c =:oppId];

        return drlist;
    }




}