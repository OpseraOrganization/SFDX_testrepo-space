@istest(seealldata=true)
 private class AssignVOC_OVOCTest{  
   
  static testMethod void myUnitTest5() {
     Test.starttest();
        VOC_OVOC_Record_Number__c vocrn3= new VOC_OVOC_Record_Number__c();
           vocrn3.Name='Reference record';
           vocrn3.VOC__c = '99999';
           vocrn3.OVOC__c = '2222';
        // insert vocrn3;
        // to insert Voice_of_Customer__c
        Voice_of_Customer__c voc3= new Voice_of_Customer__c();
        //obj.RecordTypeId='01Ia0000001u98V';
         voc3.Status__c = 'Submitted';
         voc3.Product_Family__c = 'Crew Interface';
         insert voc3;
    
    list<VOC_Group_Queue_Map__c> lstvocg= VOC_Group_Queue_Map__c.getall().values();
    List<VOC_Product_Family_Chatter__c> productlist = VOC_Product_Family_Chatter__c.getall().values();
       voc3.Sensitive__c = true;
       voc3.Status__c = 'Draft';
       voc3.ownerid = lstvocg[0].Queue_Id__c;
       update voc3;
       voc3.Status__c = 'Submitted';
       voc3.Product_Family__c = 'Crew Interface';
       update voc3;
    
     Test.stopTest();
   }
   
   static testMethod void myUnitTest6() {
     Test.starttest();
        VOC_OVOC_Record_Number__c vocrn4= new VOC_OVOC_Record_Number__c();
           vocrn4.Name='Reference record';
           vocrn4.VOC__c = '9';
           vocrn4.OVOC__c = '22';
        // insert vocrn3;
        // to insert Voice_of_Customer__c
        Voice_of_Customer__c voc4= new Voice_of_Customer__c();
        //obj.RecordTypeId='01Ia0000001u98V';
         voc4.Status__c = 'Submitted';
         voc4.RecordTypeId = '012a0000001ZPAK';
         voc4.Sensitive__c = true;
         voc4.OwnerId = '00Ga0000002tVv3';
         insert voc4;
    
     Test.stopTest();
   }
   
 }