/*
*File Name :updateOnlineOrderCSRAccess
*Description :Purpose of this Trigger is updating CSR Access
*Company : Honeywell
*/
trigger updateOnlineOrderCSRAccess on Case (after update){
      /*commenting inactive trigger code to improve code coverage-----
        List<Case> lstCases=Trigger.new;
        DateTime currDate = System.Now();
        Id qId = [SELECT QueueId FROM QueueSobject where Queue.Name = 'CSR Online Ordering Approval' and SObjectType = 'Case'].QueueId;
        if(qId != NULL || qId != ''){ 
            if(lstCases.get(0).Type =='WEB Portal Registration' && lstCases.get(0).OwnerId == qId){ //
                List<Portal_Honeywell_ID__c> phid = [SELECT Id, Contact__c, User_Type__c FROM Portal_Honeywell_ID__c where Contact__c =:lstCases.get(0).ContactId];
                
                for(Portal_Honeywell_ID__c current:phid){
                    if(lstCases.get(0).Status=='Approved'){
                        current.User_Type__c='CSR'; 
                    }
                }  
                if(phid!=null && phid.size()>0){
                    Database.update(phid); 
                }
                
            }
        }*/
}