@isTest
public With Sharing Class SalesCompetencyRatingsGridSort_Test 
{
    static Testmethod Void SCRGS_test1()
    {
         test.StartTest();
         
         
         String userAgent='iPad';
         
         //Profile p = [SELECT Id,name FROM Profile WHERE Name='Salesforce'];
         User u = [ select Id from User where id =: UserInfo.getUserId() ];
         
         Sales_Competency__c sc = new Sales_Competency__c();
         sc.user__c = u.id;
         sc.Job_Title__c = 'sales';
         sc.Status__c = 'Self Assessment (Employee)';
         sc.Role_Category__c = 'A';
         sc.Job_Category__c = 'Sales';
         sc.Name = 'test';
         sc.Level_1_Manager__c = u.id;
         insert sc;
         system.debug('-------------------sc---------------' +sc);
         
         Sales_Competency_Rating__c SCR = new Sales_Competency_Rating__c();
         SCR.Sales_Competency_Assessment__c = sc.id;
         SCR.Self_Assessment_Comment__c = 'test';
         SCR.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
         SCR.Employee_Proficiency_Rating__c = 'Experienced';
         insert SCR;
         
         SalesCompetencyRatingsGridSort SCRGS = new SalesCompetencyRatingsGridSort(new ApexPages.StandardController(sc));
         SCRGS.getSalesCompetencies();
         
         test.StopTest();
         }
         
     }