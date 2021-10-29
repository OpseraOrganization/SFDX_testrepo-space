@isTest(SeeAllData=true)
private class TestClass_AddServiceRequest{
 static testMethod void testCase(){
    String msg='manoj';
        AddExistingSR aer=new AddExistingSR();
        Service_Request__c sr=new Service_Request__c();
        aer.Value ='m%%';
        aer.letsGo();
        aer.next();
        aer.previous();
        aer.last();
        aer.first();
        aer.addInfo(msg);
        aer.addError(msg);
        aer=new AddExistingSR();
        Feedback__c fb=new Feedback__c();
        aer.srname=fb.name;
        aer.setParentRecord();
     }
    
 }