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
@isTest(seealldata=true)
private class VoiceofcustomerTestclass {

    static testMethod void myUnitTest() {
        
        /*VOC_OVOC_Record_Number__c vocrn = new VOC_OVOC_Record_Number__c();
        vocrn.Name='Reference record';
        vocrn.VOC__c = '1999';
        vocrn.OVOC__c = '2222';
        insert vocrn;*/
        
        Voice_of_Customer__c voc= new Voice_of_Customer__c();
        voc.Title__c='VOCTest';
        voc.sensitive__c=false;
        voc.Product_Family__c='[test;test1]';
        //voc.selectedgroup__c='a4Je0000000CdEhEAK';
        //insert voc;
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=voc.id;
        //insert attach;
        
                
      list<string>selectedgroup= new list<string>();
      ApexPages.StandardController con = new ApexPages.StandardController(voc);
      
      
      PageReference pageRef = Page.VocCreate;
      Test.setCurrentPage(pageRef);
      
       
      VoiceofcustomerClass vc= new VoiceofcustomerClass(con);
          
       
      
      
      VC.attachment=attach;
      vc.attachment.Body=Blob.valueOf('Unit Test Attachment Body');
      vc.getselectedgroup();
      vc.setselectedgroup(selectedgroup);
      vc.checkforaccount();
      vc.clearform();
      vc.depedentvalue();
      vc.attachment=attach;
      //vc.attachment();
      vc.gettype();
      vc.getchattergroup();
      vc.getproductfamily();
      vc.save();
      vc.showgroup();
      vc.oemsetval();
    }
    static testMethod void myUnitTest1() {
        
        /*VOC_OVOC_Record_Number__c vocrn = new VOC_OVOC_Record_Number__c();
        vocrn.Name='Reference record';
        vocrn.VOC__c = '1999';
        vocrn.OVOC__c = '2222';
        insert vocrn;*/
        
        Voice_of_Customer__c voc= new Voice_of_Customer__c();
        voc.Title__c='VOCTest';
        voc.sensitive__c=true;
        voc.Product_Family__c='[test;test1]';
        voc.RecordTypeid = '012a0000001ZPAJ';
        voc.selectedgroup__c='a4Je0000000CdEhEAK';
        voc.Date_of_VOC__c = system.today().addDays(-4);
        //insert voc;
    
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=voc.id;
        //insert attach;
        
                
      list<string>selectedgroup= new list<string>();
      ApexPages.StandardController con = new ApexPages.StandardController(voc);

      
      PageReference pageRef = Page.VocCreate;
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('RecordType','012a0000001ZPAJ'); 
      
       
      VoiceofcustomerClass vc= new VoiceofcustomerClass(con);
          
       
      
      
      VC.attachment=attach;
      vc.attachment.Body=Blob.valueOf('Unit Test Attachment Body');
      vc.getselectedgroup();
      vc.setselectedgroup(selectedgroup);
      vc.checkforaccount();
      vc.clearform();
      vc.depedentvalue();
      vc.attachment=attach;
      //vc.attachment();
      vc.gettype();
      vc.getchattergroup();
      vc.getproductfamily();
      vc.save();
      vc.showgroup();
      vc.oemsetval();
    }
}