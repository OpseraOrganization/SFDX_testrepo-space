public class REG_PortalAccount_AllSoldto_Wrapper {
    
     String sblAccountRowId='';	
     String accountId='';	
     String accountName='';	
     String addressLine1='';	
     String addressLine2='';	
     String addressLine3='';	
     String cityName='';
     String stateCode='';	
     String postalCode='';
     String countryName='';
     String marketName='';	
     String countryCode='';
     String soldToIdUiDisplay='';
    public REG_PortalAccount_AllSoldto_Wrapper(Account ac,String CountryCode){
        if(ac.SAP_Sold_To__c !=null){
            soldToIdUiDisplay = ac.SAP_Sold_To__c.split('-').get(0);
        }else{
            this.soldToIdUiDisplay='';
        }        
        this.sblAccountRowId = ac.Sbl_Account_Row_Id__c;
        this.accountId= ac.Id;
        this.accountName = ac.Name;
        this.addressLine1=ac.Address_Line_2__c;
        this.addressLine2 = ac.Address_Line_2__c;
        this.addressLine3 = ac.Address_Line_3__c;
        this.cityName = ac.City_Name__c;
        this.stateCode = ac.State_Code__c;
        this.postalCode = ac.Postal_Code__c;
        this.countryName = ac.Country_Name__c;
        this.marketName = ac.Market_Name__c;
        this.countryCode = CountryCode;
    }    
   
}