trigger OpportunityTeamMembers on Opportunity_Sales_Team__c (after delete,  after insert,after update) {

List<Id> oppList= new List<Id>();
List<Opportunity> oppListUpdate= new List<Opportunity>();
List<Opportunity_Sales_Team__c> oppTeamList= new List<Opportunity_Sales_Team__c>();
String teamName;
String tmName;

if (trigger.isInsert || trigger.isUpdate)
{
 for (Opportunity_Sales_Team__c oppTeamMember: Trigger.new)
    {
      if(trigger.isUpdate){
       //if(System.Trigger.oldMap.get(oppTeamMember.Id).User__c!=System.Trigger.NewMap.get(oppTeamMember.Id).User__c)
           if(oppTeamMember.User__c != null && oppTeamMember.Is_User_Active__c == 'TRUE') {
          oppList.add(oppTeamMember.Opportunity__c);  
          }
          else{
          oppTeamMember.adderror('Active checkbox should be enabled for the selected user record');
          }
        }  
          
      if(trigger.isInsert){
       if(oppTeamMember.User__c != NULL && oppTeamMember.Is_User_Active__c == 'TRUE'|| oppTeamMember.Contact__c!= NULL){
          oppList.add(oppTeamMember.Opportunity__c);
       }
       else{
       oppTeamMember.adderror('Active checkbox should be enabled on the opportunity team and the selected user record');
       }
    }   
       
    
}
}

if (Trigger.isDelete)
{  
    for (Opportunity_Sales_Team__c oppTeamMembers: Trigger.old)    {
        //if(oppTeamMembers.Is_User_Active__c == 'FALSE'){
      oppList.add(oppTeamMembers.Opportunity__c);
      
    //}       
    }
}   

if(oppList.size()>0){
   oppListUpdate=[Select Id,Programme_Manager__c from Opportunity where Id in :oppList];
   try{
   
   oppTeamList=[Select Id,User__r.User_EID__c,Team_Member_Full_Name__c,Opportunity__c, User__r.Name, User__c,User__r.isActive  from Opportunity_Sales_Team__c  where Opportunity__c in
                  :oppList order by createddate desc];
   }
   catch(Exception e){}              
   }
     try {
     for (integer i=0;i<oppListUpdate.size();i++){
     teamName='';
     tmName='';
        for(integer j=0;j<oppTeamList.size();j++){
            if(oppTeamList[j].Opportunity__c ==oppListUpdate[i].id && (oppTeamList[j].User__c != NULL || oppTeamList[j].User__c != '')){            
            if(oppTeamList[j].User__r.isActive){
                  String tempName =  oppTeamList[j].User__r.Name.substring(oppTeamList[j].User__r.Name.lastIndexOf(' '))+' '+oppTeamList[j].User__r.User_EID__c;
                  if(!teamName.contains(tempName))
                    teamName = teamName + ',' +tempName;
            }
          }
        }
        
        tmName = teamName.substring(teamName.indexOf(',')+1);

        oppListUpdate[i].TeamMemberLastName__c=tmName;
        
     
     }
     }catch(Exception ex){
        system.debug('Exception at 60:'+ex.getMessage());
     }
     try {
     if(oppListUpdate.size()>0)
          update oppListUpdate;
     }catch(Exception ex){
        system.debug('Exception at 66:'+ex.getMessage());
     }
}