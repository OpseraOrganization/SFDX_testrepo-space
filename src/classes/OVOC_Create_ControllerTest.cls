/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @isTest
 private class OVOC_Create_ControllerTest {
 
 static testMethod void myUnitTest() {
   Test.startTest();
   
     VOC_OVOC_Record_Number__c obj1= new VOC_OVOC_Record_Number__c();
    obj1.Name='Reference record';
    obj1.VOC__c = '111';
    obj1.OVOC__c = '222';
    insert obj1;
      // to insert Voice_of_Customer__c
    Voice_of_Customer__c obj = new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    obj.Status__c='Draft';
    insert obj;

   PageReference pageRef = page.OVOC_Create;
     pageRef.getParameters().put('index','3');  
     pageRef.getParameters().put('id',obj.Id);  
     Test.setCurrentPage(pageRef);
     //Test.setCurrentPageReference(new PageReference('Page.OVOC_Create')); 
     //System.currentPageReference().getParameters().put('index', '2');
     
     
     
     
     OVOC_Create_Controller ovocc = new OVOC_Create_Controller();
     
     ovocc.getItems();
     ovocc.AddRow();
     ovocc.getmyfile();
     ovocc.removeNewObject();
     OVOC_Create_Controller.Save_Voc('title','topic','VOC');
     OVOC_Create_Controller.Save_Voc('title','topic','OVOC');
     OVOC_Create_Controller.searchPlatforms('searchTerm');
     OVOC_Create_Controller.getPlatform('searchTerm');
     OVOC_Create_Controller.searchVOCAccounts('searchTerm');
     OVOC_Create_Controller.getVOCAccounts('searchTerm');
     OVOC_Create_Controller.searchHoneywellLead('searchTerm');
     OVOC_Create_Controller.searchHoneywellLeadBasedName('searchTerm');
     OVOC_Create_Controller.getVOCPurpose();
     OVOC_Create_Controller.getProductFamily();
     OVOC_Create_Controller.getSecurityGroup();
     OVOC_Create_Controller.getchattergroup();
     OVOC_Create_Controller.getVOCCollection();
     
    Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=obj.id;
        insert attach;
            
            
    //OVOC_Create_Controller.uploadAttachment('attachmentBody','attachmentName',string.valueOf(obj.Id),string.valueof(attach.id));
    // OVOC_Create_Controller.uploadAttachment('attachmentBody','attachmentName',string.valueOf(obj.Id),'');
    // OVOC_Create_Controller.uploadAttachment('null','attachmentName',string.valueOf(obj.Id),string.valueof(attach.id));
    VOC_Customer_Name__c voccn = new VOC_Customer_Name__c();
    
    // voccn.Name='voccustname';
     voccn.Company_Name__c = 'companyname';
     voccn.Customer_Name__c = 'customername';
     voccn.Customer_s_Title_Role__c = 'customerrole';
     voccn.Primary_Customer_s_Email__c = 'primary@mail.com';
     
     insert voccn;
     
       VOC_Customer_Name__c voccn1 = new VOC_Customer_Name__c();
    
    // voccn1.Name='voccustname';
     voccn1.Company_Name__c = 'companyname';
     voccn1.Customer_Name__c = 'customername';
     voccn1.Customer_s_Title_Role__c = 'customerrole';
     voccn1.Primary_Customer_s_Email__c = '';
     
     insert voccn1;
     
     contact con = new contact();
     con.Email = 'primary@mail.com';
     try{
     insert con;
     }
     catch(Exception e){}
     
     
     
     list<VOC_Customer_Name__c> voccnlst = new  list<VOC_Customer_Name__c>();
     list<VOC_Customer_Name__c> voccnlst1 = new  list<VOC_Customer_Name__c>();
     voccnlst.add(voccn);
     voccnlst1.add(voccn1);
     
     
     
     
     OVOC_Create_Controller.getDraftRecord(string.valueOf(obj.Id));
     
     OVOC_Create_Controller.addCustomer(voccnlst,string.valueOf(obj.Id));
     OVOC_Create_Controller.addCustomer(voccnlst1,string.valueOf(obj.Id));
     //OVOC_Create_Controller.getChatterNames('searchTerm');
     OVOC_Create_Controller.deleteCustomers(voccnlst);
     OVOC_Create_Controller.getownerQueue();
     OVOC_Create_Controller.ShareVOCRecord(string.valueOf(obj.Id),'vocTitle');
     //OVOC_Create_Controller.getAttachment(string.valueof(attach.id));

     Test.stopTest();
 }
 static testMethod void myUnitTest1() {
    Test.starttest();
     VOC_OVOC_Record_Number__c vocrn= new VOC_OVOC_Record_Number__c();
    vocrn.Name='Reference record';
    vocrn.VOC__c = '111';
    vocrn.OVOC__c = '222';
    insert vocrn;
      // to insert Voice_of_Customer__c
    Voice_of_Customer__c voc = new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    voc.Status__c='Submitted';
    insert voc;
     Test.stopTest();
    }
    
static testMethod void myUnitTest2() {
    Test.starttest();
     VOC_OVOC_Record_Number__c vocrn1= new VOC_OVOC_Record_Number__c();
    vocrn1.Name='Reference record';
    vocrn1.VOC__c = '1';
    vocrn1.OVOC__c = '2';
    insert vocrn1;
      // to insert Voice_of_Customer__c
    Voice_of_Customer__c voc1= new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    voc1.Status__c='Submitted';
    insert voc1;
      Test.stopTest();
    }
   static testMethod void myUnitTest3() { 
     Test.starttest();
    VOC_OVOC_Record_Number__c vocrn2= new VOC_OVOC_Record_Number__c();
    vocrn2.Name='Reference record';
    vocrn2.VOC__c = '11';
    vocrn2.OVOC__c = '22';
    insert vocrn2;
      // to insert Voice_of_Customer__c
    Voice_of_Customer__c voc2= new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    voc2.Status__c='Submitted';
    insert voc2;
      Test.stopTest();
    }
    static testMethod void myUnitTest4() {
      Test.starttest();
         VOC_OVOC_Record_Number__c vocrn3= new VOC_OVOC_Record_Number__c();
    vocrn3.Name='Reference record';
    vocrn3.VOC__c = '1111';
    vocrn3.OVOC__c = '2222';
    insert vocrn3;
      // to insert Voice_of_Customer__c
    Voice_of_Customer__c voc3= new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    voc3.Status__c = 'Submitted';
    voc3.Sensitive__c = true;
    insert voc3;
    
    
    
    Test.stopTest();
 
 }
   static testMethod void myUnitTest5() {
      Test.starttest();
         VOC_OVOC_Record_Number__c vocrn3= new VOC_OVOC_Record_Number__c();
    vocrn3.Name='Reference record';
   vocrn3.VOC__c = '99999';
   vocrn3.OVOC__c = '2222';
    insert vocrn3;
      // to insert Voice_of_Customer__c
    Voice_of_Customer__c voc3= new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    voc3.Status__c = 'Submitted';
   
    insert voc3;
    
    //list<VOC_Group_Queue_Map__c> lstvocg= VOC_Group_Queue_Map__c.getall().values();
    
     voc3.Sensitive__c = true;
     voc3.Status__c = 'Draft';
     //voc3.ownerid = lstvocg[0].Queue_Id__c;
    update voc3;
    voc3.Status__c = 'Submitted';
    update voc3;
    
    
    
    Test.stopTest();
 
 }
    //Test for AddAttachments     
    static testMethod void myUnitTest6() {
    
        Test.starttest();
        
        //Create VOC Account
        VOC_Accounts__c vocAcc = new VOC_Accounts__c();
        vocAcc.Name = 'Test Account';
        insert vocAcc;
        
        
        PageReference pageRef = Page.OVOC_Create;
        Test.setCurrentPage(pageRef);
        
        VOC_OVOC_Record_Number__c vocrn = new VOC_OVOC_Record_Number__c();
        vocrn.Name='Reference record';
        vocrn.VOC__c = '99999';
        vocrn.OVOC__c = '2222';
        insert vocrn;
    
        blob attachmentBlob = Blob.valueOf('Test Attachment body');
        string attachmentName = 'test.docx';
        
        //Attachment object initiation
        OVOC_Create_Controller contrl = new OVOC_Create_Controller();
        contrl.attach.body = attachmentBlob;
        contrl.attach.name = attachmentName; 
        
        //assign other field values
        contrl.recordType = Label.VOC_RecType_Id;
        contrl.VOC_Title = 'My VOC test';
        contrl.VOC_Date = '06/03/2014';
        contrl.Honeywell_Lead = 'abc';
        contrl.VOC_COllection = 'test collection';
        contrl.VOC_Hypothesis = 'Understanding the Market';
        contrl.Key_Takeaways = 'key takeaways';
        contrl.Financial_Implications = 'test fin';
        contrl.Key_Action_Items= 'key action items';
        contrl.Product_Name = 'test prod';
        contrl.Product_Family = 'Crew Interface';                                               
        contrl.customerDetails = 'null,test,'+ vocAcc.Id +',test,ss@dd.com;null,test2,'+ vocAcc.Id +',test,abc@dd.com;';
        contrl.VOC_purpose = 'Sizing the Market';
        contrl.VOC_purpose = 'Sizing the Market';
        contrl.Sensitive_Information = 'true';
        
        String draftUrl = contrl.addAttachment().getUrl();
        
        System.assertEquals('/apex/OVOC_Create?id=', draftUrl.substring(0,21));
        Test.stopTest();
 
    }
     
    //Test for AddAttachments     
    static testMethod void myUnitTest7() {
    
        Test.starttest();
        
        //Create VOC Account
        VOC_Accounts__c vocAcc = new VOC_Accounts__c();
        vocAcc.Name = 'Test Account';
        insert vocAcc;
        
        
        PageReference pageRef = Page.OVOC_Create;
        Test.setCurrentPage(pageRef);
        
        VOC_OVOC_Record_Number__c vocrn = new VOC_OVOC_Record_Number__c();
        vocrn.Name='Reference record';
        vocrn.VOC__c = '99999';
        vocrn.OVOC__c = '2222';
        insert vocrn;
    
        blob attachmentBlob = Blob.valueOf('Test Attachment body');
        string attachmentName = 'test.docx';
        
        Voice_of_Customer__c voc = new Voice_of_Customer__c();
        voc.VOC_Title__c = 'Test title';
        insert voc;
        
        Attachment vocAttach = new Attachment();
        vocAttach.body = attachmentBlob;
        vocAttach.name = attachmentName;
        vocAttach.parentId = voc.Id;
        insert vocAttach;
        
        //Attachment object initiation
        OVOC_Create_Controller contrl = new OVOC_Create_Controller();
        contrl.attach.body = attachmentBlob;
        contrl.attach.name = attachmentName; 
        
        //assign other field values
        contrl.recordType = Label.VOC_RecType_Id;
        contrl.VOC_Title = 'My VOC test';
        contrl.VOC_Date = '06/03/2014';
        contrl.Honeywell_Lead = 'abc';
        contrl.VOC_COllection = 'test collection';
        contrl.VOC_Hypothesis = 'Understanding the Market';
        contrl.Key_Takeaways = 'key takeaways';
        contrl.Financial_Implications = 'test fin';
        contrl.Key_Action_Items= 'key action items';
        contrl.Product_Name = 'test prod';
        contrl.Product_Family = 'Crew Interface';                                               
        contrl.customerDetails = 'null,test,'+ vocAcc.Id +',test,ss@dd.com;null,test2,'+ vocAcc.Id +',test,abc@dd.com;';
        contrl.VOC_purpose = 'Sizing the Market';
        contrl.VOC_purpose = 'Sizing the Market';
        contrl.Sensitive_Information = 'true';
        contrl.deleteFileList = vocAttach.Id+';';
        String draftUrl = contrl.addAttachment().getUrl();
        
        System.assertEquals('/apex/OVOC_Create?id=', draftUrl.substring(0,21));
        Test.stopTest();
 
    }
    
    //Test for Delete Attachments     
    static testMethod void myUnitTest8() {
    
        Test.starttest();
        
        //Create VOC Account
        VOC_Accounts__c vocAcc = new VOC_Accounts__c();
        vocAcc.Name = 'Test Account';
        insert vocAcc;
        
        
        PageReference pageRef = Page.OVOC_Create;
        Test.setCurrentPage(pageRef);
        
        VOC_OVOC_Record_Number__c vocrn = new VOC_OVOC_Record_Number__c();
        vocrn.Name='Reference record';
        vocrn.VOC__c = '99999';
        vocrn.OVOC__c = '2222';
        insert vocrn;
    
        blob attachmentBlob = Blob.valueOf('Test Attachment body');
        string attachmentName = 'test.docx';
        
        Voice_of_Customer__c voc = new Voice_of_Customer__c();
        voc.VOC_Title__c = 'Test title';
        insert voc;
        
        Attachment vocAttach = new Attachment();
        vocAttach.body = attachmentBlob;
        vocAttach.name = attachmentName;
        vocAttach.parentId = voc.Id;
        insert vocAttach;
        
        OVOC_Create_Controller.deleteAttachments(vocAttach.id + ';');
        Test.stopTest();
 
    }
 }