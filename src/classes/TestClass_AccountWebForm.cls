@isTest
public class TestClass_AccountWebForm{ 
    static testmethod void AccWebformtest(){

        Case tstcase = new Case();
        
        ApexPages.StandardController con = new ApexPages.StandardController(tstcase);
        AccountWebForm test = new AccountWebForm(con);
        test.filebody = Blob.valueOf('Test Blob');
        test.filename = 'test';
        test.getlistofTyperequest();
        test.getlistofTypechange();
        test.getlistofDobuss();
        test.getCaseCreate();
        test.CaseCreate.Type_of_Request__c = 'Account Change';
        //test.CaseCreate.No_FCR_Reason__c = 'Not Trained';For Ticket INC000009687923
        test.UploadFile();
        test.getmyAttach();
        test.getaccounts1();
        test.Refresh();
        test.Email='we@c.com';
        test.ShowDetails();
        test.CRMID=null;
        test.ShowDetails();
        test.caseSave();
        
    }
}