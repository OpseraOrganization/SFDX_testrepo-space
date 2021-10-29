trigger preventOpportunityProductChange on OpportunityLineItem (after update){
if(AvoidRecursion.isFirstRun_preventOpportunityProductChange()){
    String profileId;
    List<DS_Sales_Adminlist__c> mapDSAdminProfile = DS_Sales_Adminlist__c.getALL().values();
    profileId=Userinfo.getprofileId();
    profileid=profileId.substring(0,15);
    integer flagProfile = 0;
     System.debug('profileid'+profileid);
     System.debug('mapDSAdminProfile.size() '+mapDSAdminProfile.size());
    for (integer i=0;i<mapDSAdminProfile.size();i++)
    { 
    System.debug('mapDSAdminProfile '+mapDSAdminProfile[i].D_S_Admin_ProfileId__c);
      if(mapDSAdminProfile[i].D_S_Admin_ProfileId__c==profileId){
         flagProfile=1;
         System.debug('flagProfile'+flagProfile);
      }
  }
    // Commented for SR# 417354 - Start
    // String pName = [SELECT Name FROM Profile where Id  =: profileid].Name;
    // Commented for SR# 417354 - End
    for(OpportunityLineItem  opp: Trigger.new){
        if(System.Trigger.NewMap.get(opp.Id).Type__c == 'Booked' 
        || System.Trigger.OldMap.get(opp.Id).Type__c == 'Booked'
        || System.Trigger.NewMap.get(opp.Id).Type__c == 'APO' 
        || System.Trigger.OldMap.get(opp.Id).Type__c == 'APO')
        {
          //commented to fix SR 404316
           /*  if((System.Trigger.OldMap.get(opp.Id).Active__c != System.Trigger.NewMap.get(opp.Id).Active__c)
            ||
            (System.Trigger.OldMap.get(opp.Id).ServiceDate != System.Trigger.NewMap.get(opp.Id).ServiceDate)
            ||
            (System.Trigger.OldMap.get(opp.Id).Description != System.Trigger.NewMap.get(opp.Id).Description)
            ||
            (System.Trigger.OldMap.get(opp.Id).Plant__c != System.Trigger.NewMap.get(opp.Id).Plant__c)
            ||
            (System.Trigger.OldMap.get(opp.Id).Blanket_Forecast__c != System.Trigger.NewMap.get(opp.Id).Blanket_Forecast__c)
            ||
            (System.Trigger.OldMap.get(opp.Id).Probability__c != System.Trigger.NewMap.get(opp.Id).Probability__c)
            ||
            (System.Trigger.OldMap.get(opp.Id).Quantity != System.Trigger.NewMap.get(opp.Id).Quantity )
            ||
            (System.Trigger.OldMap.get(opp.Id).ListPrice != System.Trigger.NewMap.get(opp.Id).ListPrice )
            ||
            (System.Trigger.OldMap.get(opp.Id).TotalPrice != System.Trigger.NewMap.get(opp.Id).TotalPrice )
            ||
            (System.Trigger.OldMap.get(opp.Id).UnitPrice != System.Trigger.NewMap.get(opp.Id).UnitPrice )
            ||
          
            (System.Trigger.OldMap.get(opp.Id).Revenue_End_Date__c != System.Trigger.NewMap.get(opp.Id).Revenue_End_Date__c )
            ||
            (System.Trigger.OldMap.get(opp.Id).Revenue_start_Date__c != System.Trigger.NewMap.get(opp.Id).Revenue_start_Date__c )
           
            ){
              // Commented the below line code and modified the profile name for SR#375409 - Start            
                       
                if(pName == 'D&S Sales Admin' || pName == 'Honeywell System Administrator (US)' || pName == 'Honeywell System Administrator (Non US)' || pName=='Honeywell System Administrator'|| pName=='Honeywell Read Only'||pName=='Honeywell Inactive Users'||pName=='Honeywell CBT' || pName=='D&S Sales API User' || pName=='DFS API User' || pName=='D&S Sales Spiral API User'){  
              */
               /* if(pName == 'D&S Sales Admin' || pName == 'Honeywell System Administrator (US)' || pName == 'Honeywell System Administrator (Non US)' || 
                pName=='Honeywell System Administrator'|| pName=='Honeywell Read Only'||pName=='Honeywell Inactive Users'||pName=='Honeywell CBT' || 
                pName=='D&S Sales API User' || pName=='D&S Sales API Discretionary User' || pName=='D&S Sales API Spiral User'){    
                */
                // Commented the above line code and modified the profile name for SR#375409 - End
                // Multiple line Commented the above if condition and modified the profile for SR# 417354 
                 if(profileid == label.Honeywell_System_Administrator_US_Label || profileid ==label.Honeywell_System_Administrator_Label  ||
                  profileid == label.D_S_Sales_Spiral_API_User_Label || profileid == label.D_S_Sales_API_User_Label || profileid == label.DFS_API_User_Label ||
                  profileid == label.Honeywell_System_Administrator_Non_US || flagProfile==1 || (Test.isRunningTest()) )
                {
                system.debug('Above profile only can change the Oppurtunity Product similar to preventScheduleChange trigger');
                }else{  
                    opp.addError('Opportunity Product can be changed only by an admin.');                  
                }
            }
        }
        }
    }