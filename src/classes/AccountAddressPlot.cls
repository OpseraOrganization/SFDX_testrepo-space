public with sharing class AccountAddressPlot 
{


public list<Account_Address__c> objAccounts {get;set;}
    public AccountAddressPlot (){
        try{
            objAccounts = new list<Account_Address__c>();  
            objAccounts.addAll([Select Id,Report_Account_name__c,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and BGAMob_Geo_Code__Latitude__s = null and BGAMob_Geo_Code__Longitude__s = null]);
        System.debug(objAccounts);
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:'
                                                        +ex.getMessage()));
        }
    }

@RemoteAction
   Static public void updatelocation(String accid,Decimal geolat,Decimal geolng)
   {
       Account_Address__c objaccnt = new Account_Address__c();
       objaccnt  = [Select Id,Report_Account_name__c,BGAMob_Geo_Code__Latitude__s,BGAMob_Geo_Code__Longitude__s ,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true and Id =: accid ];
       objaccnt.BGAMob_Geo_Code__Latitude__s= geolat;
       objaccnt.BGAMob_Geo_Code__Longitude__s = geolng;
       update objaccnt;
   }
}