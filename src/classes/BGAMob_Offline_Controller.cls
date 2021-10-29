/**
* Apex Controller to provide relevant data binding to a Visualforce page.
**/
global without sharing class BGAMob_Offline_Controller {

    public BGAMob_Offline_Controller(ApexPages.StandardController controller) {

    }



    /**
    * Method to query details of albums from the database.
    * returm the list of 20 albums with their Id, name and price information
    */
    @RemoteAction
    global static List<Contact> queryContacts() {
         return [SELECT Id, BGAMob_Contact_Alt_Name__c, Email, Mobile_App_Role__c, Phone_5__c FROM Contact where Mobile_Directory_App__c=true ORDER BY Name];
    }
    
    /**
    * Method to query details of Skills from the database.
    * returm the list of all Skills with their Id, name and price information
    */
    @RemoteAction
    global static List<Skills2__c> querySkills() {
    Set<String> ContIdsSet = new Set<String>(); // to store unique contact ids
     List<Contact> BGAContacts = [SELECT Id FROM Contact where Mobile_Directory_App__c=true];
    if (BGAContacts.size() > 0)
            {
                for(Contact temp:BGAContacts) 
                     {
                        ContIdsSet.add(temp.Id); 
                     }
        
           }     
         return [SELECT Id, Name, Contact__c, Skill_Type__c, Skill_Value__c, Skill_Value_Comments__c FROM Skills2__c  where (Skill_Type__c='Area Covered US' or Skill_Type__c='Areas Covered Intl A-K' or Skill_Type__c='Areas Covered Intl L-Z' or Skill_Type__c='Areas Covered Canada') and Contact__c in :ContIdsSet];
         
    }
    
    /**
    * Method to query the list of tracks for a particular album.
    * returm the list of 200 tracks with their Id, name, price and album information
    */
    @RemoteAction
    global static List<Account_Address__c> queryAccountAddress() {
         return [Select Id, Report_Account_name__c,Report_Account_Name_small__c,Engine_Authorization__c,Avionics_Support_Level__c,BGAMob_Contact_Name__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_State_Province__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,BGAMob_Country_Nm__c,Mobile_App_Visibility__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_Postal_Code__c,BGAMob_Website__c from Account_Address__c 
                where Mobile_App_Visibility__c=true ORDER BY Report_Account_Name_small__c];
    }
    
    public String phoneGapUrl {
            get {
                String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
                if(!test.isRunningTest()){
                if (userAgent.contains('android')  )
                    return 'CordovaAndroid.js';
                else
                    return 'CordovaIOS.js';
                } 
                else 
                    return 'testclass';
                // iOS-specific checks that you could make.  Above, we assume it's iOS if it's not Android.
                //if (userAgent.contains('iPhone')
                //    || userAgent.contains('iPod')
                //    || userAgent.contains('iPad')
                //    || userAgent.contains('i386')
                //    || userAgent.contains('x86_64'))
                //    return 'phonegap-1.2.0-ios.js';
            }
    }
    
}