@isTest (seealldata = true)
                    
public class CaseListViewReportCtlrTests {

    public static testMethod void testMyController() {
        PageReference pageRef = Page.CaseListViewReport;
      
  CaseListViewReportCtlr controller1 = new CaseListViewReportCtlr();

       Test.setCurrentPage(pageRef);
       Map<string, String> CaseLists1 =controller1.CaseLists;
        controller1.Download();
    }
}