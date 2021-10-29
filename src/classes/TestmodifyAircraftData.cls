/**
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest (SeeAllData = true)
public class TestmodifyAircraftData{
    testMethod static void testAircraft(){
        Fleet_Asset_Detail__c fad = [SELECT Id,Name,AMSTAT_base_ICAO__c FROM Fleet_Asset_Detail__c WHERE Base_ICAO__c<>NULL AND State__c<>NULL LIMIT 1];
        update fad;
        fad = [SELECT Id,Name,AMSTAT_base_ICAO__c FROM Fleet_Asset_Detail__c WHERE Base_ICAO__c=NULL AND State__c<>NULL LIMIT 1];
        update fad;
        
        fad = [SELECT Id,Name,AMSTAT_base_ICAO__c FROM Fleet_Asset_Detail__c WHERE AMSTAT_base_ICAO__c<>NULL AND Account_SBU__c='BGA' LIMIT 1];
        update fad;
        
        fad = [SELECT Id,Name,AMSTAT_base_ICAO__c FROM Fleet_Asset_Detail__c WHERE Aircraft_Base__c=NULL AND Admin__c=false LIMIT 1];
        update fad;
    }
}