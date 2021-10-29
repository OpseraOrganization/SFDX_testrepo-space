@isTest
private class Updatetimeinreopen {
    public static testMethod void testocc(){
        case obj=new Case();
        obj.recordtypeid =label.QuotesRecordID;
        obj.status='Open';
        obj.Origin='Phone';
        //obj.Type__c='Other';
        obj.Classification__c='R&O Quote';
        obj.HON_Commit_Date__c=system.now();
        // obj.Contact_Name__c=u.id;
        obj.Export_Compliance_Content_ITAR_EAR__c='No';
        obj.Government_Compliance_SM_M_Content__c='No';
        insert obj;
        
        case obj1=new Case();
        obj1.recordtypeid =label.NavDB_Prod_RecordId;
        obj1.status='Closed';
        obj1.Origin='Phone';
        obj1.Classification__c='R&O Quote';
        obj1.HON_Commit_Date__c=system.now();
        obj1.Export_Compliance_Content_ITAR_EAR__c='No';
        obj1.Government_Compliance_SM_M_Content__c='No';
        insert obj1;
        
        Test.startTest();       
        obj.status='Re-Open';
        obj.Reopen_Status_Started__c=system.now();
        update obj;
        obj.status='Done';
        obj.Reopen_Status_Ended__c=system.now();
        Update obj;
        
        obj1.status='Re-Open';
        obj1.Reopen_Status_Started__c=system.now();
        update obj1;
        obj1.status='Closed';
        obj1.Reopen_Status_Ended__c=system.now();
        Update obj1;
        Test.stopTest(); 
    }
}