@isTest
public With Sharing Class DevelopmentactionEditableGrid_Test 
{

    static Testmethod Void DAEG_test1()
    {
        
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
      
         
         test.StartTest();
         Development_Action__c DA = new Development_Action__c();
         DA.Sales_Competency_Assessment__c = sc.id;
         DA.Action_Accepted__c = 'yes';
         insert DA;
         
         Test.setCurrentPageReference(new PageReference('/'+DA.Id));
         DevelopmentactionEditableGrid DAEG = new DevelopmentactionEditableGrid(new ApexPages.StandardController(sc));
         DAEG.saveId = DA.id;
         DAEG.strSCId = DA.id;
         DAEG.getSalesCompetencies();
         DAEG.saveRecord();
         DAEG.cancel();
         
         test.StopTest();
         
      }
      
}