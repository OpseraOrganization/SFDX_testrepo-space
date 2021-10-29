@isTest(SeeAllData=true)
private class UserUpdateHelperBatchTest
{

    static testMethod void testMethod1()
    {  
         List<Opportunity> oppList= new List<Opportunity>();
         List<Opportunity_Sales_Team__c > lstTeam = new List<Opportunity_Sales_Team__c >();
         Id informUser = UserInfo.getUserId();
         set<id> userIdSet = new set<id>();
         userIdSet.add(informUser);
                
        
        Opportunity opp = [select id from Opportunity limit 1];
        
        
        Opportunity_Sales_Team__c team = new Opportunity_Sales_Team__c();
        team.Opportunity__c = opp.Id;
        team.User__c = informUser;
        insert lstTeam;
        
              Test.StartTest();
            
            UserUpdateHelperBatch userTeam = new UserUpdateHelperBatch(userIdSet);
            Database.executeBatch(userTeam);
            
            Test.StopTest();
        
     }
     
}