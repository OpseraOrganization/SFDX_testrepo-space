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
private class BGAMob_BusinessNewTest {

     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        BGAMob_BusinessNew bg= new BGAMob_BusinessNew();
        BGAMob_BusinessNew.RssFeed rss=new BGAMob_BusinessNew.RssFeed();
        string temp='';
        XMLDom test1= new XMLDom(temp);
        BGAMob_BusinessNew.dom=test1;
        rss.RssFeed();
        bg.descrp='test';
        bg.readall();
        //BGAMob_BusinessNew.getdescription('{9948C5D0-4216-4F65-9EF0-4DD8887E2A5B}');
      //  BGAMob_BusinessNew.getdescription('https://aerospace.honeywell.com/news/high-quality-apu-repair-solution-reduces-costs-without-compromising-standards');
         BGAMob_BusinessNew.AddMore();
     }
}