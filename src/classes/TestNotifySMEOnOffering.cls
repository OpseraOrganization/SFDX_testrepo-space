@isTest
private class TestNotifySMEOnOffering{
    static testMethod void nofitySMEOffering(){
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='Test RMU Value');
        insert rmuvalue;
        Offering_File__c off = new Offering_File__c();
        off.Offering_File__c = rmuvalue.id;
        off.File_Type__c = 'ATR';
        insert off;
        //Offering_File__c  off = [select id,File_Path__c,Offering_File__c  from Offering_File__c where File_Type__c='ATR' limit 1];
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;
        cv.Origin = 'C';          
        insert cv;       

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id AND IsLatest=true];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=off.id;
        contentlink.ShareType= 'V';
        contentlink.LinkedEntityId = off.Id; 
        contentlink.ContentDocumentId=testContent.ContentDocumentId;
        insert contentlink;
            
        off.File_Path__c = testContent.ContentDocumentId;
        update off;
        
        rmuvalue.Briefcase_Path__c = testContent.ContentDocumentId;
        update rmuvalue;
        
        
      
        
        ContentDistribution cd = new ContentDistribution(); 
        cv = [SELECT Id, Title FROM ContentVersion WHERE Id =:cv.id  AND IsLatest = true]; 
        cd.ContentVersionId = cv.Id;
        cd.name = cv.Title;
        cd.PreferencesAllowOriginalDownload = false;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        insert cd;
        NotifySMEOnOffering nso = new NotifySMEOnOffering();
        nso.getOfferingID();
        nso.setOfferingID(rmuvalue.id);
        
    }
}