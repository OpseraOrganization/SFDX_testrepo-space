global class UpdateCaseList{
     @future
     public static void updateCase(Set<Id> idSet)
     {
         List<Case> caseList=[select OwnerId,subject,IsAttachment__c from Case where id in :idSet];
         if(caseList!=null && caseList.size()>0){
            for(Case c:caseList){
               c.IsAttachment__c=true;
            }
            System.debug('in future caseList == '+caseList);
            update caseList; 
            List<Case> caseList1=[select OwnerId,subject,IsAttachment__c from Case where id in :idSet];  
            System.debug('in future caseList1 == '+caseList1);                   
        }
                             
    
     }
}