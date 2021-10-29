@isTest
private class TestFetchOfferingsSBFiles {
    static testMethod void fetchOfferingsSBFiles(){
      final string getOfferID = 'a2e2D000000CjkW';
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='Test RMU Value');
        insert rmuvalue;
        
        Offering_File__c off = new Offering_File__c();
        off.Offering_File__c = rmuvalue.id;
        off.File_Type__c = 'ATR';
        insert off;
                
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
        
        //RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='Test RMU Value');
        //RMU_VALUE__c OfferVal= new RMU_VALUE__c(name='Weather Radar',Id='a2e2D000000CjkW');
        
         List<String> s = new List<String>();
         s.add(rmuvalue.id);
        FetchOfferingsSBFiles.processRequest(s);
        //System.assertEquals('a2e2D000000CjkW', getOfferID);
        
        //FetchOfferingsSBFiles sb = new FetchOfferingsSBFiles ();
       // sb.getOfferingID();
       // sb.setOfferingID(rmuvalue.id);
              
        
        RMU_VALUE__c offering =[select Id, Bulletins__c, Briefcase_Path__c from RMU_VALUE__c where id=:s ];
        offering.Bulletins__c='Test Sales Bulletins';
        update offering;
        
        
    }
}