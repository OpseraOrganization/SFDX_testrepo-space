@isTest
public class accountTypeRestResourceTest
{
    @isTest
    public static void testGetSoldTocase1()
    {
        Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        Insert acc;
        List<Account_Cross_Ref__c> lstacr = New List<Account_Cross_Ref__c >();
        
        Account_Cross_Ref__c acr = New Account_Cross_Ref__c();
        acr.name = 'Air';
        acr.Account_Name__c = acc.id;
        acr.External_Account_ID__c = '0000035674-01';
        acr.Site_Code__c = 'SAP';
        acr.External_Account_Name__c = 'SAP Air';
        acr.XREF_Type__c = 'SAP_SOLD_TO';
        lstacr.add(acr);
        
        Account_Cross_Ref__c acr1 = New Account_Cross_Ref__c();
        acr1.name = 'test1';
        acr1.Account_Name__c = acc.id;
        acr1.External_Account_ID__c = '0000035676-01';
        acr1.Site_Code__c = 'SAP';
        acr.External_Account_Name__c = 'SAP Air';
        acr1.XREF_Type__c = 'SAP_SOLD_TO';
        lstacr.add(acr1);
        
        Insert lstacr;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();   
         
        req.requestUri = '/services/apexrest/api/v1/accounttype';
        req.addParameter('soldtos','35676');
        req.httpMethod = 'Get';      
        RestContext.request = req;
        RestContext.response = res;
        
        accountTypeRestResource.doGetProduct();
                
     }   
     @isTest
    public static void testGetSoldTocase2()
    {
    
        
        Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        Insert acc;
        List<Account_Cross_Ref__c> lstacr = New List<Account_Cross_Ref__c >();
        
        Account_Cross_Ref__c acr = New Account_Cross_Ref__c();
        acr.name = 'test';
        acr.Account_Name__c = acc.id;
        acr.External_Account_ID__c = '0000035674-01';
        acr.Site_Code__c = 'SAP';
        acr.XREF_Type__c = 'SAP_SOLD_TO';
        lstacr.add(acr);
        Account_Cross_Ref__c acr1 = New Account_Cross_Ref__c();
        acr1.name = 'test1';
        acr1.Account_Name__c = acc.id;
        acr1.External_Account_ID__c = '0000035676-01';
        acr1.Site_Code__c = 'SAP';
        acr1.XREF_Type__c = 'SAP_SOLD_TO';
        lstacr.add(acr1);
        
        Insert lstacr;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();   
         
        req.requestUri = '/services/apexrest/api/v1/accounttype';
        req.httpMethod = 'Get';           
        RestContext.request = req;
        RestContext.response = res;
        accountTypeRestResource.doGetProduct();
        
        } 
    
    }