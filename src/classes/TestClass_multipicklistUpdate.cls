@isTest(seealldata=true)
private class TestClass_multipicklistUpdate{
    static testMethod void myUnitTest() {
        user u = [select id,contactid from User where id='0051300000B4LHAAA3' and ContactId!=null limit 1];
        Voice_of_Customer__c  voc = new Voice_of_Customer__c();
        voc.Product_Family__c = '[Others]';
        voc.Disposition__c = 'New';
        voc.Recordtypeid = label.VOC_RecType_Id ;
        voc.Status__c = 'Submitted';
        voc.VOC__c = '';
        voc.Sensitive__c = true;
        voc.Ownerid = '00Ga0000002tVv3';
        try{
        insert voc;
        }catch(DMLException e){}
        
        Voice_of_Customer__c  voc1 = new Voice_of_Customer__c();
        voc1.Product_Family__c = '[Others]';
        voc1.Disposition__c = 'New';
        voc1.Recordtypeid = label.OVOC_RecType_Id ;
        voc1.Status__c = 'Submitted';
        voc1.Sensitive__c = true;
        voc1.VOC__c = '';
        insert voc1;
        
        VOC_Group_Queue_Map__c vc = new VOC_Group_Queue_Map__c();
        vc.groupid__c = '0F9a0000000PSvg';
        vc.Name = 'Test';
        vc.Queue_Id__c = '00Ga0000002tVv3';
        insert vc;
        
        VOC_Product_Family_Chatter__c vp = new VOC_Product_Family_Chatter__c();
        vp.Name = '[Others]';
        vp.Chatter_Group_ID__c = '0F9a0000000PSvg';
        insert vp;
        
        OVOCLoginClass log = new OVOCLoginClass();
        
        VOC_ExportToExcel_controller ex = new VOC_ExportToExcel_controller();
    }
}