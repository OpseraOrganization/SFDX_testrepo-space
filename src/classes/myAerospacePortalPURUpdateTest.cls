@isTest()
private class myAerospacePortalPURUpdateTest{

    static testMethod void myUnitTest() 
    {
     
     Test.startTest();
     User createdUser=[select id,name from User where Name ='API User MyAerospace Portal'];
     System.runAs(createdUser){
     Portal_User_Registration__c PUR=new Portal_User_Registration__c();
     PUR.Contact_Creation_in_SFDC__c='';
     PUR.Honeywell_ID__c='testtest123';
     insert PUR;
    
     Portal_Honeywell_ID__c HWID=new Portal_Honeywell_ID__c();
     HWID.Primary_Honeywell_ID__c=true;
     HWID.Name='testtest123';
     System.debug('Shiyam!!'+HWID.CreatedBy.Name);
     insert HWID;
         
      HWID = [Select Id, Primary_Honeywell_ID__c, CreatedBy.Name from Portal_Honeywell_ID__c WHERE Id = :HWID.Id];
      System.debug('!!!!!!HWID '+HWID.Primary_Honeywell_ID__c);  
      System.debug('!!!!!!HWID '+HWID.CreatedBy.Name);   
      }   
      Test.stopTest();
    }
    
}