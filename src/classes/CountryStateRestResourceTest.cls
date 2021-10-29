@isTest
public class CountryStateRestResourceTest {
    
    @isTest
    static void teste(){
        Country__c cn = new Country__c();
        cn.Name = 'India';
        cn.SFDC_Country_Name__c = 'India';
        CN.ISO_Country_code__c = 'IND';
        insert cn;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/countrystate'; 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CountryStateRestResource.doGetCountrystate();
        req.addParameter('countryCode', 'IND');
        CountryStateRestResource.doGetCountrystate();
        req.addParameter('field', 'IND');
        CountryStateRestResource.doGetCountrystate();
        CountryStateRestResource.getCountryCount('IND');
    }
    @isTest
    static void testnew(){
        Country__c cn = new Country__c();
        cn.Name = 'India';
        cn.SFDC_Country_Name__c = 'India';
        CN.ISO_Country_code__c = 'IND';
        insert cn;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/countrystate'; 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CountryStateRestResource.doGetCountrystate();
        req.addParameter('field', 'IND');
        CountryStateRestResource.doGetCountrystate();
    }
    @isTest
    static void doGetCountrystatetest1(){
        Country__c cn = new Country__c();
        cn.Name = 'India';
        cn.SFDC_Country_Name__c = 'India';
        CN.ISO_Country_code__c = 'IND';
        insert cn;
        Country_States__c cs = new Country_States__c();
        cs.name='Karnataka';
        cs.Country__c=cn.id;
        cs.State_Code__c='KA';
        cs.StateCode__c='KA';
        insert cs;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/countrystate'; 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CountryStateRestResource.doGetCountrystate();
        req.addParameter('countryCode', 'IND');
        CountryStateRestResource.doGetCountrystate();
        req.addParameter('fields', 'states');
        CountryStateRestResource.doGetCountrystate();
    }
    @isTest
    static void doGetCountrystatetest2(){
        Country__c cn = new Country__c();
        cn.Name = 'India';
        cn.SFDC_Country_Name__c = 'India';
        CN.ISO_Country_code__c = 'IND';
        insert cn;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/countrystate'; 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        CountryStateRestResource.doGetCountrystate();
        //req.addParameter('countryCode', 'IND');
        //CountryStateRestResource.doGetCountrystate();
        req.addParameter('fields', 'states');
        CountryStateRestResource.doGetCountrystate();
    }
}