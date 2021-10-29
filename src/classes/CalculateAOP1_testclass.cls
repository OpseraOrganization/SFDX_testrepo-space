@isTest
public class CalculateAOP1_testclass{ 
static testmethod void CalculateAOP1test(){

    //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
    Account acc = new Account();
        acc.Name = 'Testwebacc';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;
  Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(FirstName = 'Tr', LastName = 'Test User',Username = 'trstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
                'tuse' ,CommunityNickname= 'tusehoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
            AOP_For_Sales_Manger__c tstAOPForSalesMngr= new AOP_For_Sales_Manger__c(AOP_Year__c = '2011',Sales_Manager__c=testUser.Id);
            insert tstAOPForSalesMngr;
            
    Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting';   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.ForecastCategoryName = 'Pipeline';
        opp.Ownerid = tstAOPForSalesMngr.Sales_Manager__c;
        opp.recordtypeid='01230000000bN7l';
        opp.dealer_account__c='0013000000bFxtr';
        insert opp;
            
ApexPages.StandardController testcls= new ApexPages.StandardController(tstAOPForSalesMngr);
calculateAOP1 test = new calculateAOP1(testcls);
   test.calculate();
}

}