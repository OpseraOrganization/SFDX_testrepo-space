@isTest
public With Sharing Class SalesCompetencyRatingController_Test 
{
    static Testmethod Void SCR_test1()
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
         
         Sales_Competency_Rating__c SCR1 = new Sales_Competency_Rating__c();
         
         Sales_Competency_Rating__c SCR = new Sales_Competency_Rating__c();
         //Sales_Competency_Rating__c SCR1 = new Sales_Competency_Rating__c();
         SCR.Sales_Competency_Assessment__c = sc.id;
         SCR.Self_Assessment_Comment__c = 'test';
         SCR.Competency__c = 'Coaches & Develops Sales Talent';
         SCR.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
         SCR.Suggested_Development_Action_New__c = '';
         SCR.Employee_Proficiency_Rating__c = 'Advanced';
         insert SCR;
         
         //SCR1 = [select id,competency__c from Sales_Competency_Rating__c where id = 'a4yV00000008US3IAM' and Sales_Competency_Assessment__c =:sc.id];
         //Development_Resource__c DR1 = new Development_Resource__c();
         
         Development_Resource__c DR1 = new Development_Resource__c();
         Development_Resource__c DR = new Development_Resource__c();
         DR.Development_Resource_Name__c = 'Develop a MOS related to team meetings to ensure clear agenda, objectives, roles, RAIL updates, etc';
         DR.Competency__c = 'Coaches & Develops Sales Talent';
         DR.Suggested_Development_Action__c = 'Conducts Effective Cadence Meetings';
         DR.Format__c = 'On Job Development';
         //List<Development_Resource__c> DR1 = New List<Development_Resource__c>();
         //DR1.Add(DR);
         Insert DR;
         
        //DR1 = [ select Id,Development_Resource_Name__c,Competency__c,Suggested_Development_Action__c,Format__c from Development_Resource__c where Competency__c  =: SCR1.competency__c];
         
         SalesCompetencyRatingController SCRC = new SalesCompetencyRatingController(new ApexPages.StandardController(sc));
         SalesCompetencyRatingController.Sscr page1 = new SalesCompetencyRatingController.Sscr(Scr);
         SalesCompetencyRatingController.CCWRowItem page = new SalesCompetencyRatingController.CCWRowItem(DR);
        // PageReference tpageRef = Page.ManagerAssessment;
         //Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', sc.id);
         ApexPages.currentPage().getParameters().put('jd', scr.id);
         SCRC.getsalesCompRatings();
         SCRC.doSelectItem();
         SCRC.Add();
         SCRC.showPopup();
         SCRC.getContacts();
         SCRC.saveclosemgr();
         SCRC.saveclosemgr1();
         SCRC.goback();
         SCRC.getUsernameExists();
         SCRC.closePopup();
         SCRC.getSelectedCount();
         //SCRC.showPopup();
         //SCRC.getContacts();
         SCRC.savecloseemp();
         SCRC.savescr();
         SCRC.doSelectItem();
         SCRC.doDeselectItem();
         
         //CCWRowItem CCw = new CCWRowItem();
         
         //SCRC.getContacts();
         
         test.StopTest();
         
      }
      
}