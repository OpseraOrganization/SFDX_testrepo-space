@isTest(SeeAllData=false)
public class Entitlementstatuschangebatch_Test{
   static testmethod void runEntitlementstatuschangebatch() {
     Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
            insert acc;
     Contract con = new Contract( Type__c='APU Selection Agreement', Status='New', StartDate=  Date.Today().addDays(-6), EndDate= Date.Today().addDays(-1),End_date_Required__c='Yes',Accountid=acc.id);
            insert con;
     Entitlement__c ent = new Entitlement__c( Contract_Number__c = con.id, Entitlement_Type__c='Aircraft Equipment', Entitlement_Start_Date__c= Date.Today().addDays(-4), End_Date__c=Date.Today().addDays(-1),Status__c='Active');
            insert ent;
    Test.StartTest();
       Entitlementstatuschangebatch EntitlementBatch1 = new Entitlementstatuschangebatch();
       database.executeBatch(EntitlementBatch1,200);
    Test.StopTest();
    }
 
   static testmethod void runEntitlementstatuschangebatch1() {
    Account acc= new Account(name = 'Test Account1',Market_name__C = 'Military');
            insert acc;
 Contract con = new Contract( Type__c='APU Selection Agreement', Status='New', StartDate=  Date.Today().addDays(-5), EndDate= Date.Today().addDays(-2),End_date_Required__c='Yes',Accountid=acc.id);
            insert con;
            
            con.status = 'Active';
            update con;
            
     Test.StartTest();
       contractstatuschangebatch contractbatch = new contractstatuschangebatch();
       database.executeBatch(contractbatch,200);
     Test.StopTest();
    }
  }