@isTest(seeAllData = true)
Public class DS_Test_ApexClass_sendIBOTemail{
    static testMethod void ApexClass_sendIBOTemail(){
    user uu = [select id,email from user where email!= NULL limit 1];
    User__c u = new User__c();
    u.name = 'test';
    u.email__c = uu.email; 
    insert u;
    
    ApexPages.StandardController Controller;
    sendIBOTemail obj = new sendIBOTemail(Controller);
    obj.sendmail();
    }
   }