/***********************************************************************************************
Name:                   CloneOpportunity
Author:                 Satya Mohanty
Created Date:            9/6/2018
Description:    used in clone without product lightning component
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
public class CloneOpportunity{

    @AuraEnabled
    public static String getCloneOpp(String oldId) {
        System.debug('oldId ' + oldId);

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
        if (query.substring(query.length()-1,query.length()) == ','){
            query = query.substring(0,query.length()-1);
        }

        // Add FROM statement
        query += ' FROM ' + objectName;

        // Add on a WHERE/ORDER/LIMIT statement as needed
        query += ' WHERE Id =  \''+ oldId +'\'  LIMIT 1'; // modify as needed   WHERE Id = \'test\' AND HasOpportunityLineItem = true LIMIT 1';
        System.debug(query);

        Opportunity opp = Database.query(query);
        System.debug(opp);
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

        return newOpp.Id;
    }

    @AuraEnabled
    public static String createChilds(String newClonedId,String oldId) {
        if(oldId !=null && newClonedId !=null )
        {
            Opportunity opp =[SELECT Id,
                    HasOpportunityLineItem
            FROM Opportunity
            WHERE Id=:oldId ];
            /*if (opp.HasOpportunityLineItem == true || opp.HasOpportunityLineItem == false)
              {
                 insert opp;
              } */
            //         insert opp;

        }
        return null;
    }
    @AuraEnabled
    public static String deleteOpp(String newClonedId) {
        System.debug('newClonedId ' + newClonedId);
        List<Opportunity> opp =[SELECT Id
        FROM Opportunity
        WHERE Id=:newClonedId ];
        if(!opp.isEmpty())
        {
            delete opp[0];
            return 'Success';
        }

        return null;
    }

    @AuraEnabled
    public static List<Discretionary__c> fetchDRRecords(String oppId)
    {
        List<Discretionary__c> drlist = new List<Discretionary__c>();
        drlist =[SELECT Id,
                Name ,
                Fiscal_Year__c,
                Approval_Status__c,
                Total_Request_Amount_rollup__c,
                CreatedDate
        FROM Discretionary__c
        WHERE Opportunity__c =:oppId];

        return drlist;
    }
}