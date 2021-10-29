/** * File Name: REG_PortalAccount_Wrapper

* Description  Queries related to account

* * @author : TCS 

Date 01/18/2019 

* */

    public class REG_PortalAccount_Wrapper{
        List<REG_PortalAccount_Intermediate_Wrapper> matchedAccounts = new List<REG_PortalAccount_Intermediate_Wrapper >();
        List<REG_PortalAccount_Intermediate_Wrapper> allAccounts = new List<REG_PortalAccount_Intermediate_Wrapper >();
        
       // Contact_Tool_Access__c contactToolObj = new Contact_Tool_Access__c();
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public REG_PortalAccount_Wrapper ( List<REG_PortalAccount_Intermediate_Wrapper> matchedAccounts,
                                           List<REG_PortalAccount_Intermediate_Wrapper> allAccounts ) {
            
            this.matchedAccounts = matchedAccounts ;
            this.allAccounts = allAccounts;        
        }
    }