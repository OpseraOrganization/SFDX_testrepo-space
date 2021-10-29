@isTest(SeeAllData=true)
private class updateOnlineOrderCSRAccessTest {
    public static testMethod void OnlineOrderCSRAccessTest(){       
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'HWell';
        con.AccountId = acc.Id;
        con.Email = 'test@test.com';
        
        insert con;
        
        Portal_Honeywell_ID__c ph = new Portal_Honeywell_ID__c();
        ph.Name = 'HWell';
        ph.Contact__c = con.Id;
        
        insert ph;
        
        Id qId = [SELECT QueueId FROM QueueSobject where Queue.Name = 'CSR Online Ordering Approval' and SObjectType = 'Case'].QueueId;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.ContactId = con.Id;
        cs.Origin = 'Email';
        cs.Type = 'WEB Portal Registration';
        cs.OwnerId = qId;
        cs.Status = 'Approved';
        cs.Resolution__c = 'Test Case';
        
        insert cs;
               
        if(qId != NULL || qId != ''){ 
            if(cs.Type =='WEB Portal Registration' && cs.OwnerId == qId){ //
                List<Portal_Honeywell_ID__c> phid = [SELECT Id, Contact__c, User_Type__c FROM Portal_Honeywell_ID__c where Contact__c =:con.Id];
                
                //for(Portal_Honeywell_ID__c current:phid){
                    if(cs.Status=='Approved'){
                        phid[0].User_Type__c='CSR'; 
                    }
                //}  
                if(phid!=null && phid.size()>0){
                    Database.update(phid); 
                }
                
            }
        }
    }
}