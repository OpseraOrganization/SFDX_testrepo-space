/** * File Name: REG_PortalAccount_Intermediate_Wrapper

* Description  Queries related to account

* * @author : TCS 

Date 01/18/2019 

* */

    public class REG_PortalAccount_Intermediate_Wrapper{ 
        //Portal_Tools_Master__c masterToolObj = new Portal_Tools_Master__c();
        string domain = '';
        boolean isInternalDomain;
        string accountName= '';
        string country = '';
        string countryCode='';
        string stateCode ='';
        string accountId= '';
        string deniedPartyStatus = '';
        string addressLine1 = '';
        string addressLine2 = '';
        string addressLine3 = '';
        string addressStatus = '';
        string addressType = '';
        boolean isPrimary;
        string city = '';
        string postalCode = '';
        
       // Contact_Tool_Access__c contactToolObj = new Contact_Tool_Access__c();
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public REG_PortalAccount_Intermediate_Wrapper (String domain ,boolean isInternalDomain ,string accountName,string country ,string countryCode, string stateCode,
                           string accountId,string deniedPartyStatus ,string addressLine1,string addressLine2,string addressLine3 ,string addressStatus ,string addressType ,
                           boolean isPrimary ,string city, string postalCode) {
            
                this.domain = domain;
                this.isInternalDomain = isInternalDomain ;
                this.accountName= accountName;
                this.country = country ;
                this.countryCode = countryCode;
                this.stateCode = stateCode; 
                this.accountId = accountId;
                this.deniedPartyStatus = deniedPartyStatus ;   
                this.addressLine1 = addressLine1;
                this.addressLine2 = addressLine2;
                this.addressLine3 = addressLine3;
                this.addressStatus= addressStatus;
                this.addressType = addressType ;
                this.isPrimary  = isPrimary ;
                this.city = city;
                this.postalCode = postalCode;
        }
    }