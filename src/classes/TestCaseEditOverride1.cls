@isTest (SeeAllData=true)
public class TestCaseEditOverride1 {
 
  static testMethod void testSave() {
    Case a = [select id,RecordTypeId from case where recordtype.name = 'A350 FT/EIS Tech Issue' and CreatedDate > 2013-04-08T10:02:21.000+0000 limit 1];
    
    //a.Name = 'Account Name';
    //insert a;
 
    PageReference ref = new PageReference('/apex/CaseEditOverride1?aId=' + a.Id);
    Test.setCurrentPage(ref);
 
    Test.startTest();
    //This will run the constructor of the controller
    ApexPages.StandardController sc = new ApexPages.StandardController(a);
    CaseEditOverride1 myController = new CaseEditOverride1(sc);
    //Now we can test our action function on the controller
    PageReference ref2 = myController.redirectpage1();
    
    Test.stopTest();
 
    //system.assertNotEquals(ref2, null);
  }
 
  //We should add another test method to test the CancelAction function too
 static testMethod void testSave1() {
    Case a = [select id,RecordTypeId from case where recordtype.name = 'A350 FT/EIS Tech Issue' and CreatedDate > 2013-04-08T10:02:21.000+0000 limit 1];
    //User u = [select id from user where Profile.name ='GTO FSE/PSE/CSPM/FT/EIS(RO) (Non US)' and isactive = true limit 1];
     User u = [select id from user where Profile.name ='GTO FSE/PSE/CSPM/FT/EIS(RO) (Non US)' and isactive = true limit 1];
    //a.Name = 'Account Name';
    //insert a;
 
    PageReference ref = new PageReference('/apex/CaseEditOverride1?aId=' + a.Id);
    Test.setCurrentPage(ref);
 System.runAs(u) {
    Test.startTest();
    //This will run the constructor of the controller
    ApexPages.StandardController sc = new ApexPages.StandardController(a);
    CaseEditOverride1 myController = new CaseEditOverride1(sc);
    //Now we can test our action function on the controller
    PageReference ref2 = myController.redirectpage1();
    
    Test.stopTest();
 }
    //system.assertNotEquals(ref2, null);
  }
}