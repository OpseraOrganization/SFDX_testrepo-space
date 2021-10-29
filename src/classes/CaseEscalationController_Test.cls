// // This is the test class for CaseEscalationController class
@isTest
Public class CaseEscalationController_Test {
    static testMethod void testratings() {
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        list<Contact> conlst = new list<Contact>();
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='testing123';
        con.Primary_Email_Address__c='testing@testing123.com';
        con.email = 'testing@testing123.com';
        con.Phone_1__c= '1234567678';
        con.Employee_Number__c = 'H411235';
        conlst.add(con);
        insert conlst;
        case cse = new case();
        cse.status = 'On Hold';
        cse.Sub_Status__c = 'Contract Hold';
        cse.Reason_for_hold__c = 'Discount Validation';
        cse.VN_Name__c = con.id;
        cse.Origin = 'Phone';
        cse.Classification__c = 'BPO';
        cse.Case_Complexity__c = 'css';
        Test.startTest();
        insert cse;
        List<CaseEscalationController.FileInfo> fileInfoLst = new List<CaseEscalationController.FileInfo>();
         String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        CaseEscalationController.FileInfo fileInfo = new CaseEscalationController.FileInfo();
        fileInfo.Title='Testing here';
        fileInfo.VersionData=myBlob;
        fileInfoLst.add(fileInfo);
        List<Object> lstObj = new List<Object>();
        lstObj = (List<Object>) fileInfoLst;
        Test.stopTest();
        CaseEscalationController.returnvalue(cse.id,cse.status,cse.Sub_Status__c, lstObj);
        
    }
}