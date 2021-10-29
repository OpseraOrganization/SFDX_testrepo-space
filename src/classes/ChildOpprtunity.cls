public class ChildOpprtunity {
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
        query += 'Account.Name '; // modify as needed    'Account.Name';
        
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
       newOpp.Parent_Opportunity__c =oldId;       
       newOpp.Is_Follow_On_Opportunity__c=true;  
       newopp.Win_Only_Opportunity__c=true;
       insert newOpp;    
       
    // Savepoint sp = Database.setSavepoint();
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
}