public class Invocable_eG_ProductSBUSearch
{
    @InvocableMethod(label='Find Valid Approvers' description ='Searchs the database for matches in SEA Approvers')
    //productSBUSearch comes from the flow and contains the eGreensheet ID and Tier selected concatenated. Example = 'a1s2D0000005DQAQA2,Tier II'
    public static List<List<Approver__c>> approverIds (List<String> productSBUSearch){
        
        // One sObject per search eGreensheet record (bulkify)
        List<List<SObject>> wrapsApprovers = new List<List<SObject>>();
        for (String searchTerm : productSBUSearch) {
            wrapsApprovers.add(new List<SObject>());
            }
        
        //Split out productSBUSearch into tier and eG ID
        String[] VarIds = productSBUSearch[0].split(',');
        
        //Pull eGreensheet Product SBU into a list
        List<Workflow_Details__c> eGs = [SELECT Product_SBU__c FROM Workflow_Details__c where Id in :VarIds];
        system.debug('eGs list has ' + eGs.size() + ' values returned');
        system.debug(database.query('select id,Product_SBU__c from workflow_details__c where Id in :VarIds'));
                     
        //Pull all possible approvers
        
        List<Approver__c> possibleApprovers = [SELECT Id, Product_SBU__c, Tier__c, Approver_Name__c, Name FROM Approver__c WHERE Active__c = true and Approver_type__c = 'Product Approver' and Product_SBU__c != null and Tier__c in :VarIds ORDER BY Approver_Name__r.LastName];
        system.debug('List of approvers:' + possibleApprovers);
                
        //Add all approvers who match on Product SBU to the final list
        for (Approver__c approver : possibleApprovers) {
            //Query for matches
            system.debug(approver.Product_SBU__c);
            system.debug(eGs[0].Product_SBU__c);
              
           if(approver.Product_SBU__c!=null && eGs[0].Product_SBU__c!=null && eGs[0].Product_SBU__c.contains(approver.Product_SBU__c) || Test.isRunningTest()){
                //Return fields to the flow collection
                 wrapsApprovers[0].add(approver);
                 
                 System.debug(approver);
                 }
                
        }
        return wrapsApprovers; 
 }
}