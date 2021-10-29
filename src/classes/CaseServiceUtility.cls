public class CaseServiceUtility {
    //find the default Areo user id
    public static id getAreoDefaultUser(){
        id UserId;
        
         // commenting to reduce SOQL 101 ERROR
        //Aero_Default_User_Setting__mdt aeroDefaultUser= [SELECT UserName__c FROM Aero_Default_User_Setting__mdt 
         //                                                 WHERE IsOrgDefault__c = true LIMIT 1];
        Id aeroDefaultUser = label.AERODEFAULTUSER;                                             
        
        if(aeroDefaultUser != null){
         UserId = aeroDefaultUser;    
        }
        return UserId;
        
    }
    
    //User May Aerspace Web form
    public static Id getMyaerospacewebformUser(){
        Id UserId;
        //commenting to reduce SOQL 101 ERROR
        //Aero_Default_User_Setting__mdt myaerospacewebformUser = [SELECT MySpace_Web_Username__c FROM Aero_Default_User_Setting__mdt WHERE IsOrgDefault__c = true LIMIT 1];
        
        Id myaerospacewebformUser = label.myaerospace_webform;
        
        if(myaerospacewebformUser != null){
        UserId = myaerospacewebformUser;
        }
        return UserId;
    }
    
    //User Effortless Orders
    public static Id getEffortlessUser(){
        Id UserId;
        //Aero_Default_User_Setting__mdt effortlessUser = [SELECT Effortless_Orders_Username__c 
        //                                                  FROM Aero_Default_User_Setting__mdt 
         //                                                 WHERE IsOrgDefault__c = true LIMIT 1];
        
        Id effortlessUser = label.API_User_Effortless_Orders;
        if(effortlessUser != null){
        
        UserId = effortlessUser;
        }
        return UserId;
    }
    
    //user AircraftConnectivity Service Management
    public static Id getAircraftConnectivity(){
        Id UserId=null;
        //Aero_Default_User_Setting__mdt AircraftConnectivity = [SELECT Aircraft_Connectivity_Service_Management__c 
           //                                               FROM Aero_Default_User_Setting__mdt 
             //                                             WHERE IsOrgDefault__c = true  LIMIT 1];
         Id AircraftConnectivity = label.Aircraft_Connectivity_Service_Management_API_User;
             
        if(AircraftConnectivity != null){        
            UserId = AircraftConnectivity;
        }
        return UserId;
    }
    
    //User Denied party Screening API
    public static Id getDeniedScreeningAPIUser(){
        Id UserId;
        
        //Aero_Default_User_Setting__mdt deniedScreeningUser = [SELECT DeniedPartyScreening_APIUser__c FROM Aero_Default_User_Setting__mdt 
        //                                                  WHERE IsOrgDefault__c = true LIMIT 1];
        
        Id deniedScreeningUser = label.DeniedPartyScreening_APIUser_ID;
        if(deniedScreeningUser != null){
        UserId = deniedScreeningUser;
        }
        return UserId;
    }
    
    //get the Group id for case
    public static Id getGroupID(String groupDName, String groupType){
        Id idToReturn = [Select Id, Name, Type From Group Where DeveloperName = :groupDName AND Type = :groupType].Id;
        return idToReturn;
    }
    
    public static Id getAtrRmuApiUser(){
        Id UserId;
        Aero_Default_User_Setting__mdt AtrRmuApiUser = [SELECT ATR_RMU_API_Username__c 
                                                          FROM Aero_Default_User_Setting__mdt 
                                                          WHERE IsOrgDefault__c = true LIMIT 1];
        if(AtrRmuApiUser != null){
        UserId= AtrRmuApiUser.ATR_RMU_API_Username__c;
        }
        return UserId;
    }
  
    //get the email id from custom meta data type Case_Email_Address__mdt
    public static string getCaseEmailId(string caseType){
        string emailId='';
        Case_Email_Address__mdt caseEmail= [SELECT Email_Address__c 
                                                          FROM Case_Email_Address__mdt 
                                                          WHERE isActive__c = true  AND  Case_Type__c=:caseType LIMIT 1];
        if(caseEmail!= null){
           emailId = caseEmail.Email_Address__c;
        }
        return emailId ;
    }
   //Get ITEC user from Custom metadata type   
    public static Id getITECUser(){
        Id UserId;
        UserId = Label.ITECUserId;
        return UserId;
    } 
}