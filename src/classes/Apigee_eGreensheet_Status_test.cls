@isTest
public class Apigee_eGreensheet_Status_test {
static testMethod void TestMethod1(){
    Account acc = TestDataFactory.createAccount();
    update acc;
    
    Opportunity opp = TestDataFactory.CreateOpportunity();
    opp.StageName = 'Propose';
    update opp;
    
    Quote__c q= new Quote__c();
        q.Name='test';
        q.Quote_Number__c='test';
        q.Revision__c='test';
        q.Status__c='Rejected';
        q.Opportunity__c=opp.id;
        insert q;
    
    Workflow_details__c wd= new Workflow_details__c();
    wd.Wokflow_Name__c='test_eG';
    wd.Quote__c=q.id;
    wd.Customer_Name__c=acc.id;
    wd.Terms_and_Conditions__c='standard';
    wd.Front_End_Loss__c=4569;
    wd.Front_End_Loss_Max_Year__c=1234;
    wd.Exposed_Cost__c=1234;
    wd.Exposed_Cost_Max_Year_K__c=4561;
    wd.Documentum__c='www.test.com';
    wd.Sales_K__c=8523;
    wd.X5_Year_Revenue_K__c=9658;
    wd.Approval_Level_in_Progress__c='Tier III';
    wd.Status__c='In progress';
    wd.Opportunity_Description__c=opp.id;
    insert wd;
    wd.Status__c='Approved';
    update wd;
    
   /* List<Apigee_eGreensheet_Status.ApigeeParameters> var = new List<Apigee_eGreensheet_Status.ApigeeParameters>();
    Apigee_eGreensheet_Status.ApigeeParameters param = new Apigee_eGreensheet_Status.ApigeeParameters();
    param.status= q.Status__c;
    param.quote_number=q.Quote_Number__c;
    param.revision=q.Revision__c;
    var.add(param); */
   Test.startTest();
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator20());
     // Apigee_eGreensheet_Status.ApigeeServiceMethodInvoke(var);
      Apigee_eGreensheet_Status.ApigeeServicemethod('Approved',q.id);
   Test.stopTest();
   
        
}
}