@isTest
private class OVOC_removePreDraftRecordsTest {
 
    static testMethod void myUnitTest() {
        
        Test.startTest();
        
        VOC_OVOC_Record_Number__c obj1= new VOC_OVOC_Record_Number__c();
        obj1.Name='Reference record';
        obj1.VOC__c = '111';
        obj1.OVOC__c = '222';
        insert obj1;
        
        List<Voice_of_Customer__c> listVOCCust = new List<Voice_of_Customer__c>();
        
        Voice_of_Customer__c voc = new Voice_of_Customer__c();
        voc.VOC_Title__c = 'Test title';
        voc.Pre_Draft__c = true;
        listVOCCust.add(voc);
        
        
        Voice_of_Customer__c voc2 = new Voice_of_Customer__c();
        voc2.VOC_Title__c = 'Test title';
        voc2.Pre_Draft__c = true;
        voc2.status__c = 'Draft'; 
        listVOCCust.add(voc2);
        
        Voice_of_Customer__c voc3 = new Voice_of_Customer__c();
        voc3.VOC_Title__c = 'Test title';
        voc3.Pre_Draft__c = true;
        voc3.status__c = 'Submitted'; 
        listVOCCust.add(voc3);
        
        
        Voice_of_Customer__c voc4 = new Voice_of_Customer__c();
        voc4.VOC_Title__c = 'Test title';
        
        
        listVOCCust.add(voc4);
        
        set<id> setVOC = new set<id>();
        Database.SaveResult[] srList = Database.insert(listVOCCust);
        for(Database.SaveResult sr: srList){
            if (sr.isSuccess()) {
                
                setVOC.add(sr.getId());
            }
        }
        system.assertEquals(setVOC.size(), 4);
        
        //OVOC_removePreDraftRecords ovocPreDraftBatch = new OVOC_removePreDraftRecords();
        //database.executeBatch(ovocPreDraftBatch,200);
        //Test.stopTest();
        //List<Voice_of_Customer__c> listVOC = [select id from Voice_of_Customer__c where id in:setVOC];
        //system.assertEquals(3,listVOC.size());
        OVOC_removePreDraftRecords batch2 = new OVOC_removePreDraftRecords ();
        batch2.start( (Database.BatchableContext) null );
        batch2.execute( (Database.BatchableContext) null, listVOCCust);
        batch2.finish( (Database.BatchableContext) null );
        batch2.execute((SchedulableContext) null );
        Test.stopTest();
    }
}