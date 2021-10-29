@isTest
private class Test_DefaultValue {
 public static testMethod void testocc(){
     
     Test.startTest(); 
     Service_Request__c sr=new Service_Request__c();
     sr.recordtypeid =label.Srrequestfeedbackrecord;
     sr.Near_Term_Alternate_Fix__c=null;
     insert sr;
     Test.stopTest();
     }
     }