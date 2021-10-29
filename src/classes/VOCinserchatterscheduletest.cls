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
private class VOCinserchatterscheduletest {
    public static testMethod void expiredPermits_testmethod() 
    {
        Test.startTest();
        System.debug('_________________________Test Started_______________________');
        VOC_OVOC_Record_Number__c vocrn = new VOC_OVOC_Record_Number__c();
        vocrn.Name='Reference record';
        vocrn.VOC__c = '99999';
        vocrn.OVOC__c = '2222';
        insert vocrn;

        VOCinsertchatterschedule vocschedule=new VOCinsertchatterschedule();
        Voice_of_Customer__c voc=new Voice_of_Customer__c();
        voc.Title__c='VOCTest';
        voc.sensitive__c=false;
        voc.Source__c ='compitetor';
        voc.oem__c = 'test';
        voc.Product_Family__c= 'test';
        insert voc; 
        
        Voice_of_Customer__c voc1=new Voice_of_Customer__c();
        voc1.Title__c='VOCTest';
        voc1.sensitive__c=true;
        voc1.Source__c ='compitetor';
        voc1.oem__c = 'test';
        voc1.selectedgroup__c=label.CrewInterface_Group_Id;  //-- Modified group id because of group earlier group archieved
        voc1.Product_Family__c= 'test';
        insert voc1;
        
        SchedulableContext sc;
        vocschedule.execute(sc);
        Test.stopTest();
        System.debug('_________________________Test Stop_______________________');
    }
}