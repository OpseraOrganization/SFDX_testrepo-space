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
private class VOCdesktopSearchTest {

    static testMethod void myUnitTest() 
    {
    id userid = [select id from user limit 1].id;
        id accountid = [select id from voc_accounts__c limit 1].id;
         id platformid = [select id from platform__c limit 1].id;
    Voice_of_Customer__c voc7= new Voice_of_Customer__c();
        voc7.Title__c= 'VOCTest';
        voc7.Source__c ='compitetor';
        voc7.honeywell__c = userid;
        voc7.voc_account__c = accountid;
       // vc7.oem__c = 'test';
       // vc7.SearchRecord.Product_Family__c= 'test';
        //vc7.SearchRecord.Platform__c= 'test';
        //vc7.SearchRecord.Other_Hoenywell_Attendees__c =  'test';
        insert voc7;
        
        Voice_of_Customer__c voc= new Voice_of_Customer__c();
        ApexPages.StandardController con = new ApexPages.StandardController(voc);
        VOCSearchDesktop vc= new VOCSearchDesktop(con);
        vc.Keywords = 'VOCTest';
        vc.SearchRecord.EndDate__c =system.today();
        vc.SearchRecord.voc_type__c ='anecdotal';
        vc.getoem();
        vc.searchform();
        
        
        ApexPages.StandardController con4 = new ApexPages.StandardController(voc);
        VOCSearchDesktop vc4= new VOCSearchDesktop(con4);
        vc4.Keywords = 'VOCTest';
        vc4.SearchRecord.voc_type__c ='anecdotal';
        vc4.searchform();
        
        ApexPages.StandardController con1 = new ApexPages.StandardController(voc);
        VOCSearchDesktop vc1= new VOCSearchDesktop(con1);
        vc1.Keywords = 'VOCTest';
        //vc1.clearform();
          
        ApexPages.StandardController con2 = new ApexPages.StandardController(voc);
        VOCSearchDesktop vc2= new VOCSearchDesktop(con2);
        vc2.Keywords = 'VOCTest';
        //vc2.redirect();
        
        Voice_of_Customer__c voc1= new Voice_of_Customer__c();
        ApexPages.StandardController con3 = new ApexPages.StandardController(voc1);
        VOCSearchDesktop vc3= new VOCSearchDesktop(con3);
        vc3.Keywords = 'VOCTest';
        vc3.SearchRecord.StartDateval__c =system.today();
        vc3.searchform();
        
        Voice_of_Customer__c voc5= new Voice_of_Customer__c();
        ApexPages.StandardController con5 = new ApexPages.StandardController(voc5);
        VOCSearchDesktop vc5= new VOCSearchDesktop(con5);
        vc5.Keywords = 'VOCTest';
        vc5.SearchRecord.Disposition__c ='New';
        vc5.SearchRecord.StartDateval__c =system.today();
        vc5.SearchRecord.EndDate__c =system.today()-1;
        vc5.SearchRecord.voc_type__c ='anecdotal';
        vc5.searchform();
        
        Voice_of_Customer__c voc6= new Voice_of_Customer__c();
        ApexPages.StandardController con6 = new ApexPages.StandardController(voc6);
        VOCSearchDesktop vc6= new VOCSearchDesktop(con6);
        vc6.Keywords = 'VOCTest';
        vc6.SearchRecord.Source__c ='compitetor';
        vc6.SearchRecord.honeywell__c = userid;
        vc6.SearchRecord.voc_account__c = accountid;
        vc6.SearchRecord.oem__c = 'test';
        vc6.SearchRecord.Product_Family__c= 'test';
        vc6.SearchRecord.Platform__c= platformid;
        vc6.SearchRecord.Other_Hoenywell_Attendees__c =  'test';
        vc6.searchform();
        
         Voice_of_Customer__c voc8= new Voice_of_Customer__c();
        ApexPages.StandardController con8 = new ApexPages.StandardController(voc8);
        VOCSearchDesktop vc8= new VOCSearchDesktop(con8);
        PageReference pageRef = Page.VOCSearchDeskTop;
        pageRef.getParameters().put('strCondition','');
        Test.setCurrentPage(pageRef);
        vc8.SearchRecord.oem__c = 'test';
        vc8.searchform();
        
        
        
        
        Voice_of_Customer__c voc10= new Voice_of_Customer__c();
        ApexPages.StandardController con10 = new ApexPages.StandardController(voc10);
        VOCSearchDesktop vc10= new VOCSearchDesktop(con10);
         PageReference pageRef2 = Page.VOCSearchDeskTop;
        pageRef.getParameters().put('strCondition','');
        Test.setCurrentPage(pageRef2);
        vc10.SearchRecord.product_family__c = 'test';
        vc10.searchform();
        vc10.DetailPage();
        
    }
}