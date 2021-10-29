/****************************************************
* @Description : Utility Apex Class that contains re-usable 
* methods
* 
* *************************************************/
public with Sharing class SalesCoach_Utility {
    
    /*************************************************
* @Description : Method verify if running user has 
* Set up information to maintain custom metadata. 
* if Yes , all custom metadata records will be returned. 
* 
* ************************************************/
    public Boolean isUserCanManageMetadata() {
        Boolean result = false ; 
        
        List<Profile> currentUserProfile = [SELECT id ,PermissionsViewSetup   
                                            FROM Profile WHERE Id =: UserInfo.getProfileId() 
                                            LIMIT 1];   
        
        if(!currentUserProfile.isEmpty()) { //for the current profile , verify the setup permission
            result = currentUserProfile[0].PermissionsViewSetup ; 
        }
        
        return result ; 
    }
    
    /*************************************************
* @Description : Method to get all custom metadata records
* 
* ************************************************/
    public List<Pipeline_Review__mdt> getAllRecords(Boolean isTeamView) {
        return [SELECT Object_API_Name__c , Fields_API_Name__c , Condition_Expression__c ,
                Restrict_Records_to_Owner__c , MasterLabel , DeveloperName , 
                Grouping_Title__c , Limit__c , First_Range_Limit__c , 
                First_Range_Limit_Color__c , Second_Range_Limit__c , 
                Second_Range_Limit_Color__c , End_Limit_Color__c , 
                Apex_Unique_Identifier__c , Generate_From_Apex__c , 
                Help_Text__c , GBE__c , Division__c , Region__c
                
                FROM Pipeline_Review__mdt
                WHERE 
                Is_Team_View__c =: isTeamView
                ORDER BY DeveloperName ASC
                LIMIT 20000];
    }
    
    
    /*************************************************
* @Description : Method to get all custom metadata records
* 
* ************************************************/
    public List<Pipeline_Review__mdt> getConfiguredRecords(Boolean isTeamView) {
        
        String userGBE ; 
        String userRegion ;
        String userDivision ; 
        
        String configGBE ; 
        String configRegion ; 
        String configDivision ; 
        //use below booleans to identify if the configuration metadata record is
        //matching the current user values. 
        Boolean isGBEVerified = false ; 
        Boolean isRegionVerified = false ; 
        Boolean isDivisionVerified = false ; 
        List<Pipeline_Review__mdt> lstResults = new List<Pipeline_Review__mdt>(); 
        
        List<User> lstCurrentUser = [SELECT id 
                                     FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        
        if(!lstCurrentUser.isEmpty()) {
           // userGBE= lstCurrentUser[0].GBE__c ; 
         //   userRegion = lstCurrentUser[0].Region__c ; 
          //  userDivision = lstCurrentUser[0].Brand__c ; 
        }
        
        for(Pipeline_Review__mdt objData : getAllRecords(isTeamView)) {
            configGBE = objData.GBE__c ; 
            configRegion = objData.Region__c ; 
            configDivision = objData.Division__c ; 
            isGBEVerified = verifyConfig(objData.GBE__c , userGBE); 
            isRegionVerified = verifyConfig(objData.Region__c , userRegion ); 
            isDivisionVerified = verifyConfig(objData.Division__c , userDivision); 
            if(isGBEVerified && isRegionVerified && isDivisionVerified) {
                lstResults.add(objData);     
            }
        }
        System.debug('lstResults====>'+lstResults);
        return lstResults;
    }
    
    /*************************************************************
     * @Description : 
     * 
     * ***********************************************************/
    public Boolean verifyConfig(String inputConfig,String userValue) {
        Boolean result = false ; 
        Set<String> setValues = new Set<String>();
        if(String.isNotBlank(inputConfig)) {
            
            setValues.addAll(inputConfig.split(',')); 
            
            if(setValues.contains(userValue)) {
                result = true ; 
            }
            else {
                result = false ; 
            }
            
        }
        else {
            result = true ; //set it to true , when there is no config found
        }
        return result ; 
    }
    /**********************************************
     * 
     * *******************************************/
   public Set<Id> getMyTeamUsers() { 
        Set<Id> setResults = new Set<Id>(); 
        for(user teamUser : [select Id, name, ManagerId from user where (Level_1_Manager__c =:UserInfo.getUserId() OR Level_2_Manager__c =:UserInfo.getUserId()) AND SBI_Checkbox__c = True LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())])     
        {
            setResults.add(teamUser.Id);
             System.debug('teamUser'+teamUser);
        }
      
        //setResults.add(UserInfo.getUserId()); //add self user id also
        return setResults ; 
    }
}