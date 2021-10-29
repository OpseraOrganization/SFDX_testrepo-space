trigger preventOpportunityProductDelete on OpportunityLineItem (before delete) {
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
    for(OpportunityLineItem  opp: Trigger.old){
        system.debug('oppp'+opp);
        if(Opp.Type__c == 'Booked' || Opp.Type__c == 'APO')
        {
            system.debug('Inside type Booked');
                  if(profileid == label.Honeywell_System_Administrator_US_Label || profileid ==label.Honeywell_System_Administrator_Label  ||
                  profileid == label.D_S_Sales_Spiral_API_User_Label || profileid == label.D_S_Sales_API_User_Label || profileid == label.DFS_API_User_Label ||
                  profileid == label.Honeywell_System_Administrator_Non_US || flagProfile==1 || (Test.isRunningTest()) )
                {
                system.debug('Above profile only can delete the Oppurtunity Product');
                }else{  
                    opp.addError('Opportunity Product can be deleted only by an admin.');                  
                }
            }
        }
}